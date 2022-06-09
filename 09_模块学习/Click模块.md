

```python

Python版本：3.6.4

相关模块：

requests模块；

# execjs模块；Python执行js代码
pip install PyExecJS  # 需要注意， 包的名称：PyExecJS  

# lxml模块；

# click模块；click模块是Flask的作者开发的一个第三方模块，用于快速创建命令行。它的作用与Python标准库的argparse相同，但是，使用起来更简单。

# prettytable模块；用来生成美观的ASCII格式的表格 pip install prettytable


nodejs版本：v10.15.3
```

1. ## Click模块

   click模块是Flask的作者开发的一个第三方模块，用于快速创建命令行。它的作用与Python标准库的argparse相同，但是，使用起来更简单。

   click是一个第三方库，因此使用起来需要先行安装

   ## 安装click模块

   使用pip命令即可完成模块的安装

   ```python
   pip install click
   ```

   ## 基本使用

   Click对argparse的主要改在在于易用性，使用click模块主要分为两个步骤：

   1. 使用@click.command() 装饰一个函数，使之成为命令行接口
   2. 使用@click.option() 等装饰函数，为其添加命令行选项

   下列为click官方提供的例子：

   ```python
   import click
    
   @click.command()
   @click.option('--count', default=1, help='Number of greetings.')
   @click.option('--name', prompt='Your name',
                 help='The person to greet.')
   def hello(count, name):
       """Simple program that greets NAME for a total of COUNT times."""  # 会当作help信息进行输出
       for xin range(count):
           click.echo('Hello %s!' % name)
    
   if __name__== '__main__':
       hello()
   ```

   在上面的例子中，函数hello接受两个参数，分别是count和name，他们的取值从命令行中获取，这里我们使用了click模块中的command、option、echo，他们的作用如下：

   - command：使函数hello成为命令行接口
   - option：增加命令行选项
   - echo：输出结果，使用echo进行输出是为了更好的兼容性，因为python 2中的print是个语句，python 3中的print 是一个函数

   运行上面的脚本，可以通过命令指定--name,--count的值，由于我们在option中指定了prompt选项，那么如果我们执行脚本没有传递name这个参数时，Click会提示我们在交互模式下输入

   PS：与argparse模块一样，click也会为我们自动生成提示信息

   ```python
   lidaxindeMacBook-Pro:hello DahlHin$ python3 click模块.py--help
   Usage: click模块.py [OPTIONS]
    
     Simple program that greets NAMEfor a total of COUNT times.
    
   Options:
     --count INTEGER  Number of greetings.
     --name TEXT      The person to greet.
     --help           Show this messageand exit.
   ```

   ## 其他参数

   option最基本的用法就是通过指定命令行选项的名称，从命令行读取参数值，再将其传递给函数。option常用的参数含义：

   - default： 设置命令行参数的默认值
   - help：参数说明
   - type：参数类型，可以是string、int、float等
   - prompt：当在命令行中没有输入相应的参数时，会更具prompt提示用户输入
   - nargs：指定命令行参数接受的值的个数
   - required：是否为必填参数

   ```python
   import click
    
   @click.command()
   @click.option('--pos',nargs=2,type=float)
    
   def getfloat(pos):
       click.echo('%s / %s' % pos )
    
   if __name__== '__main__':
       getfloat()
   ```

   **注意：option中定义的参数名称，那么就需要用同名的变量进行接受。**

   **更多参数请参考： http://click.pocoo.org/5/options/#choice-opts** 