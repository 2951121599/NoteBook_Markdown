# R相关计算

## 文件操作

### 读取写入csv文件

```R
# 读取csv
b_data <- data.frame(data.table::fread(file_name, sep = ",", header = T))
rownames(b_data) <- b_data[, 1]  # 读取文件后, 一般将第一列作为行名 先进行保存

# 写入csv 
data.table::fwrite(
  data.frame(r),
  "pearson_r.csv",
  sep = ",",
  quote = FALSE,
  row.names = FALSE
)

# 保存为csv文件(简单写法)
data.table::fwrite(data, csv_filename, sep = ",", row.names = F)
```

```R
  name  C  M   E Mean Std
1   zs 80 90 100   NA  NA
2   ls 90 90  90   NA  NA

# -------------------------------------
data <- read.csv("csv_demo.csv")
print(data)

# 读取大文件时 用fread
data.table::fread()
```

```R
# 判断是否为frame
is.data.frame(data)

# 计算有多少列数据  6
ncol(data)

# 计算有多少行数据  2
nrow(data)

# 获取E列的最大值  [1] 100
res <- max(data$E)

# 获取E列的最大值的人的全部信息
res <- subset(data, E == max(data$E))

# 求2-4列 每行的均值
res <- rowMeans(data[2:4])

# 求2-4列 每行的和
rowSums(data[2:4])

# 获取或设置对象名称
names(data)

# 显示对象结构
str(data)

# 给出数据的概略信息
summary(data)
```

```R
# 写文件名时小于0的要注意
for(i in 1:11){  
 if(i<10){
    out_filename <- paste0('0', i, ".csv")
  }else{
    out_filename <- paste0(i, ".csv")
  }
  print(out_filename)
  data.table::fwrite(result_data, out_filename)
}
```

### 

### 读取写入xlsx文件

```R
library("xlsx")
# 读取xlsx
data <- read.xlsx("input.xlsx", sheetIndex = 1)

# 写入xlsx
res <- c(1:10)
data <-
  write.xlsx(
    res,
    "input.xlsx",
    sheetName = "test",
    col.names = FALSE,
    row.names = FALSE,
    append = FALSE
  )

# 写入同一excel，及同一sheet注意
write.xlsx(x, file, sheetName="Sheet1", col.names=TRUE, row.names=TRUE, append=FALSE, showNA=TRUE)

# 将data1写da.xlsx的sheet1, 将data2写da.xlsx的sheet2中
write.xlsx(data1, file, sheetName="sheet1")
write.xlsx(data2, file, sheetName="sheet2", append=TRUE)  # append一定要设置为TRUE，否则就会把sheet1中的数据覆盖掉
```

```R
# 求各列的均值与方差
library("xlsx")
library("matrixStats")
data = read.xlsx("sheet3.xlsx", 1, header = F)
colMeans(data, na.rm = T)
colVars(as.matrix(data), na.rm = T)
```

readxl包

```R
# 下载和引用readxl
install.packages("readxl")
library(readxl)

# 读取Excel
read_excel("old_excel.xls")
read_excel("new_excel.xlsx")

# sheet参数，指定sheet名或者数字
read_excel("excel.xls", sheet = 2)
read_excel("excel.xls", sheet = "data")

# 如果NAs由非空白单元格表示，请设置na参数
read_excel("excel.xls", na = "NA")
```



### 创建文件夹

```R
outpath = 'result'
if(!dir.exists(outpath)){
    dir.create(outpath)
}
```

### 多线程合并csv

```R
# 注意不能有其它的csv文件 合成的文件的数据 按照各个文件的字母顺序

library(pacman)
p_load(doParallel,data.table,dplyr,stringr,fst)

# 识别所在文件路径下所有的csv文件名称
dir() %>% str_subset("\\.csv$") -> fn

# 并行计算环境设置
(cl = detectCores() %>% 
    makeCluster()) %>% 
  registerDoParallel()

# 并行读取csv，并进行合并
system.time({
  big_df = foreach(i = fn,
                   .packages = "data.table") %dopar% {
                     fread(i,colClasses = "character")
                   } %>% 
    rbindlist(fill = T)
})

# 停止并行环境
stopCluster(cl)

# 读出文件
# write_fst(big_df,"big_df.fst",compress = 100)

fwrite(big_df,"merge.csv")
```



## 行列操作

```R
b_data <-
  data.frame(
    x1 = c(1, 3, 5, 7),
    x2 = c(2, 4, 6, 8),
    x3 = c(11, 12, 13, 14),
    x4 = c(15, 16, 17, 18)
  )
> b_data
  x1 x2 x3 x4
1  1  2 11 15
2  3  4 12 16
3  5  6 13 17
4  7  8 14 18
```



### 获取设置行名列名

```R
# 查看行名
rownames(b_data)

# 获取行名
row_names <- rownames(b_data)
row_names

# 设置行名
rownames(b_data) <- c('a', 'b', 'c', 'd')
rownames(b_data)  # "a" "b" "c" "d"

# 获取列名
col_names <- colnames(b_data)

# 设置列名
colnames(b_data) <- c('y1', 'y2', 'y3', 'y4')
colnames(b_data)  # y1" "y2" "y3" "y4"

# 指定几列进行命名
colnames(b_data)[1:2] <- c('z1', 'z2')
colnames(b_data)  # "z1" "z2" "y3" "y4"

# 循环赋值列名
col_names <- c('y1', 'y2', 'y3', 'y4')
for (i in 1:ncol(b_data)) {
  colnames(b_data)[i] <- col_names[i]
}
```



### 添加行

```R
data1 <- data.frame(x1 = round(runif(5, 1, 10), 0),
                    x2 = round(runif(5, 1, 10), 0),
                    x3 = round(runif(5, 1, 10), 0))
data1
row <- c(1, 1, 1)
data2 <- rbind(data1[1:2, ], row, data1[3:nrow(data1),])
data2

# 行绑定和rep
cv_bat <- data.frame(cbind(feature, cv_lot_all, group=rep(str, time = length(feature))))
```



### 添加列

```R
# 添加一列并设置列名
b_data <- cbind(i_data$feature, b_data)
colnames(b_data)[1] <- 'feature'
```

```R
b_data$group <- substring(b_data[, 1], 1, 1)  # 第一列数据的第一个字符作为新的列
names(b_data$group) <- c("group")  # 对新列设置列名
# colnames(t_data)[ncol(b_data)]  # 获取最后一列的列名
```



### 合并列

```R
# 将y列插入到dataframe里
y <- 1:4
data1 <-
  data.frame(
    x1 = c(1, 3, 5, 7),
    x2 = c(2, 4, 6, 8),
    x3 = c(11, 12, 13, 14),
    x4 = c(15, 16, 17, 18)
  )
data2 <- cbind(data1[, 1:2], y, data1[, 3:ncol(data1)])

# 在最后追加一列
data3 <- cbind(data1, y)
```



### 过滤行数据

```R
# 过滤行数据(只包含DS和X的行)
b_data <- dplyr::filter(b_data, grepl('DS|X', feature))
```

```R
# 获取特征名
feature <-
  c(
    'X16.5_373.274mz_pos',
    'X14.8_405.265mz_neg',
    'X13.1_448.307mz_neg',
    'X16.9_373.274mz_pos'
  )

# 过滤行数据 in
filter_b_data <- b_data[which(b_data$sample_no %in% feature), ]
```



### 过滤列数据

```R
# 过滤列数据
b_data <- b_data[, grep(no, colnames(b_data))]

# 查找数据所在的列号
pattern <- "np_mean"
np_mean.colnum <- grep(pattern, colnames(base))

# 根据b_data 在i_data中筛选数据
i_data <- subset(i_data, select= c(colnames(i_data)[1:2], b_data))

# 找到ip_mean的列号 获取ip_mean 列  
ip_mean_colnum <- grep('ip_mean', colnames(sample))
ip_mean <- sample[, ip_mean_colnum]
```



### subset 查询

```R
# 查询type不为F的行
b_data <- subset(b_data, type != "F")

# 查询F_fc>1.2或者F_fc < 0.8的数据
b_data <- subset(b_data, F_fc > 1.2 | F_fc < 0.8)
```





### 移动列的位置

```R
b_data <- b_data[, -ncol(b_data)]  # 去掉最后一列
b_data <- b_data[, c(1, ncol(b_data), 2:(ncol(b_data) - 1))]  # 修改列的位置

# 或者更直接
b_data <- b_data[, c(10, 1:9)]
```



### 随机抽取列

```R
# 随机抽取b_data的11列(replace=F 不放回)
group1 <- sample(x = b_data, size = 11, replace = F)

# 按1:1的比例产生了1和2(replace=T 有放回)
index <- sample(x = 2, size = ncol(b_data), replace=T, prob = c(0.5, 0.5))
```

### 只对某些列进行操作

```R
# 对除了1,2列的数据进行保留一位小数的运算
cv_bat[, -(1:2)] <- round(cv_bat[, -(1:2)], 1)
```



## 常用函数

```R
str() 显⽰数据集和变量类型，并简要展⽰数据集情况
subset() 取⼦集
which.min(), which.max()和which() 返回的是位置(索引)
grep() 找出所数据框中元素所在的列值(仅数据框中)
assign() 通过变量名的字符串来赋值
split()根据因⼦变量拆分数据框/向量
unique()返回 x 但是省去重复的数值
round()四舍五入取整；floor()向下取整；ceiling()向上取整
sign() 符号函数 根据其参数数值是正值、零、负值将其分别转化为1，0，-1
%in% 检验x是否为集合y中的元素(x%in%y)
```

```R
14、数据管理相关
vector：向量
numeric：数值型向量
logical：逻辑型向量
character；字符型向量
list：列表
data.frame：数据框
c：连接为向量或列表
length：求长度
subset：求子集
seq，from:to, sequence：等差序列
rep：重复
NA：缺失值
NULL：空对象
sort，order，unique，rev：排序
unlist：展开列表
attr，attributes：对象属性
mode，typeof：对象存储模式与类型
names：对象的名字属性

15、字符串处理函数
character：字符型向量
nchar：字符数
substr：取子串
format，format C：把对象用格式转换为字符串
paste，strsplit：连接或拆分
charmatch，pmatch：字符串匹配
grep，sub，gsub：模式匹配与替换

16、因⼦
factor：因子
codes：因子的编码
levels：因子的各水平的名字
nlevels：因子的水平个数
cut：把数值型对象分区间转换为因子
table：交叉频数表
split：按因子分组
aggregate：计算各数据子集的概括统计量
tapply：对不规则数组应用函数

17、数学计算
+, -, *, /, ^, %%, %/%：四则运算
ceiling，floor，round，signif，trunc，zapsmall：舍入
max，min，pmax，pmin：最大最小值
range：最大值和最小值
sum，prod：向量元素和积
cumsum，cumprod，cummax，cummin：累加、累乘
sort：排序
approx和approx fun：插值
diff：差分
sign：符号函数

18、数组相关
array：建立数组
matrix：生成矩阵
data.matrix：把数据框转换为数值型矩阵
lower.tri：矩阵的下三角部分
mat.or.vec：生成矩阵或向量 
t：矩阵转置
cbind：把列合并为矩阵
rbind：把行合并为矩阵
diag：矩阵对角元素向量或生成对角矩阵
aperm：数组转置
nrow, ncol：计算数组的行数和列数
dim：对象的维向量
dimnames：对象的维名
row/colnames：行名或列名
%*%：矩阵乘法
crossprod：矩阵交叉乘积(内积)
outer：数组外积
kronecker：数组的Kronecker积
apply：对数组的某些维应用函数
tapply：对“不规则”数组应用函数
sweep：计算数组的概括统计量
aggregate：计算数据子集的概括统计量
scale：矩阵标准化
matplot：对矩阵各列绘图
cor：相关阵或协差阵
Contrast：对照矩阵
row：矩阵的行下标集
col：求列下标集

19、逻辑运算
<=，>=，==，!=：比较运算符
!，&，&&，|，||，xor()：逻辑运算符
logical：生成逻辑向量
all，any：逻辑向量都为真或存在真
ifelse()：二者择一
match，%in%：查找
unique：找出互不相同的元素
which：找到真值下标集合
duplicated：找到重复元素

20、控制结构相关
f，else，ifelse，switch：分支
for，while，repeat，break，next：循环
apply，lapply，sapply，tapply，sweep：替代循环的函数

21、⾃定义函数相关
function：函数定义
source：调用文件
call：函数调用

22、输⼊输出
cat，print：显示对象
sink：输出转向到指定文件
dump，save，dput，write：输出对象
scan，read.table，load，dget：读入

23、⼯作环境
ls，objects：显示对象列表
rm, remove：删除对象
q，quit：退出系统
.First，.Last：初始运行函数与退出运行函数
options：系统选项
?，help，help.start，apropos：帮助功能
data：列出数据集

24、简单统计量
sum, mean, var, sd, min, max, range, median, IQR(四分位间距)等为统计量
sort，order，rank与排序有关

25、时间序列
diff：计算差分
time：时间序列的采样时间
window：时间窗
```



