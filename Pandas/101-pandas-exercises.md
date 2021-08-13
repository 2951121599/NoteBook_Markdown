## 101-pandas-exercises

### 56. 如何交换df的两行

```python
def swap_rows(df, frow, srow):
    print("Previously: \n", df)
    temp = df.iloc[frow].copy()
    df.iloc[frow], df.iloc[srow] = df.iloc[srow], temp
    return df


df = pd.DataFrame(np.arange(25).reshape(5, -1))
swap_rows(df, 1, 2)
```

### 57. 如何反转df的行

```python
df = pd.DataFrame(np.arange(25).reshape(5, -1))

# 方法一
df.iloc[::-1, :]  # df.iloc[::-1]
# 方法二
df.loc[df.index[::-1], :]
```

### 63. 创建在每一行中包含倒数第二大值的列

```python
df = pd.DataFrame(np.random.randint(1,100, 80).reshape(8, -1))

df.assign(penultimate = df.apply(lambda x: sorted(x)[-2], axis=1))
```

### 64. 如何规范df的所有列

1. df通过减去列均值并除以标准偏差来归一化所有列
2. 排列所有列的范围df, 以使每一列的最小值为0且最大值为1

```python
df = pd.DataFrame(np.random.randint(1,100, 80).reshape(8, -1))

out1 = df.apply(lambda x: ((x - x.mean())/x.std()).round(2))
out2 = out1.apply(lambda x: ((x.max() - x)/(x.max() - x.min())).round(2))
```

### 65. 计算每行df与其后一行的相关性

```python
df = pd.DataFrame(np.random.randint(1,100, 80).reshape(8, -1))

[df.iloc[i].corr(df.iloc[i+1]).round(2) for i in range(df.shape[0])[:-1]]
```

### 70. 连接两个df, 使其只有公共行

```python
df1 = pd.DataFrame({'fruit': ['apple', 'banana', 'orange'] * 3,
                    'weight': ['high', 'medium', 'low'] * 3,
                    'price': np.random.randint(0, 15, 9)})

df2 = pd.DataFrame({'pazham': ['apple', 'orange', 'pine'] * 2,
                    'kilo': ['high', 'low'] * 3,
                    'price': np.random.randint(0, 15, 6)})

merged = (pd.merge(df1, df2,
                 how='inner',
                 left_on=['fruit', 'weight'],
                 right_on=['pazham', 'kilo'],
                 suffixes=['_1', '_2'])
         )
merged
```

### 72. 获得两列值匹配的行号

```python
df = pd.DataFrame({'fruit1': np.random.choice(['apple', 'orange', 'banana'], 10),
                    'fruit2': np.random.choice(['apple', 'orange', 'banana'], 10)})

df[df["fruit1"] == df["fruit2"]].index.tolist()
```

### 75. 拆分文本

```python
df = pd.DataFrame(["STD, City   State",
"33, Kolkata    West Bengal",
"44, Chennai    Tamil Nadu",
"40, Hyderabad    Telengana",
"80, Bangalore    Karnataka"], columns=['row'])

df_out = df.row.str.split(',|\t', expand=True)

# 将第一行变为headers
new_header = df_out.iloc[0]  # 获取第0行数据
df_out = df_out[1:]  # 去掉第0行
df_out.columns = new_header
df_out
```

