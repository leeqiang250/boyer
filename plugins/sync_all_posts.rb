require './plugins/sync_post.rb'
puts "sync_all_posts.rb"
if $*[0] != nil #It seems to be runed when rake generate. I don't quite understand.
  syncPost = MetaWeblogSync::SyncPost.new $*[0]
else
  syncPost = MetaWeblogSync::SyncPost.new
end
syncPost.postAllBlogs