### t 转置

```R
# 矩阵转置
t(x)

# 转为dataframe
data_t <- data.frame(t(data))

# 因为矩阵要求存放的内容是同一种数据类型，对于输入的数据框而言，一般都会有字符串，数值这些，那么最终都会被转成字符串。
# 因为原先的数据框的第一列是字符串，那么自然而然会把所有的数据都变成字符串，然后把第一列变成第一行。
# 而如果要实现他真正的目的，需要先将第第一行变成行名，然后删掉第一行在转置
# 其结果就是先保证原来的数据框里面都是数值数据，而不是让第一列充当行名。

# 方式一
df <- transform(BOD, zimu=c('a', 'b', 'c', 'd', 'e', 'f'))
data.frame(t(df))

# 方式二
df <- transform(BOD, zimu=c('a', 'b', 'c', 'd', 'e', 'f'))
title <- df[, 1]  # 第一列
df <- data.frame(t(df))
colnames(df) <- title  # 把原来的第一列赋值为新的列名
df
```

```R
i_data <- data.frame(data.table::fread("data.csv"))
feature <- i_data[, 1]
i_data <- i_data[, -1]
t_data <- t(as.matrix(i_data))
colnames(t_data) <- feature 
data.table::fwrite(data.frame(t_data), "data_t.csv", sep = ",", quote = FALSE,row.names = FALSE)
```



### dim 设置尺寸

```R
x <- 1:12
dim(x) <- c(3,4)  # dim(x) 检索或设置对象的尺寸
x
     [,1] [,2] [,3] [,4]
[1,]    1    4    7   10
[2,]    2    5    8   11
[3,]    3    6    9   12

N <- array(1:24, dim = 2:3)
dimnames(N) <- list(c(1, 2), c('Q', 'W', 'E'))  # dimnames(X) 检索或设置对象的dimnames
N
  Q W E
1 1 3 5
2 2 4 6
```



### apply 应用于数组或矩阵

```R
apply(X, MARGIN, FUN)
-x：数组或矩阵, 如果X已命名dimnames，则它可以是选择维度名称的字符向量
-MARGIN：1：对行执行操作 2：对列执行操作
-FUN：应用哪个功能。可以应用平均值，中位数，和，最小值，最大值，用户定义的函数
```

```R
m1 <- matrix(C<-(1:10), nrow=5, ncol=6)
a_m1 <- apply(m1, 2, sum)  # 对每一列求和
a_m2 <- apply(m1, 1, sum)  # 对每一行求和
```

```R
# 计算平均值
# 有默认函数 行均值 rowMeans(data) 列均值 colMeans(data)

# 对这4列的每行的对应数字求平均，去除缺失值
data$mean <- apply(data[, 7:10], 1, mean, na.rm=T)

# 计算列的平均值
data <- matrix(C<-(1:10), nrow=5, ncol=6)
colMeans(data)  # 等价于 apply(data, 2, mean)

# 计算第3列的平均值
colMeans(data[3])
```

```R
data <- matrix(c(1:4, 1, 6:8), nrow = 2)
# 为每个数据加上它所在列的均值(1表示行，2表示列)
b_data <- apply(data, 2, function(x) {
  x + (mean(x))
})
```



apply自定义一些函数

```R
# cv=(标准差/均值)*100
rowCv = function(x) {
  apply(x, 1, function(x)
    (round(sd(x) / mean(x) * 100, 2)))
}

# fc=N/C
rowFc = function(x) {
  apply(x, 1, function(x)
    (round(x[1] / x[2], 2)))
}

# 差的绝对值
rowAbsMinus = function(x) {
  apply(x, 1, function(x)
    (abs(x[1] - x[2])))
}

# 两数据拼接
rowPaste2 = function(x) {
  apply(x, 1, function(x)
    (paste0(x[1], "_", x[2])))
}
```



### lapply 应用于列表

```R
# lapply(X, FUN)
# 用于把指定的待应用的函数应用于列表的每一个元素，并返回列表结构的输出
# 使用tolower函数将矩阵的字符串值更改为小写
movies <- c("SPYDERMAN","BATMAN","VERTIGO","CHINATOWN")
movies_lower <- unlist(lapply(movies, tolower))  # 使用unlist()将列表转换为向量
str(movies_lower)
```

### transform 添加新的列

```R
为原数据框添加新的列，改变原变量列的值，还可通过赋值NULL删除列变量。

# BOD为自带的数据集
> BOD
  Time demand
1    1    8.3
2    2   10.3
3    3   19.0
4    4   16.0
5    5   15.6
6    7   19.8

# 添加新的列
> transform(BOD, zimu=c('a', 'b', 'c', 'd', 'e', 'f'))
  Time demand zimu
1    1    8.3    a
2    2   10.3    b
3    3   19.0    c
4    4   16.0    d
5    5   15.6    e
6    7   19.8    f

# 对列赋值为NULL,即可删除此列
> transform(BOD, demand=NULL)
  Time
1    1
2    2
3    3
4    4
5    5
6    7
```

### paste0 拼接字符串

```R
str <- paste0(bat_no, no)
```



### substring 字符串截取

```R
s <- '1234567'
substr(s, 2, 5)  # "2345"
# substr(s, 2) # 缺少参数"stop",也没有缺省值

substring(s, 2, 5)  # "2345"
substring(s, 2)  # "234567"

result <- substring(col_1, 1, 1)  # 获取第一列数据的第一个字符

# 添加新列type: 截取相关字符串 "N" "N"
b_data <- transform(b_data, type = substr(x = type, start = 1, stop = 1))  
```



### melt 行变列

```R
library(data.table)
dat <-
  data.table(
    Spring = c(runif(9, 0, 1), 2),
    Summer = runif(10, 0, 1),
    Autumn = runif(10, 0, 1),
    Winter = runif(10, 0, 1)
  )
melt(dat)  # 行变列
# 把数据宽表转化长表, A,B列不够20个, 进行重复补齐
melt(
  dat,
  id.vars = c('Spring', 'Summer'),
  measure.vars = c('Autumn', 'Winter'),
  variable.name = 'type',
  value.name = 'value'
)
```





### unique 去重

```R
# 判断元素是否相同
x <- c(1, 2, 1)
length(unique(x)) == 1  # 唯一的元素的长度
sd(x) == 0  # 标准差方式
```



## 绘图

### 绘制线性图

```R
# 绘制线性图
library(ggplot2)

x <- rnorm(100, 14, 5)  # rnorm(n, mean = 0, sd = 1)
y <- x + rnorm(100, 0, 1)
ggplot(data = NULL, aes(x = x, y = y)) +  # 开始绘图
  geom_point(color = "darkred") +  # 添加点
  annotate(
    "text",
    x = 13,  # 位置
    y = 20,
    parse = T,
    label = "x[1] == x[2]"
  ) #添加注释
```

![image-20220121102748981](C:\Users\cuite\Documents\GitHub\NoteBook_Markdown\images\image-20220121102748981.png)



### 绘制频率分布直方图

https://blog.csdn.net/m0_46291589/article/details/104381073

```python
yx = c(1, 2, 3, 5)
hist(
  yx,
  col = "PINK",
  labels = TRUE,
  ylim = c(0, 60),
  main = "胰腺癌离子对时间频率分布图",
  # main = "多癌种离子对时间频率分布图",
  xlab = "RT时间",
  ylab = "出现频数"
)
```

### 判断数据是否符合正态分布

```R
# 方法1: shapiro.test 只适合小样本(5000以内)
shapiro.test(qc_data)  # 提供了W统计量和相应P值 P值大于0.05说明数据正态

# y = 2 * pnorm(q = zscore, lower.tail = FALSE)
# 
# f <- function(y) { 
#   if (diff(range(y)) == 0) NULL else shapiro.test(y)$p.value
# }
# 
# f(y)

# apply(mtcars[,2:5], 1, f)


ratio_bdata <- read.csv("C:\\r_workspace\\220322_113919-ratio数据求pvalue绘制ROC\\ratio_data\\ratio_B15_neg.csv")
log2_ratio_bdata <- read.csv("C:\\r_workspace\\220322_113919-ratio数据求pvalue绘制ROC\\log2_ratio_data\\log2_ratio_B15_neg.csv")
# 正态分布检验
# 方法2: Q-Q 图
library(ggpubr)
ggqqplot(ratio_bdata$QC1,color = "blue",main="B15_neg_ratio_QC1 Q-Q Plot")



ggqqplot(log2_ratio_bdata$QC1,color = "blue",main="B15_neg_log2_ratio_QC1 Q-Q Plot")

# 方法3: 概率密度曲线比较法
library("ggpubr")
ggdensity(ratio_bdata$QC1,
          main = "B15_neg_ratio_QC1",
          xlab = "sepal length",,col="blue",lwd=2)


ggdensity(log2_ratio_bdata$QC1,
          main = "B15_neg_log2_ratio_QC1",
          xlab = "sepal length",,col="blue",lwd=2)
```

### Venn图

```R
library(VennDiagram)
library(grid)
venn.plot <- draw.pairwise.venn(
  area1 = 754,  # 区域1的数
  area2 = 687,  # 区域2的数
  cross.area = 139,  # 交叉数
  category = c("1693_neg(754)", "15minT_neg(687)"),  # 分类名称
  fill = c("red", "blue"),  # 区域填充颜色
  lty = "blank",  # 区域边框线类型
  cex = 2,  # 区域内部数字的字体大小
  cat.cex = 1.5,  # 分类名称的字体大小
  cat.col = c("red", "blue"),  # 分类名称的显示颜色
  cat.pos = c(185, 185), #分类名称在圆的位置，默认正上方，通过角度进行调整
  # cat.dist = 0.09,   #分类名称距离边的距离（可以为负数）
  # cat.just = list(c(-1, -1), c(1, 1)),  #分类名称的位置
  # alpha = 0.7,  # 透明度
)

#将venn.plot通过grid.draw画到pdf文件中
pdf("venn.pdf")
grid.draw(venn.plot)
dev.off()
```

