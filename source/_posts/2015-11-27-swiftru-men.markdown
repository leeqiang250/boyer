---
layout: post
publiced: false
title: "Swift入门"
date: 2015-11-27 17:18:21 +0800
comments: true
tags:[swift,语法]
keywords: Swift,语法
categories: Swift
---

####背景
Apple基于已有的编译器、调试器、框架作为其基础架构。通过ARC(Automatic Reference Counting，自动引用计数)来简化内存管理。我们的框架栈则一直基于Cocoa，且Objective-C进化支持了块、collection literal和模块，允许现代语言的框架无需深入即可使用。
(by gashero)感谢这些基础工作，才使得可以在Apple软件开发中引入新的编程语言Swift。

####swift有点

编译器是按照性能优化的，而语言是为开发优化的

Swift采用了Objective-C的命名参数和动态对象模型。提供了对Cocoa框架和mix-and-match的互操作性。基于这些基础，Swift引入了很多新功能和结合面向过程和面向对象的功能。
Swift对新的程序员也是友好的：

1. 它是工业级品质的系统编程语言，却又像脚本语言一样的友好。
2. 它支持playground，允许程序员实验一段Swift代码功能并立即看到结果，而无需麻烦的构建和运行一个应用。
Swift集成了现代编程语言思想，以及Apple工程文化的智慧，编译器是按照性能优化的，而语言是为开发优化的，无需互相折中。

####swift语法
Playground允许你编辑代码并立即看到结果,可以从”Hello, world”开始学起并过渡到整个系统。
在Xcode的playground中打开:
```objc
println("Hello, world")
```

在Swift，这就是完整的程序:
1. 无需导入(import)输入输出和字符串处理的系统库。
2. 全局范围的代码就是用于程序的入口，所以你无需编写一个 main() 函数。也无需在每个语句后写分号。

所有这些使得Swift成为Apple软件开发者创新的源泉。

####简单值  -- 使用 let 来定义常量， var 定义变量
提供一个值就可以创建常量或变量，并让编译器推断其类型,一个常量或变量必须与赋值时拥有相同的类型。因此你不用严格定义类型。
常量定义类似于函数式编程语言中的变量,常量的值无需在编译时指定，但是至少要赋值一次,赋值后就无法修改。
``` swift
var myVariable = 42
myVariable = 50
let myConstant = 42
```
在上面例子中，编译其会推断myVariable是一个整数类型，因为其初始化值就是个整数。

######1. 显示/隐式 初始化数据类型 ---   类型与变量名绑定，属于静态类型语言  
类型与变量名绑定，属于静态类型语言。有助于静态优化。与Python、JavaScript等有所区别。
例如：初始化值没有提供足够的信息(或没有初始化值)，可以在变量名后写类型，以冒号分隔。
```swift
let imlicitInteger = 70
let imlicitDouble = 70.0
let explicitDouble: Double = 70
```
######2. 变量  拼接到字符串  -- 变量值永远不会隐含转换到其他类型
* String(变量名)
```swift
let label = "The width is "
let width = 94
let widthLabel = label + String(width)
```
* 以小括号来写值，并用反斜线(“”)放在小括号之前
```swift
let apples = 3
let oranges = 5     //by gashero
let appleSummary = "I have \(apples) apples."
let fruitSummary = "I have \(apples + oranges) pieces of fruit."
```

####数组和字典的用法
1. 声明并初始化
``` swift
let emptyArray = String[]()
let emptyDictionary = Dictionary<String, Float>()
shoppingList = [] //去购物并买些东西 
```
如果数组类型无法推断，你可以写空的数组为 “[]” 和空的字典为 “[:]“。
2. 访问   
创建一个数组和字典使用方括号 “[]”，访问其元素则是通过方括号中的索引或键。                      
```swift
var shoppingList = ["catfish", "water", "tulips", "blue paint"]
shoppingList[1] = "bottle of water"
var occupations = [
   "Malcolm": "Captain",
   "Kaylee": "Mechanic",
]
occupations["Jayne"] = "Public Relations"
```

####控制流  --  条件控制，循环控制

######1. 条件控制
* if  条件必须是布尔表达式  
 在 if 语句中，条件必须是布尔表达式，这意味着 if score { … } 是错误的，不能隐含的与0比较。
你可以一起使用 if 和 let 来防止值的丢失。这些值是可选的。
可选值可以包含一个值或包含一个 nil 来指定值还不存在。写一个问号 “?” 在类型后表示值是可选的。
```swift
var optionalString: String? = "Hello"
optionalString == nil
var optionalName: String? = "John Appleseed"
var greeting = "Hello!"
if let name = optionalName {
    greeting = "Hello, \(name)"
}
```

* switch 支持多种数据以及多种比较，不限制必须是整数和测试相等  
```swift
let vegetable = "red pepper"
switch vegetable {
case "celery":
    let vegetableComment = "Add some raisins and make ants on a log."
case "cucumber", "watercress":
    let vegetableComment = "That would make a good tea sandwich."
case let x where x.hasSuffix("pepper"):
    let vegetableComment = "Is it a spicy \(x)?"
default:    //by gashero
    let vegetableComment = "Everything tastes good in soup."
}
```
在执行匹配的情况后，程序会从 switch 跳出，而不是继续执行下一个情况。所以不再需要 break 跳出 switch 。
######2. 循环控制
* for-in 来迭代字典中的每个元素  
可使用 for-in 来迭代字典中的每个元素，提供一对名字来使用每个键值对。
```swift
let interestingNumbers = [
    "Prime": [2, 3, 5, 7, 11, 13],
    "Fibonacci": [1, 1, 2, 3, 5, 8],
    "Square": [1, 4, 9, 16, 25],
]
var largest = 0
for (kind, numbers) in interestingNumbers {
    for number in numbers {
        if number > largest {
            largest = number
        }
    }
}
```  
你可以在循环中保持一个索引，通过“..”来表示索引范围或明确声明一个初始值、条件、增量。   
这两个循环做相同的事情:  
```swift
var firstForLoop = 0
for i in 0..3 {
    firstForLoop += i
}
firstForLoop
var secondForLoop = 0
for var i = 0; i < 3; ++i {
    secondForLoop += 1
}
```
使用 .. 构造范围忽略最高值，而用 … 构造的范围则包含两个值。
* while 来重复执行代码块直到条件改变  
使用 while 来重复执行代码块直到条件改变。循环的条件可以放在末尾来确保循环至少执行一次。
```swift
var n = 2
while n < 100 {
    n = n * 2
}
n
var m = 2
do {
    m = m * 2
} while m < 100
m
```