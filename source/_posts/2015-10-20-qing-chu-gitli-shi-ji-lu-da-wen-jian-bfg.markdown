---
layout: post
title: "清除git历史记录大文件bfg"
date: 2015-10-20 11:17:27 +0800
comments: true
categories: 
---

1. [下载bfg](https://search.maven.org/remote_content?g=com.madgag&a=bfg&v=LATEST) 到本地soft/bfg目录下。
2. sudo vi ~/.bash_profile  添加如下：

```
alias bfg="java -jar ~/Downloads/soft/bfg/bfg.jar"
```
3. cd 到库目录，执行bfg命令： [bfg官网](https://rtyley.github.io/bfg-repo-cleaner/) 

``` 
	$ cd PBB_SSH所属目录下
	$ bfg --delete-folders universal --no-blob-protection  PBB_SSH
	$ cd PBB_SSH
	$ git reflog expire --expire=now --all && git gc --prune=now --aggressive
	$ git push
```