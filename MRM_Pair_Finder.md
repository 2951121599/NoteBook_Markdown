# 每日代码

2020年9月17日10:47:12

### 6-4训练集网格搜索.ipynb

```R
#%%



#%%

import random
import numpy as np
import pandas as pd
import sklearn.model_selection as ms
import sklearn.utils as su
import sklearn.linear_model as lm

#%%

data = pd.read_csv('../other_data/N_b_data_ratio_t_train_92_6-4.csv', header=None)
data = data.values

# 输入集 输出集
x = np.array(data[1:, 5:], dtype=float)
y = np.array(data[1:, 1], dtype=float)

#%%

# 参数
params = [
    {'solver': ['liblinear'], 'penalty': ['l1', 'l2'],
     'C': [0.01, 0.05, 0.1, 0.2, 0.5, 1, 3, 5, 10, 100]}
]

#%%

# scoring='roc_auc'
model = ms.GridSearchCV(lm.LogisticRegression(), params, cv=5, scoring='accuracy',
                        n_jobs=-1)  # n_jobs=-1 多线程并行处理 -1为使用所有的核

#%%

model.fit(x, y)

#%%

for p, s in zip(model.cv_results_['params'],
                model.cv_results_['mean_test_score']):
    print(p, s)

#%%

# 获取得分最优的的超参数信息
print("获取得分最优的的超参数信息:", model.best_params_)
# 获取最优得分
print("获取最优得分:", model.best_score_)
# 获取最优模型的信息
print("获取最优模型的信息:", model.best_estimator_)

#%%
```



2020年9月17日10:52:30

### 6-4训练全部数据找cutoff值.ipynb

```R
#%%

import random
import numpy as np
import pandas as pd
from sklearn import metrics
import sklearn.model_selection as ms
import sklearn.linear_model as lm
import sklearn.utils as su
import matplotlib.pyplot as plt
from numpy import mean, std
import pickle

data = pd.read_csv('../other_data/N_b_data_ratio_t_train_92_6-4.csv', header=None)
data = data.values

# 输入集 输出集
x = np.array(data[1:, 5:], dtype=float)
y = np.array(data[1:, 1], dtype=float)

#%%

# 2.1逻辑回归分类器
model = lm.LogisticRegression(solver='liblinear', penalty='l2', C=0.01)  # cut_off:0.62668

# 3.1用训练集训练模型
model.fit(x, y)

# 保存模型
with open('../pkl/lr_09_17_9_l2_0.01_6_4.pkl', 'wb') as f:
    pickle.dump(model, f)
print('保存模型成功!')

# 4.1计算ROC曲线面积  返回 假阳性率 真阳性率 阈值
pred = model.predict_proba(x)[:, 1]
# print("pred----------", pred)
# print("y----------", y)

fpr, tpr, threshold = metrics.roc_curve(y, pred, drop_intermediate=False)
fpr, tpr, threshold = fpr[1:,], tpr[1:,], threshold[1:,]
auc = metrics.auc(fpr, tpr)
# auc2 = metrics.roc_auc_score(y,pred)  # 第二种方法 计算auc
spec = 1 - fpr
sens = tpr
print("spec----------\n", spec)
print("sens----------\n", sens)
print("threshold----------\n", threshold)
print("auc----------", auc)

plt.plot(fpr, tpr, label='ROC curve: AUC={0:0.3f}'.format(auc))
plt.xlabel('1-Specificity')
plt.ylabel('Sensitivity')
plt.ylim([0.0, 1.05])
plt.xlim([0.0, 1.05])
plt.grid(True)
plt.title('ROC')
plt.legend(loc="lower left")
plt.show()

#%%

# l1 = []
# for index,item in enumerate(spec):
#     if item > 0.85:
#         l1.append(index)
# l2 = []
# for i in l1:
#     l2.append(sens[i])
# max_index  = np.argmax(l2)
# print("max_index----------", max_index)
# cut_off_value = threshold[max_index]
# print("cut_off_value----------", cut_off_value)

#%%



#%%

def find_optimal_cutoff(tpr, fpr, threshold):
    yue_deng_index = np.argmax(tpr + (1 - fpr) - 1)
    # youden_index = np.argmax(tpr - fpr)
    cut_off = threshold[yue_deng_index]
    position = [fpr[yue_deng_index], tpr[yue_deng_index]]
    return cut_off, position
#%%

cut_off, point = find_optimal_cutoff(tpr, fpr, threshold)
print("cut_off----------", cut_off)  # 0.57306

plt.figure(1)
plt.plot(fpr, tpr, label=f"AUC = {auc:.3f}")
plt.plot([0, 1], [0, 1], linestyle="--")
plt.plot(point[0], point[1], marker='o', color='r')
plt.text(point[0], point[1], f'Threshold:{cut_off:.2f}')
plt.title("ROC-AUC")
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")
plt.legend()
plt.show()
```



