## stdlib.h头文件

[TOC]

stdlib 头文件即standard library**标准库头文件**。里面定义了**五种类型、一些宏和通用工具函数**。

stdlib.h是一些常用的函数，但是又不知道把它们放到哪里合适，因此就都放到了stdlib.h这个头文件中。



### 使用方式

#### C语言模式：

```c
#include <stdlib.h>
```

#### C++模式：

```c++
#include <cstdlib>
```



### 五种类型

> size_t、wchar_t、div_t、ldiv_t、lldiv_t



### 宏（常量）

> NULL、EXIT_FAILURE、EXIT_SUCCESS、RAND_MAX、MB_CUR_MAX  等等



### 通用工具函数

> 常用：malloc()、calloc()、realloc()、free()、system()、atoi()、atol()、rand()、srand()、exit()  等等

> 更多：atof, atoi, atol, strtod, strtof, strtols, strtol, strtoll, strtoul,strtoull, rand, srand, callc, free, maloc, realloc, abort, atexit, exit,getenv, system, bsearch, qsort, abs, div, labs, ldiv, llabs, tlldiv, mblen,mbtowc, wctomb, mbstowcs, wcstombs

#### 1.函数名称: calloc

> 函数原型: void * calloc(unsigned n,unsign size);
>
> 函数功能: 分配n个数据项的内存连续空间,每个数据项的大小为size
>
> 函数返回: 分配内存单元的起始地址,如果不成功,返回0

#### 2.函数名称: free

> 函数原型: void free(void* p);
>
> 函数功能: 释放p所指的内存区
>
> 参数说明: p-被释放的指针

#### 3.函数名称: malloc

> 函数原型: void * malloc(unsigned size);
>
> 函数功能: 分配size字节的存储区
>
> 函数返回: 所分配的内存区地址,如果内存不够,返回0

#### 4.函数名称: realloc

> 函数原型: void * realloc(void * p,unsigned size);
>
> 函数功能: 将p所指出的已分配内存区的大小改为size,size可以比原来分配的空间大或小
>
> 函数返回: 返回指向该内存区的指针.NULL-分配失败

#### 5.函数名称: rand

> 函数原型: int rand(void);
>
> 函数功能: 产生0到32767间的随机整数(0到0x7fff之间)
>
> 函数返回: 随机整数

#### 6.函数名称: abort

> 函数原型: void abort(void)
>
> 函数功能: 异常终止一个进程

#### 7.函数名称: exit

> 函数原型: void exit(int state)
>
> 函数功能: 程序中止执行，返回调用过程
>
> 参数说明: state:0-正常中止，非0-非正常中止

#### 8.函数名称: getenv

> 函数原型: char* getenv(const char *name)
>
> 函数功能: 返回一个指向环境变量的指针
>
> 函数返回: 环境变量的定义
>
> 参数说明: name-环境字符串

#### 9.函数名称: putenv

> 函数原型: int putenv(const char *name)
>
> 函数功能: 将字符串name增加到DOS环境变量中
>
> 函数返回: 0:操作成功，-1:操作失败
>
> 参数说明: name-环境字符串

#### 10.函数名称: labs

> 函数原型: long labs(long num)
>
> 函数功能: 求长整型参数的绝对值
>
> 函数返回: 绝对值

#### 11.函数名称: atof

> 函数原型: double atof(char *str)
>
> 函数功能: 将字符串转换成一个双精度数值
>
> 函数返回: 转换后的数值
>
> 参数说明: str-待转换浮点型数的字符串

#### 12.函数名称: atoi

> 函数原型: int atoi(char *str)
>
> 函数功能: 将字符串转换成一个整数值
>
> 函数返回: 转换后的数值
>
> 参数说明: str-待转换为整型数的字符串

#### 13.函数名称: atol

> 函数原型: long atol(char *str)
>
> 函数功能: 将字符串转换成一个长整数
>
> 函数返回: 转换后的数值
>
> 参数说明: str-待转换为长整型的字符串

#### 14.函数名称: ecvt

> 函数原型: char *ecvt(double value,int ndigit,int *dec,int*sign)
>
> 函数功能: 将浮点数转换为字符串
>
> 函数返回: 转换后的字符串指针
>
> 参数说明: value-待转换底浮点数，ndigit-转换后的字符串长度

#### 15.函数名称: fcvt

> 函数原型: char *fcvt(double value,int ndigit,int *dec,int*sign)
>
> 函数功能: 将浮点数变成一个字符串
>
> 函数返回: 转换后字符串指针
>
> 参数说明: value-待转换底浮点数，ndigit-转换后底字符串长度