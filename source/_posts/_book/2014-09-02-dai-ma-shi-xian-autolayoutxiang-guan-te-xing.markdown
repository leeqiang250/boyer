---
layout: post
title: "代码实现autoLayout相关特性"
date: 2014-09-02 15:53:11 +0800
comments: true
categories: 
---


##按比例缩放
按比例缩放，这是在Interface Builder中无法设置的内容。  
而在代码中，有如下两种实现方式:

1. 使用`NSLayoutConstraint`类型的初始化函数中的`multiplier`参数就可以非常简单的设置按比例缩放。  
2. 同时也可以设置不同`NSLayoutAttribute`参数来达到意想不到的效果，比如“A的Width等于B的Height的2倍”这样的效果。  

现在就拿一个简单的**`UIButton`**做示例，在ViewController中创建一个UIButton字段：  
{%codeblock lang:objc%}
	UIButton *btn;  
{%endcodeblock%}  
####需求 1：  

1. 要求**`UIButton`**水平居中，始终距离父View底部**20**单位，其高度是父View高度的三分之一。
2. 使用**KVO**来监控**`UIButton`**的大小并实时输出到屏幕上。  
{%codeblock lang:objc%}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //创建UIButton，不需要设置frame
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"mgen" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor greenColor];
    [self.view addSubview:btn];

    //禁止自动转换AutoresizingMask
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    
    //居中
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:btn
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0]];
    
    //距离底部20单位
    //注意NSLayoutConstraint创建的constant是加在toItem参数的，所以需要-20。
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:btn
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeBottom
                              multiplier:1
                              constant:-20]];
    
    //定义高度是父View的三分之一
    [self.view addConstraint:[NSLayoutConstraint
                              constraintWithItem:btn
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:self.view
                              attribute:NSLayoutAttributeHeight
                              multiplier:0.3
                              constant:0]];

    //注册KVO方法
    [btn addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];    
}

//KVO回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == btn && [keyPath isEqualToString:@"bounds"])
    {
        [btn setTitle:NSStringFromCGSize(btn.bounds.size) forState:UIControlStateNormal];
    }
}
{%endcodeblock%}  
运行结果：  
![image](/images/runbtn1.png)![image](/images/runbtn2.png)  
<!--more-->
####需求 2：  
1. 在横向的显示中，Button的高度只有96，所以要求Button的最小高度为150。   

涉及到的相关特性：
 
 - **优先级**：当两个**`Constraint`**同时作用在一个控件时，在某些情况下是有冲突的，可以通过设置**`Constraint`**的优先级来解决。
优先级对应**`NSLayoutConstraint`**类型的**`priority`**属性，默认值是**`UILayoutPriorityRequired`**，数值上等于**1000**. 设置一个低的值代表更低的优先级。  
 - **最小值的定义**：使用**`NSLayoutRelationGreaterThanOrEqual`**作为**`NSLayoutConstraint`**类型创建时的**`relatedBy`**参数。

修改上面的比例Constraint，并在下方加入一个新的限制最小值的Constraint，代码：  
{%codeblock lang:objc%}
//定义高度是父View的三分之一
//设置优先级低于UILayoutPriorityRequired(1000)，UILayoutPriorityDefaultHigh是750
NSLayoutConstraint *con = [NSLayoutConstraint
                          constraintWithItem:btn
                          attribute:NSLayoutAttributeHeight
                          relatedBy:NSLayoutRelationEqual
                          toItem:self.view
                          attribute:NSLayoutAttributeHeight
                          multiplier:0.3
                          constant:0];
con.priority = UILayoutPriorityDefaultHigh;
[self.view addConstraint:con];

//设置btn最小高度为150
[btn addConstraint:[NSLayoutConstraint
                    constraintWithItem:btn
                    attribute:NSLayoutAttributeHeight
                    relatedBy:NSLayoutRelationGreaterThanOrEqual
                    toItem:nil
                    attribute:NSLayoutAttributeNotAnAttribute
                    multiplier:1
                    constant:150]];
{%endcodeblock%}  
运行后，横向屏幕中的Button高度成了150：  
![image](/images/runbtn3.png)  
####intrinsicContentSize 控件的内置大小
控件的内置大小是由控件本身的内容所决定的，比如一个`UILabel`的文字很长，那么该`UILabel`的内置大小自然会很长。  
在代码中获取控件的内置大小的方法：  

1. 通过`UIView`的`intrinsicContentSize`属性来获取；
2. 通过`invalidateIntrinsicContentSize`方法来在下次UI规划事件中重新计算`intrinsicContentSize`。  

注意：如果直接创建一个原始的UIView对象，它的内置大小为0。  

