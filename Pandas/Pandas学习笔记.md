## Pandas学习笔记

### 调试

```python
import pdb
pdb.set_trace()
```

### 获取桌面所在路径

```python
import os
os.path.join(os.path.expanduser('~'), "Desktop")
```

### 浏览本地文件

```python
import tkinter as tk
from tkinter import filedialog

def getLocalFile():
    root=tk.Tk()
    root.withdraw()

    filePath=filedialog.askopenfilename()

    print('文件路径：',filePath)
    return filePath

if __name__ == '__main__':
    getLocalFile()
```

### 获取列表最大值索引

```python
li = [1, 2, 3, 4, 5]
li.index(max(li))  # 4
li[li.index(max(li))]  # 5
```



### 删除目录

```python
import os
import shutil

os.remove(path)  # 删除文件
os.removedirs(path)  # 删除空文件夹

shutil.rmtree(path)  # 递归删除文件夹
```



### 移动文件

```python
import os
import shutil

folder_list = ["wash", "Q27_SST_1", "Q27_SST_2"]

for folder in folder_list:
    pos_folder = os.path.join("pos", folder)
    neg_folder = os.path.join("neg", folder)
    print(pos_folder, neg_folder)
    # 要移动的文件名列表
    neg_file_list = ["DS01.txt", "DS02.txt"]
    # 遍历文件夹下的文件
    for file in os.listdir(pos_folder):
        # 如果文件在要移动的文件名列表中,则移动到另一目录下
        if file in neg_file_list:
            # 移动文件
            shutil.move(os.path.join(pos_folder, file), os.path.join(neg_folder, file))
print("success")
```



### 提取含有指定字符串的行

- 行的提取（选择）方法

- 完全匹配

  - ==

- 部分匹配

  - str.contains()：包含一个特定的字符串

    - 参数na：缺少值NaN处理
    - 参数case：大小写我的处理
    - 参数regex：使用正则表达式模式

  - str.endswith（）：以特定字符串结尾

  - str.startswith（）：以特定的字符串开头

  - str.match（）：匹配正则表达式模式
    要提取部分匹配的行，可以使用pandas的（str.xxx（））方法，根据指定条件提取的字符串方法。

```python
import pandas as pd

df = pd.read_csv('sample.csv').head(3)
print(df)
# 1.行的提取（选择）方法
mask = [True, False, True]
df_mask = df[mask]
# print(df_mask)

# 2.完全匹配==
# print(df[df['state'] == 'CA'])

# 3.部分匹配
# str.contains()：包含一个特定的字符串
# print(df[df['name'].str.contains('li')])


# 4.参数na：缺少值NaN处理
df_nan = df.copy()
df_nan.iloc[2, 0] = float('nan')
# 如果元素是缺失值NaN，则默认情况下它将返回NaN而不是True或False。
# print(df_nan['name'].str.contains('li'))
# 用作条件时，如果na = True，则选择NaN的行，如果na = False，则不选择NaN的行。
# print(df_nan[df_nan['name'].str.contains('li', na=True)])
# print(df_nan[df_nan['name'].str.contains('li', na=False)])
# print(df_nan[df_nan['name'].str.contains('Li', na=False, case=False)])  # case=False 不区分大小写


# 5.参数regex：使用正则表达式模式
# print(df['name'].str.contains('i.*e'))  # 默认情况下，指定为第一个参数的字符串将作为正则表达式模式进行处理。

df_q = df.copy()
df_q.iloc[2, 0] += '?'
# print(df_q)
# print(df_q['name'].str.contains('?', regex=False))
# print(df_q['name'].str.contains('\?'))  # 不用加regex=False


# 6.str.startswith（）：以特定的字符串开头
# print(df['name'].str.startswith('B'))
# print(df[df['name'].str.startswith('B')])

# 7.str.endswith（）：以特定字符串结尾
# print(df['name'].str.endswith('e'))
# print(df[df['name'].str.endswith('e')])


# 8.str.match（）：匹配正则表达式模式
# print(df['name'].str.match('.*i.*e'))  # 获取与正则表达式模式匹配
# print(df['name'].str.match('.*i'))  # 确定字符串的开头是否与模式匹配。如果不是一开始就为False。
```

```python
# 提取第25批数据
df[df['sample'].str.contains('25_')]
```



### 提取df最后一列

```python
df.iloc[:, -1]
```

### 数值替换

```python
# 过滤出来的“负值”替换为“NaN”或者指定的值
import pandas as pd
import numpy as np

df = pd.read_csv('test.csv')
df[df < 0] = np.nan  # 将过滤出来小于 0 的DateFrame对象替换成指定值 对过滤出来的对象进行赋值替换
df.to_csv('你的保存路径', index=True)  # index = True/False 表示是否把索引index一起写入csv文本。

# 把大于或者小于100的值替换为0和1
df["price"][df.price < 100] = 0
df["price"][df.price > 100] = 1
```

### 整列置零 和 全部统一置零

```python
data["one_column"] = 0
data.loc[row_indexer, col_indexer] = 0
data.loc[:, :] = 0
```

### 统计每一列0值的个数

```python
# 将第一列作为索引
df = pd.read_csv(file, index_col=0)
# 统计每一列0值的个数
value_0_count = (df == 0).astype(int).sum(axis=0)
print(value_0_count)
```

### 用非0值的平均值填充0值

```python
import numpy as np
import pandas as pd

df = pd.read_csv('test2.csv')
row_index_data = df.iloc[:, 0]

# 将0的值替换为nan 计算非nan的平均值 用于填充nan
df[df == 0] = np.nan
fill_data = df.iloc[:, 1:].apply(lambda column: column.fillna(np.around(np.nanmean(column, axis=0), decimals=5)), axis=0)
df2 = pd.concat([row_index_data, fill_data], axis=1)
df2.to_csv('df2.csv', index=False)
```

### 替换0为nan

```python
df.replace(0, np.nan, inplace=True)

# 用前一行的值填补空值
df = df.fillna(method='pad', axis=0)
```

### 读excel文件

