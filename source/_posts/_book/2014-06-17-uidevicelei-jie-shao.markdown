---
layout: post
title: "UIDevice类介绍"
date: 2014-06-17 15:12:53 +0800
comments: true
tags: [UIDevice,电量,方向,近距离感应]
publiced: false
categories: IOS基础
---
###UIDevice.h

``` objc 设备的基本属性
+ (UIDevice *)currentDevice; 		  // 获取当前设备

NSString    *name;               	  // e.g. "My iPhone"  
NSString    *model;              	  // e.g. @"iPhone", @"iPod touch"  
NSString    *localizedModel;     	  // localized version of model  
NSString    *systemName;     		  // e.g. @"iOS"  
NSString    *systemVersion;   	  // e.g. @"4.0"  
UIDeviceOrientation orientation;    //除非正在生成设备方向的通知，否则返回UIDeviceOrientationUnknown  
NSUUID *identifierForVendor         //可用于唯一标识该设备，同一供应商不同应用具有相同的UUID
```
```objc 方向属性值
    UIDeviceOrientationUnknown,
    UIDeviceOrientationPortrait,                    // 竖向，头向上
    UIDeviceOrientationPortraitUpsideDown,  		// 竖向，头向下
    UIDeviceOrientationLandscapeLeft,         		// 横向，头向左
    UIDeviceOrientationLandscapeRight,       		// 横向，头向右
    UIDeviceOrientationFaceUp,                  	// 平放，屏幕朝下
    UIDeviceOrientationFaceDown                	 // 平放，屏幕朝下
```
//使用内置的宏定义的函数，根据**orientation**判断设备方向,返回值类型**BOOL**.  
{%codeblock lang:java 纵向宏定义,返回YES:纵向%}
#define UIDeviceOrientationIsPortrait(orientation)  ((orientation) == UIDeviceOrientationPortrait || (orientation) == UIDeviceOrientationPortraitUpsideDown)
{%endcodeblock %}
{%codeblock lang:java 横向宏定义,返回YES:横向%}
#define UIDeviceOrientationIsLandscape(orientation) ((orientation) == UIDeviceOrientationLandscapeLeft || (orientation) == UIDeviceOrientationLandscapeRight)
{%endcodeblock%}
<!--more-->
  
####横竖屏相关参数,方法与通知

* 检测当前设备是否生成设备转向通知
{%codeblock lang:objc%}
BOOL generatesDeviceOrientationNotifications
{%endcodeblock%}
* 设备方向开始改变时，触发该方法，可以重写实现一些操作。
{%codeblock lang:objc%}
- (void)beginGeneratingDeviceOrientationNotifications;
{%endcodeblock%}
* 设备结束方向改变时，触发的事件，可以重写该实现一些操作。
{%codeblock lang:objc%}
- (void)endGeneratingDeviceOrientationNotifications;
{%endcodeblock%}
* 通知
{%codeblock lang:objc 屏幕方向变化通知%}
UIKIT_EXTERN NSString *const UIDeviceOrientationDidChangeNotification;
{%endcodeblock%}
####手机电池相关属性与通知
* 电池属性
{%codeblock lang:objc 电池属性%}
BOOL batteryMonitoringEnabled		      // 是否启动电池监控，默认为NO 
UIDeviceBatteryState batteryState 		//电池状态
float batteryLevel   					 //电量百分比， 0 .. 1.0,监控禁用时为-1
{%endcodeblock%}
{%codeblock lang:objc 电池状态UIDeviceBatteryState属性值%}
    UIDeviceBatteryStateUnknown,		 //禁用电池监控
    UIDeviceBatteryStateUnplugged,      // 未充电
    UIDeviceBatteryStateCharging,       // 正在充电
    UIDeviceBatteryStateFull,           // 满电
{%endcodeblock%}
* 电池通知
{%codeblock lang:objc 电池状态变化通知%}
UIKIT_EXTERN NSString *const UIDeviceBatteryStateDidChangeNotification   NS_AVAILABLE_IOS(3_0);
{%endcodeblock%}
{%codeblock lang:objc 电池电量变化通知%}
UIKIT_EXTERN NSString *const UIDeviceBatteryLevelDidChangeNotification   NS_AVAILABLE_IOS(3_0);
{%endcodeblock%}

####设备的其他属性及方法
{%codeblock lang:objc %}
BOOL proximityMonitoringEnabled // 是否启动接近监控（例如接电话时脸靠近屏幕），默认为NO

BOOL proximityState // 如果设备不具备接近感应器，则总是返回NO

BOOL multitaskingSupported // 是否支持多任务

UIUserInterfaceIdiom userInterfaceIdiom // 当前用户界面模式

- (void)playInputClick   // 播放一个输入的声音
{%endcodeblock%}

//用户界面类型
{%codeblock lang:objc iOS3.2以上有效%}
#if __IPHONE_3_2 <= __IPHONE_OS_VERSION_MAX_ALLOWED
    UIUserInterfaceIdiomPhone,           // iPhone 和 iPod touch 风格
    UIUserInterfaceIdiomPad,              // iPad 风格
#endif
{%endcodeblock%}
{%codeblock lang:java 获取当前用户界面模式的宏定义%}
#define UI_USER_INTERFACE_IDIOM() ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] ? [[UIDevice currentDevice] userInterfaceIdiom] : UIUserInterfaceIdiomPhone)
{%endcodeblock%}

####一些协议的定义
{%codeblock lang:objc%}
@protocol UIInputViewAudioFeedback
@optional
// 实现该方法，返回YES则自定义的视图能够播放输入的声音
@property (nonatomic, readonly) BOOL enableInputClicksWhenVisible; 
@end
{%endcodeblock%}

####其他通知
{%codeblock lang:objc 接近状态变化通知%}
UIKIT_EXTERN NSString *const UIDeviceProximityStateDidChangeNotification NS_AVAILABLE_IOS(3_0);
{%endcodeblock%}