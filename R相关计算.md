# R相关计算

### apply

```R
apply(X, MARGIN, FUN)
-x：数组或矩阵
-MARGIN：取一个介于1到2之间的值或范围，以定义该函数的应用位置：
    1：对行执行操作
    2：对列执行操作
    c(1, 2)：该操作在行和列上执行
-FUN：告诉应用哪个功能。可以应用平均值，中位数，和，最小值，最大值甚至用户定义的函数等内置函数
	sum, max, min
```

```R
m1 <- matrix(C<-(1:10), nrow=5, ncol=6)
m1
a_m1 <- apply(m1, 2, sum)  # 对每一列求和
a_m1
a_m2 <- apply(m1, 1, sum)  # 对每一行求和
a_m2
```

```R
# 计算平均值
# 有默认函数 行均值 rowMeans(data) 列均值 colMeans(data)

# 对这4列的每行的对应数字求平均，去除缺失值
data$mean <- apply(data[, 7:10], 1, mean, na.rm=T)

# 计算列的平均值
data <- matrix(C<-(1:10), nrow=5, ncol=6)
data
colMeans(data)  # 等价于 apply(data, 2, mean)

# 计算第3列的平均值
colMeans(data[3])
```



### lapply

```R
lapply(X, FUN)
Arguments:
-X: A vector or an object
-FUN: Function applied to each element of x
lapply()的输出是一个列表
lapply()函数不需要MARGIN
```

```R
# 使用tolower函数将矩阵的字符串值更改为小写
movies <- c("SPYDERMAN","BATMAN","VERTIGO","CHINATOWN")
movies_lower <-unlist(lapply(movies, tolower))  # 使用unlist()将列表转换为向量
str(movies_lower)
```

### 读取Excel

```R
#下载和引用
install.packages("readxl")
library(readxl)
 
#读取Excel
read_excel("old_excel.xls")
read_excel("new_excel.xlsx")
 
#sheet参数，指定sheet名或者数字
read_excel("excel.xls",sheet=2)
read_excel("excel.xls",sheet="data")
 
# If NAs are represented by something other than blank cells,
# set the na argument
read_excel("excel.xls", na = "NA")
```



```R
# 求各列的均值与方差

library("xlsx")
library("matrixStats")
data = read.xlsx("sheet3.xlsx", 1, header = F)
colMeans(data, na.rm = T)
colVars(as.matrix(data), na.rm = T)
```



### 异常

```R
# append = TRUE
The workbook already contains a sheet of this name
```

### transform 函数

```R
作用: 为原数据框添加新的列，改变原变量列的值，还可通过赋值NULL删除列变量。

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



### xlsx读取与写入

```R
library("xlsx")
data <- read.xlsx("input.xlsx",sheetIndex = 1)
print(data)

res <- c(1:10)
data <- write.xlsx(res, "input.xlsx", sheetName = "test",col.names = FALSE,row.names = FALSE,append = FALSE)
```



### R语言 write.xlsx() 写入同一excel，及同一sheet注意

```R
write.xlsx(x, file, sheetName="Sheet1", col.names=TRUE, row.names=TRUE, append=FALSE, showNA=TRUE)


1、想要将data1写da.xlsx的sheet1、data2写da.xlsx的sheet2中，如下

write.xlsx(x, file, sheetName="sheet1")

write.xlsx(x, file, sheetName="sheet2",append=TRUE)     这里的append一定要设置为TRUE，否则就会把sheet1中的数据覆盖掉。

2、将数据data1、data2都加入到da2.xlsx的同一个sheet中

