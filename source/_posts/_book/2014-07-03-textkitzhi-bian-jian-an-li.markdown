---
layout: post
title: "TextKit之便笺实战"
date: 2014-07-03 17:29:00 +0800
comments: true
categories: TextKit
---

####TextKit之便笺实战 [Notepad.zip](http://cdn4.raywenderlich.com/wp-content/uploads/2013/09/TextKitNotepad-starter.zip)
* ##### 便笺练习功能点:
通过实现以下特效，练习并掌握布局管理器（layout manger），文本容器（text containers）和文本存储器（text storage）等用法。
  * 动态样式（Dynamic type）  
  * 凸版印刷效果（Letterpress effects）  
  * 环绕路径（Exclusion paths）  
  * 动态文本格式及存储（Dynamic text formatting and storage）  
  
这个应用中我们将实现回流文本，字体大小的动态变换，以及闪回文本等效果。
效果图:  
![image](/images/bianqian.png)  
App开始运行后自动生成一组便笺实例并利用table view controller显示出来。Storyboards和segues会将被选中的单元格所对应的便笺内容显示出来以供用户编辑。

* #####动态样式

动态样式（Dynamic type）是iOS 7里面变化最大的特性之一; 它使得app可以遵从用户选择的字体大小和粗细。
选择 **通用->文字大小** 或 **通用->辅助功能** 来查看app中的字体设置。

![image](/images/UserTextPreferences.png)  
iOS 7 支持通过粗体、设置字体大小等方式提高支持动态文本的应用的易读性。例如:**`UIFont`**新增了一个方法： **`preferredFontForTextStyle`** 用来根据用户对字体大小的设置来自动制定字体样式。  
下面表格中是六种可用字体样式的示例：  
![image](/images/TextStyles.png)  
最左边一列是最小字体；中间一列是最大字体；最右边一列是粗体效果。  

> <font size=3>注：要使用动态文本的话，要给文本字体设置样式而不是制定具体的字体名称和大小。 </font>

   * * ######基本支持
动态文本的基本支持设置还是比较简单明了的。无需指定具体字体名称，只要给出一个字体样式“style”请求，系统会在运行时自动根据这一样式以及用户的字体大小设置来选择使用合适的字体。  <p>
打开 NoteEditorViewController.m 在`viewDidLoad：`方法实现的最后面加入以下代码：
{%codeblock lang:objc%}
self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
{%endcodeblock%}
然后打开 NotesListViewController.m 在 `tableView:cellForRowAtIndexPath:` 方法中增加如下代码:
{%codeblock lang:objc%}
cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
{%endcodeblock%}
上面两行代码都用到了新版iOS的字体样式.
><font size=2 >注: 通过语义法命名字体，例如 `UIFontTextStyleSubHeadline`, 可以避免在代码里每一处都指定具体的字体名称和样式， 而且确保app能对用户的字体大小设置做出恰当的回应。</font>   
  
再次运行App, **Note**页面的文字大小是当前设定的字体大小；前后截屏对比图如下：  
![image](/images/NotepadWithDynamicType.png)  
看上去很不错呢——不过心细的读者可能已经发现，分辨率小了一半。  <p>
**问题**：当我们返回到**通用->文字大小**重新修改字体设置. 再打开**Note**页面, 会发现app并没有**立即**对字体设置的变化做出相应反应。

   * * * ######通过添加通知来通知APP响应用户字体设置的变化
   打开 NoteEditorViewController.m 文件并在`viewDidLoad`方法的实现的最后加入以下代码：
{%codeblock lang:objc%}
[[NSNotificationCenter defaultCenter]
                              addObserver:self
                                 selector:@selector(preferredContentSizeChanged:)
                                     name:UIContentSizeCategoryDidChangeNotification
                                   object:nil];
{%endcodeblock%}
收到用于指定本类接收字体设定变化的通知后，调用`preferredContentSizeChanged:`方法。  <p>
下一步，在NoteEditorViewController.m中`viewDidLoad`方法之后紧接着添加以下方法：
{%codeblock lang:objc%}
- (void)preferredContentSizeChanged:(NSNotification *)notification {
    self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
}
{%endcodeblock%}
这一方法作用是根据新的字体设置来设定textView中的字体。
> <font size=3>注: 当用户修改了他们的字体大小设置之后，这一样式对应的字体并不会自动更新，必须重新请求才能获取新的值。用户设置变化后，`preferredFontForTextStyle:`方法返回的字体也会变化。</font>  

