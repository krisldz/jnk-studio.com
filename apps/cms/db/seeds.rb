# Dane startowe: jedna kategoria + jedna realizacja w PL i EN.
# Idempotentne — można uruchamiać wielokrotnie (bin/rails db:seed).

category = Category.find_or_initialize_by(id: 1)
category.update!(
  name: { "pl" => "Mieszkania", "en" => "Apartments" },
  slug: { "pl" => "mieszkania", "en" => "apartments" },
  position: 1
)

project = Project.find_or_initialize_by(id: 1)
project.update!(
  category: category,
  slug:  { "pl" => "apartament-mokotow", "en" => "mokotow-apartment" },
  title: { "pl" => "Apartament na Mokotowie", "en" => "Mokotów Apartment" },
  lead:  {
    "pl" => "Spokojne, minimalistyczne wnętrze zalane światłem — z naturalnych materiałów i stonowanej palety.",
    "en" => "A calm, minimalist interior filled with light — natural materials and a muted palette."
  },
  body: {
    "pl" => "<p>Projekt 120-metrowego apartamentu na warszawskim Mokotowie. Otwarta strefa dzienna, dębowa podłoga i wapienne tynki.</p>",
    "en" => "<p>A 120 sqm apartment in Warsaw's Mokotów district. An open living area, oak flooring and lime plaster.</p>"
  },
  year: 2025,
  location: "Warszawa",
  area_m2: 120,
  featured: true,
  position: 1,
  status: "published",
  published_at: Time.current
)

# Konto administratora panelu. Dane z ENV (ADMIN_EMAIL / ADMIN_PASSWORD),
# z domyślnymi wartościami dla dev. Idempotentne.
admin_email = ENV.fetch("ADMIN_EMAIL", "admin@jnk-studio.com")
admin_password = ENV.fetch("ADMIN_PASSWORD", "jnkstudio123")
admin = User.find_or_initialize_by(email_address: admin_email)
admin.password = admin_password if admin.new_record?
admin.save!

puts "Seed gotowy: #{Project.count} realizacja(e), #{Category.count} kategoria(e), " \
     "#{User.count} administrator(ów) (#{admin_email})."
