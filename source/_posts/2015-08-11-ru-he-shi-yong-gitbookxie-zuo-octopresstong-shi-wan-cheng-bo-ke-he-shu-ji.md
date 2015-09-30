---
layout: post
title: "如何使用gitBook协作Octopress同时完成博客和书籍"
date: 2015-08-11 14:41:40 +0800
comments: true
categories:
---
使用GitBook 来编写Octopress博客的步骤：  
1. ```cd ~/MyBlog```  
2. **`rake new_post['文章名']`**或 **`rake new_page['404']`**新建md文档.  
3. **`mv *.markdown *.md`** mv命令修改后缀为md，便于gitbook在Preview website识别该文档。  
4. 配置SUMMARY.md 关联 gitbook，通过目录访问Octopress文档。  
5. 打开gitbook客户端，对新建的文档进行编写即可。
