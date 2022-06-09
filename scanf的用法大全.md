## scanf的用法大全

目录索引：

[TOC]

[C语言在线编程网站](https://www.bccn.net/run/)

2、附加格式说明字符表修饰符说明 
3、问题一：scanf()函数不能正确接受有空格的字符串？
4、scanf()函数如何结束数据的输入
5、问题二：键盘缓冲区残余信息问题
6、问题三： 如何处理scanf()函数误输入造成程序死锁或出错？
7、%[ ] 的用法

===========================================================================

### 1. scanf函数的一般形式

>scanf(格式控制，地址表列)
>原型：int scanf(char *format[,argument,...]);
>参数：格式控制：含义同printf函数
>		   地址表列：是由若干个地址组成的表列，可以是变量的地址，或字符串首地址
>返回值：返回成功赋值的数据项数，读到文件末尾出错时则返回EOF

```c
#include <stdio.h>
void main()
{
    int a, b, c;
    printf("input a,b,c\n");
    scanf("%d%d%d", &a, &b, &c);  // 输入三个数 eg: 1 2 3
    printf("a=%d,b=%d,c=%d", a, b, c);  // a=1,b=2,c=3
}
```

### 2. 格式化字符串 

```c
%a,%A 读入一个浮点值(仅C99有效) 
%c 读入一个字符
%d 读入十进制整数
%i 读入十进制，八进制，十六进制整数
%o 读入八进制整数
%x,%X 读入十六进制整数
%c 读入一个字符
%s 读入一个字符串，遇空格、制表符或换行符结束。
%f,%F,%e,%E,%g,%G 用来输入实数，可以用小数形式或指数形式输入。
%p 读入一个指针
%u 读入一个无符号十进制整数
%n 至此已读入值的等价字符数
%[] 扫描字符集合
%% 读%符号
```

 

### 3. 要注意的问题 

- scanf()中的变量必须使用地址 
- scanf()的格式控制串可以使用其它非空白字符，但在输入时必须输入这些字符
- 在用"%c"输入时，空格和“转义字符”均作为有效字符

#### scanf()函数能不能正确接受有空格的字符串？

如: I love you!

```C
#include <stdio.h>
int main()
{
    char str[80];
    scanf("%s", str);  // 输入：I love you!
    printf("%s", str);  // 输出：I
    return 0;
}
```

scanf() 函数接收输入数据时，遇以下情况结束一个数据的输入：（不是结束该scanf函数，scanf函数仅在每一个数据域均有数据，并按回车后结束）。
  ① 遇空格、回车、跳格键
  ② 遇宽度结束
  ③ 遇非法输入
所以，上述程序并不能达到预期目的，scanf()扫描到"I"后面的空格就认为对str的赋值结束，并忽略后面的"love you!"。这里要注意是"love you!"还在键盘缓冲区（关于这个问题，网上我所见的说法都是如此，但是，我经过调试发现，其实这时缓冲区字符串首尾指针已经相等了，也就是说缓冲区清空了，scanf()函数应该只是扫描stdin流，这个残存信息是在stdin中)。我们改动一下上面的程序来验证一下：

```C
#include <stdio.h>
int main()
{
    char str[80];
    char str1[80];
    char str2[80];
    scanf("%s", str); //此处输入:I love you!
    printf("%s", str);
    scanf("%s", str1);
    scanf("%s", str2);
    printf("\n%s", str1);
    printf("\n%s", str2);
    return 0;
}
```

```c
 输入：I love you!
 输出：
 I
 love
 you!
```

  好了，原因知道了，那么scanf()函数能不能完成这个任务？回答是：能！别忘了scanf()函数还有一个 %[] 格式控制符,请看下面的程序：

 ```C
 #include <stdio.h>
 int main()
 {
     char string[50]; // scanf("%s",string); 不能接收空格符
     scanf("%[^\n]", string);
     printf("%s\n", string);  // I love you! 成功输出
     return 0;
 }
 ```

### 4. scanf的特殊用法

> **%[ ]** 的用法：%[ ]表示要读入一个字符[集合](https://so.csdn.net/so/search?q=集合&spm=1001.2101.3001.7020), 如果[ 后面第一个字符是”^”，则表示反意思。
>
> ​           [ ]内的[字符串](https://so.csdn.net/so/search?q=字符串&spm=1001.2101.3001.7020)可以是1或更多字符组成。空字符集（%[]）是违反规定的，可
>
> ​           导致不可预知的结果。%[^]也是违反规定的。     

**%[a-z]** 读取在 a-z 之间的字符串，如果不在此之前则停止，如

​       char s[]="hello, my friend” ;     // 注意: ,逗号在不 a-z之间

​        sscanf( s, “%[a-z]”, string ) ; // string=hello

**%[^a-z]** 读取不在 a-z 之间的字符串，如果碰到a-z之间的字符则停止，如

​       char s[]="HELLOkitty” ;     // 注意: ,逗号在不 a-z之间

​        sscanf( s, “%[^a-z]”, string ) ; // string=HELLO

**%\*[^=]**  前面带 ***** 号表示不保存变量。跳过符合条件的字符串。

​       char s[]="notepad=1.0.0.1001" ;

​    char szfilename [32] = "" ;

​    int i = sscanf( s, "%*[^=]", szfilename ) ; // szfilename=NULL,因为没保存

int i = sscanf( s, "%*[^=]=%s", szfilename ) ; // szfilename=1.0.0.1001

**%40c**   读取40个字符

​       The run-time

library does not automatically append a null terminator

to the string, nor does reading 40 characters

automatically terminate the scanf() function. Because the

library uses buffered input, you must press the ENTER key

to terminate the string scan. If you press the ENTER before

​    the scanf() reads 40 characters, it is displayed normally,

​    and the library continues to prompt for additional input

​    until it reads 40 characters



**%[^=]**   读取字符串直到碰到’=’号，’^’后面可以带更多字符,如：

​       char s[]="notepad=1.0.0.1001" ;

​    char szfilename [32] = "" ;

​    int i = sscanf( s, "%[^=]", szfilename ) ; // szfilename=notepad   

​    如果参数格式是：%[^=:] ，那么也可以从 notepad:1.0.0.1001读取notepad

​       

使用例子：

​    char s[]="notepad=1.0.0.1001" ;

char szname [32] = "" ;

char szver [32] = “” ;

sscanf( s, "%[^=]=%s", szname , szver ) ; // szname=notepad, szver=1.0.0.1001

总结：%[]有很大的功能，但是并不是很常用到，主要因为：

1、许多系统的 scanf 函数都有漏洞. (典型的就是 TC 在输入浮点型时有时会出错).

2、用法复杂, 容易出错.

3、编译器作语法分析时会很困难, 从而影响目标代码的质量和执行效率.

个人觉得第 3 点最致命，越复杂的功能往往执行效率越低下。而一些简单的字符串分析我们可以自已处理。