下一步，NotesListViewController.m 在`viewDidLoad` 方法的最后加入以下代码:
{%codeblock lang:objc%}
[[NSNotificationCenter defaultCenter]
                              addObserver:self
                                 selector:@selector(preferredContentSizeChanged:)
                                     name:UIContentSizeCategoryDidChangeNotification
                                   object:nil];
{%endcodeblock%}
使用tableview重新载入各个单元格的`reloadData`方法，来响应字体设置的变化，更新各个单元格的字体。  
在NotesListViewController.m中`viewDidLoad`方法之后添加以下方法：
{%codeblock lang:objc%}
- (void)preferredContentSizeChanged:(NSNotification *)notification {
    [self.tableView reloadData];
}
{%endcodeblock%}  
Build并运行app，修改字体大小设置，Note页面就可以即时更新字体大小了。
<!--more-->

  * * * ######更新布局
  现在，如果你把字体设置到很小，那每个单元格的空白区域是不是太多了，看上去文字比较稀疏，如下面所示：  
  ![image](/images/ChangingLayout.png)  
      
这是**动态样式**有点小复杂的部分：要保证App在字体大小变化后，同时也修改文字表格的行高。  
<p>在NotesListViewController.m中实现`tableView:heightForRowAtIndexPath:` 代理方法:
{%codeblock lang:objc%}
- (CGFloat)tableView:(UITableView *)tableView
        heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    static UILabel* label;
    if (!label) {
        label = [[UILabel alloc]
             initWithFrame:CGRectMake(0, 0, FLT_MAX, FLT_MAX)];
        label.text = @"test";
    }
 
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [label sizeToFit];
    return label.frame.size.height * 1.7;
}
{%endcodeblock%}
以上代码创建了一个共享的——或者说静态的——**UILabel**实例，设定它的字体和表中单元格内文本字体一致。然后调用它的`sizeToFit`方法，使这个label的frame恰好能放得下它的内容文字, 然后把这个label的高度乘个1.7作为表内单元格高度。  
<p>Build并运行app，修改字体大小设置，行高也会随着字体大小的变化而变化。 如下图所示：  
![image](/images/TableViewAdaptsHeights.png)  

* #####凸版印刷效果（Letterpress effects）  
凸版印刷效果（Letterpress effects）给文字加上精致的阴影和高光是文字看上去有一定一体感——就好像轻轻嵌入屏幕里一样。  
> <font size=3>注: 使用“凸版印刷（letterpress）”这一印刷术语是向早期印刷业的致敬。所谓凸版印刷，就是将涂上油墨的图文凸版嵌在印版上，然后在纸面上按压就把图文凸版上的油墨转移到纸面上了——纸面受力在文字边缘形成好看的突起。现在这一工艺已广泛被数码打印所取代。</font>  

打开NotesListViewController.m 将`tableView:cellForRowAtIndexPath: `方法中的代码用以下代码替换:  
{%codeblock lang:objc%}
static NSString *CellIdentifier = @"Cell";
UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier 
                                                        forIndexPath:indexPath];
Note* note = [self notes][indexPath.row];

UIFont* font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];

UIColor* textColor = [UIColor colorWithRed:0.175f green:0.458f blue:0.831f alpha:1.0f];

NSDictionary *attrs = @{ NSForegroundColorAttributeName : textColor,
                                    NSFontAttributeName : font,
                              NSTextEffectAttributeName : NSTextEffectLetterpressStyle};

NSAttributedString* attrString = [[NSAttributedString alloc]
                                       initWithString:note.title
                                           attributes:attrs];
