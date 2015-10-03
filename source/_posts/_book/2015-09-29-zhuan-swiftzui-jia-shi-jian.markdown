---
layout: post
title: "[转]Swift最佳实践"
date: 2015-09-29 17:05:21 +0800
comments: true
categories: Swift,IOS
---
[英文][SwiftCommunityBestPractices]
[SwiftCommunityBestPractices]: https://github.com/schwa/Swift-Community-Best-Practices
[SwiftCommunity]: http://swift-lang.schwa.io/

###黄金法则
* Apple 通常是对的。应紧随苹果所推荐的或他的 Demo 中所展示的方式。您应该尽可能地遵守 Apple 在 [The Swift Programming Language][The Swift Programming Language] 一书中所定义的代码风格。但我们还是可以看到他们的示例代码中有不符合这些规则的地方，毕竟 Apple 是一家大公司嘛。
* 不要仅仅为了减少字符的键入数量而使用模棱两可的简短命名，较长的命名都可以依赖自动完成、自我暗示、复制粘贴来减低键入的难度。命名的详细程度往往对代码维护者很有帮助。但过于冗长的命名却会绕过Swift的主要特性之一: 类型推导,所以命名的原则应该是简洁明了。

[The Swift Programming Language]: https://developer.apple.com/library/prerelease/ios/documentation/Swift/Conceptual/Swift_Programming_Language/index.html

##最佳实践

###命名
按照 [The Swift Programming Language][The Swift Programming Language] 所推荐的命名法则，类型名称应该使用[首字母大写的驼峰命名法][upper camel case] (例如: "VehicleController")。

变量与常量应该使用首字母小写的驼峰命名法(例如: " vehicleName " )。

推荐使用 Swift 模块来定义代码的命名空间，而非在 Swift 代码上使用 Objective-C 样式的类前缀(除非接口要与 Objective-C 交互)。

不推荐使用任何形式的[匈牙利命名法][Hungarian notation]（比如：k 代表常量，m 代表方法）,取代代之我们应该使用短而简洁的名字并使用 Xcode 的类型快速帮助 (⌥ + 左击)。同样我们也不要使用类似 `SNAKE_CASE` 这样的名字。

这些法则之上，唯一例外的情况就是枚举值了，枚举值在这里应该首字母大写(这是 Apple 的 [The Swift Programming Language][The Swift Programming Language] 中的规范)：

{%codeblock lang:ruby%}
enum Planet {
    case Mercury, Venus, Earth, Mars, Jupiter, Saturn, Uranus, Nepture
}
{%endcodeblock%}

有必要的话命名不要缩写，实际上在 Xcode 的"文本自动补全"功能下你可以轻而易举地键入 类似 `ViewController` 的长命名。极为常见的缩写，例如: URL， 是很好的。缩写应该是全部大写 ( "URL" )或者酌情全部小写( "url" )。URL 的类型和变量命名推荐的规则： 如果 url 是一个类型，它应该被大写，如果是一个变量，那么应该小写。

[upper camel case]: http://www.wikiwand.com/en/Studly_caps
[Hungarian notation]: http://www.wikiwand.com/en/Hungarian_notation
### 注释

不应该使用注释来禁用代码。被注释掉的代码会污染你的源代码。如果你当前想要删除一段代码，但将来又可能会用到，推荐你依赖 git 或你的 bug 追踪系统来管理。

(TODO: 追加一个关于文档注释的小节，使用 nshipster 的链接)
### 类型推导

如果可能的话，使用 Swift 的类型推导，以避免冗余的类型信息。例如：

推荐：

{%codeblock lang:ruby%}
Swift
var currentLocation = Location()
{%endcodeblock%}

而非：

{%codeblock lang:ruby%}
Swift
var currentLocation: Location = Location()
{%endcodeblock%}
### 内省

让编译器自动推断所有的情况，这是可以做到的。在一些领域 self 应该被显式地使用，包括在 init 中设置参数，或者 `non-escaping`闭包。例如：
{%codeblock lang:ruby%}
	struct Example{
  	  let name: String
 	   init(name: String) {
  	      self.name = name
  	  }
	}
{%endcodeblock%}
### 捕获列表的类型推导

在一个捕获列表( capture list )中指定参数类型会导致代码冗余。如果需要的话，仅指定类型即可。  

{%codeblock lang:ruby%}
	let people = [
	    ("Mary", 42),
	    ("Susan", 27),
	    ("Charlie", 18),
	]	
	
	let strings = people.map() {
	    (name: String, age: Int) -> String in
	    return "\(name) is \(age) years old"
	}
{%endcodeblock%}
如果编译器可以推导出来的话，完全可以把类型删掉：

{%codeblock lang:ruby%}
let strings = people.map() {
    (name, age) in 
    return "\(name) is \(age) years old"
}
{%endcodeblock%}

使用编号的参数名 ("$0") 进一步降低冗长，往往能彻底消除捕获列表的代码冗余。在闭包中当参数名没有附带任何更多信息时仅使用编号形式即可( 如非常简单的映射和过滤器 )。

Apple 能够并且将会改变闭包的参数类型，通过他们的 Objective-C 框架的 Swift 变种提供出来。例如，`optionals` 被删除或更改为 `auto-unwrapping` 等。故意 under-specifying 可选并依赖 Swift 来推导类型，可以减少在这些情况下代码被破译的风险。

你应该避免指定返回类型，例如这个捕获列表( capture list )就是完全多余的:

{%codeblock lang:ruby%}
dispatch_async(queue) {
    ()->Void in
    print("Fired.")
}
{%endcodeblock%}

(以上内容也可以参考:[这里][swiftCaptureLists])

[swiftCaptureLists]: http://www.russbishop.net/swift-capture-lists
### 常量

类型定义中使用的常量应当被申明成静态类型。例如:
{%codeblock lang:ruby%}
	struct PhysicsModel {
    static var speedOfLightInAVacuum = 299_792_458
	}
	
	class Spaceship {
   		 static let topSpeed = PhysicsModel.speedOfLightInAVacuum
  	     var speed: Double
   		 func fullSpeedAhead() {
       		 speed = Spaceship.topSpeed
    	}
	}
{%endcodeblock%}
将常量标示为 static ，允许它们可以被无类型的实例引用。

一般应该避免生成全局范围的常量，单例除外。
