2020年9月17日16:21:49

### 6-4训练集网格搜索.ipynb

```R
#%%



#%%

import random
import numpy as np
import pandas as pd
import sklearn.model_selection as ms
import sklearn.utils as su
import sklearn.linear_model as lm

#%%

data = pd.read_csv('../other_data/N_b_data_ratio_t_train_92_6-4.csv', header=None)
data = data.values

# 输入集 输出集
x = np.array(data[1:, 5:], dtype=float)
y = np.array(data[1:, 1], dtype=float)

#%%

# 参数
params = [
    {'solver': ['liblinear'], 'penalty': ['l1', 'l2'],
     'C': [0.01, 0.05, 0.1, 0.2, 0.5, 1, 3, 5, 10, 100]}
]

#%%

# scoring='roc_auc'
model = ms.GridSearchCV(lm.LogisticRegression(), params, cv=5, scoring='accuracy',
                        n_jobs=-1)  # n_jobs=-1 多线程并行处理 -1为使用所有的核

#%%

model.fit(x, y)

#%%

for p, s in zip(model.cv_results_['params'],
                model.cv_results_['mean_test_score']):
    print(p, s)

#%%

# 获取得分最优的的超参数信息
print("获取得分最优的的超参数信息:", model.best_params_)
# 获取最优得分
print("获取最优得分:", model.best_score_)
# 获取最优模型的信息
print("获取最优模型的信息:", model.best_estimator_)

#%%
```



2020年9月17日16:22:08

### 6-4训练全部数据找cutoff值.ipynb

```R
#%%

import random
import numpy as np
import pandas as pd
from sklearn import metrics
import sklearn.model_selection as ms
import sklearn.linear_model as lm
import sklearn.utils as su
import matplotlib.pyplot as plt
from numpy import mean, std
import pickle

data = pd.read_csv('../other_data/N_b_data_ratio_t_train_92_6-4.csv', header=None)
data = data.values

# 输入集 输出集
x = np.array(data[1:, 5:], dtype=float)
y = np.array(data[1:, 1], dtype=float)

#%%

# 2.1逻辑回归分类器
model = lm.LogisticRegression(solver='liblinear', penalty='l2', C=0.01)

# 3.1用训练集训练模型
model.fit(x, y)

# 保存模型
with open('../pkl/lr_09_17_9_l2_0.01_6_4.pkl', 'wb') as f:
    pickle.dump(model, f)
print('保存模型成功!')

# 4.1计算ROC曲线面积  返回 假阳性率 真阳性率 阈值
pred = model.predict_proba(x)[:, 1]
# print("pred----------", pred)
# print("y----------", y)

fpr, tpr, threshold = metrics.roc_curve(y, pred, drop_intermediate=False)
fpr, tpr, threshold = fpr[1:,], tpr[1:,], threshold[1:,]
auc = metrics.auc(fpr, tpr)
# auc2 = metrics.roc_auc_score(y,pred)  # 第二种方法 计算auc
spec = 1 - fpr
sens = tpr
print("spec----------\n", spec)
print("sens----------\n", sens)
print("threshold----------\n", threshold)
print("auc----------", auc)

plt.plot(fpr, tpr, label='ROC curve: AUC={0:0.3f}'.format(auc))
plt.xlabel('1-Specificity')
plt.ylabel('Sensitivity')
plt.ylim([0.0, 1.05])
plt.xlim([0.0, 1.05])
plt.grid(True)
plt.title('ROC')
plt.legend(loc="lower left")
plt.show()

#%%

# l1 = []
# for index,item in enumerate(spec):
#     if item > 0.85:
#         l1.append(index)
# l2 = []
# for i in l1:
#     l2.append(sens[i])
# max_index  = np.argmax(l2)
# print("max_index----------", max_index)
# cut_off_value = threshold[max_index]
# print("cut_off_value----------", cut_off_value)

#%%



#%%

def find_optimal_cutoff(tpr, fpr, threshold):
    yue_deng_index = np.argmax(tpr + (1 - fpr) - 1)
    # youden_index = np.argmax(tpr - fpr)
    cut_off = threshold[yue_deng_index]
    position = [fpr[yue_deng_index], tpr[yue_deng_index]]
    return cut_off, position

#%%

cut_off, point = find_optimal_cutoff(tpr, fpr, threshold)
print("cut_off----------", cut_off)  # 0.57306

plt.figure(1)
plt.plot(fpr, tpr, label=f"AUC = {auc:.3f}")
plt.plot([0, 1], [0, 1], linestyle="--")
plt.plot(point[0], point[1], marker='o', color='r')
plt.text(point[0], point[1], f'Threshold:{cut_off:.2f}')
plt.title("ROC-AUC")
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")
plt.legend()
plt.show()

```



