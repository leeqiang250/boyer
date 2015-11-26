---
layout: post
title: "使用SmartSVN创建版本库"
date: 2015-10-05 19:16:47 +0800
comments: true
categories: 
---
SmartSVN有以下版本：

1. SmartSVN enterprise 9 企业版
2. SmartSVN foundation 8 基础版

由于企业版只能建立本地的版本库，无法创建&使用svn://localhost方式。
####用基础版来说明创建版本库。
参考：[Create Repository in SmartSVN – Tutorial](http://hammadk.com/how-to-create-repository-in-smartsvn-tutorial/)  

1. 启动SmartSVN SmartSVN foundation 8 基础版  
2. 菜单栏Project-> set up Local Repository...      
需要设置如下两个参数：  
	3. svnadmin 在终端执行： whereis svnadmin  
	4. svnserve 在终端执行： whereis svnserve  
￼![image](https://app.yinxiang.com/shard/s33/nl/2147483647/59a78b5d-81de-48f1-afe9-2fb2bde72da2//res/adeb039a-b429-481a-ac25-2044b871e45e/screenshot.png?resizeSmall&width=832)  
3. 指定版本库的目录位置：  
![image](https://app.yinxiang.com/shard/s33/nl/2147483647/59a78b5d-81de-48f1-afe9-2fb2bde72da2//res/a3f00903-101c-4848-a10a-3479643baea7/screenshot.png?resizeSmall&width=832)  
3. 初始化账户密码：  
![image](https://app.yinxiang.com/shard/s33/nl/2147483647/59a78b5d-81de-48f1-afe9-2fb2bde72da2//res/140f257e-e452-47ea-8317-34a5ed8d6c7f/screenshot.png?resizeSmall&width=832)  
4. 完成。  
![image](https://app.yinxiang.com/shard/s33/nl/2147483647/59a78b5d-81de-48f1-afe9-2fb2bde72da2//res/ed975623-72bb-4132-8d04-ac9a7b1d2fc9/screenshot.png?resizeSmall&width=832)  
![image](https://app.yinxiang.com/shard/s33/nl/2147483647/59a78b5d-81de-48f1-afe9-2fb2bde72da2//res/53306789-9d97-485c-a54d-a143e7b078f1/screenshot.png?resizeSmall&width=832)
	
#####开始导入项目源码，来跟踪版本变化，实现版本控制。  
5. 新建SmartSVNRepos目录，存放APP源码，用于导入版本库的原始目录。导入后，该目录源码就被版本跟踪了，在开发时，不用再从版本库导出，可以用该目录的代码直接在版本上开发了。  
![image](https://app.yinxiang.com/shard/s33/nl/2147483647/59a78b5d-81de-48f1-afe9-2fb2bde72da2//res/ee02bf65-27e3-435a-8300-8189bc087eb8/screenshot.png?resizeSmall&width=832)
6. 菜单栏Project -> Import Into Repository...  
![image](https://app.yinxiang.com/shard/s33/nl/2147483647/59a78b5d-81de-48f1-afe9-2fb2bde72da2//res/eccc10f0-4c5a-435c-8397-062028d0d4f4.png?resizeSmall&width=832)
7. 选择以上新建的SmartSVN版本库：svn://localhost  
![image](https://app.yinxiang.com/shard/s33/nl/2147483647/59a78b5d-81de-48f1-afe9-2fb2bde72da2//res/ecfe16b4-17ac-4fc1-a64f-1ce259d77b3b/screenshot.png?resizeSmall&width=832) 

查看是否安装SVN服务：

	svnserve —version

SVN随系统一起启动：
	
	vi /etc/rc.local   //(此文件Mac系统中默认是不存在的，需手动创建)
	
	添加启动SVN服务： 
	svnserve -d -r /data/svn/repos  
	
关闭svn服务:

	直接ps aux | grep svn，然后kill -9 进程号

1. 创建库:  
	打印应用目录命令：
	
		whereis svn
	
	新建版本库目录：

		sudo mkdir -p /data/svn/repos/local	
		chmod u+w 文件名
	创建：
	
		sudo svnadmin create /data/svn/repos/local
	    查看文件权限： ls -l

2. 配置版本库的访问权限

		cd conf/ 
	 
   1. 开启密码权限，普通用户/匿名用户
   
			sudo vi svnserve.conf
   2. 设置用户：密码
   
			sudo vi passwd
	
   2. 分组设置，组权限
   
			sudo vi authz
3. 启动svnserve服务  

   		sudo svnserve -d -r /data/svn/repos —log-file=/var/log/svn.log
   		
4. 测试端口：

    	telnet localhost 3690
    
5. 重启必先kill ：

		sudo kill PID
6. 版本库路径：

    	svn://localhost/local
其他：

		svn ls svn://svnpath 可以查询snv仓库内容  
		lsof -i :3690 查看svn是否启动  
		ps aux | grep ‘svn’ 查找所有svn启动的进程id  
		kill -9 pid 将pid替换为上面查到的进程id可以杀掉svn进程  

