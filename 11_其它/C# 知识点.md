## C# 知识点



### 打开工具箱 Ctrl + Alt + X

### 控件介绍

**标准类型控件**

```python
Button是按钮控件，可以插入一个按钮。
Calendar是日历控件，控件中显示具体的年月日。
CheckBox就是复选框控件，可以插入一个带复选框的对象。
CheckBoxList是多选的复选框组，可以同时在网页中插入带有多个复选框的组合。
DropDownList是下拉列表框，该控件可以插入一个下拉列表框，用户可以选择设置的选项。
FileUpload是上传文件控件，通过该控件可以实现向指定目录上传文件。
Label是标签控件，可以在网页中插入一个标签，用以标识不同的对象。
RadioButton是单选框控件，用它可以直接制作单选按钮。

DataGrid 控件 ：显示数据集中的表格数据，并允许对数据源进行更新。
DataGridView 控件 ：为显示和编辑表格数据提供了灵活、可扩展的系统。
对话框控件和组件（Windows 窗体） ：描述一组控件，这些控件允许用户执行与应用程序或系统的标准交互操作。
FlowLayoutPanel 控件（Windows 窗体） ：表示一个沿水平或垂直方向动态排放其内容的面板。
HScrollBar 和 VScrollBar 控件（Windows 窗体） ：通过在应用程序或控件中水平或垂直滚动，提供在项列表或大量信息中导航的功能。
ImageList 组件（Windows 窗体） ：在其他控件上显示图像。
PictureBox 控件（Windows 窗体） ：以位图、GIF、JPEG、图元文件或图标格式显示图形。
ProgressBar 控件（Windows 窗体） ：以图形方式指示操作的完成进度。
SaveFileDialog 组件（Windows 窗体） ：选择要保存的文件和该文件的保存位置。
SplitContainer 控件（Windows 窗体） ：允许用户调整停靠控件的大小。
Splitter 控件（Windows 窗体） ：允许用户调整已停靠的控件的大小
TabControl 控件（Windows 窗体） 显示多个可以包含图片或其他控件的选项卡。
TableLayoutPanel 控件（Windows 窗体） ：表示一个面板，它可以在一个由行和列组成的网格中对其内容进行动态布局。
```

控件: Button是按钮控件  	DataGrid显示和编辑表格数据 	 ImageList在其他控件上显示图像。

TabControl 控件（Windows 窗体） 显示多个可以包含图片或其他控件的选项卡。

![image-20220223141740339](C:\Users\cuite\Documents\GitHub\NoteBook_Markdown\images\image-20220223141740339.png)

**常用控件的基本属性**

```python
Name：代码中用来标示该控件，对该控件的称呼，命名应该通俗易懂,大小写规范。
AutoSize：控件大小调整，选中该属性时，窗体大小改变也会使控件按照对应比例变化。
AutoScroll：滚动条设置。
Anchor：控件与装载容器边缘绑定效果，容器发生变化时，按照设置随之变化。
BackColor：控件背景色。
BorderStyle：控件边框样式。
ControlBox：是否显示菜单栏。
Cursor：鼠标移动到该控件时光标变化。
ContextMenuStrip：与控件MenuStrip对应属性，在该控件右击鼠标显示已编辑快键菜单。
Displaystyle：控件的呈现方式，以哪种格式出现在容器中。
DoubleBuffered：双缓冲处理，应用双缓冲技术消除抖动时选中。
Dock：控件边缘绑定，选中后控件占据容器的整个选中方向。
DropDownIter：与ToolStrip控件绑定属性，设置列表菜单等。
Enabled：控件是否启用。
Font：控件内文本样式，与FontDialog同样效果，涉及字体样式，大小，下划线等。
ForeColor：控件中文本或图形颜色，也称前景色。
FormBorderStyle：窗体外观和行为。
Image：导入到控件的图像。
ImageAlign：导入图像在控件中的对齐方式。
Icon：窗体图标，也就是我们看到的软件快捷方式图标。
MainMenuTrip：与MenuStrip控件对应的属性。
MaximizeBox（MinimizeBox）：是否显示窗体右上角最大化（最小化）按键。
Node（Item）：控件内容编辑。
Opacity：控件透明度。
StartPosition：窗体加载完毕第一次出现在屏幕上的位置。
Text：控件上的文本。
TextAlign：控件上文本的对齐方式。
TopMost：窗体固定状态，选中时始终位于其他窗体上方。
UseMnemonic：选中后启用快捷键。
Visible：控件的可见性。
WindowState：初始化状态，规定大小或最大化（最小化）。
```

### c#中如何定义空数组

```C#
yLength = 10;
double[] z = new double[yLength];
```

### double转int

```C#
double转int
 
一、 Convert.ToInt32和int强制转换
static void Main(string[] args)
{  
   double dbTmp = 234.44;
   int iTmp = Convert.ToInt32(dbTmp);
   int iTmp1 = (int)dbTmp;
   Console.WriteLine(iTmp1.ToString());
   Console.Read();
}
答案是一样的，都是234.
现在我们将数值变成234.54.现在就有个四舍五入的问题了，那下面的代码会得到什么数字呢？
static void Main(string[] args)
{  
   double dbTmp = 234.54;
   int iTmp = Convert.ToInt32(dbTmp);
   //int iTmp1 = (int)dbTmp;
   Console.WriteLine(iTmp.ToString());
}
答案是235.
如果改成用(int)强制转换呢？
static void Main(string[] args)
{  
   double dbTmp = 234.54;
   //int iTmp = Convert.ToInt32(dbTmp);
   int iTmp1 = (int)dbTmp;
   Console.WriteLine(iTmp1.ToString());
}
这次的答案是234，而不是四舍五入。
那么这两种转换方式的区别是什么呢？
1. （int)是类型转换，Convert.ToInt32是内容转换。
2. （int）是舍去转换，Convert.ToInt32是四舍五入。
```