cell.textLabel.attributedText = attrString;
return cell;
{%endcodeblock%}
上面的代码为单元格的标题创建了一个使用了凸版印刷效果的**`NSAttributedString`**。  <p>
Build并运行app， 表格将显示凸版印刷效果，如下图所示：  
![image](/images/Letterpress.png)  
凸版印刷效果是很精巧——但是并不表示你可以随意过度使用它。视觉特效能让文字看上去更有趣，但并不表示一定能让你的文字更清晰易读。

* #####环绕路径（Exclusion paths）
文字环绕图片或其它内容分布是大多数文字处理软件的标准特性之一。`Text Kit`允许你通过环绕路径（`exclusion paths`）将文字按照复杂路径和形状分布。  

**任务需求**:在便笺右上角添加一个曲线形视图，告知用户便笺创建的日期。  
任务分解：  
 * * 首先添加一个视图。  
 * * 再创建一个环绕路径，以使文字按照这个路径分布。 

 * * ######添加视图
打开 NoteEditorViewController.m 在顶部的`imports`部分加入以下代码：
{%codeblock lang:objc%}
#import "TimeIndicatorView.h"
{%endcodeblock%} 
然后，在NoteEditorViewController.m中添加以下变量：
{%codeblock lang:objc%}
@implementation NoteEditorViewController
{
    TimeIndicatorView* _timeView;
}
{%endcodeblock%}
正如其名，这个变量表示的是一个用以显示文本创建日期的子视图。  
在NoteEditorViewController.m的`viewDidLoad`方法的最后添加以下代码：
{%codeblock lang:objc%}
_timeView = [[TimeIndicatorView alloc] initWithDate:_note.timestamp];
[self.view addSubview:_timeView];
{%endcodeblock%}
这一步创建了新的视图实例并把它作为一个子视图添加进去。  
<p>当**NoteEditor**视图的控件调用`viewDidLayoutSubviews`对子视图进行布局时，`TimeIndicatorView`作为子控件也需要有相应的变化。  
在NoteEditorViewController.m 的最后添加如下代码：
{%codeblock lang:objc%}
- (void)viewDidLayoutSubviews {
    [self updateTimeIndicatorFrame];
}
- (void)updateTimeIndicatorFrame {
    [_timeView updateSize];
    _timeView.frame = CGRectOffset(_timeView.frame,
                          self.view.frame.size.width - _timeView.frame.size.width, 0.0);
}
{%endcodeblock%}
`viewDidLayoutSubviews`调用`updateTimeIndicatorFrame`来做两件事：  
  第一调用`updateSize`来设定`_timeView`的尺寸。  
  第二将`_timeView`放在右上角。  
<p>接下来在控件接收到文本内容的尺寸发生了变化的时候调用`updateTimeIndicatorFrame`。  
修改NoteEditorViewController.m中`preferredContentSizeChanged:`方法如下：
{%codeblock lang:objc%}
- (void)preferredContentSizeChanged:(NSNotification *)n {
    self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [self updateTimeIndicatorFrame];
}
{%endcodeblock%}
Build并运行app，点击选择一个便笺，日期显示视图将出现在右上角，如下图所示：  
![image](/images/TimIndicator.png)  
修改设备中文本大小设置，这个视图也将自动调整到相应的合适尺寸。  

**问题:**日期控件周围文字，并没有围绕排布，这正是环绕路径（exclusion paths）将要解决的问题!  

