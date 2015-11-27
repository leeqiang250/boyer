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
要求:搭建一个独立博客网站,首先要有台连接到英特网服务器,要有前端的页面和后端的数据库,以及域名等.

1. github可以提供给我们的是,github一个免费的代码托管仓库,它支持用户html页面的显示,用户可以上传HTML文件,然后在远程像访问网页一样访问它。

2. 这时，博客还缺具有管理能力的网站后台,github不提供数据库等，对于博客这种数据规模很小,便可返璞归真,用回静态页面。
3. **Octopress**:能将易于编写的**Markdown**的文本，翻译成为繁琐的**html**页面，同时帮助用户管理**html**页面并发布到github page上。

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

* 新建Markdown文件: 		 `rake new_post['文章名']`或 `rake new_page['404']`

* 翻译Mardown为静态文件:   `rake generate`

* 检测文件变化：			`rake watch`

* 启动本机测试端口4000：  `rake preview`

* 发布至git库：			`rake deploy`


####添加多说：

  需要在多说网注册个帐号，添加站点，获取站点 <font color=red>short_name</font>.

* ######底部评论：

	* 在 <font color=red> _config.yml</font> 	中添加
{%codeblock lang:ruby %}
#duoshuo comments
duoshuo_comments: true
duoshuo_short_name: yourname
{%endcodeblock%}
* 在<font color=red>`source/_layouts/post.html`</font>中的<font color=red> disqus</font>代码：

{%codeblock lang:js %}
{ % if site.disqus_short_name and page.comments == true % }
	<section>
		<h1>Comments</h1>
 		<div id="disqus_thread" aria-live="polite">{ % include post/disqus_thread.html % }</div>
	</section>
{ % endif % }
{%endcodeblock%}
下方添加 <font color=red>多说评论</font> 模块:

{%codeblock lang:js %}
{ % if site.duoshuo_short_name and site.duoshuo_comments == true and  page.comments == true % }
<section>
 			<h1>Comments</h1>
 				<div id="comments" aria-live="polite">{ % include post/duoshuo.html % }</div>
 				</section>
{ % endif % }
{%endcodeblock%}

* 然后就按路径创建一个<font color=red>source/_includes/post/duoshuo.html</font>

{%codeblock lang:js %}
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
{%endcodeblock%}

随后，再修改 <font color=red>_includes/article.html </font>文件,
```	js
{ % if site.disqus_short_name and page.comments != false and post.comments !=false and site.disqus_show_comment_count == true % }
			 | <a href="{ % if index % }{{ root_url }}{{ post.url }}{ % endif % }#disqus_thread">Comments</a>
{ % endif % }
```

下方添加如下<font color=red>多说评论链接路径</font>：

{%codeblock lang:js %}
{ % if site.duoshuo_short_name and page.comments != false and post.comments != false and site.duoshuo_comments == true % }
| <a href="{ % if index % }{{ root_url }}{{ post.url }}{ % endif % }#comments">Comments</a>
{ % endif % }

{%endcodeblock %}

* ######首页侧边栏插入最新评论
  * 首先在 _config.yml 中再插入如下代码
	{%codeblock lang:ruby %}
	duoshuo_asides_num: 10      # 侧边栏评论显示条目数
	duoshuo_asides_avatars: 0   # 侧边栏评论是否显示头像
	duoshuo_asides_time: 0      # 侧边栏评论是否显示时间
	duoshuo_asides_title: 0     # 侧边栏评论是否显示标题
	duoshuo_asides_admin: 0     # 侧边栏评论是否显示作者评论
	duoshuo_asides_length: 18   # 侧边栏评论截取的长度
	{%endcodeblock %}

  * 再创建 <font color=red>_includes/custom/asides/recent_comments.html</font>
{%codeblock lang:html %}
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
{%endcodeblock %}

* 最后修改：<font color=red>_config.yml </font>配置:
	* 方式一：在<font color=red> blog_index_asides</font> 行或 <font color=red>page_asides </font>行或 <font color=red>post_asides </font>添加：

