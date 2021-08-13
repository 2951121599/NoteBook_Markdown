## 同一个项目中让R和Python无缝工作的五种方法

### 在项目启动时定义Python环境

> 为避免与使用错误的Python解释器相关问题，首先来定义Python环境。 

```R
Sys.setenv(RETICULATE_PYTHON="C:/Python/Python37")
print(paste("Python environment forced to", Sys.getenv("RETICULATE_PYTHON"))) 

# py_available()  # 检查是否返回True
# 使用condaenv
# use_condaenv("C:/Python/Python37")
```

> 其中，第一个命令设置您的python可执行文件所在路径。 第二个命令将打印确认，该确认将在您每次启动项目时显示在您的终端中。

### 使用``repl_python()``在``Python``中实时编码

> 在项目中如果需要``Python``和``R``一起使用, 可以使用``Reticulate``软件包中的``repl_python()``函数将R终端切换到Python终端，以便您可以在Python中进行实时编码。 您可以使用exit命令退出它，然后在R中编写更多代码，然后再回到Python终端，它仍然会记住上一个会话中的所有对象，这意味着它很容易在各种语言之间无缝地切换。 这是一个简单的示例：

```R
Sys.setenv(RETICULATE_PYTHON="C:/Users/user/Anaconda3")
print(paste("Python environment forced to", Sys.getenv("RETICULATE_PYTHON")))

# 引入包reticulate
library(reticulate)

# R
for(i in c(1:5)){
  print(i)
}

# 第一次使用Python
reticulate::repl_python()
py_list = [2, 4, 6, 8, 10]
exit

# 继续使用Python, 上面的对象依然可以使用
reticulate::repl_python()
py_list
exit
```



### 在Python和R之间交换对象

> 可以在``Python``和``R``之间交换任何相当标准的数据对象，例如值，列表和dataframe 。
> 要在``Python``中使用名为``r_object``的``R``对象，可以使用``r.r_object``进行调用。
> 要在``R``中使用名为``py_object``的``Python``对象，可以使用``py$py_object``进行调用。 

```R
# 在R中使用Python对象
for(i in py$py_list){
  print(i)
}

# 在Python中使用R对象
r_list = c(1, 2, 3, 4, 5)

reticulate::repl_python()
py_r_list = r.r_list
py_r_list  # [1.0, 2.0, 3.0, 4.0, 5.0]
exit
```



### 将Python函数转换为R函数

> 当同时使用这两种语言时,你最终会需要将Python代码作为一个R的函数来执行
>
> 如果将编写的Python函数写到一个文件中,然后R中调用source_python()，那么这个文件可以以源代码文件的形式使用。

```PYTHON
# sumof.py
def sumof(a, b):
    return a+b

# 获取sumof.py并将其变成R函数：
reticulate::source_python('sumof.py')
sumof(3, 5)
```



### 创建包含R和Python代码的MD文档

> R Markdown代码可以在代码块之间交换对象

````R
---
title: "test Python and R"
output: html_document
---

```{r setup}
library(reticulate)
```

```{Python}
my_py_obj = [1, 3, 5]
print(my_py_obj)
```
````

> 同样，你可以用一种语言编写函数，在另一种语言中轻松使用它们:

```R
# 在R中使用Python在文件里定义的函数
reticulate::source_python('sum_of.py')
sum_of(3, 5)

# 在Python中使用R定义的函数
average_of <-function(a, b){
  return((a+b)/2)
}

reticulate::repl_python()
py_r_average_of = r.average_of(2,5)
py_r_average_of  # 3.5
exit
```