2020年9月17日16:36

### 6-4预测验证集.ipynb

```R
#%%

import pickle
import numpy as np
import pandas as pd
from sklearn import metrics
from collections import Counter
import matplotlib.pyplot as plt

data = pd.read_csv('../other_data/N_b_data_ratio_t_validation_92_6-4.csv', header=None)
# data = pd.read_csv('../other_data/N_b_data_ratio_t_train_92_6-4.csv', header=None)  # 训练集
data = data.values

# 输入集 输出集
x = np.array(data[1:, 5:], dtype=float)
y = np.array(data[1:, 1], dtype=float)

# 从文件中加载模型
with open('../pkl/lr_09_17_9_l2_0.01_6_4.pkl', 'rb') as f:
    model = pickle.load(f)

#%%

pred_y = model.predict(x)

#%%

proba_y = model.predict_proba(x)[:, 1]

#%%

# 修改阈值预测
cut_off = 0.57306

predicted=[1 if i > cut_off else 0 for i in proba_y]
np.array(predicted)

fpr, tpr, threshold = metrics.roc_curve(y, predicted)
auc = metrics.auc(fpr, tpr)
spec = 1 - fpr
sens = tpr
print("spec----------", spec[1])
print("sens----------", sens[1])
print("auc----------", auc)

accuracy = metrics.accuracy_score(y, predicted)
print("accuracy----------", accuracy)
# print(metrics.precision_recall_curve(y,predicted))

# 混淆矩阵
tn, fp, fn, tp = metrics.confusion_matrix(y, predicted).ravel()
ppv = tp / (tp + fp)
npv = tn / (tn + fn)
rpp = (tp + fp) / (tp+fp+tn+fn)
rnp = (tn + fn) / (tp+fp+tn+fn)
print("ppv----------", ppv)
print("npv----------", npv)
print("rpp----------", rpp)
print("rnp----------", rnp)

# 绘制ROC曲线
metrics.plot_roc_curve(model, x,y)
plt.show()

# # 显示ROC曲线
# display = metrics.RocCurveDisplay(fpr=fpr, tpr=tpr,roc_auc=auc)
# display.plot()
# plt.show()

# plt.plot(fpr, tpr, label='ROC curve: AUC={0:0.2f}'.format(auc))
# plt.xlabel('1-Specificity')
# plt.ylabel('Sensitivity')
# plt.ylim([0.0, 1.0])
# plt.xlim([0.0, 1.0])
# plt.grid(True)
# plt.title('ROC')
# plt.legend(loc="lower left")
# plt.show()

#%%

# # 正常预测 0.5时
# fpr, tpr, threshold = metrics.roc_curve(y, pred_y)
# auc = metrics.auc(fpr, tpr)
# spec = 1 - fpr
# sens = tpr
# print("spec----------", spec[1])
# print("sens----------", sens[1])
# print("auc----------", auc)

#%%

# plt.plot(fpr, tpr, label='ROC curve: AUC={0:0.2f}'.format(auc))
# plt.xlabel('1-Specificity')
# plt.ylabel('Sensitivity')
# plt.ylim([0.0, 1.0])
# plt.xlim([0.0, 1.0])
# plt.grid(True)
# plt.title('ROC')
# plt.legend(loc="lower left")
# plt.show()

#%%

# def find_optimal_cutoff(tpr, fpr, threshold):
#     youden_index = np.argmax(tpr + (1 - fpr) - 1)  # Only the first occurrence is returned.
#     # youden_index = np.argmax(tpr - fpr)  # Only the first occurrence is returned.
#     optimal_threshold = threshold[youden_index]
#     point = [fpr[youden_index], tpr[youden_index]]
#     return optimal_threshold, point
#     # return optimal_threshold
#
#

#%%

# optimal_threshold, point = find_optimal_cutoff(tpr, fpr, threshold)
# print("optimal_threshold----------", optimal_threshold)
#
# plt.figure(1)
# plt.plot(fpr, tpr, label=f"AUC = {auc:.3f}")
# plt.plot([0, 1], [0, 1], linestyle="--")
# plt.plot(point[0], point[1], marker='o', color='r')
# plt.text(point[0], point[1], f'Threshold:{optimal_threshold:.2f}')
# plt.title("ROC-AUC")
# plt.xlabel("False Positive Rate")
# plt.ylabel("True Positive Rate")
# plt.legend()
# plt.show()
```



