## DataFrame

### 常用属性

- index 索引
- T 转置
- columns 列索引
- values 值数组
- describe() 快速统计
- info() 数据信息

### 位置索引和标签索引

iloc 和 loc

```python
# 1.对列进行索引
df['name']  # 索引取单列
df[['name', 'sex']]  # 取多列

# 2.对行进行索引
df.loc['a']  # 取单行
df.iloc[0]  # 取单行

df.loc[['a', 'b']]  # 取多行
df.iloc[[0, 1]]  # 取多行

# 3.取单个元素
df.loc['a', 'price']
df.iloc[1, 1]

# 4.取多个元素
df.loc[['a', 'b'], 'price']
df.iloc[[1, 2], 1]
```



### 数据对齐

df 对象在运算时, 同样会进行数据对齐, 其行索引和列索引分别对齐

### 缺失值数据

- dropna(axis=0, where='any')
- fillna()
- isnull()
- notnull()

### 常用方法

- mean(axis=0) 对列(行)求平均值
- sum(axis=1) 对列(行)求和
- sort_index() 按列(行)索引排序
- sort_values() 按某一列(行)的值排序
- to_datetime() 转为时间序列类型

### 获取所有标签名

```python
df.columns
```

### 对 df 缺失值进行统计

```python
df.isnull().sum()  # 统计所有有缺失值列的缺失值个数
df['a'].isnull().sum()  # 统计某一列有缺失值的缺失值个数
```

### 去掉缺失值的列

```python
df = df.drop('a', axis=1)
```

### 去掉有缺失值的样本

```python
df = df.dropna(axis=0)
```

### 对缺失值进行填充

```python
df.fillna(np.mean(0))  # 每一列的平均值 也可以直接填0
```