{%codeblock lang:ruby %}
blog_index_asides:[custom/asides/recent_comments.html]
或
page_asides:[custom/asides/recent_comments.html]
或
post_asides:[custom/asides/recent_comments.html]
{%endcodeblock %}

   * 方式二：将路径添加到 default_asides:[...] 中
{%codeblock lang:ruby %}
default_asides: [custom/asides/recent_comments.html, asides/recent_posts.html, ...]
{%endcodeblock %}

   * Update
	``` html
	 多说评论似乎升级了系统，无法自动获取到页面文章标题，所以手动在评论页插入 data-title。--2013.09.10
	```
####Tips:

* ######发布图文：

如果在文章中上传图片：

	* 直接copy到/source/images目录即可。便可以以相对路径(/images/imgname.png)的形式，在文章中引用。

	* 或找一个图库站点，例如flickr之类，然后在文章中引用该图片远程路径即可。
* ######域名：
如果有自己的域名空间，可以将域名指向自己的博客，步骤如下：


	* **配置DNS(需购买域名)**:在域名管理中，新建一个CNAME指向，将自己的域名指向yourname.github.com.

	* **给repo配置域名**:在source目录里，新建一个名为CNAME的文件，然后将自己的域名输入即可。

	* 将内容push到github后，大概需审核一个小时左右生效，然后就可以使用自己的域名访问该博客了。

* ######添加百度统计和google analytics
	* 从[百度统计](http://tongji.baidu.com/)获取脚本,然后添加到文件source/_includes/after_footer.html文件中。
	* 从[google analytics](https://support.google.com/analytics/)获取跟踪ID,然后将这个ID添加到_config.yml文件的google_analytics_tracking_id后面即可。
<!--![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "title text")-->

* **Octopress**目录结构，及之间的关系：

￼![alt text](/images/sourceFrame.png "Octopress目录图解")

* ######原理：

	* Octopress版本库：

		* **gh-pages**分支：用于存放生成的最终网页。

		* **source**分支:用于存放最初的markdown文件。

	 职责详述：平时写作和提交都在**source**分支下，当需要发布时，`rake deploy` 命令会将内容生成到public这个目录，然后将这个目录中的内容push到**gh-pages**分支中。

- * 其中**sass**和**source**:这是博客的源代码文件目录。发布时，需要把源代码也上传到github上,这样便可以多台机写博客了。
- * **_deploy**:是通过octopress生成的静态页面的博客文件夹,我们可以看到它的里面也有.git的文件。
	- cd进到该目录,使用`git remote ­v`查看
{%codeblock lang:js %}
origin http://github.com/....github.io(fetch)
origin http://github.com/....github.io(push)
{%endcodeblock%}
- 它会在我们使用`rake deploy`时自动push到该远程库的**gh-pages**分支。这时就不需要再手动push。只需要将博客源代码手动push到该远程库的**source**分支中.
	**以上细节可参照Octopress根目录中Rakefile配置信息**
- * 使用多台电脑的同时写博客
	- 1. 需要先拿把**source** code拿下来 `git pull origin source`
	- 2. `check in`更新,将本地 **source**分支上的代码，合并到远程仓库上
```
git add .
git commit -m 'yourmessage'
git push origin source
```
######版本管理

你可以先去github上新建一个空的Repo（最好是private的，否则可能会被其他人拿到你的source），拿到repo的url，然后到octopress目录下执行下面这些操作：
``` ruby
# 因为你是从octopress github上clone的，所以需要把origin这个branch换一个名字
git remote rename origin octopress
git remote add origin (your github url)
# 把你的github branch作为默认的branch
git config branch.master.remote origin
# 把你的octopress导入到github上去
git push -u origin master
```
如果你新增加了博客或者修改了某些内容，你可以把你的改动commit到github上去：
```
git add source
git commit -a -m 'new blog or edit some blog'
git push -u origin master
```
如果octopress有更新，你可以直接pull octopress这个branch进行更新即可
```
git pull octopress master
git push -u origin master
```
