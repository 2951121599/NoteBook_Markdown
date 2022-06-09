## pandas的fillna()方法-填充空值

pandas中fillna()方法，能够使用指定的方法填充NA/NaN值。

### 1. 函数详解

函数形式：fillna(value=None, method=None, axis=None, inplace=False, limit=None, downcast=None, **kwargs)

参数：

value：用于填充的空值的值。

method： {'backfill', 'bfill', 'pad', 'ffill', None}, default None。定义了填充空值的方法， pad / ffill表示用前面行/列的值，填充当前行/列的空值， backfill / bfill表示用后面行/列的值，填充当前行/列的空值。

axis：轴。0或'index'，表示按行删除；1或'columns'，表示按列删除。

inplace：是否原地替换。布尔值，默认为False。如果为True，则在原DataFrame上进行操作，返回值为None。

limit：int， default None。如果method被指定，对于连续的空值，这段连续区域，最多填充前 limit 个空值（如果存在多段连续区域，每段最多填充前 limit 个空值）。如果method未被指定， 在该axis下，最多填充前 limit 个空值（不论空值连续区间是否间断）

 

### 2. 示例

```python
import numpy as np
import pandas as pd

a = np.arange(100, dtype=float).reshape((10, 10))
for i in range(len(a)):
    a[i, :i] = np.nan
a[6, 0] = 100.0

d = pd.DataFrame(data=a)
print(d)
```

### 3. 填充值

```python
print(d.fillna(value=0))  # 用0填补空值
print(d.fillna(method='pad', axis=0))  # 用前一行的值填补空值
print(d.fillna(method='backfill', axis=1))  # 用后一列的值填补空值
print(d.fillna(method='ffill',axis=0, limit=3))  # 连续空值，最多填补3个
print(d.fillna(value=-1,axis=0, limit=3))  # 每条轴上，最多填补3个
```

## **read_csv**参数整理

### **sep** : str, default ‘,’

指定分隔符。如果不指定参数，则会尝试使用逗号分隔

### **header** : int or list of ints, default ‘infer’

指定行数用来作为列名，数据开始行数。如果文件中没有列名，则默认为0，否则设置为None。如果明确设定header=0 就会替换掉原来存在列名。header参数可以是一个list例如：[0,1,3]，这个list表示将文件中的这些行作为列标题（意味着每一列有多个标题），介于中间的行将被忽略掉（例如本例中的2；本例中的数据1,2,4行将被作为多级标题出现，第3行数据将被丢弃，dataframe的数据从第5行开始。）。

注意：如果skip_blank_lines=True 那么header参数忽略注释行和空行，所以header=0表示第一行数据而不是文件的第一行。

### **names** : array-like, default None

用于结果的列名列表，如果数据文件中没有列标题行，就需要执行header=None。默认列表中不能出现重复，除非设定参数mangle_dupe_cols=True。

### **index_col** : int or sequence or False, default None

用作行索引的列编号或者列名，如果给定一个序列则有多个行索引。

如果文件不规则，行尾有分隔符，则可以设定index_col=False 来是的pandas不适用第一列作为行索引。

### **usecols** : array-like, default None

返回一个数据子集，该列表中的值必须可以对应到文件中的位置（数字可以对应到指定的列）或者是字符传为文件中的列名。例如：usecols有效参数可能是 [0,1,2]或者是 [‘foo’, ‘bar’, ‘baz’]。使用这个参数可以加快加载速度并降低内存消耗。

### **prefix** : str, default None

在没有列标题时，给列添加前缀。例如：添加‘X’ 成为 X0, X1, ...

### **skiprows** : list-like or integer, default None

需要忽略的行数（从文件开始处算起），或需要跳过的行号列表（从0开始）。

### **nrows** : int, default None

需要读取的行数（从文件头开始算起）。

### **skip_blank_lines** : boolean, default True

如果为True，则跳过空行；否则记为NaN。

### **float_precision** : string, default None

指定转换器C引擎应该使用浮点值。普通的选项没有转换器,高的高精度转换器,round_trip双向变换器指定

### **encoding** : str, default None

指定字符集类型，通常指定为'utf-8'.

## pandas读取文件的read_csv()

参考链接: https://www.jianshu.com/p/ebb64a159104

