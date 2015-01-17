---
layout: post
title: "Xcode HeaderDoc 教程"
date: 2014-08-28 15:18:41 +0800
comments: true
categories:
---
HeaderDoc 是在Xcode 5 和 iOS7 发布时，新增的一个命令行工具，功能：可以从代码中自动生成格式良好的HTML文档——当然，必须依赖于特定格式的注释来完成的。

另外，Xcode 还会在 quick look 面板中以**HeaderDoc**风格显示你的注释。

通过本教程，将学习如下几点：

* 如何书写 HeaderDoc 风格的注释
* 分如何在 Xcode 中预览文档
* 如何生成 HTML 文档
* 如何使用 VVDocumenter-Xcode(一个易于使用的第3方文档制作工具)

####准备工作
下载本教程中用到的 [示例项目](http://cdn2.raywenderlich.com/wp-content/uploads/2014/03/DocumentationExamples_Starter.zip)

这个简单的示例程序只包含了两个类：

* Car: 包含几个属性及一个 “drive” 方法以及一个 completion 块。
* MathAPI: 包含了1个方法，用于累加两个数。
现在，这两个类还没有任何注释。以便演示如何通过 **HeaderDoc** 为这两个类创建文档。

####HeaderDoc 注释

**HeaderDoc** 可以从命令行中运行，也可以通过 Xcode 运行。它扫描文件中以某种格式书写的注释,包括这3种形式：
这3中语法在 Xcode 中产生同样效果的文档

	注释 1. 一般用于单行注释
		/// Your documentation comment will go here
	注释 2.
		/**  * Your documentation comment will go here  */
	注释 3: 一般用于较长的注释块
		/*!  * Your documentation comment will go here  */

	注意：在注释2和注释3中，在每一行开头都会有一个额外的*，直至结尾的 */。这仅仅是为了美观，而不是必须的。
####HeaderDoc 标签

当 **HeaderDoc** 发现上述3种注释，它就开始寻找其中的**HeaderDoc 标签**。**HeaderDoc 标签** 用来修饰**HeaderDoc 注释**。

**HeaderDoc 标签**以 **@** 符号开头，然后是关键字，然后是一个空格，最后才是相应的文本（例如 @param foo）。
HeaderDoc 标签可以分为两种：

1. 顶级标签: 这些标签声明所要注释的对象的类型（例如头部声明、类、方法等等）。
   * 顶级标签，例如 @typedef，用于表示 **typedef** 定义的类型，比如枚举、结构体和函数指针。
   * **HeaderDoc** 能够根据上下文自动产生顶级标签，因此通常不是必须的。

2. 二级标签:这些标签才是具体的注释内容。
   * @brief: 简单描述你准备文档化的数据的类型，方法等等。
   * @abstract: 等于 @brief。
	* @discussion: 类似 @abstract 和 @brief，但允许多行。它不是必须的，仅仅是为了使描述更清晰。
	* @param: 描述方法、回调或函数的参数名称。
	* @return: 描述方法或函数的返回值。（等同于 @result）

<!-- More -->

####具体实现
 * ######属性的文档化
用 Xcode 打开**DocumentationExamples** 项目, 打开**ViewController.h**,
在** car **属性的前面，加入一行注释:

		/*!  * @brief The ViewController class' car object.  */

		@property (nonatomic) Car *car;

编译项目。编译结束，按住 alt/option 键，点击**car** 变量名。你将看到**pop菜单**中显示了刚才的注释内容。
 ![image](/images/car.jpg)
另一种方法:切换到Utitlities 面板的**Quick Help** 检查器窗口。点击 **car** 变量名，通过**Quick Help**,你将看到如下效果：
 ![image](/images/carquickhelp.jpg)

 * ######方法的文档化

 **MathAPI**包含一个方法需要文档化。打开**MathAPI.h**,找到`addNumber:toNumber:`。

这个方法有两个参数及一个返回值。因此需要一个 @description 标签、两个@param标签，以及一个@return 标签，如下面所示：


	/*!  * @discussion A really simple way to calculate the sum of two numbers.

     	 * @param firstNumber An NSInteger to be used in the summation of two numbers

     	 * @param secondNumber The second half of the equation.

      	 * @return The sum of the two numbers passed in.

	*/

	+ (NSInteger)addNumber:(NSInteger)firstNumber toNumber:(NSInteger)secondNumber;


编译，再 **alt + 左键**：
 ![image](/images/method.jpg)

 问题: 在 Xcode 文本编辑窗口，很多地方都支持 **alt+左键**。请确保你点击在正确的地方。在上面的例子里，你应当在addNumber: 和 toNumber: 两处使用 alt+左键。

你也许不知道，这个方法的实现真的很恶心。它只能使用非负数作为参数。为了让用户明白这一点，你应当在注释中添加更多的说明。因此，我们可以在 @return 前面加入一个 @warning 标签。

	* @warning Please make note that this method is only good for adding non-negative numbers.

编译项目，然后使用 alt+左键。我们添加的 @warning 标签效果如下：
 ![image](/images/warning.jpg)

#### Code Snippets，让一切变得更简单:
一个**snippet** 是一个可以重用的代码块（存储在 snippet 库中）。**Snippets** 甚至可以包含一些需要你去填充的占位符。
这意味着, 可以用 **snipppet**来进行文档化。

在 **MathAPI.h** 中，在原有的注释上面加入以下内容：

	/*!  * @discussion <#description#>

	     * @param <#param description#>

	     * @return <#return description#>
	*/
 注意，当粘贴上述代码时，“<# #>”之间的内容会变成一个**token**,意味着可以通过 **tab 键**在 **token** 之间来回切换。就像编写代码时的自动完成功能。
 ![image](/images/token.png)

######学习使用Code Snippets工具
 打开 **Utilities 面板**中的 **CodeSnippets Library 检查器**窗口，选中上述注释块，将它拖到该检查器窗口中（从某个 token 例如<#description#>开始拖）:
 ![image](/images/codesnippet.jpg)
 将会弹出一个编辑窗口让输入 snippet 的某些信息，并以此来创建一个**自动完成快捷方式**。要修改某个**snippet**时,直接点击 **Code Snippet Library** 中的 snippet，然后点 Edit 按钮。按照如下形式填写：
 ![image](/images/snippetwindow.jpg)

要想让 **snippet** 生效，首先删除原有注释，然后将鼠标放到addNumber:toNumber: 方法的 + 号前面,输入**doccomment**，然后回车，该**snippet** 将自动生成。然后，通过 Tab 键在3个 token 间移动，并填充它们。最终完成的文档化结果如下:

	/*!  * @discussion A really simple way to calculate the sum of two numbers.

		 * @param firstNumber An NSInteger to be used in the summation of two numbers.

		 * @param secondNumber The second half of the equation.

		 * @warning Please make note that this method is only good for adding non-negative numbers.

	     * @return The sum of the two numbers passed in.
	*/
**@param 标签**和 **@warning 标签**需要手动书写。

####Typedefs的文档化
 打开 Car.h，在 class 之,有一个NS_ENUM，即 typedef enum，一个块，几个属性，一个空方法等，需要文档化。

还记得 @typedef 标签吗？
这个顶级标签稍微特殊一点。它可以对**typedef enum** 或者 **typedef struct** 的类型进行注释。
根据注释的对象的不同，它会包含与定义的类型相关的二级标签。

以 enum 为例，它会包含 @constant 标签，用于每个常量（对于struct，则会是 @field 标签）。

找到 **enum OldCarType**。它包含两个常量，是用于古典汽车的。在**typedef** 声明之上，将原来的注释替换为：

	/*!  * @typedef OldCarType

		 * @brief A list of older car types.

		 * @constant OldCarTypeModelT A cool old car.

		 * @constant OldCarTypeModelA A sophisticated old car.
	*/

	typedef enum {
			/// A cool, old car.

     		OldCarTypeModelT,

    		/// A sophisticated older car.

    		OldCarTypeModelA

	} OldCarType;

 编译，然后在 **OldCarType** 或上**OldCarTypeModelT**使用**alt + 左键**。

在这个类中只有一个 **NS_ENUM**，因此接下来进行进行文档化。常量已经注释了，只要对整个**NS_ENUM** 进行一个总体的注释就可以了。

	/*!  * @typedefCarType

		 * @brief Alist of newer car types.

		 * @constantCarTypeHatchback Hatchbacks are fun, but small.

		 * @constantCarTypeSedan Sedans should have enough room to put your kids, and your golfclubs

		 * @constantCarTypeEstate Estate cars should hold your kids, groceries, sport equipment,etc.

		 * @constantCarTypeSport Sport cars should be fast, fun, and hard on the back.
	*/

注意:这个enum 是通过宏来声明的，悲催的 Xcode 不能完全支持和 **typedef enum** 一样的文档特性，虽然**NS_ENUM** 实际上是声明 enums 的推荐的方法。


####typedef block 文档化

	/*!  * @brief A block that makes the car drive.
		 * @param distance The distance is equal to a distance driven when the block is ready to execute. It could be miles, or kilometers, but not both. Just pick one and stick with it. ;]
	*/

	typedef void(^driveCompletion)(CGFloat distance);

**typedef block** 的文档化和之前的并无多少不同，它包含了：

* 一个 @brief 标签，简单说明了一下这个块的作用。
* 一个 @param 标签，说明调用块时需要传递的参数。


####添加格式化代码到文档中

例如，Car 类的 **driveCarWithComplete:** 方法。

这个方法以块作为参数，因为块对于新手来说一般比较困难，因此最好是告诉程序员如何使用这个方法。

这需要使用 **@code 标签**。在 **driveCarWithCompletion**方法声明之前添加如下内容：

	/*!  * @brief The car will drive, and then execute the drive block

		 * @param completion A driveCompletion block

		 * @code [car driveCarWithCompletion:^(CGFloat distance){

		 					   NSLog(@"Distance driven %f", distance);

		 					}];
	*/

编译，在方法名上使用**alt+左键**。如下图所示：
 ![image](/images/driveCar.jpg)

####检查文档
学会了如何添加注释，如果 **Xcode** 能帮你检查你的工作，就像Xcode会自动检查代码中的语法错误，那岂不是更好？有一个好消息，Clang 有一个标志，叫做“**CLANG_WARN_DOCUMENTATION_COMMENTS**”,可以用于检查 **HeaderDoc** 格式的注释。

打开 **DocumentationExamples**的项目设置，点击 **Build Settings**，找到 **DocumentationComments**, 将值设置为 **YES**。
![image](/images/buildsetting.jpg)
如下，打开 **MathAPI.h**，将第一个 @param 标签的参数名由**firstNumber** 修改为 **thirdNumber**,然后编译。
有一个警告发生，甚至提出了修改建议。它不会影响任何事情，但有助于检查文档中的错误。
 ![image](/images/RW_Documentation_WarningEx.png)
####特殊注释

**Xcode** 还支持几种特殊注释，对于你或者使用你代码的人非常有用。

打开 Car.m，在 **driveCarWithCompletion:** 方法中，在调用**completion** 块之前添加下列注释：

	// FIXME: This is broken

	// !!!: Holy cow, it should be checked!

	// ???: Perhaps check if the block is not nil first?

这里出现了3中注释：

* FIXME: 某个地方需要修正
* !!!: 某个地方需要注意。
* ???: 代码中有问题，或者代码是可疑的。

这些注释不但有助于浏览代码，而且 Xcode 绘制 **Jump Bar** 中显示它们。点击**Jump Bar**，如下图所示：

![image](/images/RW_Documentation_JumpBar-700x151.png)


 你将看到这3个注释以粗体显示：

 ![image](/images/RW_Documentation_JumpBarSelect-700x287.png)

 到此，你已经完全掌握了如何对项目进行文档化。花一些时间对项目的其他属性和方法操作一番，并加入一些自己的东西。看看在注释块中改变一些东西或者删除某个标签会发生什么。这将让你明白注释格式如何对文档造成影响的。

#用headerdoc2html 创建 HTML文档
文档化是由一个 **HeaderDoc 工具**完成的。当 Xcode 安装时，它就已经安装好了。
它除了解释已添加的注释，显示一个弹出菜单以及将注释在**Quick Help** 中显示之外，还可以在文档化之后创建 HTML、XML 以及联机帮助手册。

本节介绍 HTML 文件的制作。如果你对用 HeaderDoc 如何创建在线文档感兴趣，请参考[HeaderDoc 用户指南](https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/HeaderDoc/usage/usage.html).

打开终端，转到 DocumentationExamples 项目目录：


		cd /path/to/your/folder

		确保该路径下包含了 Xcodeproject  文件(“DocumentationExamples.xcodeproj”)。



然后用下列命令创建 HTML 文档：

		headerdoc2html -o ~/Desktop/documentation DocumentationExamples/

此时终端会有许多输出。当创建完毕，返回桌面，出现一个名为documentation 的目录。双击打开，找到 Car_h 目录，打开 index.html：
![image](/images/Screen-Shot-2014-04-05-at-5.58.18-PM.png)

**headerdoc2html 脚本**有两个参数：

So what justhappened? Well, you ran the headerdoc2htmlscript with 2 options:

* -o ~/Desktop/documentation – 这个参数指定输出的 Html 文件路径——即桌面的 documentation 目录。
* DocumentationExamples/ – 该参数指定要解析的源文件位于 DocumentationExamples 目录（不包含项目目录下的其他目录，因为它们并不包含源代码）

问题:

1. 最新版本**headerdoc2html**有个问题，用 google chrome打开 index.html后，左边的目录显示不正常，但 Safari打开正常。
2. 最新版本的**headerdoc2html** 不能正确解析 /// 类的注释，可以使用 /*! 类型的注释代替。

这很酷，但还可以更进一步。除了手动进入到输出目录中进行导航，**HeaderDoc**还会创建一个主目录索引。
返回终端，导航至新建的 **documentation** 目录，输入：

	cd ~/Desktop/documentation

然后输入命令，创建内容索引:

	gatherheaderdoc .

**gatherheaderdoc**自动查找目录，为 **.** 目录（表示当前目录）创建索引。
用 Finder 打开 documentation  目录。你会发现多出一个 **masterTOC.html** 文件。打开它，它将列出所有已文档化的属性、方法、枚举和块的链接。
![image](/images/Screen-Shot-2014-04-05-at-6.01.35-PM.png)
你可以将所有 HTML 文件放到 web 服务器上，然后所有人都可以访问你的文档！

#VVDocumenter-Xcode

最后的内容是 **VVDocumenter-Xcode**，一个第三方 Xcode插件，它能让你的文档化工作简单至比使用早先介绍的 **Code Snippet** 更容易。

首先，从 [Github](https://github.com/onevcat/VVDocumenter-Xcode) 下载插件。

你所需要做的全部工作就是打开项目，然后 **Build**。它会将插件自动安装到~/Library/ApplicationSupport/Developer/Shared/Xcode/Plug-ins 目录。

然后重启 Xcode。再次打开 DocumentationExamples项目。在 MathAPI.h，删除 **`addNumber:toNumber`** 方法的注释块，然后在方法声明上面输入：

	///

**VVDocumenter-Xcode** 将自动创建注释块，包括所有必要的 **@param** 标签以及自动完成 **token**。
![image](/images/RW_Documentation_VVDocumentor-700x184.png)

打开 Car.h，删除 **NS_ENUM CarType** 的注释，以及每个常量的注释。在**NS_ENUM** 声明之上，输入：

	///

这回，它会在 enum 之上创建 **discussion** 标签，甚至还每个常量上面放入了必要的注释！

**VVDocumenter-Xcode** 使你的生活更加轻松。如果你想定制**VVDocumenter-Xcode**，在Xcode中，使用 **Window>VVDocumenter菜单**。
![image](/images/VW_Documentation_VVDocPrefs-700x410.png)

这里，你可以改变自动完成关键字、注释风格以及其他。你想怎样定制 VVDocumenter-Xcode都行。VVDocumenter-Xcode 为我省下了大量的时间！
接下来做什么？

最终完成的示例项目在 这里[下载](http://cdn2.raywenderlich.com/wp-content/uploads/2014/03/DocumentationExamples_Final.zip)。

在你自己的代码中进行文档化。尝试自己编写 **code snippet** 并使用**VVDocumentor**。


