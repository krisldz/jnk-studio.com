# Import treści ze starego serwisu JNK (MySQL → JSON w tmp/legacy_migration).
# Idempotentny: rekordy kluczowane po `legacy_id`, pliki dopinane tylko gdy brak.
# Mapowanie: jnk_articles→Post, jnk_portfolio_groups→Project,
# jnk_portfolio_categories→Category, jnk_categories→PostCategory,
# jnk_portfolio→ProjectImage (+ okładka z main=1). PL→PL, DE→DE, EN puste (fallback PL).
module LegacyImport
  DIR = Rails.root.join("tmp/legacy_migration")
  IMG = DIR.join("images")

  PL_MAP = {
    "ą" => "a", "ć" => "c", "ę" => "e", "ł" => "l", "ń" => "n", "ó" => "o",
    "ś" => "s", "ż" => "z", "ź" => "z",
    "ä" => "ae", "ö" => "oe", "ü" => "ue", "ß" => "ss"
  }.freeze

  module_function

  def load_json(name)
    JSON.parse(File.read(DIR.join(name)))
  end

  # Pełne dekodowanie encji HTML + usunięcie tagów → czysty tekst
  # (Ruby CGI.unescapeHTML nie zna encji nazwanych typu &nbsp; / &oacute;).
  def decode_text(str)
    Nokogiri::HTML.fragment(str.to_s).text.tr(" ", " ").squish
  end

  # Treść HTML zostawiamy jako HTML (encje są poprawne, renderuje je przeglądarka).
  def html_body(str)
    str.to_s.strip
  end

  # Slug z polskich/niemieckich znaków.
  def slugify(str)
    s = decode_text(str).downcase
    PL_MAP.each { |k, v| s = s.gsub(k, v) }
    s.parameterize.presence || "wpis"
  end

  # Unikalny slug w obrębie modelu (różne legacy_id nie dzielą slugu PL).
  def unique_slug(base, used, legacy_id)
    slug = base
    slug = "#{base}-#{legacy_id}" if used.include?(slug)
    slug = "#{slug}-#{used.size}" while used.include?(slug)
    used << slug
    slug
  end

  # Zajawka: czysty tekst z HTML, przycięty.
  def lead_from(html, fallback, limit = 180)
    text = decode_text(html)
    text.presence ? text.truncate(limit, separator: " ") : fallback
  end

  def content_type_for(name)
    case File.extname(name).downcase
    when ".png" then "image/png"
    when ".gif" then "image/gif"
    when ".webp" then "image/webp"
    else "image/jpeg"
    end
  end

  # Dopnij plik tylko jeśli jeszcze nie dopięty (idempotencja).
  def attach_image(attachment, filename)
    return :missing if filename.blank?
    return :exists if attachment.attached?

    path = IMG.join(filename)
    return :nofile unless File.exist?(path)

    attachment.attach(io: File.open(path), filename: filename, content_type: content_type_for(filename))
    :attached
  end
end