2020年9月17日16:46:09

### 6-4预测早中晚三期.ipynb

```R
#%%

import pickle
import numpy as np
import pandas as pd
from sklearn import metrics
from collections import Counter
import matplotlib.pyplot as plt

data = pd.read_csv('../other_data/N_b_data_ratio_t_validation_92_6-4_0_3.csv', header=None)
data = data.values

# 输入集 输出集
x = np.array(data[1:, 5:], dtype=float)
y = np.array(data[1:, 3], dtype=float)

# 从文件中加载模型
with open('../pkl/lr_09_17_9_l2_0.01_6_4.pkl', 'rb') as f:
    model = pickle.load(f)

#%%

pred_y = model.predict(x)

#%%

proba_y = model.predict_proba(x)[:, 1]

#%%


# 修改阈值预测
cut_off = 0.57306

predicted=[1 if i > cut_off else 0 for i in proba_y]
np.array(predicted)

fpr, tpr, threshold = metrics.roc_curve(y, predicted)
auc = metrics.auc(fpr, tpr)
spec = 1 - fpr
sens = tpr
print("spec----------", spec[1])
print("sens----------", sens[1])
print("auc----------", auc)

# 精确度
acc = metrics.accuracy_score(y, predicted)
print("acc----------", acc)

# 混淆矩阵
tn, fp, fn, tp = metrics.confusion_matrix(y, predicted).ravel()
ppv = tp / (tp + fp)
npv = tn / (tn + fn)
rpp = (tp + fp) / (tp+fp+tn+fn)
rnp = (tn + fn) / (tp+fp+tn+fn)
print("ppv----------", ppv)
print("npv----------", npv)
print("rpp----------", rpp)
print("rnp----------", rnp)

# 绘制ROC曲线
metrics.plot_roc_curve(model, x,y)
plt.show()

# plt.plot(fpr, tpr, label='ROC curve: AUC={0:0.2f}'.format(auc))
# plt.xlabel('1-Specificity')
# plt.ylabel('Sensitivity')
# plt.ylim([0.0, 1.0])
# plt.xlim([0.0, 1.0])
# plt.grid(True)
# plt.title('ROC')
# plt.legend(loc="lower left")
# plt.show()
```



2020年9月18日18:07:23

### 5-5训练集网格搜索.ipynb

```R
#%%

import random
import numpy as np
import pandas as pd
import sklearn.model_selection as ms
import sklearn.utils as su
import sklearn.linear_model as lm

#%%

data = pd.read_csv('../other_data/N_b_data_ratio_t_train_92_1_0.55.csv', header=None)
data = data.values

# 输入集 输出集
x = np.array(data[1:, 5:], dtype=float)
y = np.array(data[1:, 1], dtype=float)

#%%

# 参数
params = [
    {'solver': ['liblinear'], 'penalty': ['l1', 'l2'],
     'C': [0.01, 0.05, 0.75, 0.1, 0.2, 0.5, 1, 3, 5, 10, 100]}
]

#%%

# scoring='roc_auc'
model = ms.GridSearchCV(lm.LogisticRegression(), params, cv=5, scoring='accuracy',
                        n_jobs=-1)  # n_jobs=-1 多线程并行处理 -1为使用所有的核

#%%

model.fit(x, y)

#%%

for p, s in zip(model.cv_results_['params'],
                model.cv_results_['mean_test_score']):
    print(p, s)

#%%

# 获取得分最优的的超参数信息
print("获取得分最优的的超参数信息:", model.best_params_)
# 获取最优得分
print("获取最优得分:", model.best_score_)
# 获取最优模型的信息
print("获取最优模型的信息:", model.best_estimator_)

#%%
```



2020年9月18日18:07:43

### 5-5训练全部数据找cutoff值.ipynb

