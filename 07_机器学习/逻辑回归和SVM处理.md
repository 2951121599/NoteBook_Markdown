

## 逻辑回归和SVM处理

### 逻辑回归处理

```R
import numpy as np
import pandas as pd
from sklearn import metrics
import sklearn.model_selection as ms
import sklearn.linear_model as lm
import sklearn.utils as su
import matplotlib.pyplot as mp
from numpy import mean, std

data = pd.read_csv('../ml_data/N_b_data_10_variables.csv', header=None)
data = data.values

# 输入集 输出集
x = np.array(data[:, :-1], dtype=float)
y = np.array(data[:, -1], dtype=float)
x, y = su.shuffle(x, y, random_state=7)

# 1.划分训练集和测试集
train_x, test_x, train_y, test_y = \
    ms.train_test_split(x, y, test_size=0.25, random_state=5)


accuracy = []
auc = []
fprs = np.ndarray([])
tprs = np.ndarray([])
for i in range(1000):
    print(i)
    # 1.1划分训练集和测试集
    train_x, test_x, train_y, test_y = ms.train_test_split(x, y, test_size=0.2, random_state=i)

    # 2.1逻辑回归分类器
    # model = lm.LogisticRegression(solver='liblinear', penalty='l2', C=0.5)
    model = lm.LogisticRegression(solver='liblinear', penalty='l1', C=10)

    # 3.1用训练集训练模型
    model.fit(train_x, train_y)

    # 4.1计算ROC曲线面积  返回 假阳性率 真阳性率 阈值
    pred = model.predict_proba(test_x)[:, 1]
    fpr, tpr, threshold = metrics.roc_curve(test_y, pred)
    roc_auc = metrics.auc(fpr, tpr)
    auc.append(roc_auc)
    fprs = np.append(fprs, fpr)
    tprs = np.append(tprs, tpr)

# 2.模型训练
model = lm.LogisticRegression(solver='liblinear', penalty='l2', C=0.5)
# K折交叉验证 评估模型
print("交叉验证:")
print("精确度指标:", ms.cross_val_score(model, train_x, train_y, cv=10, scoring='accuracy').mean())
print("查准率指标:", ms.cross_val_score(model, train_x, train_y, cv=10, scoring='precision_weighted').mean())
print("召回率指标:", ms.cross_val_score(model, train_x, train_y, cv=10, scoring='recall_weighted').mean())
print("f1得分指标:", ms.cross_val_score(model, train_x, train_y, cv=10, scoring='f1_weighted').mean())
print("\n")
model.fit(train_x, train_y)

# 3.预测
pred_test_y = model.predict(test_x)

# 4.计算并打印预测输出的精确度
accuracy.append((test_y == pred_test_y).sum() / pred_test_y.size)  # pred_test_y.size 个数
print("精确度:", accuracy)

# 5.计算AUC SD CI
print("平均AUC:", mean(auc))
print("平均SD:", std(auc))
print("95%CI:", mean(auc) - 1.96 * std(auc), "~", mean(auc) + 1.96 * std(auc))

# 6.画图
mp.figure(figsize=(6, 6))
mp.title('Validation ROC')
mp.plot(sorted(fprs), sorted(tprs), 'b', label='Val AUC = %0.3f' % mean(auc))
mp.legend(loc='lower right')
mp.plot([0, 1], [0, 1], 'r--')
mp.xlim([0, 1])
mp.ylim([0, 1])
mp.ylabel('True Positive Rate')
mp.xlabel('False Positive Rate')
mp.show()
```

```R
交叉验证:
精确度指标: 0.9714285714285715
查准率指标: 0.9761904761904763
召回率指标: 0.9714285714285715
f1得分指标: 0.9679653679653679
精确度: [0.9473684210526315]
平均AUC: 0.9918053204148792
平均SD: 0.018877190206892994
95%CI: 0.954806027609369 ~ 1.0288046132203894
```



### SVM处理

```R
import numpy as np
import pandas as pd
import matplotlib.pyplot as mp
import sklearn.model_selection as ms
import sklearn.svm as svm
import sklearn.utils as su
from sklearn import metrics

data = pd.read_csv('../ml_data/N_b_data_10_variables.csv', header=None)
data = data.values

# 输入集 输出集
x = np.array(data[:, :-1], dtype=float)
y = np.array(data[:, -1], dtype=float)
x, y = su.shuffle(x, y, random_state=7)

# 1.划分训练集和测试集
train_x, test_x, train_y, test_y = ms.train_test_split(x, y, test_size=0.25, random_state=7)

# 2.建立SVM模型
model = svm.SVC(kernel='linear', class_weight='balanced', C=1, probability=True)  # 线性核函数

# 3.交叉验证
print("交叉验证:")
print("精确度指标:", ms.cross_val_score(model, train_x, train_y, cv=10, scoring='accuracy').mean())
print("查准率指标:", ms.cross_val_score(model, train_x, train_y, cv=10, scoring='precision_weighted').mean())
print("召回率指标:", ms.cross_val_score(model, train_x, train_y, cv=10, scoring='recall_weighted').mean())
print("f1得分指标:", ms.cross_val_score(model, train_x, train_y, cv=10, scoring='f1_weighted').mean())

# 4.训练并预测
model.fit(train_x, train_y)
pred_test_y = model.predict(test_x)
print("\n精确率:", (pred_test_y == test_y).sum() / pred_test_y.size)

# 5.计算auc面积
pred = model.predict_proba(test_x)[:, 1]
fpr, tpr, threshold = metrics.roc_curve(test_y, pred)
roc_auc = metrics.auc(fpr, tpr)

# # 6.画ROC曲线
# mp.figure(figsize=(6, 6))
# mp.title('Validation ROC')
# mp.plot(fpr, tpr, 'b', label='Val AUC = %0.3f' % roc_auc)
# mp.legend(loc='lower right')
# mp.plot([0, 1], [0, 1], 'r--')
# mp.xlim([0, 1])
# mp.ylim([0, 1])
# mp.ylabel('True Positive Rate')
# mp.xlabel('False Positive Rate')
# mp.show()

# 7.测试新数据
test_x1 = np.array(
    [0.30162507, -0.00158531, -0.82297095, 0.6948774, 0.86469149, -0.01574061, -0.03839677, 1.01190349, 0.2297296,
     0.38715348]
)

test_x2 = np.array(
    [2.162507, 2.00158531, 0.297095, 5.48774, 4.86469149, -0.01574061, -0.03839677, 1.01190349, 0.2297296,
     0.38715348]
)

pred_test_y = model.predict(test_x1.reshape(1, -1))
print(pred_test_y)

pred_test_y = model.predict(test_x2.reshape(1, -1))
print(pred_test_y)
```

```R
交叉验证:
精确度指标: 0.9547619047619049
查准率指标: 0.964047619047619
召回率指标: 0.9547619047619049
f1得分指标: 0.9511784511784512

精确率: 1.0
[0.]
[1.]
```

