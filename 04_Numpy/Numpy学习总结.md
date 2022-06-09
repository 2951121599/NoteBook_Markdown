# Numpy学习总结

### 获取数据的行数和列数

```python
np.shape(csv_data)[0]  # 行
np.shape(csv_data)[1]  # 列
```



### 生成csv文件

```python
np.savetxt(filename, data, fmt='%s', delimiter=',')

# eg:
np.savetxt('final_Ipooled_CV.csv', res1, fmt='%s', delimiter=',')  # numpy.array写文件
```



### 读取文件

```python
input_data = pd.read_csv('final_area.csv').values  # 读文件 不包含header
# 必须添加header=None，否则默认把第一行数据处理成列名删除导致缺失
col = pd.read_csv('final_area.csv',header=None).values[1:,0:2]  # 前两列数据(去除第一行)
row = pd.read_csv('final_area.csv',header=None).values[0,:]  # 第一行行名
```



### 删除某一列

```Python
res1 = np.delete(data, col_index, axis=1)

# eg:
res1 = np.delete(res1, -5, axis=1)
```



### 行列合并相关

```Python
row = np.concatenate((row,['Ipooled_CV']))  # 给原有的列名增加一列 concatenate绑定数据 元组
res = np.column_stack((col,input_data,Ipooled_CV))  # 合并列(列上追加)
res1 = np.row_stack((row,res))  # 合并行(行上追加)
```



### 标准差/均值的计算

```python
std = np.std(yx01Ipooled, axis=1)  # 计算标准差 axis=1是在行方向上进行计算
mean = np.mean(yx01Ipooled, axis=1) # 计算平均数
Ipooled_CV = (std/mean) * 100  # 计算cv
```



### 所有列减去某一列

```python
input_data = (input_data.T - ISBLK).T  # 所有列减去ISBLK
```



### 将小于0的置为0

```python
input_data = np.maximum(input_data, 0)  # 将小于0的置为0
```



### 将空值赋值为0

```python
input_data = np.nan_to_num(input_data, nan=0)  # 将空值赋值为0
```



### 矩阵除法

```python
res = np.divide(input_data1,input_data2)  # 做矩阵除法
```

### 设置小数位数

```python
res = res.astype(float)
res = np.around(res, decimals=3) # 设置三位小数

# 设置为int型
peak_area = peak_area.astype(int)
```



### 增删

```python
#%%

import numpy as np

a = np.array([1,2,3,4,5,6])
b = np.array([1,2,3])

# 增: 合并两个ndarray
c = np.hstack((a,b))  # [1 2 3 4 5 6 1 2 3]

#%%

# 删除
for item in b:
    index = np.where(a==item)
    np.delete(a,index)
print(a)

#%%

print(b)
d = np.delete(a, b)  # b为index列表
print(d)
print(a)  # 未变化

#%%

e = np.delete(a,[1,2,3])
print(e)
# 获取元素在类array中的位置索引------以上两个好像没什么不一样
index = [np.argwhere(a == item)[0][0] for item in b]
print(index)

index1 = [np.where(a == item)[0][0] for item in b]
print(index1)
```

### 输出全部array

```python
# print array时array中间是省略号没有
import numpy as np
np.set_printoptions(threshold=np.inf)

# 大量元素情况
# 可以采用set_printoptions(threshold='nan')
set_printoptions(threshold='nan')
```

### numpy 创建 等间隔（等差）数组

```python
np.arange(0.001, 1, 0.001)  #  array([0.001 0.002 0.003 ..... 0.999])
np.arange(1, 9.1, 2)  #  array([1, 3, 5, 7, 9])

# 表示在［1，10］范围等间隔的取6个数，包含区间端点值
np.linspace(1, 10, 6)  # array([ 1. ,  2.8,  4.6,  6.4,  8.2, 10. ])
```