```R
#%%

import random
import numpy as np
import pandas as pd
from sklearn import metrics
import sklearn.model_selection as ms
import sklearn.linear_model as lm
import sklearn.utils as su
import matplotlib.pyplot as plt
from numpy import mean, std
import pickle

data = pd.read_csv('../other_data/N_b_data_ratio_t_train_92_1_0.55.csv', header=None)
data = data.values

# 输入集 输出集
x = np.array(data[1:, 5:], dtype=float)
y = np.array(data[1:, 1], dtype=float)

#%%

# 2.1逻辑回归分类器
model = lm.LogisticRegression(solver='liblinear', penalty='l1', C=0.05)
# model = lm.LogisticRegression(solver='liblinear', penalty='l2', C=0.01)

# 3.1用训练集训练模型
model.fit(x, y)

# 保存模型
with open('../pkl/lr_09_18_10_l1_0.05_5_5.pkl', 'wb') as f:
    pickle.dump(model, f)
print('保存模型成功!')

# 4.1计算ROC曲线面积  返回 假阳性率 真阳性率 阈值
pred = model.predict_proba(x)[:, 1]

fpr, tpr, threshold = metrics.roc_curve(y, pred, drop_intermediate=False)
fpr, tpr, threshold = fpr[1:,], tpr[1:,], threshold[1:,]

auc = metrics.auc(fpr, tpr)
spec = 1 - fpr
sens = tpr
print("spec----------\n", spec)
print("sens----------\n", sens)
print("threshold----------\n", threshold)

print("auc----------", auc)

#%%

# 截取>0.85的最后一个值,来找cut_off
# l1 = []
# for index,item in enumerate(spec):
#     if item > 0.85:
#         l1.append(index)
# l2 = []
# for i in l1:
#     l2.append(sens[i])
# max_index  = np.argmax(l2)
# print("max_index----------", max_index)
# cut_off_value = threshold[max_index]
# print("cut_off_value----------", cut_off_value)

#%%

# 通过约登指数计算cut_off值
def find_optimal_cutoff(tpr, fpr, threshold):
    # yue_deng_index = np.argmax(tpr + (1 - fpr) - 1)
    youden_index = np.argmax(tpr - fpr)
    cut_off = threshold[youden_index]
    point = [fpr[youden_index], tpr[youden_index]]
    return cut_off, point

#%%

# 获得cut_off值 和 所在位置坐标
cut_off, point = find_optimal_cutoff(tpr, fpr, threshold)
print("cut_off----------", cut_off)
print("point----------", point)

# 绘制ROC曲线
metrics.plot_roc_curve(model, x,y)
plt.plot([0, 1], [0, 1], linestyle="--")
plt.plot(point[0], point[1], marker='o', color='r')
plt.text(point[0] + 0.1, point[1] - 0.1, f'cut_off:{cut_off:.2f}' + f' (x:{point[0]:.3f}' + f' ,y:{point[1]:.3})', fontsize = 14)
plt.grid(True)
plt.xticks(np.arange(0, 1, step=0.1))
plt.yticks(np.arange(0, 1, step=0.1))
plt.show()
```



2020年9月18日18:08:16

### 5-5预测验证集.ipynb

```R
#%%

import pickle
import numpy as np
import pandas as pd
from sklearn import metrics
from collections import Counter
import matplotlib.pyplot as plt

data = pd.read_csv('../other_data/N_b_data_ratio_t_validation_92_1_0.55.csv', header=None)
# data = pd.read_csv('../other_data/N_b_data_ratio_t_train_92_1_0.55.csv', header=None)  # 训练集
data = data.values

# 输入集 输出集
x = np.array(data[1:, 5:], dtype=float)
y = np.array(data[1:, 1], dtype=float)

# 从文件中加载模型
with open('../pkl/lr_09_18_10_l1_0.05_5_5.pkl', 'rb') as f:
    model = pickle.load(f)

#%%

# 修改阈值预测
# cut_off = 0.57306
cut_off = 0.53877

# 计算各项指标
proba_y = model.predict_proba(x)[:, 1]
predicted=[1 if i > cut_off else 0 for i in proba_y]
np.array(predicted)

fpr, tpr, threshold = metrics.roc_curve(y, predicted)
auc = metrics.auc(fpr, tpr)
spec = 1 - fpr
sens = tpr
print("spec----------", spec[1])
print("sens----------", sens[1])
print("auc----------", auc)

acc = metrics.accuracy_score(y, predicted)
print("acc----------", acc)

# 混淆矩阵
tn, fp, fn, tp = metrics.confusion_matrix(y, predicted).ravel()
ppv = tp / (tp + fp)
npv = tn / (tn + fn)
rpp = (tp + fp) / (tp+fp+tn+fn)
rnp = (tn + fn) / (tp+fp+tn+fn)
print("ppv----------", ppv)
print("npv----------", npv)
print("rpp----------", rpp)
print("rnp----------", rnp)

#%%

# 通过约登指数计算point值 (spec + sens 最高的点)
def find_youden_point(tpr, fpr):
    youden_index = np.argmax(tpr - fpr)
    point = [fpr[youden_index], tpr[youden_index]]
    return point

point = find_youden_point(tpr, fpr)
print("point----------", point)

# 绘制ROC曲线
metrics.plot_roc_curve(model, x,y)
plt.plot([0, 1], [0, 1], linestyle="--")
plt.plot(point[0], point[1], marker='o', color='r')
plt.text(point[0] + 0.1, point[1] - 0.1, f' spec:{1 - point[0]:.3f}' + f' ,sens:{point[1]:.3})', fontsize = 14)
plt.grid(True)
plt.xticks(np.arange(0, 1, step=0.1))
plt.yticks(np.arange(0, 1, step=0.1))
plt.show()
```



