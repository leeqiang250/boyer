---
layout: post
title: "iOS Document Interaction 编程指南"
date: 2014-07-01 23:12:01 +0800
comments: true
categories: 
---

####关于 Document Interaction
  iOS支持在你的app中通过调用其他app来预览和显示文档。iOS还支持文件关联，允许其他app调用你的app打开文件。这些技术包括了UIKit中提供的UIDocumentInteractionController类（ [UIDocumentInteractionController Class Reference](http://))，以及Quick Look框架（[Quick Look Framework Reference](http://))。  
  从iOS4.2开始，Quick Look框架提供了内置的文件打印支持。如果你要定制自己的打印和拷贝行为，你可以自己实现documentinteraction controller委托方法来提供支持。UIDocumentInteractionController和QLPreviewController类的示例代码，请参考[DocInteraction](http://)示例工程.

* 预览文档和呈现选项菜单  
  如果app需要打开自身并不支持的文件时，就需要使用**UIDocumentInteractionController**。一个**document interaction controller**通过**Quick Look框架**判断文档是否能被另一个app打开和预览。也就是说，app可以通过**documentinteraction controller**提供一些可选的操作方案，来帮助用户实现该需求。
要使用一个**document interaction controller**，需要以下步骤：

* * 针对需要通过其他APP打开的文件，创建相应的`UIDocumentInteractionController`实例。  

* * 在自己APP的UI中提供一个代表这种文件的图像标（一般显示文件名或者图标，例如xxx.pdf,文件格式图标）。

* * 如果用户和这个对象交互，如触摸这个控件，则调用`documentinteractioncontroller`显示以下三种界面:	  
	1. 预览文件的内容。
	2. 一个包含预览和打开操作的菜单。可以通过实现某些委托方法，向菜单中加入其他操作，比如复制、打印。
	3. 一个菜单，仅包含“以其它方式打开”操作。

同时，`documentinteractioncontroller`内置了一些手势，如需要可以直接实现。与文件交互的app都可以使用`documentinteractioncontroller`。  
这些程序绝大部分都需要从网络下载文件。例如，email程序需要打开和预览邮件附件。即使是从不下载文件的app，也需要`documentinteractioncontroller`。 例如 ，APP需要支持文件共享（参考“File-Sharing Support” in [iOS Technology Overview](https://developer.apple.com/library/ios/documentation/Miscellaneous/Conceptual/iPhoneOSTechOverview/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007898) 以及[DocInteraction](http://) 示例工程), 即可以对同步到app Documents/Shared目录下的文件使用`documentinteractioncontroller`。
<!--more-->
####创建Document Interaction Controller
要创建一个**document interaction controller**实例，需要用即将其他APP打开的文件实例化它，并设置它的`delegate`属性。delegate对象负责告诉**document  interaction controller**呈现视图时需要的信息，以及当视图显示和用户交互时要执行的动作。  
如以下代码所示。注意方法的调用者必须retain返回对象。
```objc 实例化document interaction controller
- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL) fileURL
    											 usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate 
{
	   UIDocumentInteractionController *interactionController =
	       									[UIDocumentInteractionController interactionControllerWithURL: fileURL];
	   interactionController.delegate = interactionDelegate;
	
	   return interactionController;
}  
```

创建好**document interaction controller**之后，可以通过它的属性来读取与之关联的文件信息，包括文件名、类型和URL。该controller还有一个`icons`属性，其中包含了多个 `UIImage` 对象,可以用于表示该文档的多个大小的图标。这些信息可用于UI。

如果想让用户用在其他APP中打开这个文件，可以使用controller的 `annotation` 属性，将该程序所需的附加信息放在其中。当然信息的格式必须能够被该应用程序识别。例如，该属性将被某个应用程序套件中的单个程序所用。当这个程序想与套件中的其他程序进行交互时，就可以使用`annotation` 属性。当调用应用程序打开一个文件时，`option` 字典中会包含 `annotation` 的值，可以使用`UIApplicationLaunchOptionsAnnotationKey` 作为键在option字典中检索它。