addDataFrame(x, sheet, col.names=TRUE, row.names=TRUE,
startRow=1, startColumn=1, colStyle=NULL, colnamesStyle=NULL,
rownamesStyle=NULL, showNA=FALSE, characterNA="", byrow=FALSE）

其中的x一定要是data.frame类型，否则会报错：Error in sheet$getWorkbook : $ operator is invalid for atomic vectors
```

### 读取文件

```R
b_data <- data.frame(data.table::fread(file_name, sep = ",", header = T))
rownames(b_data) <- b_data[, 1]  # 读取文件后, 一般将第一列作为行名 先进性保存
```



### 读取csv

  name  C  M   E Mean Std
1   zs 80 90 100   NA  NA
2   ls 90 90  90   NA  NA

```R
data <- read.csv("csv_demo.csv")
print(data)
```

```R
print(is.data.frame(data))  # 判断是否为frame
print(ncol(data))  # 计算有多少列数据  6
print(nrow(data))  # 计算有多少行数据  2

res <- max(data$E)  # 获取E列的最大值  [1] 100
res <- subset(data, E == max(data$E))  # 获取E列的最大值的人的全部信息
```

```R
 # 获取E列的最大值的人的全部信息
	name  C  M   E Mean Std
1   zs   80  90 100 NA   NA
```

```R
# 求2-4列 每行的均值
res <- rowMeans(data[2:4])

# 求2-4列 每行的和
rowSums(data[2:4])


---------------------------------------------------
# 显示每一列的名称
names(data)

[1] "name" "C"    "M"    "E"    "Mean" "Std" 
---------------------------------------------------

# 显示对象结构
str(data)

'data.frame':	2 obs. of  6 variables:
 $ name: Factor w/ 2 levels "ls","zs": 2 1
 $ C   : int  80 90
 $ M   : int  90 90
 $ E   : int  100 90
 $ Mean: logi  NA NA
 $ Std : logi  NA NA
---------------------------------------------------

# 给出数据的概略信息
summary(data)

 name         C              M            E        
 ls:1   Min.   :80.0   Min.   :90   Min.   : 90.0  
 zs:1   1st Qu.:82.5   1st Qu.:90   1st Qu.: 92.5  
        Median :85.0   Median :90   Median : 95.0  
        Mean   :85.0   Mean   :90   Mean   : 95.0  
        3rd Qu.:87.5   3rd Qu.:90   3rd Qu.: 97.5  
        Max.   :90.0   Max.   :90   Max.   :100.0  
   Mean           Std         
 Mode:logical   Mode:logical  
 NA's:2         NA's:2  

---------------------------------------------------
 summary(data$M)
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
     90      90      90      90      90      90 
# 1st Qu. 第一个4分位数
```

### 拼接字符串

```R
str <- paste0(bat_no, no)
```



### ※ 计算平均值

```R
df1 = data.frame( Name = c('George','Andrea', 'Micheal','Maggie','Ravi','Xien','Jalpa'), 
 Mathematics1_score=c(62,47,55,74,32,77,86),
 Mathematics2_score=c(45,78,44,89,66,49,72),
 Science_score=c(56,52,45,88,33,90,47))

# 计算方法如下

# 方法1.rowMeans() 
df1$Avg_score = rowMeans(df1[,c(2,3,4)])  # 对每一行求均值

# 方法2.apply()
df1$Avg_score = apply(df1[,-1], 1, mean)

# 类似的求标准差
apply(df1[,-1], 1, sd)
# 方差
apply(df1[,-1], 1, var)
```

```R
	Name  Mathematics1_score  Mathematics2_score  Science_score  Avg_score
1  George        62					 45				 56		 54.33333333
2  Andrea		47					78				52		59.00000000
3  Micheal		55					44				45		48.00000000
4  Maggie		74					89				88		83.66666667
5  Ravi			32					66				33		43.66666667
6  Xien			77					49				90		72.00000000
7  Jalpa		86					72				47		68.3333
```



### apply跨数组元素的计算

我们可以使用**apply()**函数在数组中的元素上进行计算。

参考链接: https://www.w3cschool.cn/r/r_arrays.html

```
apply(x, margin, fun)
```

以下是所使用的参数的说明 -

- **x**是一个数组。
- **margin**是所使用的数据集的名称。
- **fun**是要应用于数组元素的函数。

### 插入列

```R
y<-1:4
data1 <- data.frame(x1=c(1,3,5,7), x2=c(2,4,6,8),x3=c(11,12,13,14),x4=c(15,16,17,18))
data2 <- cbind(data1[,1:2], y, data1[,3:ncol(data1)])  # 所有行的1 2列  y  所有行的第3列到最后一列

# 输出
> data1
  x1 x2 x3 x4
1  1  2 11 15
2  3  4 12 16
3  5  6 13 17
4  7  8 14 18
> data2
  x1 x2 y x3 x4
1  1  2 1 11 15
2  3  4 2 12 16
3  5  6 3 13 17
4  7  8 4 14 18
```



### 在最后追加一列

```R
y<-1:4
data1 <- data.frame(x1=c(1,3,5,7), x2=c(2,4,6,8),x3=c(11,12,13,14),x4=c(15,16,17,18))
data2 <- cbind(data1, y)

# 追加一列
> data2
  x1 x2 x3 x4 y
1  1  2 11 15 1
2  3  4 12 16 2
3  5  6 13 17 3
4  7  8 14 18 4
```



### 插入行

```R
data1<- data.frame(x1=runif(10),x2= runif(10),x3= runif(10))
row<- c(1, 1, 1)
data2 <- rbind(data1[1:5,], row, data1[6:nrow(data1), ])  # 1-5行 所有列 row 6-最后一行所有列数据

> data1
           x1         x2         x3
1  0.82770168 0.19924776 0.09671562
2  0.86244861 0.85845936 0.82083266
3  0.14983867 0.07897586 0.13062951
4  0.37223133 0.22825656 0.11450407
5  0.54093833 0.18302166 0.34376273
6  0.33506462 0.38303857 0.68068095
7  0.40437549 0.28705806 0.76902653
8  0.09435355 0.84434415 0.01876149
9  0.56567934 0.77701494 0.86199593
10 0.87996482 0.31431554 0.77827917
> data2
           x1         x2         x3
1  0.82770168 0.19924776 0.09671562
2  0.86244861 0.85845936 0.82083266
3  0.14983867 0.07897586 0.13062951
4  0.37223133 0.22825656 0.11450407
5  0.54093833 0.18302166 0.34376273
6  1.00000000 1.00000000 1.00000000  # 插入的一行数据
61 0.33506462 0.38303857 0.68068095
7  0.40437549 0.28705806 0.76902653
8  0.09435355 0.84434415 0.01876149
9  0.56567934 0.77701494 0.86199593
10 0.87996482 0.31431554 0.77827917
```

### 数据切片

```R
> data
  name  C  M   E
1   zs 80 90 100
2   ls 90 90  90

# 下面两者是等价的
> data[,2:4]  # 取2-4列
   C  M   E
1 80 90 100
2 90 90  90

> data[,-1]  # 去掉第一列
   C  M   E
1 80 90 100
2 90 90  90
```





## ※ 改进版

```R
# 设置工作路径
setwd("C:\\Users\\cuite\\Documents\\工作\\R_Program")
# 读取csv文件
data <- read.csv("testdata.csv")

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
write.table(b_data,
            "data_result.csv",
            sep = ",",
            row.names = F)



# -------------------------------------------------
# 方法二: 比较麻烦
# 获取所有F开头的求出的数据
pattern <- "^F_"
N.colnum <- grep(pattern, colnames(b_data))
data_N <- b_data[, N.colnum]

# 追加列 绑定数据
data_result <- cbind(data, data_N)

# 将data_result写入到新文件中去
write.csv(data_result, "testdata_result.csv")
```

```R
# 读取大文件时 用fread
data.table::fread()
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

### 设置行名

```R
rownames(b_data) <- b_data[, 1]
```

### 过滤数据- 过滤列数据

```R
# 过滤列数据
b_data <- b_data[, grep(no, colnames(b_data))]

# 查找数据所在的列号
pattern <- "np_mean"
np_mean.colnum <- grep(pattern, colnames(base))
```

### 过滤数据- 过滤行数据

```R
i_data <- data.frame(data.table::fread("data.csv"))

# 获取特征名
feature <-
  c(
    'X16.5_373.274mz_pos',
    'X14.8_405.265mz_neg',
    'X13.1_448.307mz_neg',
    'X16.9_373.274mz_pos',
  )
class(feature)  # "character" 得到一个字符串 6112个特征名

# 过滤行数据
filter_i_data <- i_data[which(i_data$sample_no %in% feature), ]

# 存储为csv文件 
data.table::fwrite(
  filter_i_data,
  "filter_data.csv",
  sep = ",",
  quote = FALSE,
  row.names = FALSE
)
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

### 转置

```R
b_data_t <- data.frame(t(b_data))
```

### 获取列名

```R
feature <- colnames(b_data_t)
```

### 设置列名

```R
colnames(cv_bat) <- c("IS", "CV", "Bat")
```

### 移动列的位置

```R
df <- df[, c(10, 1:9)]
```

### 添加一列并设置列名

```R
b_data <- cbind(i_data$feature, b_data)
colnames(b_data)[1] <- 'feature'
```

### for循环

```R
  for (i in 1: length(feature)){
    name <- feature[i]
    sub_data <- b_data_t[, name]
    cv_lot <- round(sd(sub_data) / mean(sub_data)*100,1)
      # 存为num
    if (is.null(cv_lot_all)){
      cv_lot_all<- cv_lot
    } else {
      cv_lot_all <- c(cv_lot_all, cv_lot)
    }
  }
```

### 求cv

| sample                 | SP51     |
| ---------------------- | -------- |
| B02_ISBLK_202009001Y_1 | 16687250 |
| Q02_C_202009001Y_1     | 18064182 |
| Q02_NC10_202009001Y_1  | 19317651 |
| Q02_NC20_202009001Y_1  | 20088865 |
| Q02_NC30_202009001Y_1  | 19137796 |
| Q02_NC40_202009001Y_1  | 18554253 |
| Q02_NC50_202009001Y_1  | 19975848 |
| Q02_NC75_202009001Y_1  | 18612781 |
| Q02_N_202009001Y_1     | 19777232 |

```R
cv_lot <- round(sd(sub_data) / mean(sub_data) * 100, 1)
```

判断是否为空

```R
if (is.null(cv_lot_all)){
    cv_lot_all<- cv_lot
} else {
    cv_lot_all <- c(cv_lot_all, cv_lot)
}
```

### 行绑定

```R
cv_bat <- data.frame(cbind(feature, cv_lot_all, group=rep(str, time = length(feature))))
```

| feature | cv_lot_all | group         |
| ------- | ---------- | ------------- |
| SP51    | 5.7        | 2_202009001Y_ |
| SP52    | 6.2        | 2_202009001Y_ |
| SP53    | 8.2        | 2_202009001Y_ |
| SP54    | 12.7       | 2_202009001Y_ |
| SP55    | 9.9        | 2_202009001Y_ |
| SP56    | 38.1       | 2_202009001Y_ |
| NB51    | 9.4        | 2_202009001Y_ |

### 写文件

```R
data.table::fwrite(cv_dis, file = "is_pos_cv_bat2.csv")
```

### 写文件名时小于0的要注意

```R
for(i in 1:11){  
 if(i<10){
    out_filename <- paste0('0', i, ".csv")
  }else{
    out_filename <- paste0(i, ".csv")
  }
  print(out_filename)
  data.table::fwrite(result_data, out_filename)
}

[1] "01.csv"
[1] "02.csv"
[1] "03.csv"
[1] "04.csv"
[1] "05.csv"
[1] "06.csv"
[1] "07.csv"
[1] "08.csv"
[1] "09.csv"
[1] "10.csv"
[1] "11.csv"
```

### 合并csv

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



### 只对某些列进行操作

```R
# 对除了1,2列的数据进行保留一位小数的运算
cv_bat[, -(1:2)] <- round(cv_bat[, -(1:2)], 1)
```

### 宽数据与长数据之间的互相转换

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



### 异常

  ```R
  tryCatch({
      
  }, error = function(e) {
    print(e)
  }, finally = {
      
  })
  ```

### 数字转为百分比

```R
    # 转换为可显示的百分比字符串
    ratio_list2 <- round(ratio_list*100, 1)
    x <- NULL
    x2 <- NULL
    for(i in ratio_list2){
      x2 <- c(x2, i)
      s <- paste0(i, "%")
      x <- c(x, s)
    }
    ratio_list_text <- x  # 显示的百分比字符串 91.7%
    ratio_list_num <- x2  # 数字 91.7
```

### 转换为因子保证顺序不变

```R
    draw_data$x_list <- factor(draw_data$x_list, levels = x_list)  # 保证X轴顺序不变
    data$x_list <- factor(data$x_list, levels = x_list)  # 保证X轴顺序不变
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

### 常用自定义函数

```R
rowCv = function(x) {
  apply(x, 1, function(x)
    (
      round(sd(x) / mean(x) *100, 2)
    ))
}

rowFc = function(x) {
  apply(x, 1, function(x)
    (
      round(x[1] / x[2],2)
    ))
}

rowAbsMinus = function(x) {
  apply(x, 1, function(x)
    (
      abs(x[1] - x[2])
    ))
}

rowPaste2 = function(x) {
  apply(x, 1, function(x)
    (
      paste0(x[1], "_", x[2])
    ))
}
```

### subset 查询

```R
# 查询type不为F的行
b_data <- subset(b_data, type != "F")

# 查询F_fc>1.2或者F_fc < 0.8的数据
b_data <- subset(b_data, F_fc > 1.2 | F_fc < 0.8)
```

### 字符串截取

```R
s <- '1234567'
substr(s, 2, 5)  # "2345"
# substr(s, 2) # 缺少参数"stop",也没有缺省值

substring(s, 2, 5)  # "2345"
substring(s, 2)  # "234567"

b_data <- transform(b_data, type = substr(x = type, start = 1, stop = 1))  # 添加新列type: 截取相关字符串 "N" "N"
```

### 转置

```R
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

### 转置数据

```R
i_data <- data.frame(data.table::fread("data.csv"))
feature <- i_data[, 1]
i_data <- i_data[, -1]
t_data <- t(as.matrix(i_data))
colnames(t_data) <- feature 
data.table::fwrite(data.frame(t_data), "data_t.csv", sep = ",", quote = FALSE,row.names = FALSE)
```



### 将NA值赋值为极小值

```R
bdata_N[is.na(bdata_N)] <- 1e-10
```

### 读取excel

```R
library(readxl)
sd_data <- data.frame(read_excel("上地昌平相似性数据.xlsx", sheet = "上地内(2415)"))
```

### 一些函数

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

### 1. 添加第一列 i_data$Compound 并修改列名

```R
  b_data_RmaNormalization <- cbind(i_data$Compound, b_data_RmaNormalization)
  colnames(b_data_RmaNormalization)[1] <- 'Compound'
```

```R
# 有BUG 获取第一列 为了cbind到后面的数据上
col_1_names <- i_data[, 1]
colnames(b_data_RmaNormalization)[1] <- colnames(i_data)[1]
colnames(b_data_RmaNormalization) <- col_1_names
```

添加新列 并修改列名

```R
col_1 <- t_data[,1]  # 第一列数据
result <- substring(col_1, 1, 1)  # 第一列数据的第一个字符
t_data$group <- result  # 产生新的列
names(t_data$group) <- c("group")  # 对新列设置列名
# colnames(t_data)[ncol(t_data)]  # 最后一列的列名 
```

```R
# 指定几列进行命名
colnames(d)[1:44] <- sample_no

```

```R
# for (i in 1:nrow(i_data)) {
#   rownames(i_data)[i] <- row_names[i]
# }
```



### 2.矩阵转置

```R
# 矩阵转置
t(x)
```

### 3. dim() 和 dimnames()

```R
> x <- 1:12 
> x
 [1]  1  2  3  4  5  6  7  8  9 10 11 12
> dim(x) <- c(3,4)  # dim(x) 检索或设置对象的尺寸。
> x
     [,1] [,2] [,3] [,4]
[1,]    1    4    7   10
[2,]    2    5    8   11
[3,]    3    6    9   12
```



```R
N <- array(1:24, dim = 2:3)
N
dimnames(N) <- list(c(1,2), c('Q','W','E'))  # dimnames(X) 检索或设置对象的dimnames
N
```

```R
> N <- array(1:24, dim = 2:3)> N     [,1] [,2] [,3][1,]    1    3    5[2,]    2    4    6> dimnames(N) <- list(c(1,2), c('Q','W','E'))> N  Q W E1 1 3 52 2 4 6
```



### 4. 截取字符串

语法
substring()函数的基本语法是：

substring(x,first,last)
以下是所使用的参数的说明：

x - 是字符向量输入。
first - 是第一个字符要被提取的位置。
last - 是最后一个字符要被提取的位置。

```R
result <- substring(col_1, 1, 1)  # 获取第一列数据的第一个字符
```



### 5. 为每个数据加上它所在列的均值

```R
ma <- matrix(c(1:4, 1, 6:8), nrow = 2)mama <- apply(ma, 2, function(x) {  x + (mean(x))})
```

```R
> ma <- matrix(c(1:4, 1, 6:8), nrow = 2)> ma     [,1] [,2] [,3] [,4][1,]    1    3    1    7[2,]    2    4    6    8> > ma <- apply(ma, 2, function(x) {+   x + (mean(x))+ })     [,1] [,2] [,3] [,4][1,]  2.5  6.5  4.5 14.5[2,]  3.5  7.5  9.5 15.5
```



### 6. 行变列

```R
library(data.table)library(ggplot2)dat <- data.table(Spring = c(runif(9,0,1),2),                  Summer = runif(10,0,1),                  Autumn = runif(10,0,1),                  Winter = runif(10,0,1))dat1 = melt(dat)
```

```R
# 箱体图library(data.table)library(ggplot2)dat <- data.table(Spring = c(runif(9,0,1),2),                  Summer = runif(10,0,1),                  Autumn = runif(10,0,1),                  Winter = runif(10,0,1))dat1 = melt(dat)# ggplot(data=dat1,aes(x=variable,y=value)) +geom_boxplot()ggplot(data=dat1,aes(x=variable,y=value,colour=variable)) +geom_boxplot() 
```



### 7. 移动列的位置

![](C:\Users\cuite\Documents\工作\截图\移动列的位置.png)

```R
# 设置工作路径setwd("C:\\Users\\cuite\\Documents\\工作\\R_Program")b_data <-  data.frame(    data.table::fread(      "b_data_group_t.csv",      sep = ",",      header = T    )  )ncol(b_data)b_data <- b_data[, -ncol(b_data)]# 修改列的位置b_data <- b_data[, c(1, ncol(b_data), 2:(ncol(b_data)-1))]ncol(b_data)# 保存转置之后的文件data.table::fwrite(  b_data,  "N_data_final_t2.csv",  sep = ",",  quote = FALSE,  row.names = FALSE)
```



### 8. 筛选列

```R
# 根据b_data 在i_data中筛选数据i_data <- subset(i_data, select= c(colnames(i_data)[1:2], b_data))
```



### 9. 将nan置为0

```R
i_data[is.na(i_data)] <- 0
```



### 10. 过滤得到某些列

```R
  # 找到ip_mean的列号 获取ip_mean 列  ip_mean_colnum <- grep('ip_mean', colnames(sample))  ip_mean <- sample[, ip_mean_colnum]
```



### 11. 写csv文件

```R
  # 保存为csv文件  data.table::fwrite(data,              csv_filename,              sep = ",",              row.names = F)
```



### 12.打乱数据集

```R
library(caret)sample(New_Microsoft_Excel_Worksheet_3_, 28)caret::createDataPartition(New_Microsoft_Excel_Worksheet_3_[,1:2], p=0.5)a1 = New_Microsoft_Excel_Worksheet_3_[, 1]c1 = c(1:29)inTest <- createDataPartition(New_Microsoft_Excel_Worksheet_3_[, 1], p = 3 / 4, list = FALSE)traindata <- newdata[inTest,]data1 <-  data.frame(data.table::fread(    paste0(      "d:/a1.csv"    ),    sep = "\t",    header = T  ))inTest <- sample(c1, 29)traindata <- data1[inTest,]write.csv(traindata,"d:/2.csv")
```

### 保存转置文件

```R
# 读取计算了fc的csv文件 生成转置之后的文件N_data_neg_final_t.csv
# 设置工作路径
setwd("C:\\Users\\cuite\\Documents\\工作\\R_Program")


# 1.读取计算了fc的csv文件
neg_sample <-
  data.frame(data.table::fread("data_final_fc.csv",
                               sep = ",",
                               header = T))
neg_sample <- subset(neg_sample, F_fc > 1.2 | F_fc < 0.8)

# 计算T
b_data_ratio <- neg_sample

title <- b_data_ratio[, 1]  # 第一列

b_data_ratio_t <- t(b_data_ratio[,-1])  # 先用矩阵转置t 再转为data.frame 快很多

b_data_ratio_t <- data.frame(b_data_ratio_t)
colnames(b_data_ratio_t) <- title  # 赋值列名

b_data_ratio_fc_t <- b_data_ratio_t

type <-
  rownames(b_data_ratio_fc_t)  # "N_DZ_0037" "N_DZ_0042" ... "F_fc"
sample_no <- type

b_data_ratio_fc_t <- cbind(sample_no, type, b_data_ratio_fc_t)

b_data_ratio_fc_t <-
  transform(b_data_ratio_fc_t, type = substr(x = type, start = 1, stop = 1))  # "N" "N"

b_data_ratio_fc_t <- subset(b_data_ratio_fc_t, type != "Q")
b_data_ratio_fc_t <-
  subset(b_data_ratio_fc_t, type != "F")  # 去掉type为F的行

neg_sample_t <- b_data_ratio_fc_t

data.table::fwrite(
  neg_sample_t,
  "N_data_neg_final_t.csv",
  sep = ",",
  quote = FALSE,
  row.names = FALSE
)

```



### 计算Anova 的P_value

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

# fc 和 pvalue

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
b_data_ratio_fc_t <-
  data.frame(
    data.table::fread(
      "N_data_neg_final_t_test.csv",
      sep = ",",
      header = T
    )
  )

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

