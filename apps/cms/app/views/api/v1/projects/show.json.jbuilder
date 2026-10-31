json.locale I18n.locale
json.partial! "api/v1/projects/project", project: @project

json.body @project.body

# Bloki treści (tekst, galeria, cytat, CTA, liczby) dołączą wraz z modelem Block.
json.blocks @project.project_images.ordered do |image|
  json.kind "image"
  json.alt image.alt
  json.credit image.credit
  if image.image.attached?
    json.url rails_blob_path(image.image, only_path: true)
  end
end

json.seo do
  json.title @project.title
  json.description @project.lead
end