```python
import pandas as pd

sheet_name_list = ['不包含胆汁酸-50%-1','不包含胆汁酸-50%-2','不包含胆汁酸-50%-3','不包含胆汁酸-80%-1','不包含胆汁酸-80%-3','包含胆汁酸-50%-2']
for sheet_name in sheet_name_list:
    # 筛选feature表
    df_feature = pd.read_excel('NC模型离子对.xlsx', sheet_name=sheet_name, header=None, names=['id', 'feature', 'value'])
    df_feature = df_feature[['feature']]

    # 全部信息表
    df_all = pd.read_csv('CV_data.csv')
    df_all.head()

    # 合并vlookup
    df_merge = pd.merge(left=df_feature, right=df_all, left_on='feature', right_on='feature')
    df_merge.to_csv('CV_data' + '_' + sheet_name + '.csv', index=False)
    print("success !")
```

### 写Excel

```python
# 用Pandas把DataFrame数据写入Excel文件，一般使用to_excel方法：
df.to_excel(target_filename, sheet_name)
```

### 写入到多张表

```python
# 输出文件
output_excel = os.path.join(file_root_path, ion + '_check_result.xlsx')
if os.path.exists(output_excel):
    os.remove(output_excel)
with pd.ExcelWriter(output_excel) as writer:
    res_sst_area_rsd.to_excel(writer, sheet_name=ion + "_SST样本面积的RSD", index=False)
    res_qc_area_rsd.to_excel(writer, sheet_name=ion + "_QC样本面积的RSD", index=False)
    res_qc_peak_height_rsd.to_excel(writer, sheet_name=ion + "_QC样本峰高的RSD", index=False)
    res_qc_rt_rsd.to_excel(writer, sheet_name=ion + "_QC样本RT的RSD", index=False)
print(ion + "生成成功! ")
```



### 按行合并多个文件

```python
import pandas as pd
import os

root_path = './归一化数据'
file_list = os.listdir(root_path)
print(file_list[0])
df1 = pd.read_csv(os.path.join(root_path, file_list[0]), float_precision='round_trip')
for i in range(1, len(file_list)):
    df2 = pd.read_csv(os.path.join(root_path, file_list[i]), float_precision='round_trip')
    df1 = df1.merge(df2)
    pd.options.display.max_columns = None
    print(df1[0:2])
df1.to_csv('merge_file.csv', index=False)
print("success !")
```

```python
# 公共列sample 合并完只剩一列
pd.merge(res_y,res_pred_y,left_on='sample',right_on='sample')
```



### 读csv文件

```Python
import pandas as pd

filename = 'sample.csv'
header = pd.read_csv(filename, encoding='utf-8', header=None).values[0, :]  # 行名
data = pd.read_csv(filename, encoding='utf-8')  # 数据

# 保证浮点数不被转换为多位小数 加参数 float_precision='round_trip'
import pandas as pd
res1 = pd.read_csv('res3.csv',float_precision='round_trip')

# 读文件时设置列名names=[]
df = pd.read_csv('./area/' + filename, header=None, names=[feature])
```

`read_csv`支持非常多的参数用来调整读取的参数

|       参数       |                           说明                            |
| :--------------: | :-------------------------------------------------------: |
|       path       |                         文件路径                          |
| sep或者delimiter |                        字段分隔符                         |
|      header      |               列名的行数，默认是0（第一行）               |
|    index_col     |               列号或名称用作结果中的行索引                |
|      names       |                     结果的列名称列表                      |
|     skiprows     |                   从起始位置跳过的行数                    |
|    na_values     |                     代替`NA`的值序列                      |
|     comment      |                  以行结尾分隔注释的字符                   |
|   parse_dates    |         尝试将数据解析为`datetime`。默认为`False`         |
|  keep_date_col   |   如果将列连接到解析日期，保留连接的列。默认为`False`。   |
|    converters    |                        列的转换器                         |
|     dayfirst     | 当解析可以造成歧义的日期时，以内部形式存储。默认为`False` |
|   data_parser    |                    用来解析日期的函数                     |
|      nrows       |                   从文件开始读取的行数                    |
|     iterator     |         返回一个TextParser对象，用于读取部分内容          |
|    chunksize     |                     指定读取块的大小                      |
|   skip_footer    |                  文件末尾需要忽略的行数                   |
|     verbose      |                  输出各种解析输出的信息                   |
|     encoding     |                         文件编码                          |
|     squeeze      |       如果解析的数据只包含一列，则返回一个`Series`        |
|    thousands     |                      千数量的分隔符                       |

### 写csv文件

```Python
# 写文件
df.to_csv(path, index=False, header=header)
```

### 获取df的行数和列数

```python
# 返回列数：
df.shape[1]
# 返回行数：
df.shape[0]
# 或者：
len(df)
```

### writerow实现字符串写入CSV

```python
# 每个字符后面加了一个逗号
# 解决方法 在writerow()中加入列表 writer.writerow([folder])
def write_csv_file(data, write_filename):
    data = list(map(lambda x: [x], data))
    with open(write_filename, 'w', newline='') as f:
        writer = csv.writer(f)
        writer.writerow([folder])
        for row in data:
            writer.writerow(row)
```

### np合并行/列

```python
import numpy as np

res = np.column_stack((data1, data2))  # 合并列
res = np.row_stack((data1, data2))  # 合并行
```

### pd合并列

```python
res = pd.concat([res, tmp], axis=1)  # 合并列
```

### 选取部分列

```python
# 选取部分列(numpy)
res = res[:, (1, 2, 3, 5, 8, 9, 10, 12, 13, 14, 15)]

# pandas
filename = 'neg_ion_list_20201215RT.csv'
data = pd.read_csv(filename, encoding='utf-8')
data1 = data.iloc[:, 1:5]  # 索引
data2 = df.loc[:, ['sample_no', 'type', 'X209', 'X002']]  # 列表
```

### 选取部分行

```python
import pandas as pd

data = pd.read_csv('test.csv', encoding='utf-8')
# 重新设置索引
data = data.set_index('feature')
# 根据标签去选择相应的行
res = data.loc[['X002','X004','X006'], :]

# 取一行时也要加上[]
res = data.loc[['X002'], :]
res = data.loc[[feature], :]
```

### 选取部分满足条件的行

```python
# 提取字符串为"Python"的行
df[df['grammer'] == 'Python']

# 提取含有字符串"Python"的行
df[df['grammer'].str.contains('Python')]

# 提取popularity列值大于3小于7的行
df[(df['popularity'] > 3) & (df['popularity'] < 7)]

# 提取popularity列最大值所在行¶
df[df['popularity'] == df['popularity'].max()]

# isin()
feature_ratio_data[feature_ratio_data['SampleName'].isin(N_sample_list_M_sample_name)]
```

### 使用正则过滤df里的列

