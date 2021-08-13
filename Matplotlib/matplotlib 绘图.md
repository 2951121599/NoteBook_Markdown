## matplotlib 绘图

### python绘图设置标题、标签，无法显示中文

```python
plt.rcParams['font.sans-serif']=['SimHei']
plt.rcParams['axes.unicode_minus']=False
```

### matplotlib 绘图显示中文

```python
import matplotlib

# 设置matplotlib正常显示中文和负号
matplotlib.rcParams['font.sans-serif']=['SimHei']   # 用黑体显示中文
matplotlib.rcParams['axes.unicode_minus']=False     # 正常显示负号
```

### Matplotlib 绘图

```python
# 绘图
mp.figure('Polynomial Regression', facecolor='lightgray')
mp.title('Polynomial Regression', fontsize=20)
mp.xlabel('x', fontsize=14)
mp.ylabel('y', fontsize=14)
mp.tick_params(labelsize=10)
mp.grid(linestyle=':')
mp.scatter(x, y, c='dodgerblue', alpha=0.75, s=60, label='Sample')
mp.plot(test_x, pred_test_y, c='orangered', label='Regression')
mp.legend()  # To make a legend for a list of lines and labels 图例
mp.show()
```

```python
# 创建一个新图
mp.figure('Polynomial Regression', facecolor='lightgray')
```

### 创建子图-散点图

```python
fig = mp.figure(figsize = (10,6))
ax1 = fig.add_subplot(2,1,1)  # 创建子图1
ax1.scatter(SP01.index, SP01.values, s=7)
mp.grid()
mp.show()
```

### 绘制频率分布图

```python
spikins = pd.DataFrame(spikins)
for i in range(5):
    sp = spikins.iloc[:, i]
    # 统计每个值出现的次数
    items = dict(sp.value_counts())
    bins = len(list(items.keys()))

    mp.hist(sp, bins=bins)  # 频数分布直方图
    mp.title(feature_headers[i+1])
    mp.xlabel('rt')
    mp.ylabel('count')
    mp.show()
```

### 散点图示例

```python
# 散点图示例
import matplotlib.pyplot as mp
import numpy as np

n = 200
# 期望值：期望值是该变量输出值的平均数
# 标准差：是反映一组数据离散程度最常用的一种量化形式，是表示精确度的重要指标
x = np.random.normal(172, 20 ,n ) # 期望值, 标准差, 生成数量
y = np.random.normal(60, 10, n) # 期望值, 标准差, 生成数量

x2 = np.random.normal(180, 20 ,n ) # 期望值, 标准差, 生成数量
y2 = np.random.normal(70, 10, n) # 期望值, 标准差, 生成数量

mp.figure("Persons", facecolor="lightgray")
mp.grid(linestyle=':')
mp.title("Persons Demo")

# 通过d表示每个样本与标准身高体重的距离
d = (x-175)**2+(y-65)**2

# cmap='jet' 颜色映射 数越小越偏蓝 越大越偏红 (具体查表)  c和color只能有一个
mp.scatter(x, y, c=d, cmap='jet', marker="o", alpha=0.7, label='Persons')

mp.legend()
mp.show()
```

![image-20210616173130932](C:\Users\cuite\AppData\Roaming\Typora\typora-user-images\image-20210616173130932.png)



### 生成1920*1080的图像

```python
mp.figure(dpi=300,figsize=(6.4,3.6))
```

### 关闭坐标刻度、坐标轴不可见

#### plt.xticks

- 关闭坐标刻度：`plt.xticks([])`
- 旋转刻度：
  - plt.xticks(x, labels, rotation=70)
  - plt.xticks(x, labels, rotation=‘vertical’)

#### 关闭坐标刻度

```python
# plt
plt.xticks([])
plt.yticks([])

# 关闭坐标轴
plt.axis('off')

# ax
ax.set_xticks([])
ax.set_yticks([])
```

#### 设置所要保存图像的 dpi

```python
plt.savefig(..., dpi=150)
```

#### 坐标轴不可见

```python
frame = plt.gca()
# y 轴不可见
frame.axes.get_yaxis().set_visible(False)
# x 轴不可见
frame.axes.get_xaxis().set_visible(False)
```

### 保存时图片保存不完整的问题

```python
plt.colorbar()
plt.savefig(title, dpi=300, bbox_inches = 'tight')
plt.show()
```

### 绘制Roc曲线

```python
import matplotlib.pyplot as plt
import pandas as pd
df = pd.read_csv('1.csv')
fpr = list(df['x'])
tpr = list(df['y'])

plt.figure()

plt.plot(fpr, tpr, color='darkorange',label='ROC curve')
plt.plot([0, 5], [0, 5], color='navy', lw=lw, linestyle='--')
plt.xlim([0.0, 5.0])
plt.ylim([0.0, 5.05])
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('Receiver operating characteristic example')
plt.legend(loc="lower right")
plt.show()
```

