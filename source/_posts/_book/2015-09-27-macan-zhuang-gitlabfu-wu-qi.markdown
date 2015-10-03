---
layout: post
title: "Mac安装gitLab服务器"
date: 2015-09-27 19:25:38 +0800
comments: true
categories: 
---
####必要配置
	
	*创建一个名称为"gitlab"管理员用户，然后再创建一个名称为"gitlab"的群组
	*开启gitlab用户的远程登录

在系统启动界面:  
隐藏gitlab用户 
	
	sudo defaults write /Library/Preferences/com.apple.loginwindow HiddenUsersList -array-add gitlab
显示git用户
	
	sudo defaults delete /Library/Preferences/com.apple.loginwindow HiddenUsersList
####添加系统账户gitlab

######生成gitlab服务器目录，即用户根目录
进入**系统偏好设置...**,在管理**用户与群组**中，添加其他用户，暂时定为：gitlab ，登录密码假设为：gitlab，添加完成后，会自动在/Users目录下，生成用户根目录gitlab.
######安装 Gitlab Shell

	cd /Users/gitlab
	sudo -u gitlab git clone https://github.com/gitlabhq/gitlab-shell.git
	cd gitlab-shell
	sudo -u gitlab git checkout v1.9.1
	sudo -u gitlab cp config.yml.example config.yml
打开 config.yml,然后进行编辑  
设置  gitlab_url. 把 gitlab.example.com 替换成你自己的域名 （如果本地就不用了）  
把所有的/home 替换成 /Users

	sudo -u gitlab sed -i "" "s/\/home\//\/Users\//g" config.yml
	sudo -u gitlab sed -i "" "s/\/usr\/bin\/redis-cli/\/usr\/local\/bin\/redis-cli/" config.yml
然后执行安装脚本：`sudo -u gitlab -H ./bin/install`  **//需在gitlab-shell目录下载执行**

######安装gitlab
先下载gitlab

	cd /Users/gitlab
	sudo -u gitlab git clone https://github.com/gitlabhq/gitlabhq.git
	cd gitlab
	sudo -u gitlab git checkout 6-7-stable
配置gitlab

	sudo -u gitlab cp config/gitlab.yml.example config/gitlab.yml
	sudo -u gitlab sed -i "" "s/\/usr\/bin\/git/\/usr\/local\/bin\/git/g" config/gitlab.yml
	sudo -u gitlab sed -i "" "s/\/home/\/Users/g" config/gitlab.yml
	sudo -u gitlab sed -i "" "s/localhost/domain.com/g" config/gitlab.yml

配置MySQL数据库，创建gitlab用户，数据库，和gitlab用户的管理权限

	# Login to MySQL
	$ mysql -u root -p
	
	# Create the GitLab production database
	mysql> CREATE DATABASE IF NOT EXISTS `gitlabhq_production` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;
	
	# Create the MySQL User change $password to a real password
	mysql> CREATE USER 'gitlab'@'localhost' IDENTIFIED BY '$password';
	
	# Grant proper permissions to the MySQL User
	mysql> GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON `gitlabhq_production`.* TO 'gitlab'@'localhost';
	
######安装 Gitolite帮助管理git内部用户

克隆gitlab的gitolite分支源代码：
	
	sudo -H -u gitlab git clone -b gl-v304 https://github.com/gitlabhq/gitolite.git /Users/gitlab/gitolite
安装：

	cd /Users/gitlab
	sudo -u gitlab -H mkdir bin
	sudo -u gitlab sh -c 'echo -e "PATH=\$PATH:/Users/gitlab/bin\nexport PATH" >> /Users/gitlab/.profile'
	sudo -u gitlab sh -c 'gitolite/install -ln /Users/gitlab/bin'
	
	sudo cp ~/.ssh/id_rsa.pub /Users/gitlab/gitlab.pub
	sudo chmod 0444 /Users/gitlab/gitlab.pub
	
	sudo -u gitlab -H sh -c "PATH=/Users/gitlab/bin:$PATH; gitolite setup -pk /Users/gitlab/gitlab.pub"

为 Git 创建用户：	
	
	sudo adduser \
	  --system \
	  --shell /bin/sh \
	  --gecos 'git version control' \
	  --group \
	  --disabled-password \
	  --home /home/git \
	  git
	

若干问题解决办法：[Mac搭建Git服务器—开启SSH](http://www.cnblogs.com/whj198579/archive/2013/04/09/3009350.html)

	Cloning into '/tmp/gitolite-admin'...
	ssh: connect to host localhost port 22: Connection refused
	fatal: Could not read from remote repository.
SSH无密码登陆设置：
	
	$ cd /etc
	$ chmod 666 sshd_config
	$ vim sshd_config
	
	#PermitRootLogin yes  改为：PermitRootLogin no
	#UsePAM yes			 改为: UsePAM no
Remove the # from the following
	
	#RSAAuthentication yes
	#PubkeyAuthentication yes
	#AuthorizedKeysFile     .ssh/authorized_keys	
	#PasswordAuthentication no
	#PermitEmptyPasswords no
	
		
		
		
	
	
	
	
	