```python
import pandas as pd
import numpy as np

df = pd.DataFrame(np.array([[1,2,3],[2,3,4],[3,4,5]]),columns=['a','d1','d2'])

# filter使用正则过滤以“d”开头的列
df.filter(regex=("d.*"))

>>
   a  d1  d2
0  1  2   3
1  2  3   4
2  3  4   5

>>
   d1  d2
0  2   3
1  3   4
2  4   5
```

### 绘图

```python
import pandas as pd
import numpy as np

# 随机生成示例数据
df= pd.DataFrame(np.random.rand(8, 4), columns=['A','B','C','D'])

# 柱状图
df.plot.bar()

df = pd.DataFrame({'a': np.random.randn(1000) + 1, 
                   'b': np.random.randn(1000),
                   'c': np.random.randn(1000) - 1},
                  columns=['a', 'b', 'c'])

# 堆叠/不堆叠的直方图
df.plot.hist(stacked=True, bins=20)
df.plot.hist(alpha=0.5)

### 箱体图
# 随机生成示例数据
df= pd.DataFrame(np.random.rand(8, 4), columns=['A','B','C','D'])
df.plot.box()

### 散点图
df = pd.DataFrame([[5.1, 3.5, 0], [4.9, 3.0, 0], [7.0, 3.2, 1],
                   [6.4, 3.2, 1], [5.9, 3.0, 2]],
                  columns=['length', 'width', 'species'])

df.plot.scatter(x='width', y='length', s=200, c='green', alpha=0.4)  # s为散点大小 c为散点颜色 alpha为颜色透明度

# 参数c，不单单可以用来指定颜色，还可以传入一个column name
# 关于colormap，可以参考下官方介绍：https://matplotlib.org/tutorials/colors/colormaps.html
df.plot.scatter(x='width' , y='length' , s=200 , c='species' , colormap='viridis')
```

### 插入添加列

```python
# 1.插入到最后一列
res['feature'] = feature

# 2.插入到任意位置
col_name = res.columns.tolist()
col_name.insert(0, 'feature')
res = res.reindex(columns = col_name)
res['feature'] = feature
```

```python
import pandas as pd

df = pd.read_csv('20210305_Shimadzu_shangdi_neg_new_rt_merge.csv')

df_ds = df.iloc[:10, :]
df_nb = df.iloc[11:21, :]

res = df_ds.iloc[:, 1:].values - df_nb.iloc[:, 1:].values
res = pd.DataFrame(res)

# 插入一列 insert参数 位置 列名 数据
row_name = ["DS01 - NB01", "DS02 - NB02", "DS03 - NB03", "DS04 - NB04", "DS05 - NB05", "DS06 - NB06", "DS07 - NB07", "DS08 - NB08", "DS09 - NB09", "DS10 - NB10"]
res.insert(0, 'feature', row_name)

res.to_csv('20210305_Shimadzu_shangdi_neg_new_rt_sub_result.csv', index=False, header=df.columns)
```



### 移动列的位置

```python
origin = pd.read_csv("german_clean.csv")
cols = list(origin)
cols.insert(62,cols.pop(cols.index('class')))  # 共有62个特征值, 将’class’移动到第62列, 即最后一列
origin = origin.loc[:,cols]  # 利用loc获取新的DataFrame并拷贝
```

### 删除非空文件夹

```python
# 方式一
import os
dirs = './data'
for root, dirs, files in os.walk(dirs, topdown=False):
    for name in files:
        os.remove(os.path.join(root, name))
    for name in dirs:
        os.rmdir(os.path.join(root, name))
os.removedirs('./data')

# 方式二
import shutil
dirs = './data'
shutil.rmtree(dirs, ignore_errors=True)
```

### 合并两个文件里对应的列

```python
# 11.csv
1,2,3
4,5,6

# 22.csv
20,21,22
30,31,32

# 输出文件
1,20,2,21,3,22
4,30,5,31,6,32

# 代码如下:
import pandas as pd
res1 = pd.read_csv('11.csv', header=None, float_precision='round_trip')
res2 = pd.read_csv('22.csv', header=None, float_precision='round_trip')

res = None
for i in range(len(res1.values[0])):
    # 连接两个dataframe, axis=1时, 组成一个DataFrame
    tmp = pd.concat([res1.iloc[:,i], res2.iloc[:,i]], axis=1)
    res = pd.concat([res, tmp], axis=1)
res.to_csv('res.csv', index=False, header=None, mode='a+')
```

### 

```python
import pandas as pd

filename = '1215_lot3.csv'
data = pd.read_csv(filename, encoding='utf-8', index_col=0)  # 第一列作为索引列
header = pd.read_csv(filename, encoding='utf-8', header=None).values[0, :]  # 行名

# 选取行
res = data.loc[['X002','X004','X006','X010','X011','X012','X016','X023','X024','X029','X032','X036','X042','X043','X051','X055','X066','X133','X141','X144','X152','X155','X160','X161','X171','X183','X196','X285','X286','X287','X292','X313','X154','X188','X013','X068','X070','X166','X001','X019','X020','X136','X139','X178','X279','X299'], :]
res = res.reset_index()  # 重置索引
res

# 写文件
res.to_csv('1215_lot3_final.csv',index=False, header=header)
print("输出成功! ")
```

``` python
# test.csv
feature,Q01_C_1_MEN04,Q01_C_2_MEN04,Q01_C_3_MEN04
X001,18861,18557,21886
X002,141026,169517,154293
X003,14251,15220,7849
X004,359410,385932,382829
X005,219788,237625,229802
X006,437422,475025,463760
X007,10271,10848,11088

# 若想选取'X002','X004','X006'行的数据 代码如下:

import pandas as pd

filename = 'test.csv'
data = pd.read_csv(filename, encoding='utf-8', index_col=0)  # feature作为索引
header = pd.read_csv(filename, encoding='utf-8', header=None).values[0, :]  # 行名

res = data.loc[['X002','X004','X006'], :]
res = res.reset_index()  # 重置索引

# 写文件
res.to_csv('res.csv', index=False, header=header)
```

### 读取csv文件的一列数据

```python
# 没有header时
import os
import pandas as pd

filename = os.listdir('./adjust_sample/')
filename = './adjust_sample/' + filename[0]
data = pd.read_csv(filename, encoding='utf-8', header=None)
sample_name_list = data.iloc[:, 0].values.tolist()
sample_name_list

# 有header时
filename = os.listdir('./adjust_sample/')
filename = './adjust_sample/' + filename[0]
data = pd.read_csv(filename, encoding='utf-8')
sample_name_list = data.iloc[:, 0].values.tolist()
sample_name_list

```