![image-20220321115906723](C:\Users\cuite\Documents\GitHub\NoteBook_Markdown\images\image-20220321115906723.png)

### 柱状累计分布图

```R
data <- matrix(c(2587, 4576, 2457, 2946, 6670, 5790, 5862, 5421), ncol = 4, nrow = 2)
colnames(data) <- c('B-neg', 'T-neg', 'B-pos', 'T-pos')
data
barplot(height = data,
        main = "15minB和T",  # 标题
        col = c('green', 'white'),  # 填充颜色
        legend.text = c('Total','Match'),#设置图例的内容
        args.legend = list(x = "topright", cex=0.7), #修改图例的位置
        xlim = c(0, 9),
        ylim = c(0, 12000), # Y轴范围
        width = 1.5,  # 必须指定xlim
)
```

![image-20220321161630956](C:\Users\cuite\Documents\GitHub\NoteBook_Markdown\images\image-20220321161630956.png)

### 箱体图

```R
# 箱体图
library(data.table)
library(ggplot2)
dat <-
  data.table(
    Spring = c(runif(9, 0, 1), 2),
    Summer = runif(10, 0, 1),
    Autumn = runif(10, 0, 1),
    Winter = runif(10, 0, 1)
  )
dat1 = melt(dat)
ggplot(data = dat1, aes(x = variable, y = value)) +  geom_boxplot()
ggplot(data = dat1, aes(x = variable, y = value, colour = variable)) + geom_boxplot()
```



### ggpolt保存svg

```R
require("ggplot2")
head(diamonds) 
qplot(clarity, data=diamonds, fill=cut, geom="bar")
image=qplot(clarity, data=diamonds, fill=cut, geom="bar")
# 保存图片
ggsave(file="test.svg", plot=image, width=10, height=8)
```

### 双坐标

```R
p1 <- ggplot() + 
geom_col(data = data, aes(x = x_list, y = number_list, fill = x_list), width = 0.1) +
labs(title = NULL, x = NULL, y = NULL, fill = NULL)

p2 <- p1 +
geom_point(data = draw_data, aes(x = x_list, y = ratio_list_num)) + 
geom_line(data = draw_data, aes(x = x_list, y = ratio_list_num), group = 1, size = 1.3) + 
geom_text(size = 4, aes(x_list, ratio_list_num, label = ratio_list_text), vjust = -0.6, fontface = "bold")
p2

filename <- paste0(project_uuid, "_rsd_NB_SP.png")
ggsave(file=filename, plot=p2, width=8, height=6)
```

### 转换为因子保证顺序不变

```R
draw_data$x_list <- factor(draw_data$x_list, levels = x_list)  # 保证X轴顺序不变
data$x_list <- factor(data$x_list, levels = x_list)  # 保证X轴顺序不变
```

### 数字转为百分比

```R
# 转换为可显示的百分比字符串
ratio_list2 <- round(ratio_list * 100, 1)
x <- NULL
x2 <- NULL
for (i in ratio_list2) {
  x2 <- c(x2, i)
  s <- paste0(i, "%")
  x <- c(x, s)
}
ratio_list_text <- x  # 显示的百分比字符串 91.7%
ratio_list_num <- x2  # 数字 91.7
```



### 生成峰PDF图

```R
# GeneratePeakPDF.R
library(reshape2)
library(tidyr)
library(ids)
library(lars)
library(ggplot2)
library(ggrepel)


GeneratePeakPDF <-
  function(jinyangbiao,
           jifenbiao,
           peakheightbiao,
           outpath ,
           n_Cores = 0) {
    # 读取进样表
    zp_sample_data <-
      data.frame(data.table::fread(jinyangbiao, encoding = "UTF-8"))
    colnames(zp_sample_data)[2] <- c("type")  # 修改列名
    colnames(zp_sample_data)[4] <- c("sample_number")
    
    # 读取积分数据
    jifen_data <-
      data.frame(data.table::fread(jifenbiao, encoding = "UTF-8"))
    colnames(jifen_data)[2] <- "feature"
    
    # 读取原始峰高数据
    peakheight_data <-
      data.frame(data.table::fread(peakheightbiao, encoding = "UTF-8"))
    
    
    func_excute_peak_graph <-
      function(m,
               sample_data,
               jifen_data,
               peakheight_data,
               outpath) {
        library(reshape2)
        library(tidyr)
        library(ids)
        library(lars)
        library(ggplot2)
        library(ggrepel)
        
        input_sample_number <- sample_data[m, "sample_number"]
        
        no = paste0("00", m)
        no_result <- substring(no, nchar(no) - 2, nchar(no))
        
        pdf(
          file = paste0(outpath, "#", no_result, "_", input_sample_number, ".pdf"),
          useDingbats = FALSE,
          paper = "a4r",
          width = 14,
          height = 6
        )
        
        
        QueryData <-
          subset(jifen_data, sample_number == input_sample_number)
        
        for (n in 1:nrow(QueryData)) {
          print(n)
          dat = QueryData[n,]
          
          input_feature <- dat[1, "feature"]
          
          bdata <-
            subset(peakheight_data,
                   sample == input_sample_number & feature == input_feature)
          
          s_index = dat[, "rt_start_index"]
          e_index = dat[, "rt_end_index"]
          rt = dat[, "new_rt"]
          new_rt_decimal = dat[, "new_rt_decimal"]
          
          peak_height_base_line = dat[, "peak_height_base_line"]
          expect_rt = dat[, "expect_rt"]
          peak_area = dat[, "peak_area"]
          predict_rt = dat[, "predict_rt"]
          isblk_height = dat[, "isblk_height"]
          if (rt == 0) {
            rt = expect_rt
            new_rt_decimal = expect_rt
          }
          
          peak_data <- bdata[c(s_index:e_index),]
          
          title = paste(
            "Feature = ",
            input_feature,
            "RT = ",
            rt,
            "ExpectRT = ",
            expect_rt,
            "PredictRT = ",
            round(predict_rt, 3),
            "PeakArea=",
            peak_area,
            "BLK height=",
            isblk_height
          )
          
          p = ggplot() +
            geom_line(bdata, mapping = aes(timing, height)) +
            geom_area(
              peak_data,
              mapping = aes(timing, height),
              fill = 'blue',
              alpha = 0.3
            ) +
            xlab('RT') +
            ylab('Abundance') +
            ggtitle(title) +
            # ggtitle(stringr::str_wrap(title, width = 80)) +
            geom_vline(
              xintercept = new_rt_decimal,
              linetype = 4,
              size = 0.8,
              colour = "#0DAE51"
            ) +
            geom_hline(
              yintercept = peak_height_base_line,
              linetype = 2,
              size = 0.8,
              colour = "#FE7200"
            ) +
            theme_bw()
          
          grid::grid.draw(p)
        }
        
        dev.off()
        
      }
    
    require(parallel)
    require(doParallel)
    if (n_Cores == 0) {
      n_Cores <- detectCores()
    }
    cluster_Set <- makeCluster(n_Cores)
    registerDoParallel(cluster_Set)
    
    # 查询进样表neg样本
    sql = paste0(
      "select sample_number from zp_sample_data where sample_number <> 'wash'  and sample_number <> 'BLK' ",
      " and type = 'neg' ;"
    )
    sample_data_neg = sqldf::sqldf(sql)
    
    # 查询进样表npos样本
    sql = paste0(
      "select sample_number from zp_sample_data where sample_number <> 'wash'  and sample_number <> 'BLK' ",
      " and type = 'pos' ;"
    )
    sample_data_pos = sqldf::sqldf(sql)
    
    sample_data <- sample_data_neg
    if (nrow(sample_data_neg) == 0) {
      sample_data = sample_data_pos
    }
    count = nrow(sample_data)
    
    r <- foreach(m = 1:count) %dopar% func_excute_peak_graph(m, sample_data, jifen_data, peakheight_data, outpath)
    
    stopCluster(cluster_Set)
    stopImplicitCluster()
    
  }
```

```R
# Run.R
source("D:/r_workspace/GeneratePeakPDF/GeneratePeakPDF.R")

jinyangbiao = "D:/r_workspace/GeneratePeakPDF/data/进样序列表20211224.csv"
jifenbiao = "D:/r_workspace/GeneratePeakPDF/data/MS03@20211224&merge_draw_info_result_final.csv"
peakheightbiao = "D:/r_workspace/GeneratePeakPDF/data/MS03@20211224&merge_wiff_file_result.csv"
outpath = "D:/r_workspace/GeneratePeakPDF/output/"
n_Cores = 0

GeneratePeakPDF(jinyangbiao, jifenbiao, peakheightbiao, outpath, n_Cores)

print('PDF ok!')
```



## 其它

### 异常

  ```R
tryCatch({
    
}, error = function(e) {
  print(e)
}, finally = {
    
})
  ```

### for和if

```R
for(RSD in RSD_list) {
  RSD <- as.numeric(RSD)
  if (RSD <= 5) {
    A = A + 1
  } else if (5 < RSD & RSD <= 10) {
    B = B + 1
  }
  else if (10 < RSD & RSD <= 15) {
    C = C + 1
  }
  else if (15 < RSD & RSD <= 20) {
    D = D + 1
  }
  else if (20 < RSD & RSD <= 30) {
    E = E + 1
  }
  else if (30 < RSD) {
    G = G + 1
  }
}
```

```R
# for循环求每一列的cv
for (i in 1:length(feature)) {
  sub_data <- b_data[, feature[i]]
  cv_lot <- round(sd(sub_data) / mean(sub_data) * 100, 2)
  
  # 判断是否为空
  if (is.null(cv_lot_all)) {
    cv_lot_all <- cv_lot
  } else {
    cv_lot_all <- c(cv_lot_all, cv_lot)
  }
}
```



### NA值处理

```R
# 将NA值赋值为极小值
i_data[is.na(i_data)] <- 1e-10

# 将NA置为0
i_data[is.na(i_data)] <- 0
```



## R相关code

### 矩阵相除

```R
division_value <- round((mat1 / mat2), 2)
```



### 获取mz

```R
data1 <- data.frame(data.table::fread('MS1.csv'))
# data2 <- data.frame(data.table::fread('2.csv'))

# 计算有多少行数据
nrow_data1 <- nrow(data1)
# nrow_data2 <- nrow(data2)
# step <- 2
# data2_new <- data2[-c(1:step, (nrow_data2-step+1):nrow_data2), ]
# data2_new
ms1_list <- unique(data1$ms1)

ms1_list <- unique(data1$ms1)
ms1_list[1]
per_ms1_data <- data1[which(data1[, 1] == ms1_list[1]), ]
per_ms1_data_scan_list <- unique(per_ms1_data$scan)
per_scan_data <-
  per_ms1_data[which(per_ms1_data[, 2] == per_ms1_data_scan_list[1]), ]

# 获取ms1的mz
mz_str <- unique(per_scan_data$ms1)
mz_str2 <- strsplit(tail(strsplit(mz_str, ' ')[[1]], 1), '-')[[1]]
mz_str2 <- gsub("\\[", "", mz_str2)
mz_str2 <- gsub("\\]", "", mz_str2)
mz <- (as.numeric(mz_str2[1]) + as.numeric(mz_str2[2])) / 2
mz

# 计算mz上下10ppm
mz_min <- mz - (mz * 10 / 1000000)
mz_max <- mz + (mz * 10 / 1000000)

# 判断所在范围内的mz 取强度最高的峰
```