* * ######创建环绕路径
打开 TimeIndicatorView.h 添加如下方法声明：
{%codeblock lang:objc%}
- (UIBezierPath *)curvePathWithOrigin:(CGPoint)origin;
{%endcodeblock%}
这就可以在从视图控件中调用 `curvePathWithOrigin:`以及定义文本所要遵循的环绕路径。 这就是为啥这个方法中会涉及到贝赛尔曲线！  
<p>接下来定义环绕路径本身。  
打开 NoteEditorViewController.m 在`updateTimeIndicatorFrame`方法实现的最后面添加如下代码：
{%codeblock lang:objc%}
UIBezierPath* exclusionPath = [_timeView curvePathWithOrigin:_timeView.center];
_textView.textContainer.exclusionPaths  = @[exclusionPath];
{%endcodeblock%}
上面的代码根据你的日期显示视图创建了一个基于贝赛尔路径的环绕路径。还有相对与文本视图的原点和坐标信息。  
<p>Build并运行app，选择一个便笺项，如下图所示：  
![image](/images/ExclusionPath.png)  
注意:exclusionPaths是NSArray类型，因此一个文本容器是可以支持多个环绕路径的。  
此外，环绕路径的使用既可以更简单也可以很复杂。比如，想要让文字环绕出一个星形或者蝴蝶形状么？只要你能定义出路径，环绕路径功能就能将它实现！  
<p>文本**环绕路径**发生改变后会通知文本管理器，然后**环绕路径**的变化就可以动态地，甚至是动画式地体现到文本上！  

* #####动态文本格式及存储（Dynamic text formatting and storage）
你已经看到了Text Kit可以根据用户设置的字体大小动态地调整字体。
但是如果字体也可以根据实际的文字本身来进行动态更新是不是会更酷呢？  
比方说，你想要你的app可以自动地：  
	* *  把波浪线(~)之间的文本变为艺术字体  
	* *  把下划线(_)之间的文本变为斜体  
	* *  为破折号(-)之间的文本添加删除线  
	* *  把字母全部大写的单词变为红色  
![image](/images/DynamicTextExample.png)  
这些正是你将要在这一部分利用Text Kit framework来实现的效果。  

<p>做这些之前，你要先理解Text Kit中的文本存储系统是如何工作的。这里有张图展示了“Text Kit 堆栈”是如何存储、处理以及显示文本的。  
![image](/images/TextKitStack-443x320.png)  
当你创建`UITextView`, `UILabel` or `UITextField`的时候，Apple在自动在后台帮你创建了这些类。你可以使用这些默认的实现或者是自定义一部分，以便达到想要的效果。

* * * **`NSTextStorage`**: 以`attributedString`的方式存储所要处理的文本并且将文本内容的任何变化都通知给布局管理器。可以自定义`NSTextStorage`的子类，当文本发生变化时，动态地对文本属性做出相应改变。  
* * * **`NSLayoutManager`**: 获取存储的文本并经过修饰处理再显示在屏幕上；在App中扮演着**布局“引擎”**的角色。  
* * * **`NSTextContainer`**: 描述了所要处理的文本在屏幕上的位置信息。每一个文本容器都有一个关联的`UITextView`. 可以创建 `NSTextContainer`的子类来定义**一个复杂的形状**，然后在这个形状内处理文本。  
<p>
* * * ######**在app中实现动态文本格式的步骤:**
    1. 需要创建一个`NSTextStorage`的子类，用以在用户输入文本的时候，动态地添加文本属性。  
    2. 将`UITextView`的默认文本存储器,用自定义的实现替换掉。
<p>
*  ###创建NSTextStorage子类
鼠标右键单击**project navigator**中的**TextKitNotepad**组，选择**New File…**, 然后选择**iOSCocoa TouchObjective-C** 类。将新建的类命名为**`SyntaxHighlightTextStorage`**, 并设为**`NSTextStorage`**的子类。  
<p>打开 **SyntaxHighlightTextStorage.m**并添加实例变量并初始化：
{%codeblock lang:objc%}

#import "SyntaxHighlightTextStorage.h"

@implementation SyntaxHighlightTextStorage
{
    NSMutableAttributedString *	_backingStore;
}