### 获取列名

```python
import pandas as pd
from numpy.random import randint
df = pd.DataFrame(columns=list('abcdefghij'))

df.columns.values.tolist()  # 最快
```

### 修改列名

```python
df = pd.DataFrame(np.random.rand(6,4),columns=list('ABCD'))

# 1. 修改全部列名：df.columns = [新列名] 该方法必须将所有列名全部修改，否则会报错
df.columns = [list('EFGH')]  # 必须[]

# 2. 修改部分列名：df.rename(columns={oldname1:newname1, oldname2:newname2}}, inplace=True)
df2.rename(columns={'E':'e', 'F':'f'}, inplace=True) # inplace=True，表示在原始dataframe上修改列名
```

```python
# 列重命名(部分)
df.rename(columns={
    'score':'s',
    'name':'n'
}, inplace=True)


# df.columns = [sample_name] (全部)
x = None
for filename in filename_list:
    sample_name = filename.split('.')[0]
    df = pd.read_csv(os.path.join(folder, filename), usecols=[7])
    df.columns = [sample_name]
    x = pd.concat([x, df], axis=1)
x = pd.concat([feature, x], axis=1)
x.to_csv('new_rt_merge.csv', index=False)

```

### 添加列名

```python
# df2.columns = [列名的列表]即可
res.columns = name_list  # 赋予列名
```

### 读文件时设置列名

```python
# 读文件时设置列名names=[]
df = pd.read_csv(filename, header=None, names=['id', 'feature', 'value'])
```

### 写文件时设置列名

```python
res.to_csv(feature_headers[i] + '.csv', index=False, header=['test_y', 'pred_test_y'])
```



### 删除行或列drop

```python
# 删除两列数据
d_useless = [0,1]
df.drop(labels=d_useless, axis=1, inplace=True)

# 删除两行数据
df_useless = [6,7]
df.drop(labels=df_useless, axis=0, inplace=True)

# drop参数
DataFrame.drop(labels=None, axis=0, index=None, columns=None, inplace=False)

参数说明：
labels 就是要删除的行列的名字，使用用列表
axis 默认为0，指删除行，因此删除列时要指定axis=1
index 直接指定要删除的行
columns 直接指定要删除的列
inplace=False，默认该删除操作不改变原数据，而是返回一个执行删除操作后的新dataframe
inplace=True，则会直接在原数据上进行删除操作，删除后无法返回

因此，删除行列有两种方式：
1）labels=None, axis=0 的组合
2）index或columns直接指定要删除的行或列

```

```python
import pandas as pd
import numpy as np
df = pd.DataFrame(
    np.arange(12).reshape(3, 4),
    columns=['A', 'B', 'C', 'D']
)
df

# print
	A	B	C	D
x	0	1	2	3
y	4	5	6	7
z	8	9	10	11

# 删除行
# 方式一: 按照label行名删除行
df.drop(['x', 'y'], axis=0)

# 方式二: 按照index直接删除行
df.drop(index=['x', 'y'])

# print
	A	B	C	D
z	8	9	10	11


# 删除列
# 方式一: 按照label列名删除列
df.drop(['B', 'C'], axis=1)

# 方式二: 按照columns直接删除列
df.drop(columns=['B', 'C'])

# 方式一变种: 按照列索引获取列名label 删除列
drop_columns = df.columns[[1, 2]]  # 获取列名
df.drop(drop_columns, axis=1)

# print
	A	D
x	0	3
y	4	7
z	8	11
```

### 获取满足条件的行列索引

```python
# 要删除列“score”<50的所有行：
df = df.drop(df[df.score <50].index)
 
df.drop(df[df.score <50].index, inplace=True)

# 多条件情况
# 可以使用操作符：| 只需其中一个成立, & 同时成立, ~ 表示取反，它们要用括号括起来。
# 例如删除列 score<50 和 score>20 的所有行
df = df.drop(df[(df.score <50) & (df.score >20)].index)
```

### 得到某一值所在的行索引

```python 
# 找到指定数值所在行索引：
# 比如2012年所在的行索引
index = df[df.year == 2012].index.tolist()[0]  
print(index)  
# 找到索引号为3月份的值
value = df.month.loc[3]
print(value)  # 4

# rt_start的索引 rt_end的索引
rt_start_index = df[df.loc[:, 0] == rt_start].index.tolist()[0]
rt_end_index = df[df.loc[:, 0] == rt_end].index.tolist()[0]
```



### 分组求和

```python
import pandas as pd

l = [[1, 2, 3], [1, None, 4], [2, 1, 3], [1, 2, 2]]
df = pd.DataFrame(l, columns=["a", "b", "c"])

# 不包括 NA 默认设置为dropna=True
df.groupby(by=["b"]).sum()

# 包括 NA
df.groupby(by=["b"], dropna=False).sum()
```

### 过滤数据filter

```python
import pandas as pd
import numpy as np
df = pd.DataFrame(np.array(([1, 2, 3], [4, 5, 6])),
                  index=['mouse', 'rabbit'],
                  columns=['one', 'two', 'three'])

df.filter(items=['one', 'three'])

# 正则表达式
df.filter(regex='e$', axis=1)

# 选择行包含"bbi"
df.filter(like='bbi', axis=0)
```

### 过滤列

```python

import pandas as pd
import os
filename_list = []
for j in os.listdir('../in'):
    if os.path.splitext(j)[1] == '.csv':
        filename_list.append(j)
print("filename_list----------", filename_list)
print(len(filename_list))

for filename in filename_list:
    QC_data.to_csv('../out/QC_' + filename, index=False)  # 2.写文件
```



### 列名添加前缀后缀

```python
import pandas as pd

df = pd.DataFrame({'A': [1, 2, 3, 4], 'B': [3, 4, 5, 6]})

# 给列名添加前缀
df.add_prefix('col_')


df = pd.DataFrame({'A': [1, 2, 3, 4], 'B': [3, 4, 5, 6]})
# 给列名添加后缀
df.add_suffix('_col')
```

### 按照值排序

