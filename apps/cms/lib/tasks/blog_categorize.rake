# Tworzy taksonomię kategorii bloga (PL/EN/DE) i przypisuje każdemu wpisowi
# kategorię na podstawie słów kluczowych w tytule + zajawce (pierwsze trafienie
# wg priorytetu; brak trafienia → "Porady i inspiracje"). Idempotentne.
namespace :blog do
  # [slug, pl, en, de, [słowa-klucze (stemy, lowercase)]]  — kolejność = priorytet
  CATEGORIES = [
    [ "kuchnia", "Kuchnia", "Kitchen", "Küche",
      %w[kuchni kuchn aneks\ kuchen zabudow\ kuchen] ],
    [ "lazienka", "Łazienka", "Bathroom", "Badezimmer",
      %w[łazienk łazienc prysznic wanna umywalk toalet sanitar bateri\ ] ],
    [ "sypialnia", "Sypialnia", "Bedroom", "Schlafzimmer",
      %w[sypialn łóżk łoż materac pościel] ],
    [ "pokoj-dzieciecy", "Pokój dziecięcy", "Kids' Room", "Kinderzimmer",
      %w[dziecię dzieck dzieci niemowl młodzież nastolat] ],
    [ "salon-jadalnia", "Salon i jadalnia", "Living & Dining Room", "Wohn- und Esszimmer",
      %w[salon pokój\ dzienny strefa\ dzienn jadaln stół stoł kanap sofa telewiz] ],
    [ "male-wnetrza", "Małe wnętrza", "Small Spaces", "Kleine Räume",
      %w[mał kawalerk niewielk metraż mikro powiększ optyczn ciasn] ],
    [ "oswietlenie", "Oświetlenie", "Lighting", "Beleuchtung",
      %w[oświetl lamp światł żyrandol kinkiet led reflekt] ],
    [ "kolory-materialy", "Kolory i materiały", "Colours & Materials", "Farben & Materialien",
      %w[kolor barw biel biał szar czerń czarn beż paleta drewn płytk beton cegł tapet marmur kamień fornir farb lakier] ],
    [ "dekoracje-dodatki", "Dekoracje i dodatki", "Decor & Accessories", "Deko & Accessoires",
      %w[dekora dodatk obraz rośl kwiat poduszk zasłon firan dywan lustr świec wazon plakat galeri] ],
    [ "meble-przechowywanie", "Meble i przechowywanie", "Furniture & Storage", "Möbel & Aufbewahrung",
      %w[mebl przechowyw szaf komod półk regał przedpok garderob schowek zabudow organizacj] ],
    [ "style-wnetrz", "Style wnętrz", "Interior Styles", "Einrichtungsstile",
      %w[skandynaw loft glamour boho industrial rustyk klasyczn minimaliz prowansal vintage retro eklektyz styl\ ] ]
  ].freeze

  CATCHALL = [ "porady-inspiracje", "Porady i inspiracje", "Tips & Inspiration", "Tipps & Inspiration" ].freeze

  desc "Utwórz kategorie bloga i skategoryzuj wpisy wg słów kluczowych"
  task categorize: :environment do
    by_slug = {}
    (CATEGORIES.map { |c| c[0..3] } + [ CATCHALL ]).each_with_index do |(slug, pl, en, de), i|
      c = PostCategory.where("slug ->> 'pl' = ?", slug).first_or_initialize
      c.slug_pl = slug
      c.name_pl = pl
      c.name_en = en
      c.name_de = de
      c.slug_en = slug
      c.slug_de = slug
      c.position = i + 1
      c.save!
      by_slug[slug] = c
    end
    puts "[blog] kategorii: #{by_slug.size}"

    sanitizer = ->(html) { ActionView::Base.full_sanitizer.sanitize(html.to_s) }
    counts = Hash.new(0)
    Post.find_each do |post|
      text = "#{post.title(:pl)} #{sanitizer.call(post.lead(:pl))}".downcase
      slug = CATEGORIES.find { |_, _, _, _, keys| keys.any? { |k| text.include?(k.strip) } }&.first
      slug ||= CATCHALL[0]
      post.update_columns(post_category_id: by_slug[slug].id)
      counts[slug] += 1
    end

    puts "[blog] rozkład wpisów po kategoriach:"
    counts.sort_by { |_, n| -n }.each { |slug, n| puts format("  %4d  %s", n, slug) }
  end
end
