---
layout: post
title: "IOS7新宠Text Kit"
date: 2014-06-16 22:24:48 +0800
comments: true
publiced: false
categories: 
---

##Text Kit 
**`Text Kit`**：基于`Core Text`构建的快速、先进的文本排版和渲染引擎，并且与UIKit框架很好的集合，它让程序能够通过**NSTextStorage**对象存储文本排版和显示文本等主要信息，并支持排版所需要的所有特性，包括字距调整、连写、换行和对齐等。  
>更直观的理解，**UITextView**，**UITextField**、**UILabel**等UIKit控件都已经基于**Text Kit**重新构建，是为UIKit框架提供高质量排版服务而扩展的一些类和协议，例如：NSTextStorage对象，它本身是**NSMutableAttributedString**的子类，支持分批编辑，这就意味着在改变一个范围内的字符样式时，不用整体替换文本内容，就能完成排版效果。其中支持分页文本、文本包装、富文本编辑、交互式文本着色、文本折叠和自定义截取等特性。  

IOS6之前，想实现一些丰富的文本排版，例如在textView中显示不同样式的文本，或者图片和文字混排等，就需要借助于UIWebView或者深入研究一下`Core Text`。后来iOS6，增加一个很棒的属性:`NSAttributedString`，主要用于支持UILabel、UITextField、UITextView等UIKit控件自主排版的功能。很显然，IOS7并没有满足于这一改进，同时推出一款功能更为齐全，易用的`Text Kit`新宠。  
在iOS 6中, 用于文本的UIKit控件是基于WebKit和Core Graphics的字符串绘制方法来实现的。如下面层级体系图所示：  
![image](/images/TextRenderingArchitecture-iOS6.png)  
iOS 7的整体构架要更清晰，所有基于文本的UIKit控件（除了UIWebView）现在都可以使用Text Kit，如下图所示：  
![image](/images/TextRenderingArchitecture-IOS7.png)  
更为直观的理解如图：  
![image](/images/TextKit.png)