```python
import pandas as pd
import numpy as np

df = pd.DataFrame({
    'col1': ['A', 'A', 'B', np.nan, 'D', 'C'],
    'col2': [2, 1, 9, 8, 7, 4],
    'col3': [0, 1, 9, 4, 2, 3],
    'col4': ['a', 'B', 'c', 'D', 'e', 'F']
})

# 按照一列排序
df = df.sort_values(by=['col1'])

# 多列排序
df = df.sort_values(by=['col1', 'col2'])

# 降序
df = df.sort_values(by='col1', ascending=False)

# 放NAs到第一位
df = df.sort_values(by='col1', ascending=False, na_position='first')

# 按键功能排序
df = df.sort_values(by='col4', key=lambda col: col.str.lower())
```

### 按照指定的顺序排序

```python
# DataFrame按某种指定顺序排序

import pandas as pd

filter_info = 'feature'  # 要过滤的字段
input_filename = 'test.csv'  # 要过滤的信息表
output_filename = 'filter_' + input_filename  # 过滤后输出的文件

# 指定排列顺序
sort_list = ["NB01","NB02","NB03","NB04","NB05","NB06","NB07","NB08","NB09","NB10","DS01","DS02","DS03","DS04","DS05","DS06","DS07","DS08","DS09","DS10","DS11"]

# 筛选信息表
df = pd.read_csv(input_filename, encoding='gbk')
df.index = df[filter_info]
df_sort = df.loc[sort_list]

df_sort.to_csv(output_filename, index=False)
```



### 获取上级文件夹的名称

```python
os.getcwd().split('\\')[-1]
```

### 获取路径下所有的csv文件名

```python
import os

csv_filename_list = []
root_path = './data'
for j in os.listdir(root_path):
    if os.path.splitext(j)[1] == '.csv':
        csv_filename_list.append(j)
print("csv_filename_list----------", csv_filename_list)
```

### 目录不存在时创建文件夹

```Python
dirs = './data'
if not os.path.exists(dirs):
    os.makedirs(dirs)
    print("data文件夹 创建成功!\n")
```

### 数据去重

```python
DataFrame.drop_duplicates(subset=None, keep=‘first’, inplace=False)

subset : 用来指定特定的列，默认所有列
keep : 删除重复项并保留第一次出现的项
inplace : 是直接在原来数据上修改还是保留一个副本 默认是False 直接修改

# 1、整行去重。
DataFrame.drop_duplicates()
# 2、按照其中某一列去重
DataFrame.drop_duplicates(subset='列名')
# 3、只要是重复的数据，我都删除（例如有三个数字 1,2,1 执行之后变成 2, 重复的都删除了）
DataFrame.drop_duplicates(keep=False)
```

### 分组求每组中出现频率最高的键

```python
data.groupby('feature').transform(lambda x: Counter(x).most_common(1)[0][0])
```

### dataframe转为数字

```python
res2.iloc[1:,i].astype(float)
```

### 合并两个文件里对应的列

```python
import pandas as pd
res1 = pd.read_csv('11.csv',header=None,float_precision='round_trip')
res2 = pd.read_csv('22.csv',header=None,float_precision='round_trip')

x = None
for i in range(len(res1.values[0])):
    # 连接两个dataframe
    res = pd.concat([res1.iloc[:,i], res2.iloc[:,i]],axis=1)  # axis=1 时，组成一个DataFrame
    # print(res)
    x = pd.concat([x, res],axis=1)
x.to_csv('sample.csv', index=False, header=None, mode='a+')
```

### 第一列除以第二列 得到第三列

```python

import pandas as pd
res1 = pd.read_csv('./Analyst/QC_negdata_lot5.csv',header=None,float_precision='round_trip')
res2 = pd.read_csv('./Skyline/QC_neg_run5_final_all_area.csv',header=None,float_precision='round_trip')
res1 = res1.drop(0, axis=1)
x = None
# 每两列做运算 第一列除以第二列,结果追加到这两列之后
for i in range(len(res1.values[0])):
    # 两个csv文件对应元素互相连接 之后得到3个dataframe进行连接
    res = pd.concat([res1.iloc[:,i], res2.iloc[:,i], round(res1.iloc[1:,i].astype(float) / res2.iloc[1:,i].astype(float), 2)],axis=1)  # axis=1 时，组成一个DataFrame
    x = pd.concat([x, res], axis=1)
x.to_csv('neg_run5.csv', index=False, header=None, mode='a+')
```

### 计算每一列的均值

```python
import numpy as np
import pandas as pd

df = pd.DataFrame(
    {'var1': np.random.rand(100),  # 生成100个0到1之间的随机数
     'var2': 100,
     'var3': np.random.choice([20, 30, 90])  # 在这几个数之间选择
     })
print(df)
for col in df.columns:
    print("%.2f" % df[col].mean())  # 计算每列均值
```

### 计算RSD

```python
# 过滤QC数据
qc_neg_df = neg_df.filter(regex="_QC_QC")
# 计算RSD 标准差/均值*100
# print(qc_neg_df.mean(axis=1))  # 计算每一行的平均数
# print(qc_neg_df.std(axis=1))  # 计算每一行的标准差
RSD = round(qc_neg_df.std(axis=1) / qc_neg_df.mean(axis=1) * 100, 2)
```



### 设置保留2位小数

```python
df = pd.read_csv(filepath + filename, sep='\t', header=None, names=['time', 'height', 'data1', 'data2'])
df = df.round({'time': 2})  # 设置某列的精度
df = df.round(5)  # 设置所有列的精度

# 设置多列的精度
# 添加两列
df['sub_half_window'] = df['ExpectRT'] - rt_half_window
df['add_half_window'] = df['ExpectRT'] + rt_half_window
df = df.round({'sub_half_window': 2, 'add_half_window': 2})
```

### 修改某一行的数据

```python
import pandas as pd

half_peak_width = 0.15
neg_ion_list_filename = 'pos_ion_list_20210111.csv'
df = pd.read_csv(neg_ion_list_filename, float_precision='round_trip')
df.set_index(['ID'], inplace=True, drop=False)  # 将ID列设置为索引 进行检索

feature = 'X166'
RT = '2.6'
Start = '2.5'
End = '2.7'

df.loc[feature, 'RT'] = RT
df.loc[feature, 'Start'] = Start
df.loc[feature, 'End'] = End

df.to_csv('final_' + neg_ion_list_filename, index=False)
```

### 按字母顺序排序

```python
# 方式一
df_ion_list = pd.read_csv(ion_list_path).sort_values(by='Feature')
feature_list = df_ion_list['Feature'].values.tolist()

# 方式二
feature = pd.read_csv(ion_list_path).sort_values(by='Feature').iloc[:, 0]
feature = pd.DataFrame(feature, index=None).rename(columns={'Feature': 'feature'}).reset_index().iloc[:, 1]
```

