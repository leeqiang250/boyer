---
layout: post
title: "快速正确的安装 Ruby, Rails 运行环境"
date: 2015-01-21 23:00:39 +0800
comments: true
categories:
---
安装ruby环境：
方法一：下载源码，编译安装：[配置中制定安装目录](http://fsjoy.blog.51cto.com/318484/115045/)  
方法二：使用rvm安装：[可以提供一个便捷的多版本 Ruby 环境的管理和切换](https://ruby-china.org/wiki/rvm-guide)  
方法三：使用macport安装 `port install ruby`

[详细教程](https://ruby-china.org/wiki/install_ruby_guide)


问题：  
`ERROR: While executing gem ... (Errno::EPERM) Operation not permitted - /usr/bin/rake`
[stackoverflow方法](http://stackoverflow.com/questions/30812777/cannot-install-cocoa-pods-after-uninstalling-results-in-error/30851030#30851030)测试结果没走通。  
最终通过[OS X 10.11中Rootless的实现与解释以及关闭方法](http://tadaland.com/os-x-rootless.html)解决.
####Gem介绍

Gem是一个ruby库和程序的标准包，它通过RubyGem来定位、安装、升级和卸载，非常的便捷。

Ruby 1.9.2版本默认安装RubyGem，如果你使用其它版本，请参考如何安装RubyGem。
<!--more-->
####升级RubyGem
{%codeblock lang:ruby%}
$ gem update --system
{%endcodeblock%}

####安装新的Gem
{%codeblock lang:ruby%}
$ gem install rai

//指定安装某一版本的Gem包
gem install [gemname] --version=1.3.2
{%endcodeblock%}

在安装过程中可以看到如下提示，说明它是从rubygems.org内去寻找并安装gem package的。
Fetching source index for http://rubygems.org/

####gem 的安装方式


####MacPorts安装和使用
http://ccvita.com/434.html  
http://guide.macports.org  
http://www.fantageek.com/318/install-pkg-config-for-mac-osx/  


Mac下面除了用dmg、pkg来安装软件外，比较方便的还有用MacPorts来帮助你安装其他应用程序，跟BSD中的ports道理一样。MacPorts就像apt-get、yum一样，可以快速安装些软件。

安装后，配置：

	sudo vi /etc/profile
	export PATH=/opt/local/bin:$PATH
	export PATH=/opt/local/sbin:$PATH

MacPorts使用 http://witcheryne.iteye.com/blog/991821

1. 更新ports tree和MacPorts版本，强烈推荐第一次运行的时候使用-v参数，显示详细的更新过程。
sudo port -v selfupdate

2. 搜索索引中的软件
	
	port search name

3. 安装新软件  
sudo port install name

4. 卸载软件  
sudo port uninstall name

5. 查看有更新的软件以及版本  
port outdated

6. 升级可以更新的软件  
sudo port upgrade outdated

实例：  
Eclipse的插件需要subclipse需要JavaHL，下面通过MacPorts来安装

	sudo port install subversion-javahlbindings

	installed 
列出全部或者指定的已经安装的软件：

        port installed
        port -v installed atlas
dependents 查看哪些软件时依赖与这个软件的

    删除一个软件时候，最好先执行一下这个命令.
        port dependents openssl
