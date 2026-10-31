json.locale I18n.locale
json.partial! "api/v1/posts/post", post: @post

json.body @post.body

json.seo do
  json.title @post.title
  json.description @post.lead
end
