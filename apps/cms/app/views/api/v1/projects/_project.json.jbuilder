json.slug project.slug(I18n.locale)
json.alternates project.slug_alternates
json.title project.title
json.lead project.lead
json.year project.year
json.location project.location
json.area_m2 project.area_m2
json.featured project.featured

if project.category
  json.category do
    json.slug project.category.slug(I18n.locale)
    json.name project.category.name
  end
else
  json.category nil
end

if project.cover.attached?
  json.cover do
    blob = project.cover.blob
    json.alt project.title
    json.width blob.metadata["width"]
    json.height blob.metadata["height"]
    json.url rails_blob_path(project.cover, only_path: true)
  end
else
  json.cover nil
end