2020年9月18日18:09:02

### 5-5预测早中晚三期.ipynb

```R
#%%

import pickle
import numpy as np
import pandas as pd
from sklearn import metrics
from collections import Counter
import matplotlib.pyplot as plt

T = '1'  # 修改预测哪一期

data = pd.read_csv('../other_data/N_b_data_ratio_t_validation_92_1_0.55.csv', header=None)
data = data.values

# 从文件中加载模型
with open('../pkl/lr_09_18_10_l1_0.05_5_5.pkl', 'rb') as f:
    model = pickle.load(f)

#%%

# 筛选出0-1 0-2 0-3 子数据
df = pd.DataFrame(data)
# 第4列数据为一二三期 t_0T为0和T期数据之和
t_0T = df.loc[(df[3] == '0') | (df[3] == T)]
t_0T = t_0T.values
# 重新定义 输入集 输出集
x = np.array(t_0T[:, 5:], dtype=float)
y = np.array(t_0T[:, 3], dtype=float)

# 将2或3都转换为1 方便模型识别阳性(一般都为1)
y[np.where(y>1)]=1

#%%

# 修改阈值预测
cut_off = 0.53877

# 计算各项指标
proba_y = model.predict_proba(x)[:, 1]
predicted=[1 if i > cut_off else 0 for i in proba_y]
np.array(predicted)

fpr, tpr, threshold = metrics.roc_curve(y, predicted)
auc = metrics.auc(fpr, tpr)
spec = 1 - fpr
sens = tpr
print("spec----------", spec[1])
print("sens----------", sens[1])
print("auc----------", auc)

# 精确度
acc = metrics.accuracy_score(y, predicted)
print("acc----------", acc)

# 混淆矩阵
tn, fp, fn, tp = metrics.confusion_matrix(y, predicted).ravel()
ppv = tp / (tp + fp)
npv = tn / (tn + fn)
rpp = (tp + fp) / (tp+fp+tn+fn)
rnp = (tn + fn) / (tp+fp+tn+fn)
print("ppv----------", ppv)
print("npv----------", npv)
print("rpp----------", rpp)
print("rnp----------", rnp)

#%%

# 通过约登指数计算point值 (spec + sens 最高的点)
def find_youden_point(tpr, fpr):
    youden_index = np.argmax(tpr - fpr)
    point = [fpr[youden_index], tpr[youden_index]]
    return point

point = find_youden_point(tpr, fpr)
print("point----------", point)

# 绘制ROC曲线
metrics.plot_roc_curve(model, x,y)
plt.plot([0, 1], [0, 1], linestyle="--")
plt.plot(point[0], point[1], marker='o', color='r')
plt.text(point[0] + 0.1, point[1] - 0.1, f' spec:{1 - point[0]:.3f}' + f' ,sens:{point[1]:.3})', fontsize = 14)
plt.grid(True)
plt.xticks(np.arange(0, 1, step=0.1))
plt.yticks(np.arange(0, 1, step=0.1))
plt.show()
```

### 最终版 MRM_Pair_Finder

