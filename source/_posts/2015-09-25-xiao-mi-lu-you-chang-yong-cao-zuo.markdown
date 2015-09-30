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
