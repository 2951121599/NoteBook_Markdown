## Python数据异常值检测和处理

数据清洗中的另一个常见问题：**异常值检测和处理**

### 1 什么是异常值？

在机器学习中，**异常检测和处理**是一个比较小的分支，或者说，是机器学习的一个副产物，因为在一般的预测问题中，**模型通常是对整体样本数据结构的一种表达方式，这种表达方式通常抓住的是整体样本一般性的性质，而那些在这些性质上表现完全与整体样本不一致的点，我们就称其为异常点**，通常异常点在预测问题中是不受开发者欢迎的，因为预测问题通产关注的是整体样本的性质，而异常点的生成机制与整体样本完全不一致，如果算法对异常点敏感，那么生成的模型并不能对整体样本有一个较好的表达，从而预测也会不准确。

**从另一方面来说，异常点在某些场景下反而令分析者感到极大兴趣**，如疾病预测，通常健康人的身体指标在某些维度上是相似，如果一个人的身体指标出现了异常，那么他的身体情况在某些方面肯定发生了改变，当然这种改变并不一定是由疾病引起（通常被称为噪音点），但异常的发生和检测是疾病预测一个重要起始点。

### 2 异常值的检测方法

一般异常值的检测方法有基于统计的方法，基于聚类的方法，以及一些专门检测异常值的方法等，下面对这些方法进行相关的介绍。

#### 2.1 简单统计

如果使用`pandas`，我们可以直接使用`describe()`来观察数据的统计性描述（只是粗略的观察一些统计量），不过统计数据为连续型的，或者简单使用散点图也能很清晰的观察到异常值的存在。

#### 2.2 3∂原则

这个原则有个条件：**数据需要服从正态分布。**在3∂原则下，异常值如超过3倍标准差，那么可以将其视为异常值。正负3∂的概率是99.7%，那么距离平均值3∂之外的值出现的概率为`P(|x-u| > 3∂) <= 0.003`，属于极个别的小概率事件。如果数据不服从正态分布，也可以用远离平均值的多少倍标准差来描述。

##### 应用

```python
# pandas读取包含header的csv文件
# 计算每一列中1到倒数第一行的满足小于最后一行的数据的均值
import pandas as pd

df = pd.read_csv('./三倍标准差/GMI.csv', encoding='gbk')

df_new = None
for i in range(1, len(df.columns)):
    each_column = df[df.columns[i]]
    mask = each_column < df.iloc[-1, i]
    df_new = pd.concat([df_new, each_column[mask]], axis=1)  # 得到小于最后一行3倍标准差的数据
    # print(each_column[mask].mean())  # 计算均值
    print(each_column[mask].std())  # 计算标准差
df_new = pd.concat([df.iloc[:, 0], df_new], axis=1)
df_new.to_csv('./三倍标准差/GMI_new.csv', index=False)
```



#### 2.3 箱型图

这种方法是利用箱型图的**四分位距（IQR）**对异常值进行检测。四分位距(IQR)就是上四分位与下四分位的差值。而我们通过IQR的1.5倍为标准，规定：超过**（上四分位+1.5倍IQR距离，或者下四分位-1.5倍IQR距离）**的点为异常值。箱型图的定义如下：

![img](https://pic1.zhimg.com/80/v2-718d499e25dcf986ddcf9a903a869fdc_1440w.jpg)



![img](https://pic1.zhimg.com/80/v2-102271f32f83a0429a7472a82010e5e4_1440w.jpg)

数列的四分位中：

- 四分位距 IQR = Q3 – Q1
- 下界 Lower Limit = Q1 – 1.5 IQR.
- 上界 Upper Limit = Q3 + 1.5 IQR

下界 Lower Limit 和 上界 Upper Limit 之外的数据为异常值。

##### 代码实现

```python
import pandas as pd

df = pd.read_csv('https://www.gairuo.com/file/data/team.csv')
df.head()
'''
    name team   Q1   Q2   Q3  Q4
0  Liver    E  555   21   24  64
1   Arry    C   36  888   37  57
2    Ack    A   57   60 -111  84
3  Eorge    C   93   96   71  78
4    Oah    D   65   49   61  86
'''

# 构造异常值
df.at[0, 'Q1'] = 555
df.at[1, 'Q2'] = 888
df.at[2, 'Q4'] = -111

# 检测到异常值置为 nan
def box_plot_outliers(s):
    q1, q3 = s.quantile(.25), s.quantile(.75)
    iqr = q3 - q1
    low, up = q1 - 1.5*iqr, q3 + 1.5*iqr
    outlier = s.mask((s<low) | (s>up))
    return outlier

# 应用
df.head().loc[:, 'Q1':].apply(box_plot_outliers)
'''
     Q1    Q2    Q3  Q4
0   NaN  21.0  24.0  64
1  36.0   NaN  37.0  57
2  57.0  60.0   NaN  84
3  93.0  96.0  71.0  78
4  65.0  49.0  61.0  86
'''
```

##### 应用

```python
import pandas as pd

df = pd.read_csv('四分位法/GMI.csv', encoding='gbk')
print(df.head())


# 检测到异常值置为 nan
def box_plot_outliers(s):
    q1, q3 = s.quantile(.25), s.quantile(.75)
    iqr = q3 - q1
    low, up = q1 - 1.5*iqr, q3 + 1.5*iqr
    # outlier = s.mask((s < low) | (s > up))  # 考虑上下限
    outlier = s.mask(s > up)  # 只考虑上限
    return outlier


# 应用
df_filter = df.iloc[:, 1:].apply(box_plot_outliers)
print(df_filter)

copy_df_filter = df_filter.copy()  # 拷贝

# 计算每一列的均值
df_filter.loc['mean'] = df_filter.apply(lambda x: x.mean())
# 计算每一列的标准差
df_filter.loc['std'] = df_filter.apply(lambda x: x.std())
# 计算每一列的95%置信区间
df_filter.loc['ci'] = copy_df_filter.apply(lambda x: x.mean()) + (1.96 * copy_df_filter.apply(lambda x: x.std()))

# 输出结果
print(df_filter)
df_filter.to_csv('四分位法/GMI_result.csv', index=False)
```



### 3 异常值的处理方法

检测到了异常值，我们需要对其进行一定的处理。而一般异常值的处理方法可大致分为以下几种：

- **删除含有异常值的记录：**直接将含有异常值的记录删除；
- **视为缺失值：**将异常值视为缺失值，利用缺失值处理的方法进行处理；
- **平均值修正：**可用前后两个观测值的平均值修正该异常值；
- **不处理：**直接在具有异常值的数据集上进行数据挖掘；

是否要删除异常值可根据实际情况考虑。因为一些模型对异常值不很敏感，即使有异常值也不影响模型效果，但是一些模型比如逻辑回归LR对异常值很敏感，如果不进行处理，可能会出现过拟合等非常差的效果。

通过一些检测方法我们可以找到异常值，但所得结果并不是绝对正确的，具体情况还需自己根据业务的理解加以判断。同样，对于异常值如何处理，是该删除，修正，还是不处理也需结合实际情况考虑，没有固定的做法。