```R
data1 <- data.frame(data.table::fread('MS1.csv'))

ms1_list <- unique(data1$ms1)
# for(i in ms1_list){
#   
# }
ms1_list[1]
per_ms1_data <- data1[which(data1[, 1] == ms1_list[1]), ]
per_ms1_data_scan_list <- unique(per_ms1_data$scan)
per_scan_data <-
  per_ms1_data[which(per_ms1_data[, 2] == per_ms1_data_scan_list[1]), ]

# 获取ms1的mz
mz_str <- unique(per_scan_data$ms1)
mz_str2 <- strsplit(tail(strsplit(mz_str, ' ')[[1]], 1), '-')[[1]]
mz_str2 <- gsub("\\[", "", mz_str2)
mz_str2 <- gsub("\\]", "", mz_str2)
mz <- (as.numeric(mz_str2[1]) + as.numeric(mz_str2[2])) / 2
mz

# 计算mz上下10ppm
mz_min <- mz - (mz * 10 / 1000000)
mz_max <- mz + (mz * 10 / 1000000)

# 判断所在范围内的mz 取强度最高的峰
mz_range <-
  per_scan_data[which(mz_min <= per_scan_data$mz &
                        per_scan_data$mz <= mz_max), ]
if (nrow(mz_range) == 0) {
  print("null")
} else {
  # 取强度最高的峰
  print("have value")
  max_intensity <- subset(mz_range, max_intensity == max(mz_range$intensity))
  print(max_intensity)
}
```

```python
# # # 定义峰高高于最高峰的1/4值才是峰
# # peak_index = list(find_peaks_index(all_scan_df["intensity"], all_scan_df['intensity'].max() / 4))

# # 所有scan
# all_scans = sorted(list(set(list(all_scan_df["scan"].values))))

# # 从533母离子中找到每个scan上的峰之和
# df_tmp = pd.DataFrame()
# all_total_intensity = []
# for scan in all_scans:
#     # 找到533母离子 scan为5548的数据
#     per_scan_df = ms2_df[(ms2_df["ms1_mz"] == ms1_mz) & (ms2_df["scan"] == scan)]
#     # per_scan_df = ms2_df[(ms2_df["ms1_mz"] == 533) & (ms2_df["scan"] == 5548)]

#     # 定义峰高高于10的值才是峰
#     peak_index = list(find_peaks_index(per_scan_df["intensity"], 10))

#     # 找到每一个scan的所有峰, 累加之和, 代表MS2上的intensity
#     total_intensity = per_scan_df.iloc[peak_index, ]["intensity"].sum()
#     all_total_intensity.append(total_intensity)

# # 转为DataFrame
# df_tmp['scan'] = pd.DataFrame(all_scans)
# df_tmp['intensity'] = pd.DataFrame(all_total_intensity)
# df_tmp = df_tmp.sort_values(by='intensity', ascending=False)  # 按照intensity降序排序
# print(df_tmp)
```



### lowess 局部加权回归

```R
func_lowess <- function(b_data_qc) {
  # 数据转置
  b_data_qc_t <- data.frame(t(b_data_qc))
  b_data_qc_lowess_t <- b_data_qc_t
  
  # 对每一列数据做lowess 局部加权回归
  for (i in 1:ncol(b_data_qc_lowess_t)) {
    x = b_data_qc_lowess_t[, i]
    y = lowess(x)
    b_data_qc_lowess_t[, i] = as.numeric(y$y)
  }
  
  # 数据转置回去
  b_data_qc_lowess <- data.frame(t(b_data_qc_lowess_t))
  return(b_data_qc_lowess)
}
```

### NormalizeRatio 归一化Ratio

```R
# Normalize
func_getNormalizeData <- function(b_data, sample_names_filter, qc_prefix = qc_prefix) {
    # 获取qc数据的归一化后的数据
    b_data_filter <- b_data[, sample_names_filter]
    b_data_qc <- b_data_filter[, grep(qc_prefix, colnames(b_data_filter))]
    b_data_other <- b_data_filter[,-grep(qc_prefix, colnames(b_data_filter))]
    b_data_qc_lowess <- func_lowess(b_data_qc)
    
    # 绑定数据
    b_data_lowess <- cbind(b_data_qc_lowess, b_data_other)
    
    # 求每一行qc的均值
    b_data_lowess <- b_data_lowess[, sample_names_filter]
    qc_num <- grep(qc_prefix, colnames(b_data_lowess))
    mean_qc <- rowMeans(data.frame(b_data_lowess[,  qc_num]))
    
    b_data_lowess_add <- b_data_lowess
   	# 根据qc的个数进行判断
    if (qc_num[1] != 1) {
      qc_s_name <- paste0(colnames(b_data_lowess)[qc_num[1]], paste0(qc_prefix, "S"))
      b_data_lowess_add <- cbind(data.frame(b_data_lowess[, qc_num[1]]), b_data_lowess_add)
      colnames(b_data_lowess_add)[1] <- qc_s_name
    }
    
    if (qc_num[length(qc_num)] != ncol(b_data_lowess)) {
      qc_e_name <- paste0(colnames(b_data_lowess)[qc_num[length(qc_num)]], paste0(qc_prefix, "E"))
      b_data_lowess_add <- cbind(b_data_lowess_add, data.frame(b_data_lowess[, qc_num[length(qc_num)]]))
      colnames(b_data_lowess_add)[ncol(b_data_lowess_add)] <- qc_e_name
    }
    
    qc_num <- grep(qc_prefix, colnames(b_data_lowess_add))
    for (i in 2:ncol((b_data_lowess_add) - 1)) {
      name <- colnames(b_data_lowess_add)[i]
      if (stringr::str_detect(name, qc_prefix) == FALSE) {
        q_s <- qc_num[which(qc_num > i)[1] - 1]
        q_e <- qc_num[which(qc_num > i)[1]]
        
        q_s_data <- b_data_lowess_add[, q_s]
        q_e_data <- b_data_lowess_add[, q_e]
        
        b_data_lowess_add[, i] <- b_data_lowess_add[, i] * (q_s_data + q_e_data) / 2 / mean_qc
      }
    }
    nm_b_data_lowess_filter <- b_data_lowess_add[, sample_names_filter]
    nm_b_data_lowess_final <- round(nm_b_data_lowess_filter, 0)
    
    result <- list(mean_qc = mean_qc, nm_b_data_lowess_final = nm_b_data_lowess_final)
    
    return(result)
  }


func_getNormalizeRatioData <-
  function(b_data, sample_names_filter, qc_prefix = "_LH50_") {
    result <- func_getNormalizeData(b_data, sample_names_filter, qc_prefix)
    
    nm_b_data_lowess <- result$nm_b_data_lowess_final
    nm_b_data_lowess <- nm_b_data_lowess[, -1]
    mean_qc <- result$mean_qc
    ratio_nm_b_data_lowess <- nm_b_data_lowess
    
    # 对每一列数据除以QC的均值
    for (i in 1:ncol((nm_b_data_lowess))) {
      ratio_nm_b_data_lowess[, i] <- nm_b_data_lowess[, i] / mean_qc
    }
      
    # 结果保留三位小数
    ratio_nm_b_data_lowess_filter <- ratio_nm_b_data_lowess[, sample_names_filter]
    ratio_nm_b_data_lowess_final <- 
      cbind(
        feature = rownames(ratio_nm_b_data_lowess_filter),
        signif(ratio_nm_b_data_lowess_filter, 3)
      )
    
    return(ratio_nm_b_data_lowess_final)
  }
```

### rma

```R
# 设置工作路径
setwd("C:\\Users\\cuite\\Documents\\工作\\R_Program\\YX_Opt\\result")

# 多列减一列
func_cols_sub_col1 <- function(cols_data, col1_data) {
  for (i in c(1:ncol(cols_data))) {
    cols_data[, i] <- cols_data[, i] - col1_data
  }
  result_data <- cols_data
  return(result_data)
}

ion_list = c('neg', 'pos')  # neg,pos列表
bat_list = c(1:6)  # 批次号列表
for (ion in ion_list) {
  for (bat_no in bat_list) {
    # 读文件
    filename = paste(ion, "_cv_bat_", bat_no, "_Rma.csv", sep = "")
    print(filename)
    i_data <- data.frame(data.table::fread(filename))
    
    # 过滤
    # yx01Cpooled_1
    col_num_Cpooled <- grep('Cpooled', colnames(i_data))
    cols_data <- i_data[, 2:(col_num_Cpooled - 1)]  # 减数

    col_num_ip_mean <- grep('ip_mean', colnames(i_data))
    col1_data <- i_data[, col_num_ip_mean, drop = F]  # 被减数

    # 多列减一列
    result_data <- func_cols_sub_col1(cols_data, col1_data)

    # 行名
    feature <- i_data[, 1]
    result_data <- cbind(feature, result_data)

    # 保存为csv文件
    csv_filename <-
      paste("neg_cv_bat_", bat_no, "_Rma_ratio.csv", sep = "")
    data.table::fwrite(result_data,
                       csv_filename,
                       sep = ",",
                       row.names = F)
  }
}
```

### 计算R²/Titration线性关系

```r
x = c(0, 10, 20, 30, 40, 30, 75, 100)
y = c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.75, 1)
model <- lm(y ~ x, na.action=na.omit)
s1 <- summary(model)
r2 <- s1$r.squared
r2

# 残差
# residuals <- sqrt(sum(s1$residuals^2))

# Excel里面利用公式也可计算R2
=INDEX(LINEST(Y5:AD5,A5:F5,TRUE,TRUE), 3)

LINEST 函数语法
LINEST(y集合, x集合, 正常计算截距, 返回统计值)
使用index获取第3个参数R2
```

```R
x = c(0, 10, 20, 30, 40, 30, 75, 100)
y = c(0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.75, 1)
model <- lm(y ~ x, na.action=na.omit)
s1 <- summary(model)
r2 <- s1$r.squared
r2

# 残差
# residuals <- sqrt(sum(s1$residuals^2))
```



### 归一化ratio