- (id)init
{
    if (self = [super init]) {
        _backingStore = [NSMutableAttributedString new];
    }
    return self;
}
@end
{%endcodeblock%}
要使用**`NSMutableAttributedString`**作为“后台存储” (后面会详细讲解)，文本存储器子类必须提供它自己的“数据持久化层”。  
<p>接下来，还是在这个文件中，添加以下方法：
{%codeblock lang:objc%}
- (NSString *)string
{
    return [_backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location
                     effectiveRange:(NSRangePointer)range
{
    return [_backingStore attributesAtIndex:location
                             effectiveRange:range];
}
{%endcodeblock%}
上面两个方法直接把任务代理给了后台存储。  
<p>最后，还在这个文件中，重载以下方法：
{%codeblock lang:objc%}
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str
{
    NSLog(@"replaceCharactersInRange:%@ withString:%@", NSStringFromRange(range), str);

    [self beginEditing];
    [_backingStore replaceCharactersInRange:range withString:str];
    [self  edited:NSTextStorageEditedCharacters | NSTextStorageEditedAttributes
              range:range
     changeInLength:str.length - range.length];
    [self endEditing];
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    NSLog(@"setAttributes:%@ range:%@", attrs, NSStringFromRange(range));

    [self beginEditing];
    [_backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}
{%endcodeblock%}
同样的，这些方法也是把任务代理给后台存储。不过，它们也调用`beginEditing` / `edited` / `endEditing`这些方法来完成一些编辑任务。这样做是为了在编辑发生后让文本存储器的类通知相关的布局管理器。  
<p>你可能注意到了你需要很多代码来创建文本存储器的类的子类。既然`NSTextStorage`是一个类族的公共接口，那就不能只是通过创建子类及重载几个方法来扩张它的功能。有些特定需求你是要自己实现的，比方`attributedString`数据的后台存储。
><font size=3>注: 类族是Apple的framework中广泛用到的一种设计模式。  
>>类族就是抽象工厂模式的实现，无需指定具体的类就可以为创建一族相关或从属的对象提供一个公共接口。一些我们很熟悉的类比方NSArray和NSNumber事实上是一族类的公共接口。  
>>>Apple使用类族来封装同一个公共抽象超类下的私有具体子类，抽象超类声明了客户创建私有子类的实例时必须要用到的方法。客户是完全无法知道工厂正在用哪一个私有类，它只和公共接口相互协作。  
>>>>使用类族当然可以简化接口，使学习和使用类更加容易，但是必须要需要指出的是要在功能扩展和接口简化之间达到平衡。创建一个类族的抽象超类的定制子类也常常是非常难的。</font> 

现在有了一个自定义的`NSTextStorage`，还需创建一个`UITextView`来使用它。  

* ###使用自定义Text Kit堆栈创建UITextView
从**storyboard**编辑器实例化`UITextView`会自动创建**`NSTextStorage`**, **`NSLayoutManager`**和**`NSTextContainer`** (例如**Text Kit**堆栈)实例以及所有的这三个只读属性。  
<p>虽然没有办法从**storyboard**编辑器中改变这种设定，但可以手动编程创建`UITextView`和**Text Kit**堆栈。  
具体步骤如下: 
* * 删除IB相关的设置:<p> 
* * * 在IB中打开**Main.storyboard** 找到**NoteEditorViewController**。 删除`UITextView`实例。
然后，打开**NoteEditorViewController.m**删除**UITextView outlet**。<p>
* * * 在**NoteEditorViewController.m**最上面，添加下面一行代码:
{%codeblock lang:objc%}
#import "SyntaxHighlightTextStorage.h"
{%endcodeblock%}
在NoteEditorViewController.m:中`TimeIndicatorView`实例变量后面紧接着添加以下代码：
{%codeblock lang:objc%}
SyntaxHighlightTextStorage* _textStorage;
UITextView* _textView;
{%endcodeblock%}
文本存储器子类有两个实例变量，还有一个文本视图稍后需要添加。  

* * * 然后从NoteEditorViewController.m的`viewDidLoad` 方法中删除以下代码：
{%codeblock lang:objc%}
self.textView.text = self.note.contents;
self.textView.delegate = self;
self.textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
{%endcodeblock%}
既然不再为文本视图使用IBOutlet，而是要编程添加，所以也就不需要这些代码了。  

* * 手动创建`UITextView`和Text Kit堆栈:<p>
* * * 在NoteEditorViewController.m中，添加下面方法：
{%codeblock lang:objc%}
- (void)createTextView
{
    // 1. Create the text storage that backs the editor
    NSDictionary* attrs = @{NSFontAttributeName:
        [UIFont preferredFontForTextStyle:UIFontTextStyleBody]};
    NSAttributedString* attrString = [[NSAttributedString alloc]
                                   initWithString:_note.contents
                                       attributes:attrs];
    _textStorage = [SyntaxHighlightTextStorage new];
    [_textStorage appendAttributedString:attrString];

    CGRect newTextViewRect = self.view.bounds;

    // 2. Create the layout manager
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];

    // 3. Create a text container
    CGSize containerSize = CGSizeMake(newTextViewRect.size.width,  CGFLOAT_MAX);
    NSTextContainer *container = [[NSTextContainer alloc] initWithSize:containerSize];
    container.widthTracksTextView = YES;
    [layoutManager addTextContainer:container];
    [_textStorage addLayoutManager:layoutManager];

    // 4. Create a UITextView
    _textView = [[UITextView alloc] initWithFrame:newTextViewRect
                                    textContainer:container];
    _textView.delegate = self;
    [self.view addSubview:_textView];
}
{%endcodeblock%}
这段代码有点多，我们一步一步来看：  
* * * * 创建一个你自定义的`NSTextStorage`的实例以及一个用来承载便笺内容的`NSAttributedString`  
* * * * 创建一个布局管理器。  
* * * * 创建一个文本容器，把它和布局管理器联系起来。然后把布局管理器和文本存储器联系起来。  
* * * * 最后用你自定义的文本容器和代理组创建实际的文本视图，  并把文本视图添加为子视图。  
现在回顾之前那个图表所展示的四个关键类(文本存储器`storage`, 布局管理器`layout manager`, 文本容器`container` 和文本视图`textView`)之间的关系，是不是觉得理解起来容易多了。  
![image](/images/TextKitStack-443x320.png)  
><font size=3>注意:文本容器的宽度会自动匹配视图的宽度，但是它的高度是无限高的——或者说无限接近于`CGFLOAT_MAX`，它的值可以是无限大。不管怎么说，它的高度足够让`UITextView`上下滚动以容纳很长的文本。</font>    

在`viewDidLoad`方法中调用超类的`viewDidLoad`方法的语句后面添加以下一行代码：
{%codeblock lang:objc%}
[self createTextView];
{%endcodeblock%}
然后修改`preferredContentSizeChanged`的第一行代码为：
{%codeblock lang:objc%}
_textView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
{%endcodeblock%}
用新的实例变量来替换掉旧的outlet属性。 <p> 
最后，编程创建的自定义视图是不会自动继承storyboard中的布局约束组的规则的。所以，设备方向变化后，视图的边界是不会自动随之改变的，你得自己编程设定视图边界。  

可以在`viewDidLayoutSubviews`方法的最后添加以下代码来实现：
{%codeblock lang:objc%}
_textView.frame = self.view.bounds;
{%endcodeblock%}
<p>Build并运行app，打开一个便笺项，在Xcode控制台上有`SyntaxHighlightTextStorage`生成的运行日志，用来告诉你这些文本处理的代码确实被调用。  
如下图：  
![image](/images/LogMessages-480x266.png)<p>
看来你的文本解析器的基础非常可靠了 —— 那现在来添加动态格式。
#动态格式（Dynamic formatting）
接下来将对你的自定义文本存储器进行修改以将＊星号符之间的文本＊变为黑体：

打开**SyntaxHighlightTextStorage.m** 添加以下方法：
{%codeblock lang:objc%}
-(void)processEditing
{
    [self performReplacementsForRange:[self editedRange]];
    [super processEditing];
}
{%endcodeblock%}
`processEditing` 将文本的变化通知给布局管理器。它也为文本编辑之后的处理提供便利。
<p>在 `processEditing`方法之后紧接着添加以下代码：
{%codeblock lang:objc%}
- (void)performReplacementsForRange:(NSRange)changedRange
{
    NSRange extendedRange = NSUnionRange(changedRange, [[_backingStore string]
                             lineRangeForRange:NSMakeRange(changedRange.location, 0)]);
    extendedRange = NSUnionRange(changedRange, [[_backingStore string] 
                          lineRangeForRange:NSMakeRange(NSMaxRange(changedRange), 0)]);
    [self applyStylesToRange:extendedRange];
}
{%endcodeblock%}
上面的代码拓展了受黑体格式类型影响的文本范围。因为`changedRange`一般只是作用到单独的一个字符； 而`lineRangeForRange` 则扩展到一整行。<p>
在 `performReplacementsForRange`方法之后紧接着添加以下代码：
{%codeblock lang:objc%}
- (void)applyStylesToRange:(NSRange)searchRange
{
    // 1. create some fonts
    UIFontDescriptor* fontDescriptor = [UIFontDescriptor
                             preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    UIFontDescriptor* boldFontDescriptor = [fontDescriptor
                           fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold];
    UIFont* boldFont =  [UIFont fontWithDescriptor:boldFontDescriptor size: 0.0];
    UIFont* normalFont =  [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

    // 2. match items surrounded by asterisks
    NSString* regexStr = @"(*w+(sw+)**)s";
    NSRegularExpression* regex = [NSRegularExpression
                                   regularExpressionWithPattern:regexStr
                                                        options:0
                                                          error:nil];

    NSDictionary* boldAttributes = @{ NSFontAttributeName : boldFont };
    NSDictionary* normalAttributes = @{ NSFontAttributeName : normalFont };

    // 3. iterate over each match, making the text bold
    [regex enumerateMatchesInString:[_backingStore string]
              options:0
                range:searchRange
           usingBlock:^(NSTextCheckingResult *match,
                        NSMatchingFlags flags,
                        BOOL *stop){

        NSRange matchRange = [match rangeAtIndex:1];
        [self addAttributes:boldAttributes range:matchRange];

        // 4. reset the style to the original
        if (NSMaxRange(matchRange)+1 < self.length) {
            [self addAttributes:normalAttributes
                range:NSMakeRange(NSMaxRange(matchRange)+1, 1)];
        }
    }];
}
{%endcodeblock%}
上面的代码有以下作用：  

  1. 创建一个粗体及一个正常字体并使用字体描述器（**Font descriptors**）来格式化文本。字体描述器能使你无需对字体手动编码来设置字体和样式。  
  2. 创建一个正则表达式来定位星号符包围的文本。例如，在字符串“iOS 7 is \*awesome\*”中，存储在regExStr中的正则表达式将会匹配并返回文本“\*awesome\*”。
  3. 对正则表达式匹配到并返回的文本进行枚举并添加粗体属性。  

将后一个星号符之后的文本都重置为“常规”样式。以保证添加在后一个星号符之后的文本不被粗体风格所影响。
> <font size=3>注： 字体描述器（**Font descriptors**）是一种描述性语言，它使你可以通过设置属性来修改字体，或者无需初始化`UIFont`实例便可获取字体规格的细节。</font>    

Build并运行app；向便笺中输入文本，并将其中一个词用星号符包围。这个词将会自动变为黑体，如下面截图所示：  
![image](/images/BoldText.png)  

##进一步添加样式
为限定文本添加风格的基本原则很简单：**使用正则表达式来寻找和替换限定字符，然后用applyStylesToRange来设置想要的文本样式即可。**  
在SyntaxHighlightTextStorage.m中添加以下实例变量：
{%codeblock lang:objc%}
- (void) createHighlightPatterns {
    UIFontDescriptor *scriptFontDescriptor =
      [UIFontDescriptor fontDescriptorWithFontAttributes:
          @{UIFontDescriptorFamilyAttribute: @"Zapfino"}];

    // 1. base our script font on the preferred body font size
    UIFontDescriptor* bodyFontDescriptor = [UIFontDescriptor
      preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];
    NSNumber* bodyFontSize = bodyFontDescriptor.
                  fontAttributes[UIFontDescriptorSizeAttribute];
    UIFont* scriptFont = [UIFont
              fontWithDescriptor:scriptFontDescriptor size:[bodyFontSize floatValue]];

    // 2. create the attributes
    NSDictionary* boldAttributes = [self
     createAttributesForFontStyle:UIFontTextStyleBody
                        withTrait:UIFontDescriptorTraitBold];
    NSDictionary* italicAttributes = [self
     createAttributesForFontStyle:UIFontTextStyleBody
                        withTrait:UIFontDescriptorTraitItalic];
    NSDictionary* strikeThroughAttributes = @{ NSStrikethroughStyleAttributeName : @1};
    NSDictionary* scriptAttributes = @{ NSFontAttributeName : scriptFont};
    NSDictionary* redTextAttributes =
                          @{ NSForegroundColorAttributeName : [UIColor redColor]};

    // construct a dictionary of replacements based on regexes
    _replacements = @{
              @"(\*w+(sw+)\*\*)s" : boldAttributes,
              @"(_w+(sw+)\*_)s" : italicAttributes,
              @"([0-9]+.)s" : boldAttributes,
              @"(-w+(sw+)\*-)s" : strikeThroughAttributes,
              @"(~w+(sw+)\*~)s" : scriptAttributes,
              @"s([A-Z]{2,})s" : redTextAttributes};
}
{%endcodeblock%}
  
这个方法的作用：

   1. 首先，它使用Zapfino字体来创建了“`script`”风格。**Font descriptors**会决定当前正文的首选字体，以保证`script`不会影响到用户的字体大小设置。  
   2. 然后，它会为每种匹配的字体样式构造各个属性。你稍后将用到 **`createAttributesForFontStyle:withTrait:`**。
   3. 最后，它将创建一个`NSDictionary`并将正则表达式映射到上面声明的属性上。

如果你对正则表达式不是非常熟悉，上面的的dictionary对你来说可能很陌生。但是，如果你一点一点仔细分析它其中包含的正则表达式，其实不用很费力就能理解了。  

以上面实现的第一个正则表达式为例，它的工作是匹配星号符包围的文本：  
(\*w+(sw+)\*\*)s  
上面两个两个相连的斜杠，其中一个是用来将Objective-C中的特殊字符转义成实体字符。去掉用来转义的斜杠，来看下这个正则表达式的核心部分：  
(\*w+(sw+)\*\*)s  
现在，逐步来分析这个正则表达式：  
{%codeblock lang:js%}
(*	 	 	  ——  匹配星号符  
w+   	 	 —— 后接一个或多个 “word”式 字符串  
(sw+)*	   —— 后接零个或多组空格然后再接 “word” 式字符串  
*)   	  —— 后接星号符  
s   	  —— 以空格结尾  
{%endcodeblock%}
> <font size=3>注：如果你想对正则表达式有更多了解，请参考 [NSRegularExpression tutorial and cheat sheet](http://www.raywenderlich.com/30288/nsregularexpression-tutorial-and-cheat-sheet).</font>  

现在你需要调用`createHighlightPatterns：`
将**SyntaxHighlightTextStorage.m** 中的`init`方法更新如下：
{%codeblock lang:objc%}
- (id)init
{
    if (self = [super init]) {
        _backingStore = [NSMutableAttributedString new];
        [self createHighlightPatterns];
    }
    return self;
}
{%endcodeblock%}

在SyntaxHighlightTextStorage.m方法中添加以下代码：
{%codeblock lang:objc%}
- (NSDictionary*)createAttributesForFontStyle:(NSString*)style
                                    withTrait:(uint32_t)trait {
    UIFontDescriptor *fontDescriptor = [UIFontDescriptor
                               preferredFontDescriptorWithTextStyle:UIFontTextStyleBody];

    UIFontDescriptor *descriptorWithTrait = [fontDescriptor
                                    fontDescriptorWithSymbolicTraits:trait];

    UIFont* font =  [UIFont fontWithDescriptor:descriptorWithTrait size: 0.0];
    return @{ NSFontAttributeName : font };
}
{%endcodeblock%}

上面的代码作用是将提供的字体样式作用到正文字体上。它给`fontWithDescriptor:size:` 提供的`size`值为0，这样做会迫使`UIFont`返回用户设置的字体大小。