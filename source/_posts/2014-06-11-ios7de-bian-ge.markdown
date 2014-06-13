---
layout: post
title: "IOS7的变革"
date: 2014-06-11 10:17:19 +0800
comments: true
tags: IOS7
keywords: 新特性, IOS7,优化,废弃,优点
categories: IOS7
---

##性能提高以及被遗弃的功能  

	

###1. `-[NSArray firstObject]`的实现

`-[NSArray firstObject]`可能是Objective-C中被调用做多的API。 在iOS4.0中`firstObject`已经被使用，但是那时仅仅是一个私有方法。在iOS7以前，常用方法：

	NSArray *arr = @[]; 
	id item = [arr firstObject]; 
	// 前你需要做以下工作 
	id item = [arr count] > 0 ? arr[0] : nil;
因为上面的方式很常用，一般创建一个类别实现该方法`firstObject`增加到NSArray中。
  
这个方法的问题:`方法名`必须是唯一的，否则,这个方法所引发的问题无法预估。所以在`NSArray`中最好不要重载`firstObject`方法，是有风险的。

###2.UIButtonTypeRoundRect被UIButtonTypeSystem取代
![alt text](http://cdn1.raywenderlich.com/wp-content/uploads/2010/05/Rate.jpg "UIButtonTypeRoundRect被UIButtonTypeSystem取代")

###3.新增截屏通知:`UIApplicationUserDidTakeScreenshotNotification`
  Prior to iOS 7, apps like Snapshot or Facebook Poke [used some pretty creative methods to detect](http://dlj.bz/XflV) when the user presses the Home and Lock buttons to take a screenshot.   
  However, iOS 7 provides a brand-new notification for this event:
  **`UIApplicationUserDidTakeScreenshotNotification`**.  
	
注册通知:  

	[[NSNotificationCenter defaultCenter]  addObserver:self 
											  selector:@selector(mymethod:)   
												  name:UIApplicationUserDidTakeScreenshotNotification object:nil]; 
接到通知后，便可以调用自己的方法：如`mymethod:`

	Note:  
		1.This notification is posted after the screenshot is taken.
		2.This notification does not contain a userInfo dictionary.
Currently there is no way to be notified before a screenshot is taken, which could be useful for hiding an embarrassing photo.  
 Hopefully Apple adds an `UIApplicationUserWillTakeScreenshotNotification` in iOS 8! :]

<!-- more-->
###4.新增手势: UIScreenEdgePanGestureRecognizer
`UIScreenEdgePanGestureRecognizer` inherits from `UIPanGestureRecognizer` and lets you **detect gestures starting near the edge of the screen**.
Using this new gesture recognizer is quite simple, as shown below:

	UIScreenEdgePanGestureRecognizer *recognizer = [[UIScreenEdgePanGestureRecognizer alloc] 
														initWithTarget:self action:@selector(handleScreenEdgeRecognizer:)];
	// accept gestures that start from the left; we're probably building another hamburger menu!
	recognizer.edges = UIRectEdgeLeft; 
	[self.view addGestureRecognizer:recognizer];
###5. New return type – `instancetype`
  苹果改变了大部分 initializer和简易构造函数（convenience constructors），`instancetype`可以代替`id`作返回类型。
     
	   instancetype 作用：
	   		1.作为从Objective-C方法的返回类型。
	   		2.在编译时，该方法的返回类型将是该方法所属的类的实例，编译器就会对返回的实例做一些检查，有bug及时发现及时解决。这一点优于id类型。
	   		3.在调用子类方法时，就可以省去对返回值的强制类型转换。
  举例:  
             
    1.NSDictionary *d = [NSArray arrayWithObjects:@(1),@(2), nil];
	NSLog(@"%i", d.count);
	  
这段代码显然有错误，但在Xcode4.6上是可以编译通过的。是由于Objective-C是动态性语言。

	+ (id)arrayWithObjects:(id)firstObj, ...;
并且，arrayWithObjects:返回`id`类型：是运行时的动态类型，编译器无法知道它的真实类型，即使调用一个id类型没有的方法，也不会产生编译警告。

那么，为什么`arrayWithObjects:`方法的返回类型还是`id`类型？来看看`NSArray`子类：
		
	@interface MyArray : NSArray
	@end
	
Now consider the use of your new subclass in the code below:
	
	MyArray *array = [MyArray arrayWithObjects:@(1), @(2), nil];
如果方法`arrayWithObjects:`返回值的类型是`NSArray *`，那么子类`MyArray`就需要被强制转换为所需的类`NSArray`。这是正是`instancetype`返回类型的用武之地。
在iPhone 7.0 SDK的NSArray中的头文件，已更新为：

	+ (instancetype)arrayWithObjects:(id)firstObj, ...;
唯一的区别是返回类`instancetype`取代`id`。这种新的返回类型会告知编译器，返回值是该方法所属的类的实例对象。  
也就是说:当`NSArray`调用`arrayWithObjects:`时，返回类型推断为NSArray\*;
当`MyArray`调用`arrayWithObjects:`时，返回类型推断为MyArray\*。  

`instancetype`解决`id`类型的问题，同时也继承`id`类型功能。如果编译在Xcode 5的原代码，你会看到下面的警告：
	
	warning: incompatible pointer types initializing 'NSDictionary *' with an expression of type 'NSArray *' [-Wincompatible-pointer-types]
    NSDictionary *d = [NSArray arrayWithObjects:@(1), @(2), nil];
                ^    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 	
  w00t — now that’s helpful! You now have the opportunity to fix the problem before it turns into a crash later down the line.  

  Initializers are also candidates for using this new return type. The compiler has warned you for some time now if you set the return type of an initializer to that of an incompatible type. But presumably it’s just implicitly converting the id return type to instancetype under the hood. You should still use instancetype for initializers though, because it’s better to be explicit for habit’s sake.  

  Strive to use instancetype as much as possible going forward; it’s become a standard for Apple — and you never know when it will save you some painful debugging time later on.

###2. `UIPasteboard`由共享变为沙盒化了
  
3. `MAC地址`:统一化，不能再用来识别设备
  
###4. app启动麦克风，需争征得用户同意  
  
  以前如果app需要使用用户的位置，通讯录，日历，提醒以及照片，接受推送消息，使用用户的社交网络的时候需要征得用户的同意。
  现在在iOS7当中，使用麦克风也需要取得用户同意了。如果用户不允许app使用麦克风的话，那么需要使用麦克风的app就不能接收不到任何声音。
  以下的代码是用来查询用户是否允许app使用麦克风：  
			
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
如果没有经过用户同意，就调用麦克风，iOS系统自动弹出以下警示栏：
![image](/images/microphone.jpg)

###Tint images with `UIImage.renderingMode`
Tinting is a big part of the new look and feel of iOS 7, and you have control whether your image is tinted or not when rendered.   
UIImage now has a read-only property named `renderingMode` as well as a new method `imageWithRenderingMode:` which uses the new enum `UIImageRenderingMode` containing the following possible values:
	
	// Use the default rendering mode for the context where the image is used
		UIImageRenderingModeAutomatic      
	// Always draw the original image, without treating it as a template
		UIImageRenderingModeAlwaysOriginal 
	// Always draw the image as a template image, ignoring its color information
		UIImageRenderingModeAlwaysTemplate 
The default value of renderingMode is UIImageRenderingModeAutomatic.  
Whether the image will be tinted or not depends on where it’s being displayed as shown by the examples below:	  
![image](/images/uiimagerenderingmode.png)  
The code below shows how easy it is to create an image with a given rendering mode:
												
	UIImage *img = [UIImage imageNamed:@"myimage"]; 
	img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]; 