```R
real_path <- "20211014_QC_run2_sample.csv"
sample_list_data <- data.frame(data.table::fread(real_path))
# sample_list_data <- transform(sample_list_data, SampleName = as.factor(SampleName))

area_filename <- "20211014_QC_run2_area_merge.csv"
ratio_nm_out_filename <- paste0('./ratio_nm_data_', area_filename)
b_data <- data.frame(data.table::fread(area_filename))

rownames(b_data) <- b_data[, 1]

data_colnames <- colnames(b_data)
sample_names <- sample_list_data[, 1]
sample_names_filter <- intersect(sample_names, data_colnames)  # 交集


func_lowess <- function(b_data_qc) {
  b_data_qc_t <- data.frame(t(b_data_qc))
  b_data_qc_lowess_t <- b_data_qc_t
  
  for (i in 1:ncol(b_data_qc_lowess_t)) {
    x = b_data_qc_lowess_t[, i]
    y = lowess(x)
    b_data_qc_lowess_t[, i] = as.numeric(y$y)
  }
  
  b_data_qc_lowess <- data.frame(t(b_data_qc_lowess_t))
  return(b_data_qc_lowess)
}

func_getNormalizeData <- function(b_data, sample_names_filter, qc_prefix = "_QC_") {
  
  b_data_filter <- b_data[, sample_names_filter]	
  b_data_qc <- b_data_filter[, grep(qc_prefix, colnames(b_data_filter))]
  b_data_other <- b_data_filter[, -grep(qc_prefix, colnames(b_data_filter))]
  b_data_qc_lowess <- func_lowess(b_data_qc)
  
  b_data_lowess <- cbind(b_data_qc_lowess, b_data_other)
  
  b_data_lowess <- b_data_lowess[, sample_names_filter]
  qc_num <- grep(qc_prefix, colnames(b_data_lowess))
  mean_qc <- rowMeans(data.frame(b_data_lowess[,  qc_num]))
  
  b_data_lowess_add <- b_data_lowess
  
  if(qc_num[1] != 1){
    qc_s_name <- paste0(colnames(b_data_lowess)[qc_num[1]], paste0(qc_prefix, "S"))
    b_data_lowess_add <- cbind(data.frame(b_data_lowess[, qc_num[1]]), b_data_lowess_add)
    colnames(b_data_lowess_add)[1] <- qc_s_name
  }
  
  if(qc_num[length(qc_num)] != ncol(b_data_lowess)){
    qc_e_name <- paste0(colnames(b_data_lowess)[qc_num[length(qc_num)]], paste0(qc_prefix, "E"))
    b_data_lowess_add <- cbind(b_data_lowess_add, data.frame(b_data_lowess[, qc_num[length(qc_num)]]))
    colnames(b_data_lowess_add)[ncol(b_data_lowess_add)] <- qc_e_name
  }
  
  qc_num <- grep(qc_prefix, colnames(b_data_lowess_add))
  for(i in 2:ncol((b_data_lowess_add) - 1)){
    name <- colnames(b_data_lowess_add)[i]
    if(stringr::str_detect(name, qc_prefix) == FALSE){
      q_s <-qc_num[which(qc_num > i)[1] - 1]
      q_e <-qc_num[which(qc_num > i)[1]]
      
      q_s_data <- b_data_lowess_add[, q_s]
      q_e_data <- b_data_lowess_add[, q_e]
      
      b_data_lowess_add[, i] <- b_data_lowess_add[, i] *(q_s_data + q_e_data)/2 / mean_qc
    }
  }
  nm_b_data_lowess_filter <- b_data_lowess_add[, sample_names_filter]
  nm_b_data_lowess_final <- cbind(feature=rownames(nm_b_data_lowess_filter), round(nm_b_data_lowess_filter,0))
  
  result <- list(mean_qc = mean_qc,
                 nm_b_data_lowess_final = nm_b_data_lowess_final)
  return(result)
}


result <- func_getNormalizeData(b_data, sample_names_filter)

nm_b_data_lowess <- result$nm_b_data_lowess_final


nm_b_data_lowess <- nm_b_data_lowess[, -1]
mean_qc <- result$mean_qc
ratio_nm_b_data_lowess <- nm_b_data_lowess
for(i in 1:ncol((nm_b_data_lowess) )){
  ratio_nm_b_data_lowess[, i] <- nm_b_data_lowess[, i] / mean_qc
}
ratio_nm_b_data_lowess_filter <- ratio_nm_b_data_lowess[, sample_names_filter]
ratio_nm_b_data_lowess_final <- cbind(feature=rownames(ratio_nm_b_data_lowess_filter), signif(ratio_nm_b_data_lowess_filter, 5))
  

data.table::fwrite(ratio_nm_b_data_lowess_final, ratio_nm_out_filename)
```

### demo

读文件 过滤数据  添加新列

```R
# 读取csv文件
data <- data.frame(data.table::fread("testdata.csv", sep = ",", header = T))

# 标准差
rowSd = function(x) {
  apply(x, 1, function(x)
    (sd(x)))
}

# 获取所有N开头的数据
pattern <- "^N_"
N.colnum <- grep(pattern, colnames(data))
data_N <- data[, N.colnum]
# 求所有N开头的数据的均值 标准差 和, 并赋予新的变量
b_data <- data.frame(data, F_meanN = rowMeans(data_N))
b_data <- data.frame(b_data, F_sdN = rowSd(data_N))
b_data <- data.frame(b_data, F_sumN = rowSums(data_N))

# 获取所有C开头的数据
pattern <- "^C_"
N.colnum <- grep(pattern, colnames(data))
data_N <- data[, N.colnum]

# 追加列 绑定数据
# b_data <- cbind(b_data, data_N)
b_data <- data.frame(b_data, F_meanC = rowMeans(data_N))
b_data <- data.frame(b_data, F_sdC = rowSd(data_N))
b_data <- data.frame(b_data, F_sumC = rowSums(data_N))

# 获取所有A开头的数据
pattern <- "^A_"
N.colnum <- grep(pattern, colnames(data))
data_N <- data[, N.colnum]

b_data <- data.frame(b_data, F_meanA = rowMeans(data_N))
b_data <- data.frame(b_data, F_sdA = rowSd(data_N))
b_data <- data.frame(b_data, F_sumA = rowSums(data_N))

# 将最终b_data数据写入到新的csv文件中去
data.table::fwrite(
  b_data,
  "data_result.csv",
  sep = ",",
  quote = FALSE,
  row.names = FALSE
)
```

### anova 的 p_value

```R
# 设置工作路径
setwd("C:\\Users\\cuite\\Documents\\工作\\R_Program")

# Anova
b_data_ratio_fc_t <-
  data.frame(
    data.table::fread(
      "N_data_neg_final_t.csv",
      sep = ",",
      header = T
    )
  )

# 特征名
compound <- colnames(b_data_ratio_fc_t)
compound <- compound[-c(1,2)]

sample_no <- b_data_ratio_fc_t[, 1]  # 第一列 样本编号全称
b_data_ratio_fc_t <- b_data_ratio_fc_t[, -1]

# mdrrClass 只有N和C
mdrrClass <- b_data_ratio_fc_t[, 1]
mdrrClass[mdrrClass == "A"]<- "C"  # 把A类当做C类

newdata <- b_data_ratio_fc_t[, -1]

func_excute_aov <- function(i, newdata, mdrrClass){
  col.name <- colnames(newdata)[i]
  data_aov <- aov(newdata[, i] ~ mdrrClass)
  a1 = summary(data_aov)
  pvalue = a1[[1]][["Pr(>F)"]][1]
  anova_name_nc <- c(col.name)
  anova_value_nc_pvalue <- pvalue
  
  result <- c(anova_name_nc,  anova_value_nc_pvalue)
  
  return(result)
}


require(parallel)
require(doParallel)
n_Cores <- detectCores()
cluster_Set <- makeCluster(n_Cores)
registerDoParallel(cluster_Set)

count <- ncol(newdata)
system.time({
  r <- foreach(
    i = 1:count,
    .combine = 'rbind'
  ) %dopar% func_excute_aov(i, newdata, mdrrClass)
})
stopCluster(cluster_Set)
stopImplicitCluster()
detach("package:doParallel", unload = TRUE)
detach("package:parallel", unload = TRUE)

save(r, file = "r.Rdata")
anova_nc = data.frame(r)

# # 遍历每一列
# for (i in 1:ncol(newdata)) {
#   print(i)
#   col.name <- colnames(newdata)[i]  # 每一列的列名
#   data_aov <- aov(newdata[, i] ~ mdrrClass)
#   a1 = summary(data_aov)
#   pvalue = a1[[1]][["Pr(>F)"]][1]  # pvalue的值 0.069
#   p <- TukeyHSD(data_aov)
#   
#   N_C <- p[["mdrrClass"]]["N-C", 4]  # N_C为校正的值 0.069
#   
#   # 赋予列名
#   if (is.null(anova_name_nc)) {
#     anova_name_nc <- c(col.name)
#   } else {
#     anova_name_nc <- c(anova_name_nc, col.name)
#   }
#   
#   # 赋予pvalue值 和 N_C值
#   if (is.null(anova_value_nc)) {
#     anova_value_nc <- c(N_C)
#     anova_value_nc_pvalue <- pvalue
#   } else {
#     anova_value_nc <- c(anova_value_nc, N_C)
#     anova_value_nc_pvalue <- c(anova_value_nc_pvalue, pvalue)
#   }
#   
# }
# 
# anova_nc <- data.frame(anova_value_nc_pvalue)

rownames(anova_nc) <- compound

# 读原始文件
data_neg_final <-
  data.frame(
    data.table::fread(
      "N_data_100_test.csv",
      sep = ",",
      header = T
    )
  )

# 赋值列名
rownames(data_neg_final) <- data_neg_final[, 1]
# 将p_value值 追加到最后
data_neg_final <- cbind(data_neg_final,
                        anova_nc)

data.table::fwrite(data_neg_final, "N_data_neg_final_anova_test.csv", quote = FALSE, sep = ",", row.names = FALSE)

```

### fc 和 pvalue

### 计算fc

```R
# 设置工作路径
setwd("C:\\Users\\cuite\\Documents\\工作\\R_Program")


# 1.读取csv文件
i_data <- data.frame(data.table::fread("relative.abundance.csv"))

compound <- rownames(i_data)

b_data <- i_data[, 2:45]

# 2.为每列数据加上列均值(排除0干扰)
b_data <- apply(b_data, 2, function(x) {
  x + (mean(x))
})
# 3.将数据分为正常和非正常数据
pattern <- paste("^N_", sep = "")
N_colnum <- grep(pattern, colnames(i_data))

sample_N <- i_data[, N_colnum]


pattern <- paste("^C_|^A_", sep = "")
C_colnum <- grep(pattern, colnames(i_data))


sample_C <- i_data[, C_colnum]
# 4.求正常和非正常数据每行的均值
b_data <- data.frame(b_data, F_meanN = rowMeans(sample_N))
b_data <- data.frame(b_data, F_meanC = rowMeans(sample_C))

# 5.作商 求fold change
rowRawRatio = function(x) {
  apply(x, 1, function(x)
    (x[1] / x[2]))
}


b_data <-
  data.frame(b_data, F_fc = rowRawRatio(b_data[, c("F_meanC", "F_meanN")]))


write.table(
  cbind(i_data[, 1], b_data),
  "data_final_fc.csv",
  sep = ",",
  row.names = F,
  col.names = T
)
# write.table(
#   cbind(compound, b_data),
#   "./output/area_ratio/N_data_neg_final.csv",
#   quote = FALSE,
#   sep = ",",
#   row.names = FALSE
# )
```



### 计算p_value

