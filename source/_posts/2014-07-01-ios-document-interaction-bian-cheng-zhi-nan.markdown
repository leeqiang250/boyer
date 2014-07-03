---
layout: post
title: "iOS Document Interaction 编程指南"
date: 2014-07-01 23:12:01 +0800
comments: true
categories: 
---

####关于 Document Interaction
  iOS支持在你的app中通过调用其他app来预览和显示文档。iOS还支持文件关联，允许其他app调用你的app打开文件。这些技术包括了UIKit中提供的[UIDocumentInteractionController](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIDocumentInteractionController_class/Reference/Reference.html)类，以及[Quick Look](https://developer.apple.com/library/ios/documentation/QuickLook/Reference/QuickLookFrameworkReference_iPhoneOS/_index.html)框架。

* ######预览文档和呈现选项菜单  
  如果app需要打开自身并不支持的文件时，就需要使用**UIDocumentInteractionController**。一个**document interaction controller**通过**Quick Look框架**判断文档是否能被另一个app打开和预览。也就是说，app可以通过**documentinteraction controller**提供一些支持打开该文件方式的菜单。
  
具体实现需要以下步骤：

* * 需要通过其他APP打开的文件，来实例化`UIDocumentInteractionController`实例对象。  
* * 在自己的APP UI中提供一个代表这种文件的图像标（一般显示文件名或者图标）。
* * 用户交互，如触摸这个控件，则调用`documentinteractioncontroller`对象。  

三种交互界面:
	1. 预览文件的内容。
	2. 一个包含预览和打开操作的菜单。可以通过实现某些委托方法，向菜单中加入其他操作，比如复制、打印。
	3. 一个菜单，仅包含“以其它方式打开”操作。

同时，`documentinteractioncontroller`内置了一些手势，必要时可以直接实现它们。  

* ######使用`documentinteractioncontroller`的场景:**与文件交互的app都可以使用。**

* - 需要从网络下载文件的APP:  
例如，email程序需要打开和预览邮件附件。
* - 不下载文件的APP:  
例如，APP需要支持文件共享（参考“File-Sharing Support” in [iOS Technology Overview](https://developer.apple.com/library/ios/documentation/Miscellaneous/Conceptual/iPhoneOSTechOverview/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007898)), 即可以对同步到app Documents/Shared目录下的文件使用`documentinteractioncontroller`。
<!--more-->
####创建Document Interaction Controller
创建时，通过需要其他APP打开的文件，来实例化`UIDocumentInteractionController`实例对象，并设置它的`delegate`属性。  
`delegate`对象负责告诉**document  interaction controller**呈现视图时需要的信息，以及当视图显示和用户交互时要执行的动作。  
如以下代码所示。注意方法的调用者必须返回对象。
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

实例创建后，可以通过它的属性来读取与之关联的文件信息，包括文件名、类型和URL。该实例中还有一个`icons`属性，其中包含了多个 `UIImage` 对象,可以用于表示该文档的多个大小的图标。这些信息可用于UI。

如果用其他APP打开该文件，可以利用该实例的 `annotation` 属性，该属性包含了其他APP所需的附加信息。当然信息的格式必须能够被该APP识别。  
例如:当程序想与套件中的其他程序进行交互时，就可以使用`annotation` 属性。当被调用应用程序打开一个文件时，`option` 字典中会包含 `annotation` 的值，可以使用<font color=red size = 1>UIApplicationLaunchOptionsAnnotationKey</font> 作为键在`option`字典中检索它。

####呈现 Document Interaction Controller
用户可以通过 `Document interaction controller`实例，来预览该文件，或者通过弹出菜单让用户选择相应的动作。  

* 模式化显示文件预览窗口，调用如下方法:
{%codeblock lang:objc 模式化预览窗口调用的方法 Declared In UIDocumentInteractionController.h %}
//Displays a full-screen preview of the target document.
- (BOOL)presentPreviewAnimated:(BOOL)animated;
{%endcodeblock%}
预览窗口是以模式视图显示的，同时必须实现以下协议方法:
{%codeblock lang:objc Declared In UIDocumentInteractionController.h%}
//Called when a document interaction controller needs the starting point for animating the display of a document preview.
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller
{%endcodeblock%}
>注:该方法最终需要返回一个**`VC`**，来作为预览窗口的父窗口。假如没有实现该方法，或者在该方法中返回 nil，或者返回的**`VC`**无法呈现模式窗口，则该预览窗口不会显示。
最终会被**`documentinteractioncontroller `**会自动解散它呈现出来的窗口。或调用系统提供销毁模态视图的方法，手动销毁如下：
{%codeblock lang:objc Declared In UIDocumentInteractionController.h%}
//Dismisses the currently active menu.
- (void)dismissMenuAnimated:(BOOL)animated  
//Dismisses the currently active document preview.
- (void)dismissPreviewAnimated:(BOOL)animated
{%endcodeblock%}

* 通过弹出菜单提示用户选择相应动作，调用如下方法:
{%codeblock lang:objc 弹出"通过其他方式打开"菜单 Declared In UIDocumentInteractionController.h%}
//Displays an options menu and anchors it to the specified location in the view.
- (BOOL)presentOptionsMenuFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated
//Displays an options menu and anchors it to the specified bar button item.
- (BOOL)presentOptionsMenuFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{%endcodeblock%}
* 提示用户用其他程序打开该文件，调用如下方法:
{%codeblock lang:objc 提示用户用其他程序打开 Declared In UIDocumentInteractionController.h%}
//Displays a menu for opening the document and anchors that menu to the specified view.
- (BOOL)presentOpenInMenuFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated
//Displays a menu for opening the document and anchors that menu to the specified bar button item.
- (BOOL)presentOpenInMenuFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
{%endcodeblock%}
以上几种方法都会显示一个视图或一个预览窗口或是弹出菜单。任何一个方法的调用，都要检查返回值。返回值为 `NO`，表示这个视图没有任何内容，将不能显示。  
例如，**`presentOpenInMenuFromRect:inView:animated:`**方法返回`NO`,表明已安装的程序中没有任何程序能够打开该文档。

####注册应用程序支持的文档类型

如果你的程序可以打开某种特定的文件类型，则可以通过**Info.plist**文件注册程序所能打开的文档类型。当其他程序向系统询问哪些程序可以识别该类型的文件时，你的程序就会被列到选项菜单中，供用户选择。  

* 有如下概念:  
* * 需要在程序的**`Info.plist`**文件中添加新字段**`CFBundleDocumentTypes`** 键 (查看 “[CoreFoundation Keys](https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html#//apple_ref/doc/uid/TP40009249)”) 。系统会将该键中包含的内容进行登记，这样其他程序就可以通过**`document interaction controller`**访问到这些信息。

* * **`CFBundleDocumentTypes`** 键是一个`dictionary`数组，一个`dictionary`表示了一个指定的文档类型。一个文档类型通常与某种文件类型是一一对应的。但是，如果你的程序对多个文件类型采用同样的处理方式，你也可以把这些类型都分成一个组，统一视作一个文档类型。  
例如，你的程序中使用到的本地文档类型，有一个是旧格式的，还有一个新格式（似乎是影射微软**office**文档），这样就可以将二者分成一组，都放到同一个文档类型下。这样，旧格式和新格式的文件都将显示为同一个文档类型，并以同样的方式打开。  

**`CFBundleDocumentTypes`** 数组中的每个`dictionary`包含以下键：
{%codeblock lang:objc 字典键名称%}
CFBundleTypeName 			//指定文档类型名称。
CFBundleTypeIconFiles    //是一个数组，包含多个图片文件名，用于作为该文档的图标。
LSItemContentTypes 		//是一个数组，包含多个 UTI 类型的字符串。UTI 类型是本文档类型（组）所包含的文件类型。
LSHandlerRank 				//表示应用程序是“拥有”还是仅仅是“打开”这种类型而已。
{%endcodeblock%}
在应用程序的角度而言，一个文档类型其实就是一种文件类型（或者多个文件类型），该程序将一个文档类型的文件都视作同样的东西对待。例如，一个图片处理程序可能将各种图片文件都看成不同的文档类型，这样便于根据每个类型进行相应的优化。但是，对于字处理程序来说，它并不关心真正的图形格式，它把所有的图片格式都作为一个文档类型对待。

* **`CFBundleDocumentTypes`**字典数组示例:
{%codeblock lang:html 自定义文件格式的文档类型 %}
<dict>
   <key>CFBundleTypeName</key>
   <string>My File Format</string>
   <key>CFBundleTypeIconFiles</key>
       <array>
           <string>MySmallIcon.png</string>
           <string>MyLargeIcon.png</string>
       </array>
   <key>LSItemContentTypes</key>
       <array>
           <string>com.example.myformat</string>
       </array>
   <key>LSHandlerRank</key>
   <string>Owner</string>
</dict>
{%endcodeblock%}


####打开支持的文件类型
系统可能会请求某个程序打开某种文件，并呈现给用户。这种情况通常发生在某个应用程序调用 **`document interaction controller`** 去处理某个文件的时候。  
这时应用程序可以通过委托方法:
{%codeblock lang:objc 获得文件的信息 Declared In UIApplication.h https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplicationDelegate_Protocol/Reference/Reference.html#//apple_ref/occ/intfm/UIApplicationDelegate/application:didFinishLaunchingWithOptions: %}
//Tells the delegate that the launch process is almost done and the app is almost ready to run.
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{%endcodeblock%}
><font size =1>注:如果你的程序要处理某些自定义的文件类型，就必须实现这个委托方法（而不是**`applicationDidFinishLaunching:`**方法) 并用这个方法启动应用程序</font>  

该方法的**`option`**包含了要打开的文件的相关信息，可以通过以下键名一一解析：
{%codeblock lang:objc %}
UIApplicationLaunchOptionsURLKey 					 //该文件的NSURL
UIApplicationLaunchOptionsSourceApplicationKey 	//发送请求的应用程序的Bundle ID
UIApplicationLaunchOptionsSourceApplicationKey		//源程序向目标程序传递的与该文件相关的属性列表对象
{%endcodeblock%}
如果 **`UIApplicationLaunchOptionsURLKey`** 键存在，你的程序应当立即用该**`URL`**打开该文件并将内容呈现给用户。其他键可用于收集与打开的文件相关的参数和信息。

####使用 Quick Look 框架
**`Quick Look`**框架提供了增强的预览功能，可以选择呈现预览窗口时的动画风格，并可以像预览单个文件一样预览多个文件。  
该框架主要提供了 **`QLPreviewController`** 类。该类依赖于委托对象响应预览动作，以及一个用于提供预览文件的数据源，内置了所支持的文件类型的 **AirPrint** 打印。  

* ######Quick Look Previews 中的预览及打印	
从 iOS 4.2 开始，**`QLPreviewController`** 提供了包含了一个 `action` 按钮（即打印按钮）的预览视图。对于 **`QLPreviewController`** 能预览的文件，不用编写任何打印代码，只需点击`action`按钮就能直接打印该文档。  

通过以下方式显示**`QLPreviewController`**:

* * 通过导航控制器，将预览窗口以“**`push` 方式**”显示。

* * 通过 **UIViewController** 的 **`presentModalViewController:animated:`**方法，将预览窗口以模态窗口的方式全屏显示。

* * 显示一个**`document interaction controller`**(如 “预览及打开文件” 中所述），再在选项菜单中选择“**`Quick Look`**”即可。  

> <font size=1 >预览窗口中会包括一个标题，显示文件 URL 的最后一段路径。如果要重载标题，可以定制**`PreviewItem`** 类，并实现**`QLPreviewItem`** 协议中的 **previewItemTitle**方法。</font>

* ######**`QLPreviewController`**能够预览下列文件：

* * iWork 文档
* * Microsoft Office 文档(Office ‘97 以后版本)
* * Rich Text Format (RTF) 文档
* * PDF 文档
* * 图片
* * 文本文件，其 uniform type identifier (UTI)  在 public.text 文件中定义 (查看UniformType Identifiers 参考)
* * Comma-separated value (csv) 文件  

使用**`QLPreviewController`**，必须指定数据源对象（即实现 **`QLPreviewControllerDataSource`** 协议，请查看[QLPreviewControllerDataSource](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Reference/QLPreviewControllerDataSource_Protocol/Reference/Reference.html#//apple_ref/doc/uid/TP40009665)协议参考）。数据源为 **`QLPreviewController`**提供预览对象（**`preivew item`**），及指明它们的数量以便在一个预览导航列表中包含它们。在这个列表中包含多个对象，在模态预览窗口（全屏显示）显示了导航箭头，以便用户在多个预览对象间切换。对于用导航控制器“push方式”显示的**`QLPreviewController`**，你可以在导航条上提供按钮以便在预览对象列表见切换。