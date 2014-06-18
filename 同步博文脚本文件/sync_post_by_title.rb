require './plugins/sync_post.rb'
puts "sync_post_by_title.rb"
raise "post title should not be empty" if($*[0] == nil)
if $*[1] != nil
  syncPost = MetaWeblogSync::SyncPost.new $*[1]
else
  syncPost = MetaWeblogSync::SyncPost.new
end
syncPost.postBlogByTitle $*[0]