```R
# Anova
b_data_ratio_fc_t <- data.frame(data.table::fread("N_data_neg_final_t_test.csv", sep = ",", header = T))

sample_no <- b_data_ratio_fc_t[, 1]  # 第一列 样本编号全称
b_data_ratio_fc_t <- b_data_ratio_fc_t[, -1]

# mdrrClass 只有N和C
mdrrClass <- b_data_ratio_fc_t[, 1]
mdrrClass[mdrrClass == "A"]<- "C"  # 把A类当做C类

newdata <- b_data_ratio_fc_t[, -1]

anova_name_nc <- NULL
anova_value_nc <- NULL
anova_value_nc_pvalue <- NULL

# 遍历每一列
for (i in 1:ncol(newdata)) {
  print(i)
  col.name <- colnames(newdata)[i]  # 每一列的列名
  data_aov <- aov(newdata[, i] ~ mdrrClass, data = newdata)
  a1 = summary(data_aov)
  pvalue = a1[[1]][["Pr(>F)"]][1]  # pvalue的值 0.069
  p <- TukeyHSD(data_aov)
  
  N_C <- p[["mdrrClass"]]["N-C", 4]  # N_C为校正的值 0.069
  
  # 赋予列名
  if (is.null(anova_name_nc)) {
    anova_name_nc <- c(col.name)
  } else {
    anova_name_nc <- c(anova_name_nc, col.name)
  }
  
  # 赋予pvalue值 和 N_C值
  if (is.null(anova_value_nc)) {
    anova_value_nc <- c(N_C)
    anova_value_nc_pvalue <- pvalue
  } else {
    anova_value_nc <- c(anova_value_nc, N_C)
    anova_value_nc_pvalue <- c(anova_value_nc_pvalue, pvalue)
  }
  
}

anova_nc <- data.frame(anova_value_nc_pvalue)

rownames(anova_nc) <- compound


data_neg_final <-
  data.frame(
    data.table::fread(
      "N_data_neg_final.csv",
      sep = ",",
      header = T
    )
  )
rownames(data_neg_final) <- data_neg_final[, 1]

data_neg_final <- cbind(data_neg_final,
                        anova_nc)

write.table(data_neg_final, "N_data_neg_final_anova.csv", quote = FALSE, sep = ",", row.names = FALSE)

```

### pvalue计算Anova

```R
# 读取转置之后的 N_data_neg_final_t.csv 文件 进行p_value的计算 计算后追加到最后一列

# 设置工作路径
setwd("C:\\Users\\cuite\\Documents\\工作\\R_Program")

# Anova
b_data_ratio_fc_t <-
  data.frame(
    data.table::fread(
      "N_data_neg_final_t.csv",
      sep = ",",
      header = T
    )
  )

# 特征名
compound <- colnames(b_data_ratio_fc_t)
compound <- compound[-c(1,2)]

sample_no <- b_data_ratio_fc_t[, 1]  # 第一列 样本编号全称
b_data_ratio_fc_t <- b_data_ratio_fc_t[, -1]

# mdrrClass 只有N和C
mdrrClass <- b_data_ratio_fc_t[, 1]
mdrrClass[mdrrClass == "A"]<- "C"  # 把A类当做C类

newdata <- b_data_ratio_fc_t[, -1]

anova_name_nc <- NULL
anova_value_nc <- NULL
anova_value_nc_pvalue <- NULL

# 遍历每一列
for (i in 1:ncol(newdata)) {
  print(i)
  col.name <- colnames(newdata)[i]  # 每一列的列名
  data_aov <- aov(newdata[, i] ~ mdrrClass, data = newdata)
  a1 = summary(data_aov)
  pvalue = a1[[1]][["Pr(>F)"]][1]  # pvalue的值 0.069
  p <- TukeyHSD(data_aov)
  
  N_C <- p[["mdrrClass"]]["N-C", 4]  # N_C为校正的值 0.069
  
  # 赋予列名
  if (is.null(anova_name_nc)) {
    anova_name_nc <- c(col.name)
  } else {
    anova_name_nc <- c(anova_name_nc, col.name)
  }
  
  # 赋予pvalue值 和 N_C值
  if (is.null(anova_value_nc)) {
    anova_value_nc <- c(N_C)
    anova_value_nc_pvalue <- pvalue
  } else {
    anova_value_nc <- c(anova_value_nc, N_C)
    anova_value_nc_pvalue <- c(anova_value_nc_pvalue, pvalue)
  }
  
}

anova_nc <- data.frame(anova_value_nc_pvalue)

rownames(anova_nc) <- compound

# 读原始文件
data_neg_final <-
  data.frame(
    data.table::fread(
      "data_final_fc.csv",
      sep = ",",
      header = T
    )
  )

# 赋值列名
rownames(data_neg_final) <- data_neg_final[, 1]
# 将p_value值 追加到最后
data_neg_final <- cbind(data_neg_final,
                        anova_nc)

write.table(data_neg_final, "N_data_neg_final_anova.csv", quote = FALSE, sep = ",", row.names = FALSE)

```

### 连接数据库做归一化处理

```R
library(reshape2)
library(tidyr)
library(ids)
library(RMySQL)

# AreaData
func_getAreaData <- function(project_uuid, user, password) {
  con <- dbConnect(MySQL(), host="localhost", dbname="zjap", user=user, password=password)
  
  # dbListTables(con)  # 列出表
  
  # 读数据库
  dbReadTable(con,"zp_integration_data")  # 中文出现乱码，这是因为字符编码格式不统一的问题
  dbSendQuery(con,'SET NAMES utf8')
  dbReadTable(con,"zp_integration_data")  # 没有乱码问题了
  
  # 查询数据
  QueryData <- dbGetQuery(
    con,
    paste0("select sample_number, ion_code, peak_area from zp_integration_data where project_uuid = '", project_uuid ,"'")
  )
  
  sample_number = QueryData[, 'sample_number']
  ion_code = QueryData[, 'ion_code']
  peak_area = QueryData[, 'peak_area']
  
  # 转换格式
  x <- QueryData
  x = transform(x, peak_area=as.numeric(as.character(peak_area)))
  x = transform(x, ion_code=(as.character(ion_code)))
  x = transform(x, sample_number=(as.character(sample_number)))
  
  transform_data <- acast(x, ion_code~sample_number, value.var="peak_area")
  area_data <- transform_data
  
  dbDisconnect(con)  # 断开连接
  
  return(area_data)
}


# InjectSampleData
func_getInjectSampleData <- function(project_uuid, user, password) {
  
  con <- dbConnect(MySQL(), host="localhost", dbname="zjap", user=user, password=password)
  
  dbReadTable(con,"zp_inject_data")  # 中文出现乱码，这是因为字符编码格式不统一的问题
  dbSendQuery(con,'SET NAMES utf8')
  dbReadTable(con,"zp_inject_data")  # 没有乱码问题了
  
  
  inject_sample_data <- dbGetQuery(
    con,
    paste0("select sample_number, inject_time, if_use from zp_inject_data where project_uuid = '", project_uuid, "'" , " order by inject_time asc;")
  )
  
  inject_sample_data <- subset(inject_sample_data, if_use== 1)
  
  sample_names <- inject_sample_data[, 1]
  sample_names_filter <- sample_names
  
  dbDisconnect(con)  # 断开连接
  
  return(sample_names_filter)
}


# lowess
func_lowess <- function(b_data_qc) {
  b_data_qc_t <- data.frame(t(b_data_qc))
  b_data_qc_lowess_t <- b_data_qc_t
  
  for (i in 1:ncol(b_data_qc_lowess_t)) {
    x = b_data_qc_lowess_t[, i]
    y = lowess(x)
    b_data_qc_lowess_t[, i] = as.numeric(y$y)
  }
  
  b_data_qc_lowess <- data.frame(t(b_data_qc_lowess_t))
  return(b_data_qc_lowess)
}


# Normalize
func_getNormalizeData <- function(b_data, sample_names_filter, qc_prefix = qc_prefix) {
  
  b_data_filter <- b_data[, sample_names_filter]	
  b_data_qc <- b_data_filter[, grep(qc_prefix, colnames(b_data_filter))]
  b_data_other <- b_data_filter[, -grep(qc_prefix, colnames(b_data_filter))]
  b_data_qc_lowess <- func_lowess(b_data_qc)
  
  b_data_lowess <- cbind(b_data_qc_lowess, b_data_other)
  
  b_data_lowess <- b_data_lowess[, sample_names_filter]
  qc_num <- grep(qc_prefix, colnames(b_data_lowess))
  mean_qc <- rowMeans(data.frame(b_data_lowess[,  qc_num]))
  
  b_data_lowess_add <- b_data_lowess
  
  if(qc_num[1] != 1){
    qc_s_name <- paste0(colnames(b_data_lowess)[qc_num[1]], paste0(qc_prefix, "S"))
    b_data_lowess_add <- cbind(data.frame(b_data_lowess[, qc_num[1]]), b_data_lowess_add)
    colnames(b_data_lowess_add)[1] <- qc_s_name
    
    
  }
  
  if(qc_num[length(qc_num)] != ncol(b_data_lowess)){
    qc_e_name <- paste0(colnames(b_data_lowess)[qc_num[length(qc_num)]], paste0(qc_prefix, "E"))
    b_data_lowess_add <- cbind(b_data_lowess_add, data.frame(b_data_lowess[, qc_num[length(qc_num)]]))
    colnames(b_data_lowess_add)[ncol(b_data_lowess_add)] <- qc_e_name
    
  }
  
  qc_num <- grep(qc_prefix, colnames(b_data_lowess_add))
  for(i in 2:ncol((b_data_lowess_add) - 1)){
    name <- colnames(b_data_lowess_add)[i]
    if(stringr::str_detect(name, qc_prefix) == FALSE){
      q_s <-qc_num[which(qc_num > i)[1] - 1]
      q_e <-qc_num[which(qc_num > i)[1]]
      
      q_s_data <- b_data_lowess_add[, q_s]
      q_e_data <- b_data_lowess_add[, q_e]
      
      b_data_lowess_add[, i] <- b_data_lowess_add[, i] *(q_s_data + q_e_data)/2 / mean_qc
    }
  }
  nm_b_data_lowess_filter <- b_data_lowess_add[, sample_names_filter]
  nm_b_data_lowess_final <- round(nm_b_data_lowess_filter,0)
  
  result <- list(mean_qc = mean_qc, nm_b_data_lowess_final = nm_b_data_lowess_final)
  
  return(result)
}


# 将归一化数据写入数据库 
func_getNormalizeRatioData2db <- function(project_uuid, user, password) {

  # project_uuid <- '402880e8783db00b01783dbe98550003'
  # user <- "root"
  # password <- "123456"
  
  project_uuid <- project_uuid
  user <- user
  password <- password
  
  b_data <- func_getAreaData(project_uuid, user, password)  # 获取积分数据
  sample_names_filter <- func_getInjectSampleData(project_uuid, user, password)  # 获取进样数据
  
  
  qc_prefix = '_QC_'
  result <- func_getNormalizeData(b_data, sample_names_filter, qc_prefix)
  nm_b_data_lowess <- result$nm_b_data_lowess_final
  # data.table::fwrite(nm_b_data_lowess, "./lowess_data.csv")
  # 宽数据转换为长数据
  nm_b_data_lowess <- cbind(ion_code=rownames(nm_b_data_lowess), nm_b_data_lowess)
  lowess_data_long <- gather(nm_b_data_lowess,sample_number,normalization_value,2:ncol(nm_b_data_lowess))
  
  
  nm_b_data_lowess <- nm_b_data_lowess[, -1]
  mean_qc <- result$mean_qc
  ratio_nm_b_data_lowess <- nm_b_data_lowess
  for(i in 1:ncol((nm_b_data_lowess) )){
    ratio_nm_b_data_lowess[, i] <- nm_b_data_lowess[, i] / mean_qc
  }
  ratio_nm_b_data_lowess_filter <- ratio_nm_b_data_lowess[, sample_names_filter]
  ratio_nm_b_data_lowess_final <- cbind(ion_code=rownames(ratio_nm_b_data_lowess_filter), signif(ratio_nm_b_data_lowess_filter, 3))
  # data.table::fwrite(ratio_nm_b_data_lowess_final, "./normalize_data.csv")
  
  # 宽数据转换为长数据
  ratio_data_long <- gather(ratio_nm_b_data_lowess_final,sample_number,normalization_ratio_value,2:ncol(ratio_nm_b_data_lowess_final))
  data_final = cbind(lowess_data_long[, c(2,1,3)], normalization_ratio_value = ratio_data_long[, 3])
  data_final
  
  
  # uuid
  uuids <- uuid(n = nrow(data_final), drop_hyphens = FALSE, use_time = NA)
  uuids <- gsub('-', '', uuids)
  zp_normalization_data <- cbind(uuid=uuids, data_final)
  
  # # create_time
  # create_time = format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  # zp_normalization_data <- cbind(zp_normalization_data, create_time, update_time=create_time)
  
  # project_uuid
  zp_normalization_data <- cbind(zp_normalization_data, project_uuid=project_uuid)
  
  # 写入数据库
  con <- dbConnect(MariaDB(), host="localhost", dbname="zjap", user=user, password=password)
  
  # 先删除数据
  # DBI::dbExecute(con, paste0("delete from zp_normalization_data where project_uuid = '",project_uuid ,"'"))
  
  result <- dbWriteTable(con, "zp_normalization_data", zp_normalization_data, append=TRUE)
  if (result) {
    return(TRUE)
  } else{
    return(FALSE)
  }
  
  dbDisconnect(con)  # 断开连接

}


project_uuid <- '402880e8783db00b01783dbe98550003'
user <- "root"
password <- "123456"
func_getNormalizeRatioData2db(project_uuid, user, password)
```

