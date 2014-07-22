---
layout: post
title: "Storyboard之Segue"
date: 2014-07-22 10:59:49 +0800
comments: true
categories: 
---
#####Segue原理:
在iOS开发中，segue用来实现storyboard中源视图控制器和目标视图控制器连接，当segue被触发时，系统将完成下列操作：

1. 实例化目标视图控制器
2. 实例化一个新segue对象，该对象持有所有的信息
3. 调用源视图控制器的prepareForSegue:sender:方法，
4. 调用segue的 perform 方法将目标控制器带到屏幕上。  
这个动作行为依赖segue的类型如modal,push,custom,modal segue告诉源视图控制器present目标视图控制器。

在源视图控制器的prepareForSegue:sender:的方法中，执行对目标视图控制器所有必要的属性配置，包括委托设置（如目标视图控制器有协议）。

在apple的文档库中第二个示例应用开发文档中，介绍了这样一个segue的使用例子。
{%codeblock lang:objc%}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender  
{  
    if ([[segue identifier] isEqualToString:@"ShowSightingsDetails"])  
    {  
    //当用户选择表视图中的一行时，触发**segue**事件，传输数据到目标视图控制器，使目标控制器上能显示`sighting`
        DetailViewController *detailViewController = [segue destinationViewController];  
        detailViewController.sighting = [self.dataController objectInListAtIndex:[self.tableView indexPathForSelectedRow].row];  
    }  
   
    if ([[segue identifier] isEqualToString:@"ShowAddSightingView"])  
    {  
        AddSightingViewController *addSightingViewController = [[[segue destinationViewController] viewControllers] objectAtIndex:0];  
        addSightingViewController.delegate = self;  
    }  
}  
{%endcodeblock%}  
在`storyboard`中，这个实现方法代码是用来处理从主视图控制器到两个不同的目标视图控制器的**segue**。这两个**segue**通过它们的`identifier`属性进行判断，具体解释如下：  
 
 * `identifier`为"**ShowSightingsDetails**"时，目标视图控制器是一个展示明细信息的视图控制器,使用的**segue**类型为`push`。这种通常用于**navigator**视图控制器中。  

 * 在`identifier`为"**ShowAddSightingView**"时，目标视图控制器管理的是一个新加的**sighting**信息视图，我们称之为**add**视图控制器。它是不需要从主视图控制器（源）传什么数据过来的。但是，主视图控制器需要获取在add视图控制器（目标）上输入的数据。  
* * 实现方式是采用`delegate`，将主视图控制器设置为add视图控制器(目标)的委托。在add目标视图控制器上执行它的委托中方法，该方法需要先在主视图控制器的实现代码中实现，方法包括如何读取add视图控制器的数据，并dismiss掉add视图控制器。  

在add视图控制器上，有两个按钮，用于执行**cancel**和**done**操作。这两个按钮操作的方法在主视图控制器中实现。
{%codeblock lang:objc%}
//
- (void)addSightingViewControllerDidCancel:(AddSightingViewController *)controller  
{  
	[self dismissViewControllerAnimated:YES completion:NULL];  
}  
 
// 
- (void)addSightingViewControllerDidFinish:(AddSightingViewController *)controller name:(NSString *)name location:(NSString *)location {  
if ([name length] || [location length]) {  
	[self.dataController addBirdSightingWithName:name location:location];  
	[[self tableView] reloadData];  
}  
	[self dismissModalViewControllerAnimated:YES];  
}
{%endcodeblock%}  
在add视图控制器实现代码中，调用它的委托中这两个方法。  
#####segue三种类型:modal segue、push segue、custom segue
* ######modal segue
  是一个视图控制器（源）为了完成一个任务而模态地（**modally**）呈现另一个视图控制器（目标）。这个目标视图控制器不是导航视图控制器(**navigation view controller**)的栈中的一部分。  
在任务完成后，使用`delegate`将呈现的视图控制器（目标）释放掉，应用界面切换到原来的视图控制器（源）上。  

这个过程的实现代码可以看成是`present`和`dismiss`两个操作。  

* ######push segue  
是将另一个视图控制器压入到导航控制器的栈中。它通常和导航视图控制器(**navigation view controller**)一起使用。  
新压入的视图控制器会有一个回退按钮，可以退回来上一层。

这个过程的实现代码可以看成是`push`和`pop`两个操作。

