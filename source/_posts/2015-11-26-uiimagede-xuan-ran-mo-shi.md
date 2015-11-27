---
layout: post
title: "UIImage的渲染模式"
date: 2015-11-26 16:15:11 +0800
comments: true
categories: 
---

设置UIImage的渲染模式：UIImage.renderingMode

```objc
UIImageRenderingModeAutomatic // 根据图片的使用环境和所处的绘图上下文自动调整渲染模式。
UIImageRenderingModeAlwaysOriginal // 始终绘制图片原始状态，不使用Tint Color。
UIImageRenderingModeAlwaysTemplate // 始终根据Tint Color绘制图片，忽略图片的颜色信息。

UIImage *img = [UIImage imageNamed:@"myimage"];
img = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//实际效果，效果依旧显示为baritem的Tint Color
UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:setImage
                                                   style:UIBarButtonItemStylePlain
                                                  target:self
                                                  action:@selector(setAction:)];
```
