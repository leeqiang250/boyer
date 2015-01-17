---
layout: post
title: "instrument之Zombie工具"
date: 2014-07-01 19:54:02 +0800
comments: true
tags: [instrument,Zombie, 工具]
categories: instrument
---
Zombie:针对**僵尸对象**导致应用程序崩溃，即已经`deallocated`的对象，它们的`retainCount`计数器已经为0，通过正常的手段是无法在`debug`中跟踪和观察到的。

如果你开启了 `Zombie Enabled` ，则当 Zombie 问题出现时，控制台会输出 Zombie 对象的地址，且程序会在此处产生断点：

	 -[CALayer retainCount]: message sent to deallocated instance <memoryaddress>
<!--more-->

虽然可以看到内存地址，知道是某个指针导致了 `Zombie` 引用，但对于解决问题却毫无帮助，因为仍不知道该地址到底是哪个对象？原因很显然，既然该对象已经`deallocated`，就无法再从内存中找回它来。虽然可以以对象的形式打印这个指针：
	
	（GDB）po <内存地址>

仍然会得到一个 **`message sent to deallocated instance`** 的错误消息。

可以在 `Instrument` 用 `Zombie` 模板，来观察到这些 `Zombie` 对象。
>提示：只能在模拟器中使用 Zombie 模板，对于在设备中运行的程序， 你只能手动找出`Zombie`对象，`Zombie`模板对物理设备无效。

使用操作如下：
点击 Xcode 的 Project --> Profile 菜单。在 Instrument 的“模板选择窗口”中，选择“iOSSimulator”下面的 Zombie 模板。
![image](/images/templateOfTraceDcument.jpg)
在模拟器中调试程序，如果 Zombie 问题出现，程序将崩溃，同时 Instrument 会弹出一个“Zombie 消息报告”，同时程序将在此处中断，如下图所示。
![image](/images/ZombieMsgAlert.jpg)

点击地址 (0x158b3c00) 右边的箭头，将列出该 Zombie 对象曾经发生过的 retain/release 动作。

从列表中找到 retain count 在变为 -1 之前的那行,打开 View -> Extended detail，将显示导致了过渡释放的代码调用：
![image](/images/ErrCodeline.jpg)

双击这句代码，将在源文件中高亮显示该语句：

![image](/images/Errorcode.png)
现在，知道问题出在哪里了吧？