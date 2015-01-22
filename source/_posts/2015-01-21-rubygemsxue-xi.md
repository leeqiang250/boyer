---
layout: post
title: "RubyGems学习"
date: 2015-01-21 23:00:39 +0800
comments: true
categories:
---
####Gem介绍

Gem是一个ruby库和程序的标准包，它通过RubyGem来定位、安装、升级和卸载，非常的便捷。

Ruby 1.9.2版本默认安装RubyGem，如果你使用其它版本，请参考如何安装RubyGem。

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