### QC

```R
library(reshape2)
library(tidyr)
library(ids)
library(RMariaDB)


rowCv <- function(x) {
  apply(x, 1, function(x)
    (round(sd(x) / mean(x) * 100, 2)))
}


# SampleData
func_getSampleData <- function(con, project_uuid, user, password) {
  dbSendQuery(con, 'SET NAMES utf8')

  
  sample_data <- dbGetQuery(
    con,
    paste0(
      "select sample_number, if_use from zp_sample_data where project_uuid = '",
      project_uuid,
      "'" ,
      " order by order_index asc;"
    )
  )
  
  sample_data <- subset(sample_data, if_use == 1)
  
  sample_names <- sample_data[, 1]
  sample_names_filter <- sample_names
  
  return(sample_names_filter)
}


# NormalizeRatioData
func_getNormalizeRatioData <- function(con, project_uuid, user, password) {
  # 读数据库
  dbSendQuery(con, 'SET NAMES utf8')

  # 查询数据
  QueryData <- dbGetQuery(
    con,
    paste0(
      "select sample_number, feature, normalization_ratio_value from zp_normalization_data where project_uuid = '",
      project_uuid ,
      "'"
    )
  )
  
  sample_number = QueryData[, 'sample_number']
  feature = QueryData[, 'feature']
  normalization_ratio_value = QueryData[, 'normalization_ratio_value']
  
  # 转换格式
  x <- QueryData
  x = transform(x, normalization_ratio_value = as.numeric(as.character(normalization_ratio_value)))
  x = transform(x, feature = (as.character(feature)))
  x = transform(x, sample_number = (as.character(sample_number)))
  
  transform_data <-
    acast(x, feature ~ sample_number, value.var = "normalization_ratio_value")
  normalize_ratio_data <- transform_data
  
  return(normalize_ratio_data)
}


# TitrationAreaMean

func_calAreaMean <- function(normalize_ratio_data) {
    
    nc_postfix <- "$"
    titration_data <- normalize_ratio_data[, grep(
        paste0(
          "N",
          nc_postfix,
          "|NC10",
          nc_postfix,
          "|NC20",
          nc_postfix,
          "|NC30",
          nc_postfix,
          "|NC40",
          nc_postfix,
          "|NC50",
          nc_postfix,
          "|NC75",
          nc_postfix,
          "|C",
          nc_postfix
        ),
        colnames(normalize_ratio_data)
      )]
    
    np80_colnum <- grep(paste0("N", nc_postfix), colnames(titration_data))  # N
    if (length(np80_colnum) > 0) {
      titration_data <-
        transform(titration_data, N_mean = rowMeans(data.frame(titration_data[, np80_colnum])))
    }
    
    nc10_colnum <-
      grep(paste0("NC10", nc_postfix), colnames(titration_data))
    if (length(nc10_colnum) > 0) {
      titration_data <-
        transform(titration_data, NC10_mean = rowMeans(data.frame(titration_data[, nc10_colnum])))
    }
    nc20_colnum <-
      grep(paste0("NC20", nc_postfix), colnames(titration_data))
    if (length(nc20_colnum) > 0) {
      titration_data <-
        transform(titration_data, NC20_mean = rowMeans(data.frame(titration_data[, nc20_colnum])))
    }
    nc30_colnum <-
      grep(paste0("NC30", nc_postfix), colnames(titration_data))
    if (length(nc30_colnum) > 0) {
      titration_data <-
        transform(titration_data, NC30_mean = rowMeans(data.frame(titration_data[, nc30_colnum])))
    }
    nc40_colnum <-
      grep(paste0("NC40", nc_postfix), colnames(titration_data))
    if (length(nc40_colnum) > 0) {
      titration_data <-
        transform(titration_data, NC40_mean = rowMeans(data.frame(titration_data[, nc40_colnum])))
    }
    nc50_colnum <-
      grep(paste0("NC50", nc_postfix), colnames(titration_data))
    if (length(nc50_colnum) > 0) {
      titration_data <-
        transform(titration_data, NC50_mean = rowMeans(data.frame(titration_data[, nc50_colnum])))
    }
    nc75_colnum <-
      grep(paste0("NC75", nc_postfix), colnames(titration_data))
    if (length(nc75_colnum) > 0) {
      titration_data <-
        transform(titration_data, NC75_mean = rowMeans(data.frame(titration_data[, nc75_colnum])))
    }
    
    
    cp80_colnum <- grep(paste0("C", nc_postfix), colnames(titration_data))  # C
    
    if (length(cp80_colnum) > 0) {
      titration_data <-
        transform(titration_data, C_mean = rowMeans(data.frame(titration_data[, cp80_colnum])))
    }
    
    pattern = "mean"
    tl_column = grep(pattern, colnames(titration_data))
    meanNC <- titration_data[, tl_column]
    
    # N_mean NC10_mean NC20_mean NC30_mean NC40_mean NC50_mean NC75_mean C_mean
    return(meanNC)
    
  }


func_calNCR2Log2 <- function(normalize_ratio_data, qc_prefix = "_QC_") {
  
  nc_postfix <- "$"
  
  qc_prefix <- qc_prefix
  
  meanNC_data <- func_calAreaMean(normalize_ratio_data)
  
  feature <- rownames(normalize_ratio_data)
  qc_data_ratio <- normalize_ratio_data[, grep(qc_prefix, colnames(normalize_ratio_data))]
  
  qc_data_ratio_cv <- transform(qc_data_ratio, cv = rowCv(qc_data_ratio))
  
  cvs <- qc_data_ratio_cv[, "cv"]
  meanNC_data_t <- data.frame(t(meanNC_data))
  b_data_r2_all <- NULL
  for (k in 1:ncol(meanNC_data_t)) {
    cv <- cvs[k]
    lowess1 <- meanNC_data_t[, k] + 1e-10  # 0.758 0.835 0.677 0.743 0.827 0.792 0.866 
    name <- feature[k]
    # print(k)
    # print(name)
    if(stringr::str_detect(name, "NB") == TRUE | stringr::str_detect(name, "SP") == TRUE ){
      b_data_r2 <-
        data.frame(
          cbind(
            "NA",
            0,
            # "NA",
            "NA",
            signif(lowess1[1] / lowess1[8], 3),
            cv,
            "NA",
            "NA",
            "NA",
            "NA",
            "NA",
            "NA",
            "NA",
            "NA"
          )
        )
      colnames(b_data_r2) <-
        c(paste0("Y"),
          paste0("R2"),
          # paste0("p.value"),
          paste0("RMSE"),
          paste0("FoldChange_NC"),
          paste0("CV"),
          paste0("N.Recovery"),
          paste0("NC10.Recovery"),
          paste0("NC20.Recovery"),
          paste0("NC30.Recovery"),
          paste0("NC40.Recovery"),
          paste0("NC50.Recovery"),
          paste0("NC75.Recovery"),
          paste0("C.Recovery")
        )
      
      if (is.null(b_data_r2_all)) {
        b_data_r2_all <- b_data_r2
      } else {
        b_data_r2_all <- rbind(b_data_r2_all, b_data_r2)
      }
    } else {
      fc_NC <- signif(lowess1[1] / lowess1[8], 3)  # 0.758 / 1.250
      
      lowess = lowess1[1:(8)]
      
      data_1 <-
        data.frame(cbind(
          E = (c(
            1.0 * fc_NC + 0.0, 
            0.9 * fc_NC + 0.1, 
            0.8 * fc_NC + 0.2, 
            0.7 * fc_NC + 0.3, 
            0.6 * fc_NC + 0.4, 
            0.5 * fc_NC + 0.5, 
            0.25 * fc_NC + 0.75, 
            0.0 * fc_NC + 1 
          )),
          value = ((lowess)),
          label = c("N", "NC10", "NC20", "NC30", "NC40", "NC50", "NC75", "C")
        ))
      colnames(data_1) <- c("E", "value", "label")
      rownames(data_1) <- data_1[, "label"]
      
      data_1 <- transform(data_1, E = as.numeric(as.character(E)))
      data_1 <- transform(data_1, value = as.numeric(as.character(value)))
      
      
      
      fit <- lm(value ~ E, weights = 1/ (E*E), data = data_1)
      xy <- paste0(signif(fit$coefficients[1], 5), "+", signif(fit$coefficients[2], 5) , "*X weight=1/(X * X)")  # "0.18947+0.85135*X weight=1/(X * X)"
      R2 <- signif(as.numeric(summary(fit)[9]), 3) # 0.522
      # p.val <- signif(summary(fit)$coef[2, 4], 3)  # 0.0428
        
      rmse <- signif(sqrt(sum(summary(fit)$residuals ^ 2)), 3)  # 0.348
      
      b_data_r2 <-
        data.frame(
          cbind(
            xy,
            R2,
            # p.val,
            rmse,
            fc_NC,
            cv
          )
        )
      colnames(b_data_r2) <-
        c(
          paste0("Y"),
          paste0("R2"),
          # paste0("p.value"),
          paste0("RMSE"),
          paste0("FoldChange_NC"),
          paste0("CV")
        )
      
      
      E_values <- data_1[, "E"]  # 0.6060 0.6454 0.6848 0.7242 0.7636 0.8030 0.9015 1.0000
      y_data <- (data_1[, "value"] - fit$coefficients[1])/ fit$coefficients[2]  # 0.6677916 0.7582360 0.5726489 0.6501726 0.7488392 0.7077281 0.7946487 1.2456959
      
      for(m in 1:length(E_values)){
        E_value <- E_values[m]
        M_value <- y_data[m]
        qc_recovery <- round(100 - round((M_value) / E_value * 100, 1), 1)
        
        head_name <- colnames(b_data_r2)
        b_data_r2 <- cbind(b_data_r2, qc_recovery)
        colnames(b_data_r2) <- c(head_name, paste0(data_1$label[m], ".Recovery"))
      }
      
      if (is.null(b_data_r2_all)) {
        b_data_r2_all <- b_data_r2
      } else {
        b_data_r2_all <- rbind(b_data_r2_all, b_data_r2)
      }
    }
  }
  data_qc <- cbind(feature, b_data_r2_all)
  
  return(data_qc)
}





# 将QC相关数据写入数据库
func_getQCData2db <- function(project_uuid, user, password) {
    
    project_uuid <- project_uuid
    user <- user
    password <- password
    
    flag = "true"
    
    
    # # 测试
    # project_uuid <- '402880e8784573da017845788af10000'
    # user <- "root"
    # password <- "123456"
    # con <-
    #   dbConnect(
    #     MariaDB(),
    #     host = "localhost",
    #     dbname = "zjap",
    #     user = user,
    #     password = password
    #   )
    

    
    
    tryCatch({
      con <-
        dbConnect(
          MariaDB(),
          host = "localhost",
          dbname = "zjap",
          user = user,
          password = password
        )
      
      
      sample_names_filter <- func_getSampleData(con, project_uuid, user, password)  # 获取进样数据
      
      normalize_ratio_data <- func_getNormalizeRatioData(con, project_uuid, user, password)  # 获取归一化ratio数据
      
      data_qc <- func_calNCR2Log2(normalize_ratio_data, qc_prefix = "_QC_")
      
      data_qc
      
      
      # 整理存入数据库的数据
      zp_qc_data <- cbind(data_qc[, c(1,6,3,4,5,7,8,9,10,11,12,13,14)])
      
      # uuid
      uuids <- uuid(n = nrow(data_qc), drop_hyphens = FALSE, use_time = NA)
      uuids <- gsub('-', '', uuids)
      
      p_data <- cbind(uuid = uuids, project_uuid = project_uuid)
      zp_qc_data <- cbind(p_data, zp_qc_data)
      
      # 设置为和数据库字段相同的列名
      colnames(zp_qc_data) <- c("uuid", "project_uuid", "feature", "rsd", "r_square", "rmse", "foldchange", "recovery_rate_c0", "recovery_rate_c10", "recovery_rate_c20", "recovery_rate_c30", "recovery_rate_c40", "recovery_rate_c50", "recovery_rate_c75", "recovery_rate_c100")
      
      zp_qc_data[ zp_qc_data == "NA"] <- NA
      
      zp_qc_data
      
      # data.table::fwrite(zp_qc_data, "./zp_qc_data.csv")
      
      
      # 写入数据库
      
      # 先删除数据
      DBI::dbExecute(
        con,
        paste0(
          "delete from zp_qc_data where project_uuid = '",
          project_uuid ,
          "'"
        )
      )
      
      # 写入数据库
      result <-
        dbWriteTable(con, "zp_qc_data", zp_qc_data, append = TRUE)
      
      
      if (result) {
        flag = "true"
      } else{
        flag = "false"
      }
    }, error = function(e) {
      print(e)
      flag = "false"
    }, finally = {
      dbDisconnect(con)  # 断开连接
    })
    
    return(flag)
    
  }

# 测试
project_uuid <- '402880e8784573da017845788af10000'
user <- "root"
password <- "123456"

func_getQCData2db(project_uuid, user, password)
```

