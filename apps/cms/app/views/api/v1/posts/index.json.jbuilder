json.locale I18n.locale
json.posts @posts do |post|
  json.partial! "api/v1/posts/post", post: post
end
