---
layout: post
title: "初步搭建Octopress"
date: 2014-06-09 23:26:22 +0800
comments: true
publiced: true
tags: [octopress,blog,github,mou,ruby]
keywords: boys,octopress,技术
categories: Octopress
---
####软件支持：
1. **Github**:后台新建项目，点击[下载](https://help.github.com/articles/set­up­git)
2. **iTerm2**:可以替代mac终端，相当强大。[下载](http://www.iterm2.com/#/section/home)
3. **ruby**:ruby安装包  [下载](http://ruby.taobao.org/mirrors/ruby/)
4. **Mou**:MarkDown编辑软件，可用于后期发布博客文章。[下载](http://mouapp.com/)
5. **Xcode**：它将帮助你安装好Unix环境需要的开发包。

￼<!--显示文章缩略部分的标记方法-->
<!-- more -->

####学习目的：
要求:我们需要自己搭建一个独立博客网站,需要什么?首先要有台连接到英特网服务器,要有前端的页面,要后端的数据库,要有域名等.  
  
1. github可以提供给我们的是,github一个免费的代码托管仓库,它支持用户html页面的显示,也就是说，用户可以上传HTML文件,然后在远程像访问网页一样访问它。  

2. 按照我们的设想1,我们这时候还缺网站的后台,数据库这些,github并不提供这些,数据库的作用是提高管理能力,对于个人博客这种数据规模很小,便可返璞归真,用回静态页面。
	- 对于计算机和一切能被用来改造这个世界的事物的使用都不应受到任何限制, 任何试图隐藏系统的复杂性的行为都只会得到一个更为复杂的系统。
3. 静态页面用起来很复杂,我们需要**Octopress**这样的引擎来帮我们干“重活”,我们可以关注于自己博客中的内容,用过HTML的都知道,内容需要写的标记,我们要把这些工作也简化,便有了Markdown,我们使用Markdown来描述我们的内容,然后由引擎“翻译”为HTML页面。

####搭建环境：

1. **Github**:既然要托管到github,那么便要有github的环境. 检查本机的git环境,在命令行输入 `git--version`  

2. **Octopress**:是基于Jekyll的,需要ruby的环境编译。检查本机ruby环境，命令行：`ruby-v`ruby的version1.9.3以上,新版的Mac,这些都是有装的。
3. **gcc**和**make**,ruby的环境需要gcc,这个会通过安装xcode的command line tool来完成安装 检查本机gcc环境，命令行：`gcc -v`
####安装Octpress:
  
通过Git安装:   
 
+ 下载**Octopress**：`gitclonegit://github.com/imathis/octopress.git octopress`
+ 进入**Octopress**目录：`cd octopress`  
+ 安装必要的依赖包：
	+ `gem install bundler`
	+ `rbenv rehash` # If you use rbenv, rehash to be able to run the bundle command
	+ `bundle install`
+ 最后安装Octopress:`rake install`

####配置：  
* 修改配置文件**_config.yml**：
	* 配置个人站点的信息：**url**:git远程库地址，**title**:博客题目,**author**:作者名,等。 
		* 注意：最好将twitter相关的配置信息全部删掉,否则由于GFW的原因,将会造成页面load很慢。	  
* 修改定制文件：/source/_includes/custom/head.html把google的自定义字体去掉,原因同上。  
  
  
####写博客：
  
博文是用markdown语法，另外扩充一些插件，网上相关介绍很多，例如：[这个](http://daringfireball.net/projects/markdown/)  

* 新建Markdown文件: 		 `rake new_post['文章名']`
* 翻译Mardown为静态文件:   `rake generate` 
* 检测文件变化：			`rake watch`
* 启动本机测试端口4000：  `rake preview`
* 发布至git库：			`rake deploy`
  
  
####添加多说：

  需要在多说网注册个帐号，添加站点，获取站点 <font color=red>short_name</font>.  

* ######底部评论：
	
	* 在 <font color=red> _config.yml</font> 	中添加 
	 
			##duoshuo comments	
			duoshuo_comments: true	
			duoshuo_short_name: yourname

	* 在<font color=red>`source/_layouts/post.html`</font>中的<font color=red> disqus</font>代码：
	
			{ % if site.disqus_short_name and page.comments == true % }
				<section>
					<h1>Comments</h1>
			 		<div id="disqus_thread" aria-live="polite">{ % include post/disqus_thread.html % }</div>
				</section>
			{ % endif % }
	
		下方添加 <font color=red>多说评论</font> 模块:

			{ % if site.duoshuo_short_name and site.duoshuo_comments == true and  page.comments == true % }
			<section>
    			<h1>Comments</h1>
    				<div id="comments" aria-live="polite">{ % include post/duoshuo.html % }</div>
    				</section>
			{ % endif % }  
	* 然后就按路径创建一个<font color=red>source/_includes/post/duoshuo.html</font>	
	
			<!-- Duoshuo Comment BEGIN -->
			<div class="ds-thread" data-title="{% if site.titlecase %}{{ post.title | site.titlecase }}{% else %}{{ post.title }}{% endif %}"></div>
			<script type="text/javascript">
			  var duoshuoQuery = {short_name:"{{ site.duoshuo_short_name }}"};
			  (function() {
			    var ds = document.createElement('script');
			    ds.type = 'text/javascript';
			    ds.async = true;
			    ds.src = 'http://static.duoshuo.com/embed.js';
			    ds.charset = 'UTF-8';
			    (document.getElementsByTagName('head')[0]  || document.getElementsByTagName('body')[0]).appendChild(ds); 
			    })();
			</script>
			<!-- Duoshuo Comment END -->  
	  
	  
	* 随后，再修改 <font color=red>_includes/article.html </font>文件,
		
			
			{ % if site.disqus_short_name and page.comments != false and post.comments !=false and site.disqus_show_comment_count == true % } 
						 | <a href="{ % if index % }{{ root_url }}{{ post.url }}{ % endif % }#disqus_thread">Comments</a> 
		    { % endif % }

		  
		下方添加如下<font color=red>多说评论链接路径</font>
	
			{ % if site.duoshuo_short_name 		and page.comments != false and post.comments != false and site.duoshuo_comments == true % }
			| <a href="{ % if index % }{{ root_url }}{{ post.url }}{ % endif % }#comments">Comments</a>
			{ % endif % }  
* ######首页侧边栏插入最新评论
	* 首先在 _config.yml 中再插入如下代码
	
			duoshuo_asides_num: 10      # 侧边栏评论显示条目数
			duoshuo_asides_avatars: 0   # 侧边栏评论是否显示头像
			duoshuo_asides_time: 0      # 侧边栏评论是否显示时间
			duoshuo_asides_title: 0     # 侧边栏评论是否显示标题
			duoshuo_asides_admin: 0     # 侧边栏评论是否显示作者评论
			duoshuo_asides_length: 18   # 侧边栏评论截取的长度	  
	* 再创建 <font color=red>_includes/custom/asides/recent_comments.html</font>

			<section>
			<h1>Recent Comments</h1>
		    <ul class="ds-recent-comments"
		     data-num-items="{{ site.duoshuo_asides_num }}"
		      data-show-avatars="{{ site.duoshuo_asides_avatars }}"
		       data-show-time="{{ site.duoshuo_asides_time }}"
		        data-show-title="{{ site.duoshuo_asides_title }}"
		         data-show-admin="{{ site.duoshuo_asides_admin }}" 
		         data-excerpt-length="{{ site.duoshuo_asides_length }}"></ul>
		    { % if index % }
			<!-- 多说js加载开始，一个页面只需要加载一次 -->
					<script type="text/javascript">
					  var duoshuoQuery = {short_name:"{{ site.duoshuo_short_name }}"};
					  (function() {
					    var ds = document.createElement('script');
					    ds.type = 'text/javascript';
					    ds.async = true;
					    ds.src = 'http://static.duoshuo.com/embed.js';
					    ds.charset = 'UTF-8';
					    (document.getElementsByTagName('head')[0]  || 
					    document.getElementsByTagName('body')[0]).appendChild(ds); 
					    })();
					</script>	
			<!-- 多说js加载结束，一个页面只需要加载一次 -->
		    { % endif % }
			</section>	  
	* 最后修改：<font color=red>_config.yml </font>配置:  
		* 方式一：在<font color=red> blog_index_asides</font> 行或 <font color=red>page_asides </font>行或 <font color=red>post_asides </font>添加：
			
				blog_index_asides:[custom/asides/recent_comments.html]
				或
				page_asides:[custom/asides/recent_comments.html]
				或
				post_asides:[custom/asides/recent_comments.html]
				
		* 方式二：将路径添加到 default_asides:[...] 中
		
				default_asides: [custom/asides/recent_comments.html, asides/recent_posts.html, ...]
	* Update

			多说评论似乎升级了系统，无法自动获取到页面文章标题，所以手动在评论页插入 data-title。--2013.09.10
####Tips:
* ######发布图文：
如果在文章中上传图片：
	* 直接copy到/source/images目录即可。便可以以相对路径(/images/imgname.png)的形式，在文章中引用。	* 或找一个图库站点，例如flickr之类，然后在文章中引用该图片远程路径即可。  
* ######域名：
如果有自己的域名空间，可以将域名指向自己的博客，步骤如下：


	* **配置DNS(需购买域名)**:在域名管理中，新建一个CNAME指向，将自己的域名指向yourname.github.com.
	* **给repo配置域名**:在source目录里，新建一个名为CNAME的文件，然后将自己的域名输入即可。
	* 将内容push到github后，大概需审核一个小时左右生效，然后就可以使用自己的域名访问该博客了。  

* ######添加百度统计和google analytics  
	* 从百度统计获取脚本,然后添加到文件source/_includes/after_footer.html文件中。
	* 从google analytics获取跟踪ID,然后将这个ID添加到_config.yml文件的google_analytics_tracking_id后面即可。  
<!--![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "title text")-->  

* **Octopress**目录结构，及之间的关系：  
￼![alt text](/images/sourceFrame.png "Octopress目录图解")  

* ######原理：
	* Octopress其实为你建立了2各分支：
		* master分支：用于存放生成的最终网页。
		* source分支:用于存放最初的markdown文件。
	  
	 职责详述：平时写作和提交都在source分支下，当需要发布时，rake deploy 命令会将内容生成到public这个目录，然后将这个目录中的内容当做master分支的内容同步至github远程库中。
	 
- * 其中**sass**和**source**:这是博客的源代码文件目录。发布时，需要把源代码也上传到github上,这样便可以多台机写博客了。
- * **_deploy**:是通过octopress生成的静态页面的博客文件夹,我们可以看到它的里面也有.git的文件。 
	- cd进到该目录,使用`git remote ­v`查看
	
			origin http://github.com/xunyn/xunyn.github.io(fetch) 
			origin http://github.com/xunyn/xunyn.github.io(push)  
	- 它会在我们使用rake deploy时自动push到 我们的路径下。这时候我们不需要在自已去push。但是博客源代码是需要我们自己push到github的server的.  
- * 使用多台电脑的同时写博客
	- 1. 需要先拿把source code拿下来 `git pull origin source` 
	- 2. 然后在更改了source后,`check in`更新,将本地 source update github的代码仓库上 
	
				git add . 
				git commit -m 'yourmessage' 
				git push origin source