namespace :legacy do
  desc "Import legacy JNK content (articles + portfolio) from tmp/legacy_migration"
  task import: :environment do
    lg = LegacyImport
    abort "Brak katalogu #{lg::DIR}" unless Dir.exist?(lg::DIR)
    log = ->(m) { puts "[legacy] #{m}" }

    # Seed wstawia jawne id=1 (nie przesuwa sekwencji PK) → nowe rekordy
    # kolidowałyby z kluczem. Reset sekwencji na max(id)+1 przed importem.
    %w[categories post_categories projects posts project_images].each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end

    # --- Kategorie realizacji (jnk_portfolio_categories) ----------------------
    cat_by_legacy = {}
    used_cat_slugs = []
    lg.load_json("portfolio_categories.json").each do |row|
      c = Category.find_or_initialize_by(legacy_id: row["id"])
      c.name_pl = lg.decode_text(row["title_pl"])
      c.name_de = lg.decode_text(row["title_de"]).presence
      c.slug_pl = lg.unique_slug(lg.slugify(row["title_pl"]), used_cat_slugs, row["id"]) if c.slug_pl.blank?
      c.slug_de = lg.slugify(row["title_de"]).presence if row["title_de"].present? && c.slug_de.blank?
      c.position = row["sort"].to_i
      c.save!
      cat_by_legacy[row["id"]] = c
    end
    log.call("kategorie realizacji: #{cat_by_legacy.size}")

    # --- Kategorie bloga (jnk_categories) -------------------------------------
    postcat_by_legacy = {}
    used_pc_slugs = []
    lg.load_json("article_categories.json").each do |row|
      c = PostCategory.find_or_initialize_by(legacy_id: row["id"])
      c.name_pl = lg.decode_text(row["title"])
      c.slug_pl = lg.unique_slug(lg.slugify(row["title"]), used_pc_slugs, row["id"]) if c.slug_pl.blank?
      c.position = row["id"].to_i
      c.save!
      postcat_by_legacy[row["id"]] = c
    end
    log.call("kategorie bloga: #{postcat_by_legacy.size}")

    # --- Realizacje (jnk_portfolio_groups) ------------------------------------
    project_by_legacy = {}
    used_proj_slugs = []
    lg.load_json("portfolio_groups.json").each do |row|
      title_pl = lg.decode_text(row["title_pl"])
      next if title_pl.blank?

      p = Project.find_or_initialize_by(legacy_id: row["id"])
      p.title_pl = title_pl
      p.title_de = lg.decode_text(row["title_de"]).presence
      p.slug_pl = lg.unique_slug(lg.slugify(title_pl), used_proj_slugs, row["id"]) if p.slug_pl.blank?
      p.body_pl = lg.html_body(row["desc_pl"]).presence || title_pl
      p.lead_pl = lg.lead_from(row["desc_pl"], title_pl)
      if row["desc_de"].present?
        p.body_de = lg.html_body(row["desc_de"]).presence
        p.lead_de = lg.lead_from(row["desc_de"], nil)
      end
      p.category = cat_by_legacy[row["category_id"]]
      p.status = "draft"
      p.position = row["id"].to_i
      p.save!
      project_by_legacy[row["id"]] = p
    end
    log.call("realizacje: #{project_by_legacy.size}")

    # --- Zdjęcia realizacji (jnk_portfolio) -----------------------------------
    stats = Hash.new(0)
    pos_counter = Hash.new(0)
    lg.load_json("portfolio_images.json")
     .sort_by { |r| [ r["group_id"].to_i, -r["main"].to_i, r["id"].to_i ] }
     .each do |row|
      project = project_by_legacy[row["group_id"]]
      unless project
        stats[:orphan] += 1
        next
      end

      img = ProjectImage.find_or_initialize_by(legacy_id: row["id"])
      img.project = project
      img.alt_pl = (lg.decode_text(row["opis"]).presence || project.title_pl) if img.alt_pl.blank?
      img.position = (row["main"].to_i == 1 ? 0 : (pos_counter[project.id] += 1))
      img.save!
      stats[lg.attach_image(img.image, row["image"])] += 1

      stats[:cover] += 1 if row["main"].to_i == 1 && lg.attach_image(project.cover, row["image"]) == :attached
    end

    # Projekty bez okładki (brak main) → pierwszym zdjęciem.
    Project.where(legacy_id: project_by_legacy.keys).find_each do |p|
      next if p.cover.attached?

      first = p.project_images.ordered.first
      next unless first&.image&.attached?

      p.cover.attach(first.image.blob)
      stats[:cover_fallback] += 1
    end
    log.call("zdjęcia: dopięte=#{stats[:attached]} już_były=#{stats[:exists]} " \
             "brak_pliku=#{stats[:nofile]} sieroty=#{stats[:orphan]} " \
             "okładki=#{stats[:cover]} okładki_fallback=#{stats[:cover_fallback]}")

    # --- Artykuły (jnk_articles) ----------------------------------------------
    used_post_slugs = []
    posts = 0
    lg.load_json("articles.json").each do |row|
      title_pl = lg.decode_text(row["title"])
      next if title_pl.blank?

      p = Post.find_or_initialize_by(legacy_id: row["id"])
      p.title_pl = title_pl
      p.slug_pl = lg.unique_slug(lg.slugify(title_pl), used_post_slugs, row["id"]) if p.slug_pl.blank?
      p.body_pl = lg.html_body(row["text"]).presence || title_pl
      p.lead_pl = lg.lead_from(row["text"], title_pl)
      p.post_category = postcat_by_legacy[row["category_id"]]
      p.published_at = (Date.parse(row["date"]) rescue nil) if row["date"].present?
      p.status = "draft"
      p.save!
      posts += 1
    end
    log.call("artykuły: #{posts}")

    log.call("GOTOWE. Projects=#{Project.count} Posts=#{Post.count} " \
             "Categories=#{Category.count} PostCategories=#{PostCategory.count} " \
             "ProjectImages=#{ProjectImage.count}")
  end
end
