json.array!(@post_list) do |post|
  json.extract! post, :id, :title, :content, :goodvote, :badvote
  json.url post_url(post, format: :json)
end