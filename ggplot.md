# ggplot

### 总结

- ggplot2的核心理念是将绘图与数据分离，数据相关的绘图与数据无关的绘图分离
- ggplot2是按图层作图
- ggplot2保有命令式作图的调整函数，使其更具灵活性
- ggplot2将常见的统计变换融入到了绘图中。



ggplot2图形系统的核心理念是把绘图与数据分离，把数据相关的绘图与数据无关的绘图分离，按图层作图。ggplot2可以把绘图拆分成多个图层，且能够按照顺序创建多重图形。

使用ggplot2包创建图形时，每个图形都是由函数ggplot()创建的，提供绘图的数据和映射：

- **数据（data）：数据框对象**
- **映射（mapping）：由aes()函数来设置映射**

由几何对象来控制绘制的几何图形，通过符号“+”来增加图形的元素，这使得绘制图形的过程结构化，同时使绘图更具灵活性。

在ggplot2中, 图形语法中至少包括了如下几个图形部件，每一个部件可以是一个图层：

- **几何对象(geom)**
- **统计变换(stats)**
- **标度(scale)**
- **坐标系(coord)**
- **分面(facet)**
- **主题(theme)**

这些组件之间是通过“+”， 以**图层(layer)**的方式来粘合构图的，可以这样理解ggplot2中的图层：每个图层可以代表一个图形组件， 这些图形组件以图层的方式叠加在一起构成一个绘图的整体，在每个图层中的图形组件又可以分别设定数据、映射或其他相关参数，因此组件之间又是具有相对独立性的。

## **一，数据和映射**

使用函数ggplot()初始化图形对象，并指定绘制图形的数据集和坐标轴的映射，在ggplot()函数中，指定数据集的默认设置，便于后续图形选项的操作：

```R
ggplot(data = NULL, mapping = aes())
```

两个重要参数：

- **data**： 用于指定要用到的数据源，必须使数据框类型
- **mapping**：使用aes()函数指定每个变量的角色，除x和y之外的其他参数，例如，size、color、shape等，必须采用name=value的形式。

在ggplot中设置的映射是默认映射关系，其他图层中可以继承该映射关系，或修改映射关系。

**1，数据**

在ggplot2中, 所接受的数据集必须为数据框(data.frame)格式，在下面的小节中，使用数据集mtcars作为ggplot的输入：

```R
library(ggplot2)
data("mtcars")
```

**2，映射**

映射是指为数据集中的数据关联到相应的图形属性过程中一种对应关系，ggplot2通过aes()函数来指定映射，把图形属性和数据关联起来。

aes是英语单词 aesthetics 的缩写，中文意思是美学，aes用于指定图形属性。

```R
aes(x, y, ...)
```

aes()函数中常见的映射选项是：

- **x和y：**用于指定x轴和y轴映射的变量
- **color**：映射点或线的颜色
- **fill**：映射填充区域的颜色
- **linetype**：映射图形的线形（1=实线、2=虚线、3=点、4=点破折号、5=长破折号、6=双破折号）
- **size**：点的尺寸和线的宽度
- **shape**：映射点的形状

