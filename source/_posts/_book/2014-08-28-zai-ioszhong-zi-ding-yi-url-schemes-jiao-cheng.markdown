---
layout: post
title: "在IOS中自定义URL Schemes 教程"
date: 2014-08-28 20:32:48 +0800
comments: true
categories: 
---
#### URL Schemes
iPhone SDK中最酷的功能之一是一个应用程序能够把自己和自定义的URL协议绑定，这个URL协议可用于启动该应用程序（通过浏览器或者iPhone上的另一个程序）。创建这样的绑定并不难，难得的是你忍不住要在你的程序里用它！

首先，你需要说明你想如何在程序中响应这个URL。最简单的自定义协议的方法是“唤醒”，而且可以通过URL把数据信息传递给程序，这样，程序被唤醒后能做更多的事情。

####注册自定义URL协议

首先需要向iPhone注册一个自定义URL协议。这是在你的项目文件夹的info.plist文件进行的（就是你改变应用程序图标的同一个文件）。

默认，Xcode在图形窗口中打开info.pllist，当然也可以直接用文本模式打开——对有的人来说这反而更简单。

######Step1. 右键，选择“Add Row”,在下拉选框中选择“**URL types**”，类型为Array:  
![image](/images/urlScheme2.gif)  
######Step2. 打开“Item 0″类型为Dic,添加新key为"URL identifier",类型为String。可以是任何值，但建议用“反域名”(例如 “com.myapp”)。
![image](/images/urlScheme2a.gif)  
#####Step3. 打开“Item 0″类型为Dic,添加新key为“URL Schemes”,类型为Array:
![image](/images/urlScheme2b.gif)  

* 类型为Array:  

	![image](/images/urlScheme2c.gif)

#####Step4. 在URL Schemes数组中添加Value，输入你的URL协议名 (例如“myapp://” 应写做“myapp”)。如果有必要，你可以在这里加入多个协议。
![image](/images/urlScheme2d.gif)  

######完成后如图所示：  
![image](/images/urlScheme2e.gif)  
	
* ######另两种视图浏览方式：
在info.plist页面上右击，选择**Raw Keys/Values**显示如下：  
![image](/images/urlScheme2f.png)
######xml  
![image](/images/urlScheme2g.gif)
<!--more-->
####处理URL

现在，URL已经注册好了。任何人都可以用打开URL的方式通过你的协议去启动一个应用程序。

* #####使用Safari 方式启动 app:Calling Custom URL Scheme from Safari【[下载](http://iosdevelopertips.com/downloads/#customURLScheme)】

Using the simulator, here’s how to call the app:

- Run the application from within Xcode  
![image](/images/urlScheme4a.png)  
- Once installed, the custom URL scheme will now be registered
- Close the app via the Hardware menu in simulator and choose Home
- Start Safari
- Enter the URL scheme defined previously in the browser address bar (see below)  
![image](/images/urlScheme32.png)  

* #####通过其他应用启动：Calling Custom URL Scheme from Another iPhone App【[下载](http://iosdevelopertips.com/downloads/#customURLScheme)】  
![image](/images/urlScheme4b.png)  

按钮的实现：
{%codeblock lang:objc%}
	 - (void)buttonPressed:(UIButton *)button
	{
	  NSString *customURL = @"iOSDevTips://";
	 
	  if ([[UIApplication sharedApplication] 
	    canOpenURL:[NSURL URLWithString:customURL]])
	  {
	    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:customURL]];
	  }
	  else
	  {
	    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"URL error"
	                          message:[NSString stringWithFormat:
	                            @"No custom URL defined for %@", customURL]
	                          delegate:self cancelButtonTitle:@"Ok" 
	                          otherButtonTitles:nil];
	    [alert show];
	  }    
	}
{%endcodeblock%}
Line 5 we check to see if the custom URL is defined, and if so, use the shared application instance to open the URL (line 8).   
The **`openURL:`**method starts the application and passes the URL into the app. The current application is exited during this process.  

* ##### 通过URL Schemes 传递参数启动应用：Passing Parameters To App Via Custom URL Scheme
Chances are you’ll need to pass parameters into the application with the custom URL definition. Let’s look at how we can do this with.

The **`NSURL `**class which is the basis for calling from one app to another conforms to the `RFC 1808` (Relative Uniform Resource Locators). Therefore the same URL formatting you may be familiar with for web-based content will apply here as well.

In the application with the custom `URL scheme`, the app delegate must implement the method with the signature below:
{%codeblock lang:objc%}
- (BOOL)application:(UIApplication *)application  openURL:(NSURL *)url 
										  sourceApplication:(NSString *)sourceApplication 
										         annotation:(id)annotation
{%endcodeblock%}   
The trick to passing in parameters from one app to another is via the URL.   
For example, assume we are using the following custom `URL scheme `and want to pass in a value for a ‘**token**’ and a flag indicating registration state, we could create URL as follows:
{%codeblock lang:objc%}
NSString *customURL = @"iOSDevTips://?token=123abct&registered=1";
{%endcodeblock%}  
As in web development, the string **`?token=123abct&registered=1`** is known as the `query` string.

Inside the app delegate of the app being called (the app with the custom URL), the code to retrieve the parameters would be as follows:
{%codeblock lang:objc%}
	- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
	        sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
	{
	  NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
	  NSLog(@"URL scheme:%@", [url scheme]);
	  NSLog(@"URL query: %@", [url query]);
	 
	  return YES;
	}
{%endcodeblock%}  
The output from the app with the custom URL (using my Bundle ID), when called from another app, is as follows:
{%codeblock lang:objc%}
Calling Application Bundle ID: com.3Sixty.CallCustomURL
URL scheme:iOSDevTips
URL query: token=123abct&registered=1
{%endcodeblock%}  
Take note of the ‘**Calling Application Bundle ID**’ as you could use this to ensure that only an application that you define can interact directly with your app.

Let’s change up the delegate method to verify the calling application Bundle ID is known:
{%codeblock lang:objc%}
	- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
	        sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
	{
	  // Check the calling application Bundle ID
	  if ([sourceApplication isEqualToString:@"com.3Sixty.CallCustomURL"])
	  {
	    NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
	    NSLog(@"URL scheme:%@", [url scheme]);
	    NSLog(@"URL query: %@", [url query]);
	 
	    return YES;
	  }
	  else
	    return NO;
	}
{%endcodeblock%}
It’s important to note that you cannot prevent another application from calling your app via custom **`URL scheme`**, however you can skip any further processing and `return NO` as shown above. With that said, if you desire to keep other apps from calling your app, create a unique (non-obvious) `URL scheme`. Although this will guarantee you app won’t be called, it will make it more unlikely.

Custom URL Scheme Example Projects

I realize it can be a little tricky to follow all the steps above. I’ve included two (very basic) iOS apps, one that has the custom URL scheme defined and one that calls the app, passing in a short parameter list (query string). These are good starting points to experiment with custom URL’s.

[Download Xcode project for app with Custom URL scheme](http://iosdevelopertips.com/downloads/#customURLScheme)  
[Download Xcode project for app to call custom URL scheme](http://iosdevelopertips.com/downloads/#customURLScheme)