### 求CV

```R
feature <- colnames(b_data_t)  # 获取列名
cv_lot_all <- NULL  
for (i in 1: length(feature)){
    name <- feature[i]  # 获取一个列名
    sub_data <- b_data_t[, name]  # 得到一列数据
    cv_lot <- round(sd(sub_data) / mean(sub_data) * 100, 1)  # 计算cv 标准差/均值
    if (is.null(cv_lot_all)){  # 如果是第一次 直接赋值
      cv_lot_all<- cv_lot
    } else {  # 如果不是第一次 合并之前的数据和新数据
      cv_lot_all <- c(cv_lot_all, cv_lot)
    }
  }

cv_bat <- data.frame(cbind(feature, cv_lot_all, group=rep('N', time = length(feature))))  # 数据拼接
```

```R
# 完整版
func_getIsCV <- function(file_name, bat_no, no) {
  b_data <-
    data.frame(data.table::fread(
      file_name,
      sep = ",",
      header = T
    ))
  
  rownames(b_data) <- b_data[, 1]
  b_data <- b_data[, -(1:2)]
  str <- bat_no
  
  if (no != "") {
    b_data <- b_data[, grep(no, colnames(b_data))]
    str <- paste0(bat_no, no)
  }
  
  b_data_t <- data.frame(t(b_data))
  
  feature <- colnames(b_data_t)
  
  cv_lot_all <- NULL
  for (i in 1: length(feature)){
    name <- feature[i]
    sub_data <- b_data_t[, name]
    cv_lot <- round(sd(sub_data) / mean(sub_data)*100,1)
    if (is.null(cv_lot_all)){
      cv_lot_all<- cv_lot
    } else {
      cv_lot_all <- c(cv_lot_all, cv_lot)
    }
    
  }
  
  cv_bat <- data.frame(cbind(feature, cv_lot_all, group=rep(str, time = length(feature))))
  
  return(cv_bat)
}

file_name <- "../pos/final/lot2/final_is_area.csv"
cv_bat_1_1 <- func_getIsCV(file_name, "2", "_202009001Y_")
cv_bat_1_2 <- func_getIsCV(file_name, "2", "_202010001Y_")
cv_bat_1_3 <- func_getIsCV(file_name, "2", "_202010002L_")
cv_bat_1_4 <- func_getIsCV(file_name, "2", "_202011001L_")
cv_bat_1 <- func_getIsCV(file_name, "2", "")

### 切割子集

​```R
ions <- data.frame(data.table::fread(real_path))
ds_ions<- subset(ions, stringr::str_detect(feature, "DS") == TRUE)
sp_ions<- subset(ions, stringr::str_detect(feature, "SP") == TRUE)
```

### cv公式

```R
cv_lot <- round(sd(sub_data) / mean(sub_data) * 100, 1)
```

### 计算pearson相关系数

```R
mat1 <- data.frame(data.table::fread("SST.csv"))

# 过滤行数据(只包含sp的行)
mat1 <- dplyr::filter(mat1, grepl('SP', feature))
mat1 <- mat1[, -1]

r <- cor(mat1)

data.table::fwrite(
  data.frame(r),
  "SST_pearson_r.csv",
  sep = ",",
  quote = FALSE,
  row.names = FALSE
)
```

### 宽数据与长数据转换

```R
library(reshape2)
library(tidyr)

a = c("a1","a2","a3","a4","a5","a1","a2","a3","a4","a5","a1","a2","a3","a4","a5")
b = c("c1","c1","c1","c1","c1","c2","c2","c2","c2","c2","c3","c3","c3","c3","c3")
c = c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15)

x = data.frame(cbind(a, b, c))  # 长数据

width_data = dcast(x, b ~ a, value.var = "c")  # 长数据转宽数据
width_data

long_data <- gather(X1, year, gdp, a1:a5)  # 宽数据转长数据
long_data
```

### 求两个文件的相关性

参考链接

https://www.jianshu.com/p/b76f09aacd9c

https://www.cnblogs.com/nkwy2012/p/8650287.html

```R
mat1 <- data.frame(data.table::fread("data_final_rma_44_18_obs_t.csv"))
mat2 <- data.frame(data.table::fread("species_log2_t_use.csv"))

library(psych)
cortest_psy <- corr.test(mat1, mat2, method = "pearson")
cortest_psy_fdr <- corr.test(mat1, mat2, method = "pearson", adjust = "fdr")
# 如果不矫正，即adjust ="none"，则其相关系数与P值其实和cor.test()等得到的一样。

r <- cortest_psy$r
p <- cortest_psy$p

# fdr_p <- cortest_psy_fdr$p

# 存储为csv文件 
data.table::fwrite(
  data.frame(r),
  "pearson_r.csv",
  sep = ",",
  quote = FALSE,
  row.names = FALSE
)

data.table::fwrite(
  data.frame(p),
  "pearson_p.csv",
  sep = ",",
  quote = FALSE,
  row.names = FALSE
)
```

### 一列除以另一列的每一行的值

2020年11月19日13:05:11

```R
"""
3个IPooled的area均值 
除以3个is里ipooled的均值
在对应的各内标的isratio里新加一列显示上面的结果
"""
# 设置工作路径
setwd("C:\\Users\\cuite\\Documents\\工作\\R_Program\\YX_Opt\\data\\neg\\lot1")

# 读取final_area.csv文件
filename = "final_area.csv"
area_data <- data.frame(data.table::fread(filename))
area_data[is.na(area_data)] <- 0

# 计算final_area.csv里面的Ipooled_mean
Ipooled_colnum <- grep('Ipooled', colnames(area_data))
Ipooled_colnum <- area_data[, Ipooled_colnum, drop=F]
Ipooled_mean <- rowMeans(Ipooled_colnum)

# 读取final_is_area.csv文件
filename2 = "final_is_area.csv"
is_area_data <- data.frame(data.table::fread(filename2))
is_area_data[is.na(is_area_data)] <- 0

# 计算final_is_area.csv里面的is_Ipooled_mean
Ipooled_colnum <- grep('Ipooled', colnames(is_area_data))
Ipooled_colnum <- is_area_data[, Ipooled_colnum, drop=F]
is_Ipooled_mean <- rowMeans(Ipooled_colnum)

# 获取内标名称
IS_names <- is_area_data[,1]
print(IS_names)
j = 1
# 遍历is_Ipooled_mean的每一个均值
for (i in is_Ipooled_mean){
  print(i)
  res <- Ipooled_mean / i  # 计算比率
  IS_name <- IS_names[j]  # 记录内标名称
  
  # 读文件 final_is_ratio_difukete.csv
  filename3 <- paste("final_is_ratio_", IS_name, ".csv", sep = "")
  print(filename3)
  is_data <- data.frame(data.table::fread(filename3))
  
  # bat_no <- 1
  is_area_data <- cbind(is_data,res)
  colnames(is_area_data)[ncol(is_area_data)] <- "yx01Ipooled_mean"
  # is_area_data <- transform(is_data, colname_mean = res)
  # 保存为csv文件
  data.table::fwrite(is_area_data,
                     filename3,
                     sep = ",",
                     row.names = F)
  j <- j + 1
}
```



### 所有列减去某一列

2020年11月19日15:04:56

```R
# 设置工作路径
setwd("C:\\Users\\cuite\\Desktop")
filename = "1.csv"
i_data <- data.frame(data.table::fread(filename))
data1 <- i_data[,1:3]  # 减数
data2 <- i_data[,ncol(i_data), drop=F]  # 被减数
for (i in c(1:ncol(data1))){
  data1[,i] <- data1[,i] - data2
}
print(data1)
```

```R
# 封装成函数
"""
	多列减去某一列
"""
func_cols_sub_col1 <- function(cols_data, col1_data) {
  for (i in c(1:ncol(cols_data))) {
    cols_data[, i] <- cols_data[, i] - col1_data
  }
  result_data <- cols_data
  return(result_data)
}
```

