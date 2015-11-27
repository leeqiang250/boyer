---
layout: post
title: "calabash一款跨平台UI测试工具初探"
date: 2015-10-06 08:32:41 +0800
comments: true
tags: [持续集成,TDD,BDD]
keywords: 持续集成,TDD,BDD
categories: 持续集成
---
参考：[使用jenkins+calabash+cocoapods搭建ios持续集成环境](http://blog.csdn.net/zangcw/article/details/25299243)

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
	这个语句，判定了当前条件"on the Welcome Screen"是否满足，如果element存在，则就在"Welcome Screen"
	
[更多的测试框架](http://www.infoq.com/cn/articles/build-ios-continuous-integration-platform-part2)

UIAutomation

UIAutomation是随着iOS SDK 4.0引入，帮助开发者在真实设备和模拟器上执行自动化的UI测试。其本质上是一个Javascript的类库，通过 界面上的标签和值的访问性来获得UI元素，完成相应的交互操作，从而达到测试的目的，类似于Web世界的Selenium。

通过上面的描述，可以得知，使用UIAutomation做测试时，开发者必须掌握两件事：

- 如何找到界面上的一个UI元素
- 如何指定针对一个UI元素的操作

在UIAutomation中，界面就是由一堆UI元素构建的层级结构，所有UI元素都继承对象UIAElement ，该对象提供了每个UI元素必须具备的一些属性：

- name
- value
- elements
- parent
- …

而整个界面的层级结构如下：

	arget（设备级别的UI，用于支持晃动，屏幕方向变动等操作）
	    Application（设备上的应用，比方说Status Bar，keyboard等）
	      Main window（应用的界面，比方说导航条）
	        View（界面下的View，比方说UITableView）
	           Element（View下的一个元素）
	              Child element(元素下的一个子元素)
下面是一个访问到Child element的例子：

	UIATarget.localTarget().HamcrestDemo().tableViews()[0].cells()[0].elements()
开发者还可以通过“UIATarget.localTarget().logElementTree()”在控制台打印出该target下所有的的elements。

找到UI元素之后，开发者可以基于该UI元素做期望的操作，UIAutomation作为原生的UI测试框架，基本上支持iOS上的所有UI元素和操作，比方说：

- 点击按钮，例: ***.buttons[“add”].tap()
- 输入文本, 例:***.textfields[0].setValue(“new”)
- 滚动屏幕，例:***.scrollToElementWithPredicate(“name begin with ’test’”)
- ……
关于使用UIAutomation做UI测试，推荐大家一定要看一下2010的WWDC的Session 306：[Automating User Interface Testing with Instruments](https://developer.apple.com/videos/wwdc/2010/?id=306)。 另外，这儿还有一篇很好的博客，详细的讲解了[如何使用UIAutomation做UI自动化测试](http://blog.manbolo.com/2012/04/08/ios-automated-tests-with-uiautomation)  
Apple通过Instruments为UIAutomation测试用例的命令行运行提供了支持，这样就为UIAutomation和CI服务器的集成提供了便利。开发者可以通过如下的步骤在命令行中运行UIAutomation测试脚本:
1. 指定目标设备，构建被测应用，该应用会被安装到指定的DSTROOT目录下
```ruby
xcodebuild
-project "/Users/twer/Documents/xcodeworkspace/AudioDemo/AudioDemo.xcodeproj" 
-schemeAudioDemo
-sdk iphonesimulator6.1 
-configuration Release SYMROOT="/Users/twer/Documents/xcodeworkspace/
AudioDemo/build" DSTROOT="/Users/twer/Documents/xcodeworkspace/AudioDemo/
build" TARGETED_DEVICE_FAMILY="1" 
install
```
2. 启动Instruments，基于第一步生成的应用运行UIAutomation测试
```ruby
instruments
-t  "/Applications/Xcode.app/Contents/Applications/Instruments.app/
Contents/PlugIns/AutomationInstrument.bundle/Contents/Resources/
Automation.tracetemplate" "/Users/twer/Documents/xcodeworkspace/AudioDemo
/build/Applications/TestExample.app"
-e UIASCRIPT <absolute_path_to_the_test_file>
``` 
为了更好的展示测试效果以及与CI服务器集成，活跃的社区开发者们还尝试把UIAutomation和Jasmine集成: https://github.com/shaune/jasmine-ios-acceptance-tests

UIAutomation因其原生支持，并且通过和Instruments的绝佳配合，开发者可以非常方便的使用录制操作自动生成测试脚本，赢得了很多开发者的支持，但是因苹果公司的基因，其系统非常封闭，导致开发者难以扩展，于是活跃的社区开发者们开始制造自己的轮子，[Fone Monkey,最新版本更新于2010年，估计过时](https://gorillalogic.com/fonemonkey-0-7-1-released/)就是其中的一个优秀成果。