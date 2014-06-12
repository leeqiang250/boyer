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
4. app启动麦克风，需争征得用户同意










































