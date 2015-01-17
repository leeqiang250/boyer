---
layout: post
title: "IOS7的变革"
date: 2014-06-11 10:17:19 +0800
comments: true
tags: [IOS7,变革,huos]
keywords: 新特性, IOS7,优化,废弃,优点
categories: IOS7
---

##性能提高以及被遗弃的功能  

	
###1.新增截屏通知:`UIApplicationUserDidTakeScreenshotNotification`

在IOS 7之前，开发者使用了一种**[很赞的方法](http://dlj.bz/XflV)**，来**拦截**截屏事件的.  
比如，Snapchat的实现原理: 用户通过**Snapchat**发送的照片将会在数秒内自动被删除，而且在浏览照片时，必须将手指按在屏幕上，否则会立即关闭。然而，在 iOS 6 中，<font color=red>**截屏将打断触控操作**</font>，开发者就利用这个功能点，在恰当时机捕捉到了截屏事件。  

在iOS 7中，专门为<font color=red>**截屏完成后**</font>提供了一个通知:
  `UIApplicationUserDidTakeScreenshotNotification`.同时，也规避了IOS 6中<font color=red>**截屏将打断触控操作**</font>的关键功能点。以至于在截屏之前，无法拦截用户的截屏操作。  
注册<font color=red>**截屏完成后**</font>通知:  
``` objc 注册监听事件，接收截屏完成后的通知
	[[NSNotificationCenter defaultCenter]  addObserver:self 
											  selector:@selector(mymethod:)
											  	    name:UIApplicationUserDidTakeScreenshotNotification 
											    object:nil]; 
```
Note:  
	1.This notification is posted after the screenshot is taken.
	2.This notification does not contain a userInfo dictionary.
###2.新增手势: UIScreenEdgePanGestureRecognizer
`UIScreenEdgePanGestureRecognizer` inherits from `UIPanGestureRecognizer` and lets you **detect gestures starting near the edge of the screen**.
Using this new gesture recognizer is quite simple, as shown below:
``` objc 
	UIScreenEdgePanGestureRecognizer *recognizer = [[UIScreenEdgePanGestureRecognizer alloc] 
														initWithTarget:self 
															action:@selector(handleScreenEdgeRecognizer:)];
	// accept gestures that start from the left; we're probably building another hamburger menu!
	recognizer.edges = UIRectEdgeLeft; 
	[self.view addGestureRecognizer:recognizer];
```

<!-- more-->
###3. 新增返回类型 – `instancetype`
  苹果改变了大部分 initializer和简易构造函数（convenience constructors），`instancetype`可以代替`id`作返回类型。
     
	   instancetype 作用：
	   		1.作为从Objective-C方法的返回类型。
	   		2.在编译时，该方法的返回类型将是该方法所属的类的实例，编译器就会对返回的实例做一些检查，有bug及时发现及时解决。这一点优于id类型。
	   		3.在调用子类方法时，就可以省去对返回值的强制类型转换。
  举例:  
``` objc  
NSDictionary *d = [NSArray arrayWithObjects:@(1),@(2), nil];
NSLog(@"%i", d.count);
```  
这段代码显然有错误，但在Xcode4.6上是可以编译通过的。是由于Objective-C是动态性语言。
``` objc
+ (id)arrayWithObjects:(id)firstObj, ...;
```
并且，arrayWithObjects:返回`id`类型：是运行时的动态类型，编译器无法知道它的真实类型，即使调用一个id类型没有的方法，也不会产生编译警告。

那么，为什么`arrayWithObjects:`方法的返回类型还是`id`类型？来看看`NSArray`子类：
``` objc
	@interface MyArray : NSArray
	@end
```
Now consider the use of your new subclass in the code below:  
``` objc
	MyArray *array = [MyArray arrayWithObjects:@(1), @(2), nil];
```  
如果方法`arrayWithObjects:`返回值的类型是`NSArray *`，那么子类`MyArray`就需要被强制转换为所需的类`NSArray`。这是正是`instancetype`返回类型的用武之地。
在iPhone 7.0 SDK的NSArray中的头文件，已更新为：
``` objc
	+ (instancetype)arrayWithObjects:(id)firstObj, ...;
```
唯一的区别是返回类`instancetype`取代`id`。这种新的返回类型会告知编译器，返回值是该方法所属的类的实例对象。  
也就是说:当`NSArray`调用`arrayWithObjects:`时，返回类型推断为NSArray\*;
当`MyArray`调用`arrayWithObjects:`时，返回类型推断为MyArray\*。  

`instancetype`解决`id`类型的问题，同时也继承`id`类型功能。如果编译在Xcode 5的原代码，你会看到下面的警告：  
``` objc
	warning: incompatible pointer types initializing 'NSDictionary *' with an expression of type 'NSArray *' [-Wincompatible-pointer-types]
    NSDictionary *d = [NSArray arrayWithObjects:@(1), @(2), nil];
                ^    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
```  
  w00t — now that’s helpful! You now have the opportunity to fix the problem before it turns into a crash later down the line.  

  Initializers are also candidates for using this new return type. The compiler has warned you for some time now if you set the return type of an initializer to that of an incompatible type. But presumably it’s just implicitly converting the id return type to instancetype under the hood. You should still use instancetype for initializers though, because it’s better to be explicit for habit’s sake.  

  Strive to use instancetype as much as possible going forward; it’s become a standard for Apple — and you never know when it will save you some painful debugging time later on.
  
###4.UIScrollView新增属性：`UIScrollViewKeyboardDismissMode`
像Messages app一样在滚动的时候，将键盘隐藏，是一种非常好的体验。  
在以前，将这项功能整合到app很难，现在仅仅只需要在Storyboard中简单的改变一个属性值，或者增加一行代码即可。

这个属性使用了新的`UIScrollViewKeyboardDismissMode` enum枚举类型。这个enum枚举类型可能的值如下：  
``` objc  UIScrollViewKeyboardDismissMode枚举值
	// the keyboard is not dismissed automatically when scrolling
		UIScrollViewKeyboardDismissModeNone   
    // dismisses the keyboard when a drag begins 
		UIScrollViewKeyboardDismissModeOnDrag  
    // the keyboard follows the dragging touch off screen, and may be pulled upward again to cancel the dismiss 
		UIScrollViewKeyboardDismissModeInteractive  
```  
在storyboard中设置该属性值:  
![UIScrollViewKeyboardDismissMode](/images/UIScrollViewKeyboardDismissMode.png)  
###5.UIKit使用[NSAttributedString]((http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSAttributedString_Class/)显示HTML，[TextKit](http://)
在app中使用Webviews有时会让人非常沮丧，即使只是显示少量的HTML内容 ,Webviews也会消耗大量的内存。
现在提供了一种全新的简单易用的方式来展示HTML内容，适用于任意的`UIKit`控件，如`UILabel`或`UITextField`等。   
1.用少量HTML片段，初始化`NSAttributedString`对象:

{% codeblock lang:objc Time to be Awesome - awesome.rb %}
	NSString *html = @"<bold>Wow!</bold> Now <em>iOS</em> can create <h3>NSAttributedString</h3> from HTMLs!";
NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
{% endcodeblock %}
	
``` objc 用少量HTML片段，初始化`NSAttributedString`对象 http://developer.apple.com/documentation/Cocoa/Reference/Foundation/Classes/NSAttributedString_Class/
NSString *html = @"<bold>Wow!</bold> Now <em>iOS</em> can create <h3>NSAttributedString</h3> from HTMLs!";
NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
NSData *htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
NSAttributedString *attrString = [[NSAttributedString alloc] initWithData:htmlData
												                      options:options 
									                       documentAttributes:nil 
									   			                        error:nil];
```								   	
NSDocumentTypeDocumentAttribute包括:
<!--https://gist.githubusercontent.com/huos3203/ecba275d5e4404678354/raw/1636f62209b056b4acbe07021f596e1ffd5ef301/%E8%A7%A3%E6%9E%90NSAttributedString%E5%AF%B9%E8%B1%A1%EF%BC%8C%E8%8E%B7%E5%8F%96%E6%88%90HTML%E7%89%87%E6%AE%B5
-->
	NSPlainTextDocumentType		//Plain text document.
    NSRTFTextDocumentType		//Rich text format document.
    NSRTFDTextDocumentType		//Rich text format with attachments document.

2.相反，也可以将`NSAttributedString`对象，解析成HTML片段：

{% gist ecba275d5e4404678354 %E8%A7%A3%E6%9E%90NSAttributedString%E5%AF%B9%E8%B1%A1%EF%BC%8C%E8%8E%B7%E5%8F%96%E6%88%90HTML%E7%89%87%E6%AE%B5.m %}	

###6.NSLinkAttributeName让标签（UILabel,UITextView）支持超链接
 
首先，创建一个`NSAttributedString`对象,然后，调用`addAttribute:value:range:`方法，添加 `NSLinkAttributeName`属性并赋值，如下：  
``` objc UITextView支持超链接
	NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"This is an example by @marcelofabri_"]; 
	[attributedString addAttribute:NSLinkAttributeName 
                         value:@"username://marcelofabri_" 
                         range:[[attributedString string] rangeOfString:@"@marcelofabri_"]]; 
	NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor greenColor], 
                                 NSUnderlineColorAttributeName: [UIColor lightGrayColor], 
                                 NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};  
	// assume that textView is a UITextView previously created (either by code or Interface Builder) 
	textView.linkTextAttributes = linkAttributes; // customizes the appearance of links 
	textView.attributedText = attributedString; 
	textView.delegate = self; 
```
当然，也可以使用`UITextViewDelegate`新增的协议方法<font color=red>**shouldInteractWithURL**</font>，来自定义点击事件：  
``` objc 协议方法shouldInteractWithURL
	- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL 
											               inRange:(NSRange)characterRange { 
				    if ([[URL scheme] isEqualToString:@"username"]) { 
				        NSString *username = [URL host];  
				        // do something with this username 
				        // ... 
				        return NO; 
				    } 
				    return YES; // let the system open this URL 
	} 
```
###4.Tint images with `UIImage.renderingMode`
Tinting is a big part of the new look and feel of iOS 7, and you have control whether your image is tinted or not when rendered.   
UIImage now has a read-only property named `renderingMode` as well as a new method `imageWithRenderingMode:` which uses the new enum `UIImageRenderingMode` containing the following possible values:
```
	// Use the default rendering mode for the context where the image is used
		UIImageRenderingModeAutomatic  
	// Always draw the original image, without treating it as a template
		UIImageRenderingModeAlwaysOriginal  
	// Always draw the image as a template image, ignoring its color information
		UIImageRenderingModeAlwaysTemplate 
```
The code below shows how easy it is to create an image with a given rendering mode:
``` objc 
	UIImage *img = [UIImage imageNamed:@"myimage"]; 
	img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]; 
```
The default value of renderingMode is UIImageRenderingModeAutomatic.  
Whether the image will be tinted or not depends on where it’s being displayed as shown by the examples below:	  
![image](/images/uiimagerenderingmode.png)


###5.Usage of tintColor vs barTintColor
In iOS 7 you can tint your entire app with a given color or even implement color themes to help your app stand out from the rest.Setting the tint color of your app is as easy as using the new property `tintColor` of `UIView`.  
Does that property sound familiar? it should — some classes such as `UINavigationBar`, `UISearchBar`, `UITabBar` and `UIToolbar` already had a property with this name. They now have a new property: `barTintColor`.  
In order to avoid getting tripped up by the new property, you should perform the following check if your app needs to support iOS 6 or earlier:

``` objc bar通过判断是否包含setBarTintColor:确定系统版本
UINavigationBar *bar = self.navigationController.navigationBar;
UIColor *color = [UIColor greenColor];

if ([bar respondsToSelector:@selector(setBarTintColor:)]) { 
		// iOS 7+
		    bar.barTintColor = color;
} else { 
		// iOS 6 or earlier
		    bar.tintColor = color;
}
```	  

###6.Check which wireless routes are available
The ability to customize a video player (and friends) has evolved throughout the past few iOS versions. As an example, prior to iOS 6 you couldn’t change the AirPlay icon on a `MPVolumeView`.  
In iOS 7, you’re finally able to know if a remote device is available via AirPlay, Bluetooth, or some other wireless mechanism. This allows your app to behave appropriately, such as hiding an AirPlay icon when that service isn’t available on other devices.  
The following two new properties and notifications have been added to MPVolumeView:  

``` objc  
// is there a route that the device can connect to?
	@property (nonatomic, readonly) BOOL wirelessRoutesAvailable;
	
// is the device currently connected?
	@property (nonatomic, readonly) BOOL wirelessRouteActive;   
  NSString *const MPVolumeViewWirelessRoutesAvailableDidChangeNotification;
	NSString *const MPVolumeViewWirelessRouteActiveDidChangeNotification;
```


###7. `-[NSArray firstObject]`的实现

`-[NSArray firstObject]`可能是Objective-C中被调用做多的API。 在iOS4.0中`firstObject`已经被使用，但是那时仅仅是一个私有方法。在iOS7以前，常用方法：
``` objc
	NSArray *arr = @[]; 
	id item = [arr firstObject]; 
	// 前你需要做以下工作 
	id item = [arr count] > 0 ? arr[0] : nil;
```
因为上面的方式很常用，一般创建一个类别实现该方法`firstObject`增加到NSArray中。
  
这个方法的问题:`方法名`必须是唯一的，否则,这个方法所引发的问题无法预估。所以在`NSArray`中最好不要重载`firstObject`方法，是有风险的。

###8.UIButtonTypeRoundRect被UIButtonTypeSystem取代
![alt text](http://cdn1.raywenderlich.com/wp-content/uploads/2010/05/Rate.jpg "UIButtonTypeRoundRect被UIButtonTypeSystem取代")

####9. `UIPasteboard`由共享变为沙盒化了
UIPasteboard过去是用来做app之间的数据分享的。开发者一般使用它来存储标识符，比如:OpenUDID。   
但在在iOS7中，使用 `+[UIPasteboard pasteboardWithName:create:]`和 `+[UIPasteboard pasteboardWithUniqueName]`创建剪贴板，而且只对相同的app group可见，这样再和其他的相关app分享以前的OpenUDID等标识符时，就会出现问题。
####10. `MAC地址`:被统一化
在IOS7之前，生成iOS设备唯一标示符的方法是使用iOS设备的Media Access Control（MAC）地址。 一个MAC地址是一个唯一的号码，它是物理网络层级方面分配给网络适配器的。
然而，苹果并不希望有人通过MAC地址来分辨用户，在iOS7以上，查询MAC地址，它现在只会返回02:00:00:00:00:00。  
目前，苹果推荐开发者使用以下两种方式，来获取作为框架和应用的唯一标示符：
``` objc
	NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString]; 
	NSString *identifierForAdvertising = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
``` 
`identifierForVendor`：由同一个公司发行的的app在相同的设备上运行的时候都会有这个相同的标识符。然而，如果用户删除了这个供应商的app然后再重新安装的话，这个标识符就会不一致。
`advertisingIdentifier`：返回给在这个设备上所有软件供应商公用的唯一值，所以只能在广告的时候使用。这个值会因为很多情况而有所变化，比如说用户初始化设备的时候便会改变。
  
####11. app启动麦克风，需争征得用户同意  
  
  以前如果app需要使用用户的位置，通讯录，日历，提醒以及照片，接受推送消息，使用用户的社交网络的时候需要征得用户的同意。
  现在在iOS7当中，使用麦克风也需要取得用户同意了。如果用户不允许app使用麦克风的话，那么需要使用麦克风的app就不能接收不到任何声音。
  以下的代码是用来查询用户是否允许app使用麦克风：  
```	objc		
	//第一次调用这个方法的时候，系统会提示用户让他同意你的app获取麦克风的数据 
	// 其他时候调用方法的时候，则不会提醒用户 
	// 而会传递之前的值来要求用户同意 
	[[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) { 
										    if (granted) { 
												        // 用户同意获取数据 
												    } else { 
												        // 可以显示一个提示框告诉用户这个app没有得到允许？ 
												    } 
										    }
    ];
```
如果没有经过用户同意，就调用麦克风，iOS系统自动弹出以下警示栏：
![image](/images/microphone.jpg)







