![img](https://images2018.cnblogs.com/blog/628084/201803/628084-20180317194650888-1810632902.png)

- **group**：默认情况下ggplot2把所有观测点分为了一组, 如果需要把观测点按额外的离散变量进行分组处理, 必须修改默认的分组设置

**注意，映射和设定是不同的：**

- **映射**是将一个变量中离散或连续的数据与一个图形属性中以不同的参数来相互关联，
- 而**设定**能够将这个变量中所有的数据统一为一个图形属性。

```R
p <- ggplot(mtcars, aes(wt, mpg)) 
p + geom_point(color = "blue")  # 设定散点的颜色为蓝色
p + geom_point(aes( color = "blue"))
```

![img](https://images2018.cnblogs.com/blog/628084/201808/628084-20180803202314035-1873975909.png)

最后一行语句为错误的映射关系, 在aes中, color = “blue”的实际意思是把”blue”当为一个变量, 用这个变量里的数据去关联图形属性中的参数, 因为”blue”只含有一个字符变量, 默认情况下为离散变量, 按默认的颜色标度标记为桃红色。

**3，分组**

**分组(group)**是ggplot2中映射关系的一种，默认情况下ggplot2把所有观测点分为了一组，如果需要把观测点按指定的**因子**进行分组处理，必须修改默认的分组设置。

```R
ggplot(data = mtcars, mapping = aes(x = wt, y = hp, group = factor(gear))) + 
  geom_line()
```

分组也可以通过**映射**把视觉特征（shape、color、fill、size和linetype等）设置为变量来实现分组，分组通常使用因子来实现，这就要求在数据集中存在因子变量，用于对数据分类，实现图形的分组。

```R
ggplot(data=ds,aes(x=var1,y=var2,fill=var3,shape=var4))+
    geom_point()
```

## 二，几何对象(geom)和统计变换(stat)

几何对象控制图层的渲染和生成的图像类型，例如，geom_point()会生成散点图，而geom_line会生成折线图。统计变换是对数据进行统计，通常以某种方式对数据信息进行汇总, 例如通过stat_smooth()添加光滑曲线。
每一个几何对象都有一个默认的统计变换, 并且每一个统计变换都有一个默认的几何对象。在ggplot2的官方文档中, 已对ggplot2中所有的geom和stat组件进行了[汇总](http://docs.ggplot2.org/current/), 更详细的内容, 可直接点开相应图形组件所对应的链接。

函数ggplot()可以设置图形，但是没有视觉输出，需要使用一个或多个几何函数向图形中添加几何对象（geometric，简写为geom），包括**点（point）、线（line）、条（bar）**等，而添加几何图形的格式十分简单，通过符号“+”把几何图形添加到plot中：

```R
ggplot()+
geom_xxx()
```

例如，使用geom_point()函数输出点状图形，并接收以下美学参数：alpha、colour、fill、group、shape、size和stroke，

```R
ggplot(data=mtcars, aes(x=wt,y=mpg))+
  geom_point(color="red",size=1,shape=0)
```

常用的图形参数是：

- **color**：对点、线和填充区域的边界进行着色
- **fill**：对填充区域着色
- **alpha**：演示的透明度，从透明（0）到不透明（1）
- **linetype**：图案的线条（1=实线、2=虚线、3=点、4=点破折号、5=长破折号、6=双破折号）
- **size**：点的尺寸和线的宽度
- **shape**：点的形状（和par()函数的pch参数相同）

![img](https://images2018.cnblogs.com/blog/628084/201803/628084-20180317194650888-1810632902.png)

- **position**：绘制条形图和点等对象的位置
- **binwidth**：分箱的宽度
- **notch**：表示方块图是否应该有缺口
- **sides**：地毯图的位置（"b"=底部、"l"=左部、"r"=右部、"bl"=左下部，等)
- **width**：箱线图的宽度

## **三，标度（scale）**

**标度**控制着数据到图形属性的映射，更重要的一点是标度将我们的数据转化为视觉上可以感知的东西, 如大小、颜色、位置和形状。所以通过标度可以修改坐标轴和图例的参数。关于标度，请查看官方文档：[Scales ](https://ggplot2.tidyverse.org/reference/index.html#section-scales)。

最常用的标度是：标签、图形选项（颜色、size、形状、线形等）和坐标轴

**1，标签**

可以通过函数labs()来指定图形的标题（title)，子标题（subtitle），坐标轴的标签（x，y）等，并可以指定标签的美学选项：

```R
labs(...)
```

参数是美学（aesthetic）选项，使用name=value模式，可以使用的选项是：

- 指定文字：title、subtitle、caption、x和y
- 指定美学选项：color、size等

**2，自定义图形选项**

```R
scale_colour_manual() 
scale_fill_manual() 
scale_size_manual() 
scale_shape_manual() 
scale_linetype_manual() 
scale_alpha_manual() 
scale_discrete_manual()
```

**3，坐标轴**

标度是区分离散和连续变量的，标度用于将连续型、离散型和日期-时间型变量映射到绘图区域，以及构造对应的坐标轴。

## **四，坐标系**

坐标系统确定x和y美学如何组合以在图中定位元素。默认的坐标系是笛卡尔坐标系，[coord_cartesian()](https://ggplot2.tidyverse.org/reference/coord_cartesian.html)，笛卡尔坐标系是最常用的坐标系，函数[coord_flip()](https://ggplot2.tidyverse.org/reference/coord_flip.html) 用于反转笛卡尔坐标系，把x轴和y轴对调。

## **五，刻面（facet）**

分组和刻面都用于对数据分组，便于观察各自的规律、趋势和模式，不同的是，分组是把图形绘制到一个大的图形中，通过美学特征来区分，而刻面是把图形绘制到不同的网格中。

刻面是在一个画布上分布多幅图形，这一过程需要先把数据划分为多个子集， 然后把每个子集依次绘制到画布的不同面板中。

ggplot2提供两种分面类型：**网格型(facet_grid)**和**封面型(facet_wrap)**。

- **网格刻**面生成的是一个**2维**的面板网格, 面板的行与列通过变量来定义, 本质是**2维**的; 
- **封装**刻面则先生成一个**1维**的面板条块, 然后再分装到**2维**中, 本质是**1维**的。

## **六，主题**

主题（Theme）用于控制图形中的非数据元素外观，不会影响几何对象和标度等数据元素，主题主要是对**标题、坐标轴标签、图例标签**等**文字**调整， 以及**网格线、背景、轴须**的颜色搭配。

ggplot图形的主题（theme）元素主要分为5大类：**图形（plot）、面板（panel）、坐标轴（axis）、图例（Legend）和带形（Strip）**，通过theme()函数来统一控制图形的美学和文本特征，可以用于调整字体，背景色，前景色和网格线等。

对于面板的网格线，分为主线（panel.grid.major）和 次线（panel.grid.minor ）,用户可以根据绘制图形的需要，显示或隐藏。

关于主题的详细用法，请查看官方文档：[Modify components of a theme](http://ggplot2.tidyverse.org/reference/theme.html) 和 [Theme elements](http://ggplot2.tidyverse.org/reference/element.html)。

Theme()中每一个参数的赋值，可以通过元素函数来实现，`margin()`函数用于指定元素的边界，element_xxx用于控制矩形，线条和文本的填充（fill）、颜色，size、形状等

```R
margin(t = 0, r = 0, b = 0, l = 0, unit = "pt")
element_blank()
element_rect(fill = NULL, colour = NULL, size = NULL, linetype = NULL, color = NULL, inherit.blank = FALSE)
element_line(colour = NULL, size = NULL, linetype = NULL, lineend = NULL, color = NULL, arrow = NULL, inherit.blank = FALSE)
element_text(family = NULL, face = NULL, colour = NULL, size = NULL,  hjust = NULL, vjust = NULL, angle = NULL, lineheight = NULL, color = NULL, margin = NULL, debug = NULL, inherit.blank = FALSE)
```

