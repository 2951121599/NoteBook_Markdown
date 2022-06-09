### PyQt5
```text
pip install PyQt5
pip install pyqt5-tools
```

- Win+S呼出Cornata主面板（搜索框），输入designer，如果看到跟下图类似的结果说明PyQt Designer已经被安装

![image-20210531104150194](C:\Users\cuite\AppData\Roaming\Typora\typora-user-images\image-20210531104150194.png)

创建“Main Window”之后，下面就来简单介绍下整个画面的构成：

- 左侧的“Widget Box”就是**各种可以自由拖动的组件**
- 中间的“MainWindow - untitled”**窗体就是画布**
- 右上方的"Object Inspector"可以**查看当前ui的结构**
- 右侧中部的"Property Editor"可以**设置当前选中组件的属性**
- 右下方的"Resource Browser"**可以添加各种素材，比如图片，背景等等**

大致了解了每个板块之后，就可以正式开始编写第一个UI了

![image-20210531104533808](C:\Users\cuite\AppData\Roaming\Typora\typora-user-images\image-20210531104533808.png)

按照惯例，我们先来实现一个能够显示HelloWorld的窗口。

1）添加文本

在左侧的“Widget Box”栏目中找到“Display Widgets”分类，将“Label”拖拽到屏幕中间的“MainWindow”画布上，你就获得了一个仅用于显示文字的文本框

2）编辑文本

双击“TextLabel”，就可以对文本进行编辑，这里我们将其改成“HelloWorld!”，如果文字没有完全展示出来，可以自行拖拽空间改变尺寸。

特别提醒，编辑完文本之后记得敲击回车令其生效！

3）添加按钮

使用同样的方法添加一个按钮（PushButton）并将其显示的文本改成“HelloWorld!”

4）修改窗口标题

下面修改窗口标题。选中右上方的"Object Inspector"中的“MainWindow”，然后在右侧中部的"Property Editor"中找到“windowTitle”这个属性，在Value这一栏进行修改，修改完记得敲击回车。

5）编辑菜单栏

注意到画布的左上方有个“Type Here”，双击它即可开始编辑菜单栏。菜单栏支持创建多级菜单以及分割线（separator）。我随意创建了一些菜单项目，如下图所示。

![image-20210531105442888](C:\Users\cuite\AppData\Roaming\Typora\typora-user-images\image-20210531105442888.png)

6）预览

使用快捷键**Ctrl+R**预览当前编写的GUI

7）保存

如果觉得完成了，那就可以保存成*.ui的文件，这里我们保存为HelloWorld.ui。为了方便演示，我将文件保存到D盘。

8）生成Python代码

使用cmd将目录切到D盘并执行下面的命令。请自行将下面命令中的name替换成文件名，比如本例中的“HelloWorld.ui”

```text
pyuic5 -o name.py name.ui
```

生成的代码应该类似下图所示

9）运行Python代码

此时尝试运行刚刚生成的“HelloWorld.py”是没用的，因为生成的文件并没有程序入口。因此我们在同一个目录下另外创建一个程序叫做“main.py”，并输入如下内容。在本例中，gui_file_name就是HelloWorld，请自行替换。



#### Qt Designer 打开设计程序

```python
Name：Qt Designer
Program：C:\Users\cuite\Anaconda3\Library\bin\designer.exe
Arguments：
Working directory：$ProjectFileDir$
```



#### PyUIC 将ui文件转为py文件

```python
Name：PyUIC
Program：C:\Users\cuite\Anaconda3\python.exe
Arguments：-m PyQt5.uic.pyuic $FileName$ -o $FileNameWithoutExtension$.py
Working directory：$FileDir$
```

10）组件自适应

如果你刚刚尝试去缩放窗口，会发现组件并不会自适应缩放，因此我们需要回到Qt Designer中进行一些额外的设置。

点击画布空白处，然后在上方工具栏找到grid layout或者form layout，在本例中我们使用grid layout。两种layout的图标如下图所示。

![img](https://pic4.zhimg.com/80/v2-26be2a271f417b0f7627a7579e0d3607_720w.png)

顺带一提，上图中layout的左边有三条横线以及三条竖线的图标，这两个是用于对齐组件，非常实用。

设置grid layout后，我们使用Ctrl+R预览，这次组件可以自适应了！因为我们已经将UI（HelloWorld.py/HelloWorld.ui）跟逻辑（main.py）分离，因此直接重复步骤7-8即可完成UI的更新，无需改动逻辑（main.py）部分。