###Usage of tintColor vs barTintColor
In iOS 7 you can tint your entire app with a given color or even implement color themes to help your app stand out from the rest.Setting the tint color of your app is as easy as using the new property `tintColor` of `UIView`.  
Does that property sound familiar? it should — some classes such as `UINavigationBar`, `UISearchBar`, `UITabBar` and `UIToolbar` already had a property with this name. They now have a new property: `barTintColor`.  
In order to avoid getting tripped up by the new property, you should perform the following check if your app needs to support iOS 6 or earlier:

	UINavigationBar *bar = self.navigationController.navigationBar;
	UIColor *color = [UIColor greenColor];
	
	if ([bar respondsToSelector:@selector(setBarTintColor:)]) { 
			// iOS 7+
			    bar.barTintColor = color;
	} else { 
			// iOS 6 or earlier
			    bar.tintColor = color;
	}

###Check which wireless routes are available
The ability to customize a video player (and friends) has evolved throughout the past few iOS versions. As an example, prior to iOS 6 you couldn’t change the AirPlay icon on a `MPVolumeView`.  
In iOS 7, you’re finally able to know if a remote device is available via AirPlay, Bluetooth, or some other wireless mechanism. This allows your app to behave appropriately, such as hiding an AirPlay icon when that service isn’t available on other devices.  
The following two new properties and notifications have been added to MPVolumeView:


	 // is there a route that the device can connect to?
		@property (nonatomic, readonly) BOOL wirelessRoutesAvailable;
			
	 // is the device currently connected?
		@property (nonatomic, readonly) BOOL wirelessRouteActive;   	
		
	NSString *const MPVolumeViewWirelessRoutesAvailableDidChangeNotification;
	NSString *const MPVolumeViewWirelessRouteActiveDidChangeNotification;






































