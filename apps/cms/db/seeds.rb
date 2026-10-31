# Dane startowe: jedna kategoria + jedna realizacja w PL, EN i DE.
# Idempotentne — można uruchamiać wielokrotnie (bin/rails db:seed).

category = Category.find_or_initialize_by(id: 1)
category.update!(
  name: { "pl" => "Mieszkania", "en" => "Apartments", "de" => "Wohnungen" },
  slug: { "pl" => "mieszkania", "en" => "apartments", "de" => "wohnungen" },
  position: 1
)

project = Project.find_or_initialize_by(id: 1)
project.update!(
  category: category,
  slug:  { "pl" => "apartament-mokotow", "en" => "mokotow-apartment", "de" => "wohnung-mokotow" },
  title: { "pl" => "Apartament na Mokotowie", "en" => "Mokotów Apartment", "de" => "Wohnung in Mokotów" },
  lead:  {
    "pl" => "Spokojne, minimalistyczne wnętrze zalane światłem — z naturalnych materiałów i stonowanej palety.",
    "en" => "A calm, minimalist interior filled with light — natural materials and a muted palette.",
    "de" => "Ein ruhiger, minimalistischer Innenraum voller Licht — aus natürlichen Materialien und einer gedämpften Palette."
  },
  body: {
    "pl" => "<p>Projekt 120-metrowego apartamentu na warszawskim Mokotowie. Otwarta strefa dzienna, dębowa podłoga i wapienne tynki.</p>",
    "en" => "<p>A 120 sqm apartment in Warsaw's Mokotów district. An open living area, oak flooring and lime plaster.</p>",
    "de" => "<p>Entwurf einer 120 m² großen Wohnung im Warschauer Stadtteil Mokotów. Offener Wohnbereich, Eichenboden und Kalkputz.</p>"
  },
  year: 2025,
  location: "Warszawa",
  area_m2: 120,
  featured: true,
  position: 1,
  status: "published",
  published_at: Time.current
)

# --- Blog -------------------------------------------------------------------

post_category = PostCategory.find_or_initialize_by(id: 1)
post_category.update!(
  name: { "pl" => "Inspiracje", "en" => "Inspirations", "de" => "Inspirationen" },
  slug: { "pl" => "inspiracje", "en" => "inspirations", "de" => "inspirationen" },
  position: 1
)

post = Post.find_or_initialize_by(id: 1)
post.update!(
  post_category: post_category,
  slug:  { "pl" => "jak-projektujemy-wnetrza", "en" => "how-we-design-interiors", "de" => "wie-wir-innenraeume-entwerfen" },
  title: { "pl" => "Jak projektujemy wnętrza", "en" => "How we design interiors", "de" => "Wie wir Innenräume entwerfen" },
  lead:  {
    "pl" => "Kulisy naszego procesu projektowego — od pierwszej rozmowy po oddanie kluczy.",
    "en" => "Behind the scenes of our design process — from the first conversation to handover.",
    "de" => "Hinter den Kulissen unseres Entwurfsprozesses — vom ersten Gespräch bis zur Schlüsselübergabe."
  },
  body: {
    "pl" => "<p>Każdy projekt zaczynamy od rozmowy o tym, jak chcecie żyć. Dopiero potem rysujemy pierwsze kreski.</p>",
    "en" => "<p>Every project begins with a conversation about how you want to live. Only then do we draw the first lines.</p>",
    "de" => "<p>Jedes Projekt beginnt mit einem Gespräch darüber, wie Sie leben möchten. Erst danach zeichnen wir die ersten Striche.</p>"
  },
  author: "JNK Studio",
  featured: true,
  position: 1,
  status: "published",
  published_at: Time.current
)

# Seed ustawia jawne id-ki, które nie przesuwają sekwencji PK — bez tego
# pierwszy rekord tworzony z panelu kolidowałby z kluczem (id=1). Reset na max+1.
%w[post_categories posts].each do |table|
  ActiveRecord::Base.connection.reset_pk_sequence!(table)
end

# Konto administratora panelu. Dane z ENV (ADMIN_EMAIL / ADMIN_PASSWORD),
# z domyślnymi wartościami dla dev. Idempotentne.
admin_email = ENV.fetch("ADMIN_EMAIL", "admin@jnk-studio.com")
admin_password = ENV.fetch("ADMIN_PASSWORD", "jnkstudio123")
admin = User.find_or_initialize_by(email_address: admin_email)
admin.password = admin_password if admin.new_record?
admin.save!

puts "Seed gotowy: #{Project.count} realizacja(e), #{Category.count} kategoria(e), " \
     "#{Post.count} wpis(ów) bloga, #{PostCategory.count} kategoria(e) bloga, " \
     "#{User.count} administrator(ów) (#{admin_email})."