### 交换两列的位置

```python
# 交换两列的位置 (先删后插)
temp = df['popularity']
df.drop(labels=['popularity'], axis=1, inplace=True)
df.insert(0, 'popularity', temp)
df

# 方法2
df[df.columns[[1, 0]]]
```

### 统计列中每个值出现的次数

```python
df['grammer'].value_counts()

# 等价于
from collections import Counter
print(Counter(list(df['grammer'])))
```

### 缺失值的处理

```python
一般的处理方法：
isnull和notnull：检测是否是空值，可用于df和series

dropna：丢弃、删除缺失值

axis : 删除行还是列，{0 or ‘index’, 1 or ‘columns’}, default 0

how : 如果等于any则任何值为空都删除，如果等于all则所有值都为空才删除

inplace : 如果为True则修改当前df，否则返回新的df

fillna：填充空值
value：用于填充的值，可以是单个值，或者字典（key是列名，value是值）

method : 等于ffill使用前一个不为空的值填充forword fill；等于bfill使用后一个不为空的值填充backword fill

axis : 按行还是列填充，{0 or ‘index’, 1 or ‘columns’}

inplace : 如果为True则修改当前df，否则返回新的df
```




### 按照某一列进行去重复值

```python
df.drop_duplicates(['grammer'])
```



### 统计列中每个字符串的长度

```python
df['len_str'] = df['grammer'].map(lambda x: len(x))
```

### 字符串转为浮点型数据

```python
# ['1.88', '0.76', '2.63']  ->  [1.88, 0.76, 2.63]
print(df[1].astype('float64').tolist())  # float64要加引号
```

### 宽数据转长数据

```python
import pandas as pd

df = pd.read_csv('D4.csv')
res = df.melt(
    id_vars=["feature"],  # 要保留的主字段
    var_name="Sample",  # 拉长的分类变量
    value_name="value"  # 拉长的度量值名称
)
```

![image-20210326174308540](C:\Users\cuite\AppData\Roaming\Typora\typora-user-images\image-20210326174308540.png)

![image-20210326174320346](C:\Users\cuite\AppData\Roaming\Typora\typora-user-images\image-20210326174320346.png)

### 长数据转宽数据

```python
res.pivot_table(
    index=["feature"],  # 行索引（可以使多个类别变量）
    columns=["Sample"],  # 列索引（可以使多个类别变量）
    values=["value"]  # 值（一般是度量指标）
)
```

### 长数据转宽数据2

长数据

| feature | pred_validation_y |
| ------- | ----------------- |
| DS01    | 3.3               |
| DS01    | 3.3               |
| DS01    | 3.3               |
| DS02    | 5.23              |
| DS02    | 5.23              |
| DS02    | 5.23              |

宽数据

| DS01 | DS02 |
| ---- | ---- |
| 3.3  | 5.23 |
| 3.3  | 5.23 |
| 3.3  | 5.23 |

```python
import pandas as pd

df = pd.read_csv('test1.csv')

res = None
name_list = []
for name, group in df.groupby('feature'):
    tmp = pd.DataFrame(list(group['pred_validation_y']))
    name_list.append(name)
    res = pd.concat([res, tmp], axis=1)
# 保存文件
res.to_csv('test1_result.csv',index=False, header=name_list)
```



### 合并多个文件(列相同)

```python
# 有列名时
import pandas as pd
import os

root_path = "folder"
header = pd.read_csv(os.path.join(root_path, os.listdir(root_path)[0]), header=None).values[0, :]
res = None
for file in os.listdir(root_path):
    file_path = os.path.join(root_path, file)
    df = pd.read_csv(file_path)
    res = pd.concat([res, df], axis=0)
print(res)
res.to_csv('res.csv', index=False, header=header)
print('success')

# 无列名时
import pandas as pd
import os

root_path = "folder"
res = None
for file in os.listdir(root_path):
    file_path = os.path.join(root_path, file)
    df = pd.read_csv(file_path, header=None)
    res = pd.concat([res, df], axis=0)
print(res)
res.to_csv('merge.csv', index=False, header=False)
print('success')
```

### 每个文件取一行元素合并文件

```python
import pandas as pd
res1 = pd.read_csv('1.csv', float_precision='round_trip')
res2 = pd.read_csv('2.csv', float_precision='round_trip')

res1 = res1.iloc[:, 0]
res2 = res2.iloc[:, 0]

res = None
for i in range(len(res1)):
    tmp = pd.concat([res1[[i]], res2[[i]]], axis=0)
    res = pd.concat([res, tmp], axis=0)
res = pd.DataFrame(res)
res.to_csv('res.csv', index=False)
```

### 转置csv

```python
import pandas as pd

df = pd.read_csv('tmp.csv')
df_t = df.T
df_t.to_csv('tmp_t.csv', header=None)
```

### 按照顺序过滤信息

```python
import pandas as pd

filter_info = 'sample_name'  # 要过滤的字段
filter_info_filename = 'sample_name.csv'  # 要过滤的信息表
all_info_filename = 'rt.csv'  # 全部信息表
res_filename = 'filter_' + all_info_filename  # 过滤后输出的文件

# 筛选信息表
df1 = pd.read_csv(filter_info_filename, encoding='gbk')
df1 = df1[filter_info]

# 全部信息表
df2 = pd.read_csv(all_info_filename)

# 合并
df_merge = pd.merge(left=df1, right=df2, left_on=filter_info, right_on=filter_info)
df_merge.to_csv(res_filename, index=False)
```

### 转换格式 - 长转宽

```python
import numpy as np
import pandas as pd

filename_list = ['5batch_rt_neg.csv']

for filename in filename_list:
    # 读csv文件
    input_data = np.array(pd.read_csv(filename))
    # 化合物名称,样本名称,面积
    feature = input_data[:, 0]
    sample = input_data[:, 1]
    area = input_data[:, 2]

    tuples = list(zip(*[list(feature), list(sample)]))  # 将数据组织成元组的格式
    index = pd.MultiIndex.from_tuples(tuples, names=['feature', 'second'])  # 对数据添加多个索引值

    area = pd.DataFrame(area, columns=['area'])
    df = pd.DataFrame(area.values, index=index, columns=['Area'])  # 设置列名

    stacked = df.stack()  # 堆叠stack
    res = stacked.unstack(1)  # 取消堆叠

    # 写入csv文件
    res.to_csv('final_area_' + filename)
```

