## Pandas 速记表

> 我们将使用简写``df``作为一个``DataFrame``对象, ``s``作为一个``Series``对象

```python
# 在开始之前先导入这些包
import pandas as pd
import numpy as np
```

### 导入数据

```python
pd.read_csv(filename)  # 读取csv文件
pd.read_table(filename)  # 读取分隔的文本文件 eg:tsv
pd.read_excel(filename)  # 读取excel文件
pd.read_sql(query, connection_object)  # 读取sql表或数据库
pd.read_json(json_string)  # 从JSON中读取数据格式化字符串，URL或文件.
pd.read_html(url)  # 解析一个html URL，字符串或文件，并提取表到一个df列表
pd.read_clipboard()  # 获取剪贴板的内容并将其传递给read_table()
pd.DataFrame(dict)  # 从一个字典读取，键作为列名，值数据作为列表
```

### 导出数据

```python
df.to_csv(filename)  # 写入CSV文件
df.to_excel(filename)  # 写入Excel文件
df.to_sql(table_name, connection_object)  # 写入sql表
df.to_json(filename)  # 以JSON格式写入文件
df.to_html(filename)  # 保存为HTML表
df.to_clipboard()  # 写入到剪贴板
```

### 创建测试对象

```python
pd.DataFrame(np.random.rand(20,5))  # 5列和20行随机数
pd.Series(my_list)  # 从可迭代的my_list创建一个Series序列
df.index = pd.date_range('1900/1/30', periods=df.shape[0])  # 添加一个日期索引
```

### 查看/检查数据

```python
df.head(n)  # 数据帧的前n行
df.tail(n)  # 数据帧的最后n行
df.shape()  # 行数和列数
df.info()  # 索引、数据类型和内存信息
df.describe()  # 数字列的汇总统计
s.value_counts(dropna=False)  # 查看唯一的值和计数
df.apply(pd.Series.value_counts)  # 所有列的唯一值和计数
```

### 筛选数据

```python
df[col]  # 返回带有列标签的列作为Series
df[[col1, col2]]  # 返回列作为新的DataFrame
s.iloc[0]  # 按照位置选择
s.loc[0]  # 按照索引选择
df.iloc[0,:]  # 第一行
df.iloc[0,0]  # 第一列的第一个元素
```

### 数据清洗

```python
df.columns = ['a','b','c']  # 重命名列
pd.isnull()  # 检查为空值的，返回布尔数组
pd.notnull()  # 检查不为空值的，返回布尔数组
df.dropna()  # 删除所有包含空值的行
df.dropna(axis=1)  # 删除所有包含空值的列
df.dropna(axis=1, thresh=n)  # 删除所有小于n个非空值行 即保留非空数值的数量>=n的行
df.fillna(x)  # 用x替换所有空值
s.fillna(s.mean())  # 用平均值替换所有的空值(平均值可以用统计部分中的几乎任何函数替换)
s.astype(float)  # 将Series数据类型转换为浮点数
s.replace(1,'one')  # 将所有等于1的值替换为'one'
s.replace([1, 3], ['one', 'three'])  # 将所有1替换为'one', 3替换为'three'
df.rename(columns=lambda x: x + 1)  # 大量重命名列
df.rename(columns={'old_name': 'new_name'})  # 选择重命名
df.set_index('column_one')  # 设置索引
df.rename(index=lambda x: x + 1)  # 大量重命名索引
```

### 过滤、排序和分组

```python
df[df[col] > 0.5]  # 列col中大于0.5的行
df[(df[col] > 0.5) & (df[col] < 0.7)]  # 列col中0.5 < col < 0.7的行
df.sort_values(col1)  # 按col1的值升序排列
df.sort_values(col2, ascending=False)  # 按col2的值降序排序
df.sort_values([col1, col2], ascending=[True, False])  # 按col1升序排序，然后按col2降序排序
df.groupby(col)  # 返回一个按列col进行分组的groupby对象
df.groupby([col1, col2])  # 返回一个按多列col1, col2进行分组的groupby对象
df.groupby(col1)[col2].mean()  # 返回一个按列col1进行分组, 列col2中值的平均值(平均值可以用统计部分中的几乎任何函数替换)
df.pivot_table(index=col1, values=[col2, col3], aggfunc=mean)  # 创建一个按col1分组的透视表，并计算col2和col3的平均值
df.groupby(col1).agg(np.mean)  # 返回按列col1分组的所有列的平均值
df.apply(np.mean)  # 对每列求平均值
df.apply(np.max, axis=1)  # 对每行求最大值
```

### 连接/组合

```python
df1.append(df2)  # 将df2中的行添加到df1的末尾(列要相同) 对应的column是可以共用的，缺失的部分会使用NaN的方式对齐
pd.concat([df1, df2], axis=1)  # 纵向拼接(行相同)  axis=0,横向拼接
df1.join(df2, on=col1, how='inner')  # sql风格, 将df1中的列与df2上的列按照col1连接起来，how的值可以为 'left', 'right', 'outer', 'inner'
```

### 统计数据

```python
# 这些都可以应用到Series中。
df.describe()  # 数字列的汇总统计
df.mean()  # 返回所有列的平均值
df.corr()  # 返回DataFrame中列之间的相关性
df.count()  # 返回每个DataFrame列中非空值的数量
df.max()  # 返回每列中的最大值
df.min()  # 返回每列中的最小值
df.median()  # 返回每列中的中位数
df.std()  # 返回每列中的标准差
```

