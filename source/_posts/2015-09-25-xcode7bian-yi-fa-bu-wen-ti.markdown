---
layout: post
title: "Xcode7编译发布问题"
date: 2015-09-25 15:58:17 +0800
comments: true
categories: 
---
####Xcode7编译发布问题
1. ERROR ITMS-90535: "Unexpected CFBundleExecutable Key. The bundle at 'Payload/PBBReader.app/TencentOpenApi_IOS_Bundle.bundle' does not contain a bundle executable. If this bundle intentionally does not contain an executable, consider removing the CFBundleExecutable key from its Info.plist and using a CFBundlePackageType of BNDL. If this bundle is part of a third-party framework, consider contacting the developer of the framework for an update to address this issue."

2. ERROR ITMS-90475: "Invalid Bundle. iPad Multitasking support requires launch story board in bundle 'pyc.com.cn.pbbReader'."
3. 苹果邮件：We have discovered one or more issues with your recent delivery for "PBB Reader". To process your delivery, the following issues must be corrected: 
Invalid Bundle - A nested bundle doesn't have the right platforms listed in CFBundleSupportedPlatforms Info.plist key.

4. IOS9访问网络设置：**NSAppTransportSecurity** 字典，字段：**NSAllowsArbitraryLoads**  字段值：**YES**
6. 搜索Target对应的build setting中，把**bitCode**支持设置为NO
8. [iPad 中的多任务适配](http://onevcat.com/2015/06/multitasking/)  
如果你不想你的 app 可以作为多任务的副 app 被使用的话，你可以在 Info.plist 中添加 **UIRequiresFullScreen** 并将其设为 **YES**
5. 对第三方SDK后台运行，有严格的把控，要求bundle资源必须为最新有效，上传包时必要条件


###解决办法：
退回Xcode6.4,进行打包发布