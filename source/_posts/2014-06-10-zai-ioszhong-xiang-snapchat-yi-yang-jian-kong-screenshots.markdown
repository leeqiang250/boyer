---
layout: post
title: "在IOS中像SnapChat一样监控screenshots"
date: 2014-06-10 18:45:37 +0800
comments: true
publiced: true
tags: [screenshot,SnapChat,截屏]
keywords:  screenshot,SnapChat
categories: screenshot
---
A [number](http://stackoverflow.com/questions/2121970/notification-of-or-detecting-screenshot-being-taken/2122117) of [Stack](http://stackoverflow.com/questions/13484516/ios-detection-of-screenshot)  [Overflow](http://stackoverflow.com/questions/10122212/iphone-screenshot)questions were having issues with this, so I figured I’d explain. From reverse engineering, this is the exact method used by SnapChat, but it’s also pretty much what I’d have done myself.
<!-- more-->
The process is pretty simple, and relies on a quirk of iOS: taking a screenshot cancels all touches on the screen. Because of that, anything that you want to protect will require you to have the user to touch the screen to see. If that works for your purposes, the general solution is to simply intercept the touch cancellation, and quickly remove any sensitive information from the screen. If you’re also implementing a screenshot counter, as with SnapChat, you will also need to take into account the other cases when a touch might be cancelled: from a system gesture (Notification Center or the iPad’s multitasking gestures), or by activating other pieces of system UI (the power down menu, or the multitasking switcher).

On a technical level, the two basic pieces are UILongPressGestureRecognizer (or -touchesCancelled:withEvent:, if you want) and UIApplicationDelegate. In your long press handler, you should hide your sensitive information when the gesture recognizer’s state is UIGestureRecognizerStateCancelled, and if you want to track the number of screenshots, increment a counter. Then, in the UIApplicationDelegate, decrement that counter when you receive the -applicationWillEnterBackground: or -applicationDidResignActive: notification to account for the other possibilities for a cancelled touch. You might also need to handle other situations where a touch could be cancelled, if other parts of your app might cause that to happen.