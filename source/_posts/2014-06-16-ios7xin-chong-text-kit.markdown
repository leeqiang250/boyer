---
layout: post
title: "IOS7新宠Text Kit"
date: 2014-06-16 22:24:48 +0800
comments: true
publiced: false
categories: TextKit
---

* ##Text Kit 
**`Text Kit`**：是个庞大的framework，继承了`Core Text`的全部功能，构建了快速、先进的文本排版和渲染引擎，更让开发者们高兴的是，设计者把它封装在了一个面向对象的API中。并且与UIKit框架很好的集成，它让程序能够通过**NSTextStorage**对象存储文本排版和显示文本等主要信息，并支持排版所需要的所有特性，包括字距调整、连写、换行和对齐等。  
><font size=3>更直观的理解，**UITextView**，**UITextField**、**UILabel**等UIKit控件都已经基于**Text Kit**重新构建，是为UIKit框架提供高质量排版服务而扩展的一些类和协议.  
例如：NSTextStorage对象，它本身是**NSMutableAttributedString**的子类，支持分批编辑，这就意味着在改变一个范围内的字符样式时，不用整体替换文本内容，就能完成排版效果。其中支持分页文本、文本包装、富文本编辑、交互式文本着色、文本折叠和自定义截取等特性。</font>  

IOS6之前，想实现一些丰富的文本排版，例如在textView中显示不同样式的文本，或者图片和文字混排等，就需要借助于UIWebView或者深入研究一下`Core Text`。后来iOS6，增加一个很棒的属性:`NSAttributedString`，主要用于支持UILabel、UITextField、UITextView等UIKit控件自主排版的功能。很显然，IOS7并没有满足于这一改进，同时推出一款功能更为齐全，易用的`Text Kit`新宠。  
在iOS 6中, 用于文本的UIKit控件是基于WebKit和Core Graphics的字符串绘制方法来实现的。如下面层级体系图所示：  
![image](/images/TextRenderingArchitecture-iOS6.png)  
iOS 7的整体构架要更清晰，所有基于文本的UIKit控件（除了UIWebView）现在都可以使用Text Kit，如下图所示：  
![image](/images/TextRenderingArchitecture-iOS7.png)  

<!--more-->
* ##Text Kit中4个重要的角色
![image](/images/TextKit_obj.jpg)  

* * **`Text Views`**: 用来显示文本内容的控件，主要包括`UILabel`、`UITextView`和`UITextField`。  
* * **`Text containers`**: 对应着`NSTextContainer`类。`NSTextContainer`定义了文本可以排版的区域。一般来说，都是矩形区域，当然，也可以根据需求，通过子类化`NSTextContainer`来创建别的一些形状，例如圆形、不规则的形状等。`NSTextContainer`不仅可以创建文本可以填充的区域，它还维护着一个数组——该数组定义了一个区域，排版的时候文字不会填充该区域，因此，我们可以在排版文字的时候，填充非文本元素。    
* * **`Layout manager`**: 对应着`NSLayoutManager`类。该类负责对文字进行编辑排版处理——通过将存储在`NSTextStorage`中的数据转换为可以在视图控件中显示的文本内容，并把统一的字符编码映射到对应的字形(`glyphs`)上，然后将字形排版到`NSTextContainer`定义的区域中。  
* * **`Text storage`**: 对应着`NSTextStorage`类。该类定义了`Text Kit`扩展文本处理系统中的基本存储机制。`NSTextStorage`继承自`NSmutableAttributedString`，主要用来存储文本的字符和相关属性。另外，当`NSTextStorage`中的字符或属性发生了改变，会通知`NSLayoutManager`，进而做到文本内容的显示更新。  
通常情况下，**`NSTextStorage`**、**`NSLayoutManager`**和**`NSTextContainer`**是一一对应关系:  
![image](/images/TextKit_obj1.jpg)
如果将文字显示为多列，或多页，可以按照下图关系，使用多个**`NSTextContainer`**:
![image](/images/TextKit_obj2.jpg)
如果针对不同的排版方式，可以按照下图关系，使用多个**`NSLayoutManager`**:
![image](/images/TextKit_obj3.jpg) 
通常由**`NSLayoutManager`**从**`NSTextStorage`**中读取出文本数据，然后根据一定的排版方式，将文本排版到**`NSTextContainer`**中，再由**`NSTextContainer`**结合`UITextView`将最终效果显示出来。
如下图，为了更直观理解，对`UITextView`的组成做了分解: 
![image](/images/TextKit.jpg)

* ##Text Kit示例

  1. 打开Xcode 5，新建一个Single View Application模板的程序，将工程命名为ExclusionPath。
  2. 打开Main.storyboard文件，然后再默认View Controller的View里面分别添加一个UITextView和UIImageView。并将这两个控件连接到ViewController.h中(名称分别为textView何imageView)。然后给textView设置一些字符串，imageView设置一个图片。
  3. 1. 打开ViewController.m文件，找到viewDidLoad方法，用如下代码替换该方法：
{%codeblock lang:objc%}
- (void)viewDidLoad
{
    [super viewDidLoad];

    //创建一个平移手势对象，该对象可以调用imagePanned：方法
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(imagePanned:)];
    [self.imageView addGestureRecognizer:panGes];

    self.textView.textContainer.exclusionPaths = @[[self translatedBezierPath]];
}
{%endcodeblock%}
在上面的代码中，给imageView添加了一个平移手势。另外通过调用translatedBezierPath方法，给textView的textContainer设置exclusionPaths属性值。表示需要排除的区域（也就是图片在排版中显示的位置）。  
  3. 2. **translatedBezierPath**方法实现如下：
{%codeblock lang:objc%}
- (UIBezierPath *)translatedBezierPath
{
    CGRect butterflyImageRect = [self.textView convertRect:self.imageView.frame fromView:self.view];
    UIBezierPath *newButterflyPath = [UIBezierPath bezierPathWithRect:butterflyImageRect];

    return newButterflyPath;
}
{%endcodeblock%}
在上面的代码中，利用imageView的frame属性创建了一个UIBezierPath，然后将该值返回。  
  3. 3. **imagePanned:**方法实现如下：
{%codeblock lang:objc%}
- (void)imagePanned:(id)sender
{
    if ([sender isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *localSender = sender;

        if (localSender.state == UIGestureRecognizerStateBegan) {
            self.gestureStartingPoint = [localSender translationInView:self.textView];
            self.gestureStartingCenter = self.imageView.center;
        } else if (localSender.state == UIGestureRecognizerStateChanged) {
            CGPoint currentPoint = [localSender translationInView:self.textView];

            CGFloat distanceX = currentPoint.x - self.gestureStartingPoint.x;
            CGFloat distanceY = currentPoint.y - self.gestureStartingPoint.y;

            CGPoint newCenter = self.gestureStartingCenter;

            newCenter.x += distanceX;
            newCenter.y += distanceY;

            self.imageView.center = newCenter;

            self.textView.textContainer.exclusionPaths = @[[self translatedBezierPath]];
        } else if (localSender.state == UIGestureRecognizerStateEnded) {
            self.gestureStartingPoint = CGPointZero;
            self.gestureStartingCenter = CGPointZero;
        }
    }
}
{%endcodeblock%}
在上面的代码中首先根据平移的距离来设置imageView的位置，然后利用`translatedBezierPath`方法重新计算了一下排除区域。  
示例效果:  
![image](/images/TextKit_gif.gif)