```python
import pandas as pd
pd.read_csv(filepath_or_buffer,header,parse_dates,index_col)
参数：
filepath_or_buffer：
字符串，或者任何对象的read()方法。这个字符串可以是URL，有效的URL方案包括http、ftp、s3和文件。可以直接写入"文件名.csv"

header：
将行号用作列名，且是数据的开头。
注意当skip_blank_lines=True时，这个参数忽略注释行和空行。所以header=0表示第一行是数据而不是文件的第一行。

【注】：如果csv文件中含有中文，该如何？
1、可修改csv文件的编码格式为unix(不能是windows)（用notepad++打开修改）
2、df = pd.read_csv(csv_file, encoding="utf-8")，设置读取时的编码或 encoding="gbk"
3、在使用列名来访问DataFrame里面的数据时，对于中文列名，应该在列名前面加'u'，表示后面跟的字符串以unicode格式存储，如下所示
print(df[u"经度(度)"])

(1)、header=None
即指定原始文件数据没有列索引，这样read_csv为其自动加上列索引{从0开始}
ceshi.csv原文件内容：
c1,c2,c3,c4
a,0,5,10
b,1,6,11
c,2,7,12
d,3,8,13
e,4,9,14

df=pd.read_csv("ceshi.csv",header=None)
print(df)
结果：
    0   1   2   3
0  c1  c2  c3  c4
1   a   0   5  10
2   b   1   6  11
3   c   2   7  12
4   d   3   8  13
5   e   4   9  14

(2)、header=None，并指定新的索引的名字names=seq序列
df=pd.read_csv("ceshi.csv",header=None,names=range(2,6))
print(df)
结果：
    2   3   4   5
0  c1  c2  c3  c4
1   a   0   5  10
2   b   1   6  11
3   c   2   7  12
4   d   3   8  13
5   e   4   9  14


(3)、header=None，并指定新的索引的名字names=seq序列；如果指定的新的索引名字的序列比原csv文件的列数少，那么就截取原csv文件的倒数列添加上新的索引名字
df=pd.read_csv("ceshi.csv",header=0,names=range(2,4))
print(df)
结果：
        2   3
c1 c2  c3  c4
a  0    5  10
b  1    6  11
c  2    7  12
d  3    8  13
e  4    9  14


(4)、header=0
表示文件第0行（即第一行，索引从0开始）为列索引
df=pd.read_csv("ceshi.csv",header=0)
print(df)
结果：
  c1  c2  c3  c4
0  a   0   5  10
1  b   1   6  11
2  c   2   7  12
3  d   3   8  13
4  e   4   9  14

(5)、header=0，并指定新的索引的名字names=seq序列
df=pd.read_csv("ceshi.csv",header=0,names=range(2,6))
print(df)
结果：
   2  3  4   5
0  a  0  5  10
1  b  1  6  11
2  c  2  7  12
3  d  3  8  13
4  e  4  9  14
注：这里是把原csv文件的第一行换成了range(2,6)并将此作为列索引

(6)、header=0，并指定新的索引的名字names=seq序列；如果指定的新的索引名字的序列比原csv文件的列数少，那么就截取原csv文件的倒数列添加上新的索引名字
df=pd.read_csv("ceshi.csv",header=0,names=range(2,4))
print(df)
结果：
     2   3
a 0  5  10
b 1  6  11
c 2  7  12
d 3  8  13
e 4  9  14


parse_dates：
布尔类型值 or int类型值的列表 or 列表的列表 or 字典（默认值为 FALSE）
(1)True:尝试解析索引
(2)由int类型值组成的列表(如[1,2,3]):作为单独数据列，分别解析原始文件中的1,2,3列
(3)由列表组成的列表(如[[1,3]]):将1,3列合并，作为一个单列进行解析
(4)字典(如{'foo'：[1, 3]}):解析1,3列作为数据，并命名为foo


index_col：
int类型值，序列，FALSE（默认 None）
将真实的某列当做index（列的数目，甚至列名）
index_col为指定数据中那一列作为Dataframe的行索引，也可以可指定多列，形成层次索引，默认为None,即不指定行索引，这样系统会自动加上行索引。

举例：
df=pd.read_csv("ceshi.csv",index_col=0)
print(df)
结果：
    c2  c3  c4
c1            
a    0   5  10
b    1   6  11
c    2   7  12
d    3   8  13
e    4   9  14
表示：将第一列作为索引index

df=pd.read_csv("ceshi.csv",index_col=1)
print(df)
结果：
   c1  c3  c4
c2           
0   a   5  10
1   b   6  11
2   c   7  12
3   d   8  13
4   e   9  14
表示：将第二列作为索引index


df=pd.read_csv("ceshi.csv",index_col="c1")
print(df)
结果：
    c2  c3  c4
c1            
a    0   5  10
b    1   6  11
c    2   7  12
d    3   8  13
e    4   9  14
表示：将列名"c1"这里一列作为索引index
【注】：这里将"c1"这一列作为索引即行索引后，"c1"这列即不在属于列名这类，即不能使用df['c1']获取列值
【注】：read_csv()方法中header参数和index_col参数不能混用，因为header指定列索引，index_col指定行索引，一个DataFrame对象只有一种索引

squeeze：
布尔值，默认FALSE
TRUE 如果被解析的数据只有一列，那么返回Series类型。
```