---
layout: post
title: "IOS7截屏问题"
date: 2014-06-10 18:29:31 +0800
comments: true
publiced: true
tags: [screenshot,SnapChat,截屏]
keywords:  screenshot,SnapChat
categories: screenshot
---
###iOS 7截图最新变化: 不再影响用户其他操作

   在 iOS 7 中，截图动作已经发生了变化，就如苹果在版本说明中描述的那样：用户截图时，有效点击不会再失效了。这个微小的变化对于多款依赖截屏来提醒用户一些不必要动作的应用来说，具有很重要的意义，比如 Snapchat 和 Facebook Poke。
<!-- More -->
　　用户在应用中打开 Snapchat 照片，查看照片时用户需要单指按在屏幕上让照片处于打开的状态。如果用户试图截图，那么照片马上就会关闭。这是 Snapchat 用来检测“非法”截图的办法。用户拍了照片发送给好友后，这些照片会根据用户所预先设定的时间按时自动销毁。如果接收方在此期间试图进行截图的话，用户也将得到通知。

   Snapchat在美国青少年群体中十分流行，因为它拥有一种独特的“阅后即焚”机制。用户通过该应用发送的照片将会在数秒内自动被删除，而且它还将采用一种特殊手段阻止照片接收者截屏，并将其截屏企图报告给发送者。在 iOS 6 中，截屏将打断触控操作，而用户观看 Snapchat 照片时，必须将手指按在屏幕上。

　　在 iOS 7 中截图的操作不会迫使 SnapChat 查看照片的窗口关闭，也就是说当用户截图时系统也不会发出提醒通知。截图不会影响用户在屏幕上的操作，照片不会关闭应用也无法识别截图的动作。如果一名 iOS 6 用户试图截图 iOS 7 用户会收到通知，而反过来的话 iOS 6 用户则不会受到通知。这对于 Snapchat 来说，绝对是个恶梦，因为该服务的风靡与阅后即焚机制关系很大。

　　虽然 iOS 7 的这个变化对于 iOS 7 Snapchat 用户来说有一定的意义，但是这也对 Snapchat 等应用提出更高的要求，他们必须研究出新的办法来检测截图操作，确保这个新特性不会对他们的应用产生影响。


　　所幸 iOS 7 beta 4 的发布可以让开发商放下心来。9to5Mac 的 Scott Buscemi 不久前宣布，新版本中新增了一个截屏侦测 API。开发者并未透露这个其具体特性，但他暗示说这个 API 对 Snapchat 来说非常至关重要.  
　　
**UIApplication.h**

	// This notification is posted after the user takes a screenshot (for example by pressing both the home and lock screen buttons)
	UIKIT_EXTERN NSString *const UIApplicationUserDidTakeScreenshotNotification NS_AVAILABLE_IOS(7_0);

　　据悉，iOS 7 beta 2 发布之后，此前一些无法实现的有趣操作也随之变得可行。由于 iOS 6 的截屏将取消触控操作，使得用户难以截取拉了半截的锁屏界面。而在 iOS 7 beta 2 中，一切变得容易起来（见下图）。  

　　![alt text](http://resource.feng.com/resource/h027/h71/img201307301647042.jpg "Snapchat福音 iOS 7 beta 4恢复截屏侦测")

