---
layout: post
title: "小米路由常用操作"
date: 2015-09-25 23:59:16 +0800
comments: true
categories: 
---
####常用命令

1. ssh登录

		局域网登录:
		ssh [user@]hostname [command]
		 例如：ssh root@192.168.31.1  或  远程登录：ssh root@222.35.145.28 -p 2195
		回车
		输入密码

		**修改密码：**
		root@xiaoqiang:~#passwd   
		回车
		输入新密码
		回车
		再次输入新密码
2. 远程拷贝数据
		
		scp Desktop/ar71xx/* root@192.168.31.1:/userdisk/myWorkspace/ar71xx
		
3. 每次重启路由获取IP:
		
		vi /etc/rc.local
		sh /etc/getIP.sh
//启动后，等待20秒，然后，获取当前时间作为文件名称
//使用ifconfig 获取路由器的ip信息
//使用 | grep 通道，和grep正则来过滤出，wan口的ip所在行
// > 使用重定向，将过滤的ip行，写入路由硬盘/userdisk/data/my/ip目录中
//通过小米路由手机客户端，找到该txt文件，并下载到手机sd卡中
//查看该文件，既有路由重启后的当前IP  
<!--more-->
	详见getIP.sh

		#!/bin/sh
		sleep 20
		current_date=`date +%Y_%m_%d`
		current_time=`date +%H_%M_%S`
		echo $current_date
		echo $current_time
		#local_ip=`ifconfig |grep '[0-9]\{1,3\}.*P-t-P'`
		local_ip=`ifconfig | grep P-t-P`
		echo $local_ip > /userdisk/data/my/ip/$current_date:$current_time.txt

4. 修改防火墙设置**/etc/config**目录下的**dropbear**和**firewall**  

		cd /etc/config  //把备份文件内容覆盖新文件即可
		1.cat dropbear.bak > dropbear  
			增加如下内容：
			config dropbear
			option PasswordAuth 'on'
			option RootPasswordAuth 'on'
			option Interface 'wan'
			option Port '2195'
		2.保存文件修改后，再重启dropbear服务，一次输入下面两行命令：
			/etc/init.d/dropbear reload
			/etc/init.d/dropbear restart
		1.cat firewall.bak > firewall
			增加如下内容： 
			config rule
			option name 'Allow-wan-ssh'
			option src 'wan'
			option proto 'tcp'
			option dest_port '2195'
			option target 'ACCEPT'
		2.保存文档的更改后，重启防火墙服务，依次输入以下两条命令：
			/etc/init.d/firewall reload
			/etc/init.d/firewall restart

5.由于铁通机制，分配的独立iP，并不能被外网访问
#### ssh登录数据库	[转](http://bbs.xiaomi.cn/thread-10339070-1-1.html)
先确保能访问[LLMP搭建的个人网站地址](http://192.168.31.1:8088/phpinfo.php)  

修复教程：  

1. 登录路由： `ssh root@192.168.31.1`  mm:admin
2. 执行命令：`/userdisk/data/lamp.sh fix`  
3. 再次访问个人网站地址。  [LLMP搭建的个人网站地址](http://192.168.31.1:8088/phpinfo.php) 。 

		1./userdisk/data/lamp.sh  (安装本插件，一键开启llmp，具体安装过程可见前面的安装步骤）       
		2./userdisk/data/lamp.sh a（卸载本插件，恢复安装前，注：卸载本插件时路由器会自动重启一次，自动断网几分钟）
		3./userdisk/data/lamp.sh fix（升级小米路由器固件后，能瞬间恢复自己搭建的网站功能，另外，如果在极特殊的情况的情况下，本功能无效，可使用如下方法恢复自建网站的功能：先尝试重新安装本插件，如果提示不能重复安装，可先卸载本插件，再重新安装本插件，并按说明3对数据库执行修改密码命令，改回原来的密码，原来自己搭建网站就可恢复使用）
		4./userdisk/data/lamp.sh help  (插件用法的帮助信息）

登录数据库：`ssh mysql@192.168.31.1 -p 2222`

正确日志：
		
	AdmindeMacBook-Air:~ admin$ ssh mysql@192.168.31.1 -p 2222
	The authenticity of host '[192.168.31.1]:2222 ([192.168.31.1]:2222)' can't be established.
	RSA key fingerprint is SHA256:bLH9smUb7sD9CZLWCsT6t9YqPy2jciznepkscFNd59M.
	Are you sure you want to continue connecting (yes/no)? yes
	Warning: Permanently added '[192.168.31.1]:2222' (RSA) to the list of known hosts.
	mysql@192.168.31.1's password:admin

	BusyBox v1.19.4 (2015-05-08 18:41:26 CST) built-in shell (ash)
	Enter 'help' for a list of built-in commands.

		~ $
错误日志：
需要修改本地的ssh配置。

1. vi /Users/admin/.ssh/known_hosts文件
2. 删除包含[192.168.31.1]:2222的一行内容。
3. 重新登录数据库：ssh mysql@192.168.31.1 -p 2222。  

		AdmindeMacBook-Air:~ admin$ ssh mysql@192.168.31.1 -p 2222
		@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
		@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
		IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
		Someone could be eavesdropping on you right now (man-in-the-middle attack)!
		It is also possible that a host key has just been changed.
		The fingerprint for the RSA key sent by the remote host is
		SHA256:bLH9smUb7sD9CZLWCsT6t9YqPy2jciznepkscFNd59M.
		Please contact your system administrator.
		Add correct host key in /Users/admin/.ssh/known_hosts to get rid of this message.
		Offending RSA key in /Users/admin/.ssh/known_hosts:10
		RSA host key for [192.168.31.1]:2222 has changed and you have requested strict checking.
		Host key verification failed.
		
#####客户端MySQLWorkbench无法连接LLMP个人网站的MySql数据库
