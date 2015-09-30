---
layout: post
title: "Xcode&amp;Jenkins持续集成的几种实现方式"
date: 2015-09-18 23:52:06 +0800
comments: true
categories: 
---
## xcode 持续集成的实现
[Setting Up Xcode Server](https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/xcode_guide-continuous_integration/adopt_continuous_integration.html#//apple_ref/doc/uid/TP40013292-CH3-SW1)


jenkins使用配置：  

1. 下载：http://mirrors.jenkins-ci.org/war/lastest/jenkins.war  
2. 运行命令行：  

	```
 	 nohup java -jar ~/Downloads/jenkins.war —httpPort=8081 —ajp13Port=8010 > /tmp/jenkins.log 2>&1 &
	```  
3. 写入启动文件中，起别名  

	```
	vi /Users/(username)/.bash_profile  
	输入:alias jenkins="nohup java -jar ~/Downloads/SVNRepos/jenkins.war --httpPort=8081 --ajp13Port=8010 > /tmp/jenkins.log 2>&1 &”  
	```  
4. 启动时，在命令行中输入：**`jenkins`** 回车  即可启动
5. 访问：http://127.0.0.1:8081/
6. 重启：http://[jenkins-server]/[command] exit推出，restart重启，reload重载。

####[使用jenkins+calabash+cocoapods搭建ios持续集成环境](http://blog.csdn.net/zangcw/article/details/25299243)

1. calabash  是一款开源的跨平台UI测试工具，目前支持iOS和Android。它使用Cucumber作为测试核心，Cucumber是一个在敏捷团队十分流行的自动化的功能测试工具，它使用接近于自然语言的特性文档进行用例的书写和测试，支持多语言和多平台。
2. 安装Calabash  
	```
	sudo gem install calabash-cucumber
	```
3. 安装Calabash中文支持包  
	```
	sudo gem install calabash-cucumber-cn
	```

####For automatic setup:      

1. In a terminal, go to your iOS project  
	```
	cd path-to-my-ios-project (i.e. directory containing .xcodeproj file)
	```  
2. Install calabash-cucumber gem (this make take some time because of dependencies)  
	```
	gem install calabash-cucumber
	```
3. Setup your project for Calabash-iOS.  
	```
	calabash-ios setup  //Answer the questions and read the output :)
	```
4. Generate a skeleton features folder for your tests  
	```
	calabash-ios gen
	```
5. In Xcode, build your project using the -cal scheme

6. Run the generated test!  
	```
	cucumber
	```

If all goes well, you are now ready to write your first test. Start by editing the file features/my_first.feature.

####[cucumber官网](https://cukes.info/)   

		* Feature（功能）  
		* Scenario（情景）  
		*  Given（给定）  
		*  When（当）  
		*  Then（则） 
#####[运行原理](http://www.educity.cn/se/619226.html)  
![image](http://img.educity.cn/img_7/262/2013122000/125005907.jpg)  
cucumber是一种BDD测试框架，核心为cucumber的calabash的脚本在运行测试的时候会在虚拟机/真机上预装一个web服务器，这个web服务器就是解释calabash的脚本，将其解释为robotium的脚本，然后这个web服务器会想测试app发送robotium的脚本，测试app拿到robotium脚本后，将其解释为instumentation命令向被测试的app发送这些命令，被测试的app执行这些命令，然后将结果返回给测试app，然后一级一级返得到最后的测试结果。    
#####结构框架
calabash完全采用了cucumber的结构模式，calabash是脚本与TC分离设计，在业务变化的情况下，只要功能存在基本只需要修改TC逻辑，在业务不变，功能变化的情况下，基本只需要修改脚本。   
![image](http://img.educity.cn/img_7/262/2013122000/126005907.jpg)  
feature为主件夹，step_definitions目录内是你封装的脚本，my_first.feature文件就是你的TC逻辑。  
再看一下其中的内容：

	　　my_first.feature
	
	　　Feature： 登陆
	
	　　Scenario： 输入正确的用户名密码能够正常登陆
	
	　　When 打开登陆页面
	
	　　And    输入用户名XXX输入密码XXX
	
	　　And   点击登陆
	
	　　Then  验证登陆成功

　　看起来很简单吧，想要验证其他功能也是类似的语言描述即可。  
如果你没有用过cucumber或者calabash那么你肯定现在有一个疑问，计算机怎么能识别汉字来进行测试的呢，  
那么看一下step_definition，以 输入用户名XXX输入密码XXX为例：

		When /^ 输入用户名\"([^\\\"]*)\" 输入密码\"([^\\\"]*)\"  $/ do |username，password|
		performAction('enter_text_into_numbered_field'，username，1)
		performAction('enter_text_into_numbered_field'，password，2)
		end
现在应该能明白为什么你需要写汉字的脚本就可以了吧。  
在这里解释一下为什么如果业务存在功能修改这种情况，自动化脚本的修改量会小。  
还是以这个登录脚本为例：

	假如现在输入用户名和密码的输入框顺序变了，在你的页面显示上，可能是从左下角移到中间了，这种变化，那么feature文件你不用改，只需要改step_definition脚本就好了
#####运行报告
alabash-android支持很多报告生成模式，支持html，json，junit等等报告模式，只需要你在run的时候添加-f参数-o参数就可以了。

　　例如 calabash-android run xxxx.apk -f html -o l，上图展示一下强大html报告  
　　![image](http://img.educity.cn/img_7/262/2013122000/127005907.jpg)

[【cucumber解析features文件】](http://blog.csdn.net/qs_csu/article/details/9000262) 		
1. my_first.feature: 描述在这个条件下需要做什么事情；

		Feature: Running a test  
		  As an iOS developer  
		  I want to have a sample feature file  
		  So I can begin testing quickly  
		  
		Scenario: Example steps1  
		  Given I am on the Welcome Screen  
		  Then I swipe left  
		  And I wait until I don't see "Please swipe left"  
		  And take picture  
		  
		Scenario: Example steps2  
		  Given I am on the Welcome Screen  
		 #ASSERTION  
		  Then I should see a "login" button  
		 #INPUT TEXT  
		  Then I enter "my_username" into text field number 1  
		#  Then I touch "Return"  
		  
		 #TOGGLE SWITCH  
		  Then I toggle the switch  
		  Then I touch "Login"  
		  And I touch "Second"  
		  And take picture  
	该文件描述了在“on the Welcome Screen”这个Step中需要做的事情，两个场景:steps1 和 steps2. 

2. my_first_step.rb: 解释了Given的具体条件

		Given /^I am on the Welcome Screen$/ do  
		  element_exists("view")  
		  check_element_exists("label text:'First View'")  
		  sleep(STEP_PSEAU)  
		end
	这个语句，判定了当前条件"on the Welcome Screen"是否满足，如果element存在，则就在"Welcome Screen"；