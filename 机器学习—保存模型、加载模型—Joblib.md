## 机器学习—保存模型、加载模型—Joblib

**Joblib是一组用于在Python中提供轻量级流水线的工具**。
**特点：**

> 透明的磁盘缓存功能和懒惰的重新评估（memoize模式）
> 简单的并行计算

Joblib可以将模型保存到磁盘并可在必要时重新运行：

```python
# 加载模块
import joblib
from sklearn.datasets import load_iris
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split

# 分割数据集
data = load_iris()
X = data.data
y = data.target
train_X, test_X, train_y, test_y = train_test_split(X, y, test_size=0.3, random_state=2)

# 训练模型
lr = LinearRegression()
lr.fit(train_X, train_y)

# 将训练的模型保存到磁盘 默认当前文件夹下
joblib.dump(lr, 'lr.pkl')

# 加载本地模型
local_model = joblib.load("lr.pkl")

# 对本地模型进行预测
print(local_model.predict(test_X))
print(local_model.score(test_X, test_y))

# 重新设置模型参数并训练
local_model.set_params(normalize=True).fit(train_X, train_y)

# 新模型做预测
print(local_model.predict(test_X))
print(local_model.score(test_X, test_y))
```