```R
# Function: MRM_Ion_Pair_Finder
# Description: MRM-Ion Pair Finder performed in R
# References: Analytical Chemistry 87.10(2015):5050-5055.
# Parameters: file_MS1: MS1 peak detection result save in .csv filetype, the first column is m/z named 'mz',
#                       the second column is retention time(s) named 'tr',
#                       intensity of samples is located begin the third column.
#             filepath_MS2: The folder path which have mgf files.
#             tol_mz(Da): The tolerence of m/z between MS1 peak detection result and mgf files. 0.01 is suitable for Q-TOF.
#             tol_tr(min): The tolerence of retention time between MS1 peak detection result and mgf files.
#             diff_MS2MS1(Da): The smallest difference between product ion and precusor ion.
#             ms2_intensity: The smallest intensity of product ion.
#             resultpath: A csv file named "MRM transitions list.csv" will saved in the path.

MRM_Ion_Pair_Finder <- function(file_MS1,
                                filepath_MS2,
                                tol_mz,
                                tol_tr,
                                diff_MS2MS1,
                                ms2_intensity,
                                resultpath){
  # Some packages used in the function
  ##########
  require(tcltk)
  require(stringr)
  require(readr)
  require(dplyr)
  ##########
  
  # Function: exact a matrix from mgf_data
  ##########
  createmgfmatrix <- function(mgf_data){
    Begin_num <- grep("BEGIN IONS", mgf_data)
    Pepmass_num <- grep("PEPMASS=",mgf_data)
    TR_num <- grep("RTINSECONDS=",mgf_data)
    End_num <- grep("END IONS", mgf_data)
    mgf_matrix <- cbind(Begin_num,TR_num,Pepmass_num,End_num)
    
    for (i in c(1:length(Pepmass_num)))
    {
      pepmass <- 
        gsub("[^0-9,.]", "", strsplit(mgf_data[Pepmass_num[i]],split = " ")[[1]][1])
      mgf_matrix[i,"Pepmass_num"] <- pepmass
      
      tr <- gsub("[^0-9,.]", "", mgf_data[TR_num[i]])
      mgf_matrix[i,"TR_num"] <- tr
    }
    return(mgf_matrix)
  } 
  ##########
  
  # Reading csv file containing peak detection result of MS1.
  ##########
  before_pretreatment <- read.csv(file = file_MS1)
  if (length(which(colnames(before_pretreatment)=="tr")) >= 1) {}
  else if (length(which(colnames(before_pretreatment)=="tr")) == 0 & length(which(colnames(before_pretreatment)=="rt")) >= 1){
    colnames(before_pretreatment)[which(colnames(before_pretreatment)=="rt")] = "tr"
  }
  else {
    packageStartupMessage("Row names of MS1 file is wrong!")
    break()
  }
  mz <- before_pretreatment$mz
  tr <- before_pretreatment$tr
  # int <- before_pretreatment[ ,3:ncol(before_pretreatment)]
  packageStartupMessage("MS1 reading is finished.")
  ##########
  
  MS2_filename <- list.files(filepath_MS2)
  data_ms1ms2 <- cbind(before_pretreatment[1,], mzinmgf=1, trinmgf=1, mz_ms2=1, int_ms2=1, CE=1)[-1,]  # Create data.frame to store information of ms1ms2 information
  
  # Reading and processing mgf files one by one.
  for (i_new in MS2_filename){
    print(paste("MS2_filename --",i_new))
    mgf_data <- scan(paste0(filepath_MS2,'\\',i_new), what = character(0), sep = "\n")  # Read mgf file
    mgf_matrix <- createmgfmatrix(mgf_data)  # create mgf_matrix
    CE <- parse_number(i_new) # get CE value in the filename of mgf
    
    # 1.Delete the data with charge > 1
    ##########
    for (i in c(1:length(mgf_data))){
      print(paste("step1 --",length(mgf_data),"--",i))
      # If the row of mgf_data is contain the "CHARGE=", 
      if (!is.na(mgf_data[i]) & str_detect(mgf_data[i],"CHARGE=")){
        if (!str_detect(mgf_data[i],"CHARGE=1")){
          mgf_data[mgf_matrix[tail(which(as.numeric(mgf_matrix[,"Begin_num"]) < i),1),"Begin_num"]:
                     mgf_matrix[which(as.numeric(mgf_matrix[,"End_num"]) > i)[1],"End_num"]] <- NA          
        }
      }
    }
    mgf_data <- na.omit(mgf_data)
    packageStartupMessage(paste("1.Deleting the data in", i_new, "with charge > 1 is finished."))
    ########
    
    # 2.Delete the data by diff_MS2MS1 and ms2_intensity
    ########
    mgf_matrix <- createmgfmatrix(mgf_data)  # create mgf_matrix
    # 开启多线程
    require(parallel)
    require(doParallel)
    n_Cores <- detectCores()
    cluster_Set <- makeCluster(n_Cores)
    registerDoParallel(cluster_Set)
    
    count = length(mgf_data)
    
    system.time({
      r <- foreach(
        i = 1:count,
        .combine = c
      ) %dopar% {
        if (!grepl("[a-zA-Z]", mgf_data[i])) {
          mz_ms2 <- as.numeric(unlist(strsplit(mgf_data[i], " "))[1])
          int_ms2 <- as.numeric(unlist(strsplit(mgf_data[i], " "))[2])
          mz_ms1 <-
            as.numeric(mgf_matrix[tail(which(as.numeric(mgf_matrix[, "Begin_num"]) < i), 1), "Pepmass_num"])
          if (mz_ms1 - mz_ms2 <= diff_MS2MS1 |
              int_ms2 <= ms2_intensity) {
            mgf_data[i] <- NA
          }
        }
        mgf_data[i]
      }
    })
    
    stopCluster(cluster_Set)
    stopImplicitCluster()
    detach("package:doParallel", unload = TRUE)
    detach("package:parallel", unload = TRUE)
    
    mgf_data = r
    
    mgf_data <- na.omit(mgf_data)
    packageStartupMessage(paste("2.Deleting the data in", i_new, "by diff_MS2MS1 and ms2_intensity is finished."))
    ########
    
    # 3.Delete the data without useful MS2
    ########
    mgf_matrix <- as.data.frame(createmgfmatrix(mgf_data))  # creat mgf_matrix
    system.time({
      for (i in c(1:nrow(mgf_matrix))){
        print(paste("step3 --",nrow(mgf_matrix),"--",i))
        if (as.numeric(as.character(mgf_matrix$End_num[i])) - as.numeric(as.character(mgf_matrix$Begin_num[i])) < 5){
          mgf_data[as.numeric(as.character(mgf_matrix$Begin_num[i])):as.numeric(as.character(mgf_matrix$End_num[i]))] <- NA
        }
      }
    })
    
    mgf_data <- na.omit(mgf_data)
    packageStartupMessage(paste("3.Deleting the data in", i_new, "without useful MS2 is finished."))
    ########
    
    # Combine ms1 and ms2
    mgf_matrix <- as.data.frame(createmgfmatrix(mgf_data))
    for (i in c(1:nrow(mgf_matrix))){
      print(paste("Combine ms1 and ms2 --",nrow(mgf_matrix),"--",i))
      mzinmgf <- as.numeric(as.character(mgf_matrix$Pepmass_num[i]))
      trinmgf <- as.numeric(as.character(mgf_matrix$TR_num[i]))
      posi <- which(abs(before_pretreatment$mz-mzinmgf) < tol_mz & abs(before_pretreatment$tr-trinmgf) < tol_tr*60)
      if (length(posi)>=1){
        posi <- posi[1]
        ms1info <- before_pretreatment[posi,]
        for (j in mgf_data[as.numeric(as.character(mgf_matrix$Begin_num[i])):as.numeric(as.character(mgf_matrix$End_num[i]))]){
          if (grepl("[a-zA-Z]", j)){
            next()
          }else{
            mz_ms2 <- as.numeric(unlist(strsplit(j, " "))[1])
            int_ms2 <- as.numeric(unlist(strsplit(j, " "))[2])
            ms1ms2conb <- cbind(ms1info,mzinmgf,trinmgf,mz_ms2,int_ms2,CE)
            data_ms1ms2 <- rbind(data_ms1ms2,ms1ms2conb)
          }
        }
      }
    }
    write.csv(data_ms1ms2,file = paste0(i_new, "_result.csv"),row.names = FALSE)
  }
  
  # 输出最终文件
  data_ms1ms2_final <- data_ms1ms2[1,][-1,]
  uniquedata_ms1ms2 <- distinct(data_ms1ms2[,1:ncol(before_pretreatment)])
  for (i in c(1:nrow(uniquedata_ms1ms2))){
    print(paste("unique data ms1 and ms2 --",nrow(uniquedata_ms1ms2),"--",i))
    posi <- which(data_ms1ms2$mz==uniquedata_ms1ms2$mz[i] & data_ms1ms2$tr==uniquedata_ms1ms2$tr[i])
    temp <- data_ms1ms2[posi,]
    posi <- which(temp$int_ms2 == max(temp$int_ms2))
    temp <- temp[posi[1],]
    data_ms1ms2_final <- rbind(data_ms1ms2_final,temp)
  }
  setwd(resultpath)
  write.csv(data_ms1ms2_final,file = "ds_neg_final_result3.csv",row.names = FALSE)
  return(data_ms1ms2_final)
}
```

### Run

```R
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("xcms")
BiocManager::install("CAMERA")
# C:\Users\cuite\Documents\工作\R_Program\ds_pos\Data\pos\MS1
source("C:\\Users\\cuite\\Documents\\工作\\R_Program\\ds_neg\\MRM_Ion_Pair_Finder_2.R")

data_ms1ms2_final <- MRM_Ion_Pair_Finder(file_MS1 = "C:\\Users\\cuite\\Documents\\工作\\R_Program\\ds_neg\\Data\\neg\\MS1\\mz_rt_neg.csv",
                                         filepath_MS2 = "C:\\Users\\cuite\\Documents\\工作\\R_Program\\ds_neg\\Data\\neg\\MS2",
                                         tol_mz = 0.01,
                                         tol_tr = 0.35,
                                         diff_MS2MS1 = 0.5,
                                         ms2_intensity = 5000,
                                         resultpath = "C:\\Users\\cuite\\Documents\\工作\\R_Program\\ds_neg\\")
print('ds_neg_final_result3.csv ok!')

```