### 修改数值

```python
df_area_modify = pd.read_csv(write_filename)
df_area_modify.set_index(['Feature'], inplace=True, drop=False)  # 将Feature列设置为索引 进行检索
df_area_modify.loc[ion_feature, folder] = res_peak_area
df_area_modify.to_csv(write_filename, index=False)

# 查找记录 进行修改
df.loc[df['value'] < 1000, 'value'] = 1000
```

### 将csv文件读为列表元素

``sample.csv``

```python
sample_name
B01_ISBLK_1
Q01_N_202009001Y_1
Q01_NC10_202009001Y_1
Q01_NC20_202009001Y_1
Q01_NC30_202009001Y_1
Q01_NC40_202009001Y_1
Q01_NC50_202009001Y_1
Q01_NC75_202009001Y_1
Q01_C_202009001Y_1
B01_ISBLK_2
```

```python
import pandas as pd

# 有列名 header
sample_name_list = pd.read_csv('sample.csv').iloc[:, 0].values.tolist()
sample_name_list

['B01_ISBLK_1',
 'Q01_N_202009001Y_1',
 'Q01_NC10_202009001Y_1',
 'Q01_NC20_202009001Y_1',
 'Q01_NC30_202009001Y_1',
 'Q01_NC40_202009001Y_1',
 'Q01_NC50_202009001Y_1',
 'Q01_NC75_202009001Y_1',
 'Q01_C_202009001Y_1',
 'B01_ISBLK_2']


# 无列名 header
sample_name_list = pd.read_csv('sample.csv', header=None).iloc[:, 0].values.tolist()
sample_name_list


['S01_fresh_0h_sample1_1_1',
 'S01_fresh_0h_sample1_1_2',
 'S01_fresh_0h_sample1_2_1',
 'S01_fresh_0h_sample1_2_2',
 'S01_fresh_0h_sample1_3_1',
 'S01_fresh_0h_sample1_3_2',
 'S01_fresh_0h_sample2_1_1',
 'S01_fresh_0h_sample2_1_2',
 'S01_fresh_0h_sample2_2_1',
 'S01_fresh_0h_sample2_2_2',
 'S01_fresh_0h_sample2_3_1',
 'S01_fresh_0h_sample2_3_2',
 'S01_fresh_0h_sample3_1_1',
 'S01_fresh_0h_sample3_1_2',
 'S01_fresh_0h_sample3_2_1',
 'S01_fresh_0h_sample3_2_2',
 'S01_fresh_0h_sample3_3_1',
 'S01_fresh_0h_sample3_3_2']
```

### 实现主窗口隐藏

```python
from tkinter import Tk
from tkinter import messagebox

try:
    pass
except Exception as e:
    print(e)
	root = Tk()
    root.withdraw()  # 实现主窗口隐藏
    messagebox.showerror("Error", "Error Message:\n%s \n xxx_ion_list not found !" % e)  # 显示错误
```

### 将预测结果输出为csv

```python
minus = (pred_test_y - test_y).round(2)
minus_abs = abs(pred_test_y - test_y).round(2)
# 将预测的结果 组织成字典的形式 - 预测的结果是numpy的ndarray类型
df = pd.DataFrame({
    'feature': feature_headers[i],
    'test_y': test_y, 
    'pred_test_y':pred_test_y, 
    'minus':minus, 
    'minus_abs':minus_abs
})
print(df)
```

### 计算R-Square

```python
# 最少三个点 两个点永远为1
from scipy import stats
import pandas as pd

df = pd.read_csv('test.csv')
test_x = df.iloc[0, 1:3].tolist()
test_y = df.iloc[0, 3:5].tolist()

def rsquared(x, y): 
    slope, intercept, r_value, p_value, std_err = stats.linregress(x, y) 
#     print("使用scipy库：a：",slope,"b：", intercept,"r：", r_value,"r-squared：", r_value**2)
    print("r：", r_value,"r-squared：", r_value**2)

rsquared(test_x, test_y)
```

### 提取众数

```python
import pandas as pd

df = pd.read_csv('20210607_oldMS_run1_pos_new_rt_merge.csv')
feature = df.iloc[:, 0]
df = df.iloc[:, 1:]  # 去掉第一列feature

mode_list = []
for i in range(df.shape[0]):
    mode = 0
    x = df.iloc[i, :].value_counts()
    x = dict(x)
    key_count = len(x)  # 字典中键的个数
    first_key = list(x.keys())[0]  # 字典中的第一个键
    
    # 1.如果键的个数为1
    if key_count == 1:
        # 众数为这个键
        mode = first_key
    # 2.如果键的个数大于1
    elif key_count > 1:
        # 判断第一个键是否为0  若为0, 则找下一个键
        if first_key == 0:
            mode = list(x.keys())[1]
        # 若不为0, 则为第一个键
        else:
            mode = first_key
    # 3.键的个数小于0 报错
    else:
        print("Error: 键的个数小于0")
    mode_list.append(mode)

# 输出文件
df = pd.DataFrame({
    'feature': feature,
    'mode': mode_list
})
df.to_csv('pos_rt_mode_result.csv', index=False)
```

### 计算RSD并保存文件

```python
import os
import pandas as pd
import configparser
from tkinter import Tk, messagebox
from pathlib import Path
import sys

root = Tk()
config = configparser.ConfigParser()
config.read('config.ini')
batch = config['batch_info']['batch']

# 相关路径
root_path = Path.cwd()
neg_file_root_path = root_path.joinpath(batch, 'neg')
pos_file_root_path = root_path.joinpath(batch, 'pos')

# neg文件所在路径
neg_area_merge_file_path = ""
for i in os.listdir(neg_file_root_path):
    if i.endswith('neg_area_merge.csv'):
        neg_area_merge_file_path = neg_file_root_path.joinpath(i)

# pos文件所在路径
pos_area_merge_file_path = ""
for i in os.listdir(pos_file_root_path):
    if i.endswith('pos_area_merge.csv'):
        pos_area_merge_file_path = pos_file_root_path.joinpath(i)

neg_df = pd.read_csv(neg_area_merge_file_path)
pos_df = pd.read_csv(pos_area_merge_file_path)


# 计算QC样本的RSD
def calc_qc_rsd(df):
    feature = df.iloc[:, 0]
    # 过滤QC数据
    qc_df = df.filter(regex="_QC_QC")
    # 计算RSD 标准差/均值*100
    RSD = round(qc_df.std(axis=1) / qc_df.mean(axis=1) * 100, 2)

    RSD = RSD.to_frame(name='QC_RSD')  # 将Series转为DataFrame
    qc_df = pd.concat([feature, qc_df], axis=1)
    res = pd.concat([qc_df, RSD], axis=1)
    res = res.sort_values(by=['QC_RSD'], ascending=False)  # 降序
    return res


neg_res = calc_qc_rsd(neg_df)
pos_res = calc_qc_rsd(pos_df)
neg_res.to_csv(os.path.join(neg_file_root_path, 'neg_QC_RSD2.csv'), index=False)
pos_res.to_csv(os.path.join(pos_file_root_path, 'pos_QC_RSD2.csv'), index=False)
```