先写一个辅助方法来快速设置UIView的边距限制：  
{%codeblock lang:objc%}
//设置Autolayout中的边距辅助方法
- (void)setEdge:(UIView*)superview view:(UIView*)view attr:(NSLayoutAttribute)attr constant:(CGFloat)constant
{
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:view 
												    attribute:attr 
												    relatedBy:NSLayoutRelationEqual 
												       toItem:superview
												    attribute:attr 
												   multiplier:1.0 
												     constant:constant]
    ];
}
{%endcodeblock%}  
接下来，创建一个UIView，利用上面的辅助方法快速设置其在父控件的左，上，右边距为20单位。如下代码：  
{%codeblock lang:objc%}
//view1
UIView *view1 = [UIView new];
view1.backgroundColor = [UIColor yellowColor];
//不允许AutoresizingMask转换成Autolayout
view1.translatesAutoresizingMaskIntoConstraints = NO;
[self.view addSubview:view1];
//设置左，上，右边距为20.
[self setEdge:self.view view:view1 attr:NSLayoutAttributeLeft constant:20];
[self setEdge:self.view view:view1 attr:NSLayoutAttributeTop constant:20];
[self setEdge:self.view view:view1 attr:NSLayoutAttributeRight constant:-20];
{%endcodeblock%}   
但是运行后会发现，界面上不会显示任何东西。原因就是上面讲的，`UIView`默认是没有**`intrinsicContentSize`**的。

创建一个自定义的`UIView`来改写**`intrinsicContentSize`**：MyView:  
![image](/images/MyView.png)  
然后在.m文件中改写**intrinsicContentSize**方法，并返回有效值，比如这样：  
{%codeblock lang:objc%}
//改写UIView的intrinsicContentSize
- (CGSize)intrinsicContentSize
{
    return CGSizeMake(70, 40);
}  
{%endcodeblock%}  
接着修改最上面的代码，把上面view1变量的类型从UIView替换成我们自定义的View：MyView类型：  
{%codeblock lang:objc%}
MyView *view1 = [MyView new];  
{%endcodeblock%}  
再次运行代码，View会按照要求显示在屏幕上：  
![image](/images/Myview2.png)  
按照同样的方式，在下方添加另一个`MyView`，要求其距离父控件边距左，下，右各为**20**，代码：  
{%codeblock lang:objc%}
//view2  
MyView *view2 = [MyView new];  
view2.backgroundColor = [UIColor yellowColor];  
//不允许AutoresizingMask转换成Autolayout  
view2.translatesAutoresizingMaskIntoConstraints = NO;  
[self.view addSubview:view2];  
//设置左，下，右边距为20.  
[self setEdge:self.view view:view2 attr:NSLayoutAttributeLeft constant:20];  
[self setEdge:self.view view:view2 attr:NSLayoutAttributeBottom constant:-20];  
[self setEdge:self.view view:view2 attr:NSLayoutAttributeRight constant:-20];  
{%endcodeblock%}  
![image](/images/myview4.png)  
####需求：
1. 通过代码加入Autolayout中的间距，命令view1和view2上下必须间隔20个单位。 
	2. - 这里要求view2在view1之下的**20**单位，所以创建**NSLayoutConstraint**中view2参数在前面。  
	2. - view2的**`attribute`**参数是**`NSLayoutAttributeTop`**，而view1的**`attribute`**参数是**`NSLayoutAttributeBottom`**  

2. 拉伸view2,而不拉伸view1。  
	1. - 控件的**`Content Hugging Priority`**拒绝拉伸的优先级，优先级越高，控件会越不容易被拉伸。    
	2. - 控件的**`Content Compression Resistance Priority`**拒绝压缩内置空间(`intrinsicContentSize`)的优先级。优先级越高，控件的内置空间(`intrinsicContentSize`)会越不容易被压缩。  
	
{%codeblock lang:objc%}
//设置两个View上下间距为20
[self.view addConstraint:[NSLayoutConstraint constraintWithItem:view2 
											attribute:NSLayoutAttributeTop 
											relatedBy:NSLayoutRelationEqual
											   toItem:view1
										    attribute:NSLayoutAttributeBottom 
										   multiplier:1.0
											 constant:20]
									];
{%endcodeblock%}  
![image](/images/view1Toview2.png)  

OK，的确，此时view1和view2相互间隔20单位，但是view1被拉伸了。

使用控件的**`Content Hugging Priority`**，如下图：  
![image](/images/ContentHuggingPriority.png)  
如图,把view1（上图中被拉伸的，在上面的View）的**`Content Hugging Priority`**设置一个更高的值，那么当`Autolayout`遇到这种决定谁来拉伸的情况时，view1不会被优先拉伸，而优先级稍低的view2才会被拉伸。  
可以直接通过UIView的`setContentHuggingPriority:forAxis`方法来设置控件的**`Content Hugging Priority`**，其中`forAxis`参数代表横向和纵向，本例中只需要设置纵向，所以传入**`UILayoutConstraintAxisVertical`**。整句代码：  
{%codeblock lang:objc%}
	//提高view1的Content Hugging Priority
	[view1 setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
{%endcodeblock%}  
![image](/images/runview1.png)






