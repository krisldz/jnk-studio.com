json.slug post.slug(I18n.locale)
json.alternates post.slug_alternates
json.title post.title
json.lead post.lead
json.author post.author
json.reading_time post.reading_minutes(I18n.locale)
json.featured post.featured
json.published_at post.published_at&.iso8601

if post.post_category
  json.category do
    json.slug post.post_category.slug(I18n.locale)
    json.name post.post_category.name
  end
else
  json.category nil
end

if post.cover.attached?
  json.cover do
    blob = post.cover.blob
    json.alt post.title
    json.width blob.metadata["width"]
    json.height blob.metadata["height"]
    json.url rails_blob_path(post.cover, only_path: true)
    json.credit post.cover_credit
    json.credit_url post.cover_credit_url
  end
else
  json.cover nil
end