### df一列升序一列降序

```python
import pandas as pd

df = pd.DataFrame({
    'a': [1,1,1,1,2,2,2,2],
    'b': list(range(8)),
    'c': list(range(8, 0, -1))
})
df
	a	b	c
0	1	0	8
1	1	1	7
2	1	2	6
3	1	3	5
4	2	4	4
5	2	5	3
6	2	6	2
7	2	7	1

### 多列升序
df.sort_values(['a', 'c'])

	a	b	c
3	1	3	5
2	1	2	6
1	1	1	7
0	1	0	8
7	2	7	1
6	2	6	2
5	2	5	3
4	2	4	4

### 一列降序, 一列升序
df.sort_values(['a', 'c'], ascending=(False, True))

	a	b	c
7	2	7	1
6	2	6	2
5	2	5	3
4	2	4	4
3	1	3	5
2	1	2	6
1	1	1	7
0	1	0	8
```

### 防止精度过高

```python
data = pd.read_csv(filename, encoding='utf-8', float_precision='round_trip')
```

### csv里的数据保留小数点后3位

```python
df.to_csv('res.csv', index=False, float_format='%.3f')
```

### 多列数据乘以一列

```python
import pandas as pd
import numpy as np

df = pd.read_csv('基线积分结果.csv')
raw = df.shape[0]
rate = df.iloc[:, 1]
rate = np.array(rate).reshape(raw, 1)  # 一列Series, 先转为numpy.array, 再转换为纵向的格式
li = df.filter(regex='_QC_QC', axis=1).columns  # 过滤需要的列的列名
print(len(li))
df[li] = (df[li] * rate).astype(int)  # 多列乘以一列 值赋给过滤的多列
df.to_csv("res2_基线积分结果.csv", index=False)
```

### 判断df、list是否为空

```python
1、判断dataframe是否为空
    如果df为空，则 df.empty 返回 True，反之 返回False。
    if not df.empty:
        pass

2、判断list是否为空
	if len(all)=0 为空，否则为非空
```

### 将series赋值给新增加的数列

```python
gz2_index_list = get_gz2()
# 在指定的index行, 追加一列数据1
df_test_data['gz2_find'] = pd.Series(data=1, index=gz2_index_list)
```

### 查找过滤数据

```python
# 多个条件筛选的时候每个条件都必须加括号
tmp = df_test_data[
    ((df_test_data['mzmin'] < mz_list[i]) & (df_test_data['mzmax'] > mz_list[i]))
    &
    ((df_test_data['rtmin'] < rt_list[i]) & (df_test_data['rtmax'] > mz_list[i]))
]
```

### 按照索引追加新数据

```python
import pandas as pd

df = pd.read_csv('test.csv')
zip_list = [(2, 1), (3, 2), (3, 9)]
df['add'] = ''  # 添加新列
for item in zip_list:
    add_idx = item[0]
    add_value = item[1]

    if not df.loc[add_idx, 'add']:
        df.loc[add_idx, 'add'] = str(add_value)
    else:
        df.loc[add_idx, 'add'] = str(df.loc[add_idx, 'add']) + ', ' + str(add_value)
print("\ndf----------\n", df)
```

```python
# test.csv
idx,a,b,c,d
0,1,2,3,4
1,1,2,4,5
2,1,2,5,6
3,1,2,6,7
4,1,2,7,8

# 输出
idx,a,b,c,d,add
0,1,2,3,4,
1,1,2,4,5,
2,1,2,5,6,1
3,1,2,6,7,"2, 9"
4,1,2,7,8,
```

### 插入一列到第一列

```python
import pandas as pd

df = pd.read_csv('tmp_neg_validation_pred.csv')
df_validation = pd.read_csv('neg_validation_data.csv')
sample = df_validation.iloc[:, 0]  # 获得第一列

res = None
name_list = []
for name, group in df.groupby('feature'):
    tmp = pd.DataFrame(list(group['pred_validation_y']))
    name_list.append(name)
    res = pd.concat([res, tmp], axis=1)
res.columns = name_list  # 赋予列名
# 插入样本列到第一列
col_name = res.columns.tolist()
col_name.insert(0, 'sample')
res = res.reindex(columns = col_name)
res['sample'] = sample
# 保存文件
res.to_csv('neg_validation_pred_by_sample.csv',index=False)
print('neg_validation_pred_by_sample.csv 生成成功')
```



### 给index列添加列名

```python
# 给index列添加列名 index_label="feature"
res_qc_rt_rsd.to_excel(writer, sheet_name=ion + "_QC样本RT的RSD", index_label="feature")
```

### 计算QC样本RT的RSD的知识点

```python
# 包含QC样本的样本名
df[df['sample_number'].str.contains('_QC_')]['sample_number']

# 查询包含QC样本的样本的feature的new_rt 并转换为dataframe
each_feature_qc_df = df[(df['sample_number'].str.contains('_QC_')) & (df['ion_code'] == feature)][
            'new_rt'].to_frame(name=feature)

# 设置数据的索引
each_feature_qc_df.index = qc_sample_list

# 计算rsd 标准差/均值*100
each_rsd = round(each_feature_qc_df.std(axis=0) / each_feature_qc_df.mean(axis=0) * 100, 2).to_frame(
            'QC_RT_RSD')

# 根据条件添加一列 判断x的值 如果小于0.8, 赋值为1; 否则赋值为0
result['check_result'] = result['QC_RT_RSD'].apply(lambda x: 1 if x <= 0.8 else 0)  

# 按照某一列的值降序排序 如果有空值, 则排在最前面
result = result.sort_values(by=['QC_RT_RSD'], ascending=False, na_position='first')  

```
