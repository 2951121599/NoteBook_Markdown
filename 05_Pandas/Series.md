

## Series

### 定义

Series 是一种类似于一维数组的对象, 由一组数据和一组与之相关的数据标签(索引)组成

### 创建方式

```python
pd.Series([1,2,3,4])
pd.Series([1,2,3,4], index=['a','b','c','d'])
pd.Series({'a':1, 'b':2})
pd.Series(0, index=['a','b','c','d'])
```

### 获取值数组和索引数组

values属性和index属性

### Series 列表+字典

#### Series 支持下标索引的特性

- 使用ndarray创建
- 与标量运算 sr * 2
- 两个Series 运算 sr1 + sr2
- 索引 sr[0]
- 切片 sr[0:2]
- 通用函数 np.abs(sr)
- 布尔值过滤 sr[sr>0]

#### Series 支持字典标签的特性

- 使用字典创建
- in运算 'a' in sr
- 键索引 ar['a'] sr[['a','b','c']]

### 数据对齐

pandas 在进行两个Series 对象的运算时, 会按索引进行对齐, 然后计算

### 缺失值处理

dropna 和 fillna

