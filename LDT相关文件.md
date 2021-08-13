## LDT相关文件(12.25版)

### 归一化ratio计算

```R
real_path <- "./sample_info_cp.csv"
sample_list_data <- data.frame(data.table::fread(real_path))
sample_list_data <- transform(sample_list_data, SampleName = as.factor(SampleName))

area_filename <- "20210319_pinggu_run7_neg_area_merge.csv"
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
# data.table::fwrite(nm_b_data_lowess, "./nm_data_20210303_Shimadzu_neg.csv")


nm_b_data_lowess <- nm_b_data_lowess[, -1]
mean_qc <- result$mean_qc
ratio_nm_b_data_lowess <- nm_b_data_lowess
for(i in 1:ncol((nm_b_data_lowess) )){
  ratio_nm_b_data_lowess[, i] <- nm_b_data_lowess[, i] / mean_qc
}
ratio_nm_b_data_lowess_filter <- ratio_nm_b_data_lowess[, sample_names_filter]
ratio_nm_b_data_lowess_final <- cbind(feature=rownames(ratio_nm_b_data_lowess_filter), signif(ratio_nm_b_data_lowess_filter, 3))
  

data.table::fwrite(ratio_nm_b_data_lowess_final, ratio_nm_out_filename)
```

### 相关性计算

```R
bdata <-
  data.frame(
    data.table::fread(
      # "C:\\r_workspace\\计算相关性\\input_BA_STD.csv"
      "C:\\r_workspace\\0422_归一化0329\\ratio_nm_data_20210324_run1_shangdi_neg_area_merge.csv"
    )
  )

bdata_N <- bdata[, -1]
bdata_N[is.na(bdata_N)] <- 1e-10
N_cos <- NULL
for (i in 1:(ncol(bdata_N) - 1)) {
  for (j in (i + 1):ncol(bdata_N)) {
    if (i != j) {
      listAcode  <- bdata_N[, i]
      listBcode  <- bdata_N[, j]
      cosθ  <-
        sum(listAcode * listBcode) / (sqrt(sum(listAcode ^ 2)) * sqrt(sum(listBcode ^ 2)))
      cos <- data.frame(matrix(c(colnames(bdata_N)[i], colnames(bdata_N)[j], cosθ), byrow = T, nrow = 1))
      
      if (is.null(N_cos)) {
        N_cos <- cos
      } else {
        N_cos <- rbind(N_cos, cos)
      }
    }
  }
}

data.table::fwrite(N_cos, "C:\\r_workspace\\0422_归一化0329\\compareResult_shangdi_0324.csv")


# bdata <-
#   data.frame(
#     data.table::fread(
#       "D:\\r_workspace\\DZ_CRC\\compareSandC\\JST_YXBC_XH\\bdata_ratio.csv"
#     )
#   )
# 
# bdata_N <- bdata[, -1]
# N_cos <- NULL
# for (i in 1:(ncol(bdata_N) - 1)) {
#   for (j in (i + 1):ncol(bdata_N)) {
#     if (i != j) {
#       listAcode  <- bdata_N[, i]
#       listBcode  <- bdata_N[, j]
#       cosθ  <-
#         sum(listAcode * listBcode) / (sqrt(sum(listAcode ^ 2)) * sqrt(sum(listBcode ^ 2)))
#       cos <- data.frame(matrix(c(colnames(bdata_N)[i], colnames(bdata_N)[j], cosθ), byrow = T, nrow = 1))
#       
#       if (is.null(N_cos)) {
#         N_cos <- cos
#       } else {
#         N_cos <- rbind(N_cos, cos)
#       }
#     }
#   }
# }
# 
# data.table::fwrite(N_cos, "D:\\r_workspace\\DZ_CRC\\compareSandC\\JST_YXBC_XH\\compareResult.csv")

```

### 计算d4之差

```R

library(readxl)
# sample_info <- data.frame(read_excel("平谷7批_d4之差和Spkin相似性.xlsx", sheet = "sample_info"))
# 
# sub_sample_info <- subset(sample_info, stringr::str_detect(SampleName, "ISBLK") == FALSE)
# 
# jf_info <- data.frame(read_excel("平谷7批_d4之差和Spkin相似性.xlsx", sheet = "积分丰度"))
# rownames(jf_info) <- jf_info[, 1]
# 
# feature <- jf_info[, 1]

# jf_info_new <- jf_info[, sub_sample_info[, 1]]
# 
# jf_info_new <- cbind(feature, jf_info_new)
# 
# data.table::fwrite(jf_info_new, "./temp/jf_info_new.csv")

# 计算胆汁酸和D4的RT的时间差(包含DS07)

ds_ion_names <- c("DS01", "DS02", "DS03", "DS04", "DS05", "DS06", "DS07", "DS08", "DS09", "DS10")
d4_ion_names <- c("NB01", "NB02", "NB03", "NB04", "NB05", "NB06", "NB07", "NB08", "NB09", "NB10")


rt_data <- data.frame(read_excel("平谷7批_d4之差和Spkin相似性.xlsx", sheet = "RT_data"))

rt_data <- rt_data[order(rt_data[, "ion"], rt_data[, "sample"]), ]

sample_list_data <- data.frame(read_excel("平谷7批_d4之差和Spkin相似性.xlsx", sheet = "sample_info"))

# sample_list_data <- subset(sample_list_data, if_use == 1)
sample_names <- as.character(sample_list_data[, 1])
rt_data <- subset(rt_data, sample %in% sample_names)

rowAbsMinus <- function(x) {
  apply(x, 1, function(x) {
    (
      abs(x[1] - x[2])
    )
  })
}

rowPaste2 <- function(x) {
  apply(x, 1, function(x) {
    (
      paste0(x[1], "_", x[2])
    )
  })
}

rt_data <- cbind(rt_data, run = substr(rt_data$sample, 2, 3))
rt_data_sub <- rt_data

ion_names <- c(ds_ion_names, d4_ion_names)
rt_data_sub <- subset(rt_data_sub, ion %in% ion_names)

runs <- as.character(unique(rt_data_sub[, "run"]))

rt_data_sub_ds <- subset(rt_data_sub, ion %in% ds_ion_names)
colnames(rt_data_sub_ds)[2:3] <- c("ion_ds", "rt_ds")
rt_data_sub_d4 <- subset(rt_data_sub, ion %in% d4_ion_names)
colnames(rt_data_sub_d4)[2:3] <- c("ion_d4", "rt_d4")
rt_data_sub_1 <- cbind(rt_data_sub_ds, rt_data_sub_d4[, 2:3])

rt_data_sub_1 <- transform(rt_data_sub_1, ds_minus = rowAbsMinus(rt_data_sub_1[, c("rt_ds", "rt_d4")]))
rt_data_sub_1 <- transform(rt_data_sub_1, name = rowPaste2(rt_data_sub_1[, c("ion_ds", "ion_d4")]))

rt_d4data_result <- rt_data_sub_1[, c("sample", "run", "name", "ds_minus", "rt_ds", "rt_d4")]

# rt_d4data_result <- subset(rt_d4data_result, stringr::str_detect(sample, "Q") == FALSE)

rt_sd <- sd(rt_d4data_result[, "ds_minus"])
rt_d4data_result$sdx1 <- 1 * rt_sd
rt_d4data_result$sdx2 <- 2 * rt_sd
rt_d4data_result$sdx3 <- 3 * rt_sd
data.table::fwrite(rt_d4data_result, "c:/r_workspace/rt_d4data_result.csv")

# # 计算胆汁酸和D4的RT的时间差(不包含DS07)
# 
# ds_ion_names <- c("DS01", "DS02", "DS03", "DS04", "DS05", "DS06", "DS07", "DS08", "DS09", "DS10")
# d4_ion_names <- c("NB01", "NB02", "NB03", "NB04", "NB05", "NB06", "NB07", "NB08", "NB09", "NB10")
# 
# 
# rt_data <- data.frame(read_excel("5批数据.xlsx", sheet = "RT_data"))
# 
# rt_data <- rt_data[order(rt_data[, "inject_time"], rt_data[, "ion"], rt_data[, "sample"]), ]
# 
# sample_list_data <- data.frame(read_excel("5批数据.xlsx", sheet = "sample_info"))
# 
# sample_list_data <- subset(sample_list_data, if_use == 1)
# sample_names <- as.character(sample_list_data[, 1])
# rt_data <- subset(rt_data, sample %in% sample_names)
# 
# rowAbsMinus <- function(x) {
#   apply(x, 1, function(x) {
#     (
#       abs(x[1] - x[2])
#     )
#   })
# }
# 
# rowPaste2 <- function(x) {
#   apply(x, 1, function(x) {
#     (
#       paste0(x[1], "_", x[2])
#     )
#   })
# }
# 
# rt_data <- cbind(rt_data, run = substr(rt_data$sample, 2, 3))
# rt_data_sub <- rt_data
# 
# ion_names <- c(ds_ion_names, d4_ion_names)
# rt_data_sub <- subset(rt_data_sub, ion %in% ion_names)
# 
# runs <- as.character(unique(rt_data_sub[, "run"]))
# 
# rt_data_sub_ds <- subset(rt_data_sub, ion %in% ds_ion_names)
# colnames(rt_data_sub_ds)[2:3] <- c("ion_ds", "rt_ds")
# rt_data_sub_d4 <- subset(rt_data_sub, ion %in% d4_ion_names)
# colnames(rt_data_sub_d4)[2:3] <- c("ion_d4", "rt_d4")
# rt_data_sub_1 <- cbind(rt_data_sub_ds, rt_data_sub_d4[, 2:3])
# 
# rt_data_sub_1 <- transform(rt_data_sub_1, ds_minus = rowAbsMinus(rt_data_sub_1[, c("rt_ds", "rt_d4")]))
# rt_data_sub_1 <- transform(rt_data_sub_1, name = rowPaste2(rt_data_sub_1[, c("ion_ds", "ion_d4")]))
# 
# rt_d4data_result <- rt_data_sub_1[, c("sample", "run", "name", "ds_minus", "rt_ds", "rt_d4")]
# 
# rt_d4data_result <- subset(rt_d4data_result, stringr::str_detect(sample, "Q") == FALSE)
# rt_d4data_result <- subset(rt_d4data_result, stringr::str_detect(name, "Q|DS07_NB07") == FALSE)
# 
# rt_sd <- sd(rt_d4data_result[, "ds_minus"])
# rt_d4data_result$sdx1 <- 1 * rt_sd
# rt_d4data_result$sdx2 <- 2 * rt_sd
# rt_d4data_result$sdx3 <- 3 * rt_sd
# data.table::fwrite(rt_d4data_result, "./temp/rt_d4data_result_noDS07.csv")

```



### 计算spkin相似性

```R

# Spike-in's similarity check
func_getSpData <- function(sp_data_ratio, run_num, qc_prefix = "_QC_") {
  
  # 计算QC样本的均值 并按照均值大小排序
  sp_data <- sp_data_ratio[, grep(paste0("^.", run_num), colnames(sp_data_ratio))]
  sp_data_mean <- transform(sp_data, mean = rowMeans(sp_data[, grep(qc_prefix, colnames(sp_data))]))
  sp_data_mean <- sp_data_mean[order(sp_data_mean[,"mean"]), ]  
  
  # qc数据 其它数据 均值
  sp_data_qc <- sp_data_mean[, grep(qc_prefix, colnames(sp_data_mean))]
  sp_data_other <- sp_data_mean[, -grep(qc_prefix, colnames(sp_data_mean))]
  sp_base <- sp_data_mean[, "mean"]
  
  # 计算余弦相似性
  s_all_cos <- NULL
  for (i in 1:ncol(sp_data_other)){
    sp <- sp_data_other[, i]
    name <- colnames(sp_data_other)[i]

    cosθ <- sum(sp_base * sp) / (sqrt(sum(sp_base ^ 2)) * sqrt(sum(sp ^ 2)))


    if(is.null(s_all_cos)){
      s_all_cos <- cosθ
    } else {
      s_all_cos <- c(s_all_cos, cosθ)
    }
  }

  sample <- colnames(sp_data_other)

  # 95%CI
  cos_95ci = mean(s_all_cos) - 1.96 * sd(s_all_cos)
  # print(cos_95ci)

  newdata <- cbind(sample, run = run_num, data.frame(s_all_cos), cos_95ci)

  newdata$cos_relation <- factor(ifelse(newdata$s_all_cos >= newdata$cos_95ci, "Normal","Non-Normal"),
                                 levels = c("Normal","Non-Normal"))

  return(newdata)
}


# 调用
library(readxl)
sp_data_ratio <- data.frame(read_excel("平谷7批_d4之差和Spkin相似性.xlsx", sheet = "Spike-in.ratio"))
rownames(sp_data_ratio) <- sp_data_ratio[, 1]
sp_result_run1 <- func_getSpData(sp_data_ratio, "01")
# data.table::fwrite(sp_result_run1, "sp_result_run1.csv")
sp_result_run2 <- func_getSpData(sp_data_ratio, "02")
# data.table::fwrite(sp_result_run2, "sp_result_run2.csv")
sp_result_run3 <- func_getSpData(sp_data_ratio, "03")
# data.table::fwrite(sp_result_run3, "sp_result_run3.csv")
sp_result_run4 <- func_getSpData(sp_data_ratio, "04")
# data.table::fwrite(sp_result_run4, "sp_result_run4.csv")
sp_result_run5 <- func_getSpData(sp_data_ratio, "05")
# data.table::fwrite(sp_result_run5, "sp_result_run5.csv")
sp_result_run6 <- func_getSpData(sp_data_ratio, "06")
# data.table::fwrite(sp_result_run6, "sp_result_run6.csv")
sp_result_run7 <- func_getSpData(sp_data_ratio, "07")
# data.table::fwrite(sp_result_run7, "sp_result_run7.csv")
```

### 置信区间

```R
当求取90% 置信区间时 n=1.645
当求取95% 置信区间时 n=1.96
当求取99% 置信区间时 n=2.576

value_90ci = mean(data) - 1.645 * sd(data)
value_95ci = mean(data) - 1.96 * sd(data)
value_99ci = mean(data) - 2.576 * sd(data)
```







### general_pos_bat.py

```python
import os

A_file_name = []
# 将当前目录下的所有文件名称读取进来
for j in os.listdir():
    # 判断是否为CSV文件，如果是则存储到列表中
    if os.path.splitext(j)[1] == '.sky':
        A_file_name.append(j)

D_file_name_list = []
for j in os.listdir('./ion'):
    if os.path.splitext(j)[1] == '.csv':
        D_file_name_list.append(j)

E_file_name_list = []
for j in os.listdir('./wiff'):
    if os.path.splitext(j)[1] == '.wiff':
        E_file_name_list.append(j)

SPACE = ' '
A = A_file_name[0]
B = A.split('.')[0] + '_tmp.sky'
C = A.split('.')[0] + '_tmp.skyd'

res = []
for E in E_file_name_list:
    for D in D_file_name_list:
        F = D.split('.')[0] + '_' + E.split('.')[0] + '_report.csv'
        s2 = 'copy ' + A + SPACE + B + ' & skylinecmd --in=' + B + ' --import-transition-list=ion/' + D + ' --import-file=wiff/' + E + ' --report-name="离子对结果（多个）" --report-file=result/' + F + ' & del ' + B + SPACE + C
        print(s2)
        res.append(s2)

filename = '3.bat'
if os.path.exists(filename):
    print("文件已存在,删除成功!")
    os.remove(filename)
# 写文件
with open(filename, 'a+') as f:
    f.write('\n'.join(res))
with open(filename, 'a+') as f:
    f.writelines('\npause')
print("文件生成成功!")

```

### generate_pos_lot_batch_csv.py

```python
# -*-coding:utf-8-*- 
# 作者：   29511
# 文件名:  generate_pos_lot_batch_csv.py
# 日期时间：2020/12/4，10:25

import shutil
import numpy as np
import pandas as pd
import os


def calc_batch_num():
    """
    计算有几个批次
    :return: 批次数 int型
    """
    file_names = []
    for j in os.listdir('./ion'):
        if os.path.splitext(j)[1] == '.csv':
            file_names.append(j)
    ion_files = len(file_names)

    file_names = []
    for j in os.listdir('./result'):
        if os.path.splitext(j)[1] == '.csv':
            file_names.append(j)
    result_files = len(file_names)
    return int(result_files / ion_files)


def one_batch_level_file_name():
    """
    计算一个批次的level文件名
    :param batch:
    :return:
    """
    level_file_name_list = []
    filepath = './result/'
    for file_path, empty_list, file_name_list in os.walk(filepath):
        for i in file_name_list:
            level_file_name_list.append(filepath + i)
    return level_file_name_list


def level_file_name(batch):
    """
    计算每个批次的level文件名
    :param batch:
    :return:
    """
    level_file_name_list = []
    filepath = './result/'
    for file_path, empty_list, file_name_list in os.walk(filepath):
        for i in file_name_list:
            if batch < 10:
                batch_str = 'pos_0' + str(batch)
            else:
                batch_str = 'pos_' + str(batch)
            if batch_str in i:
                level_file_name_list.append(filepath + i)
    return level_file_name_list


def one_batch_generate_pos_lot_csv():
    """
    只有一个批次 生成 pos_lot_x.csv
    :return: 返回生成的 csv文件
    """
    level_files = one_batch_level_file_name()
    names = [
        "feature",
        "sample",
        "precursor_mz",
        "product_mz",
        "rt",
        "area",
        "background",
        "precursor_rt",
        "precursor_rt_window",
        "half_width",
        "peak_height"
    ]
    names = np.array(names)
    res_all = pd.DataFrame(columns=names)

    for path in level_files:
        # 读文件
        res = pd.read_csv(path, encoding='utf-8', header=0)
        res = res.values  # 或者 res = np.array(res)
        res = res[:, (1, 2, 3, 5, 8, 9, 10, 12, 13, 14, 15)]

        print("pos_level_1 path----------", path)
        res = pd.DataFrame(res, columns=names)
        res_all = res_all.append(res)

    wiff_file_name = []
    for j in os.listdir('./wiff'):
        if os.path.splitext(j)[1] == '.wiff':
            wiff_file_name.append(j)
    batch = wiff_file_name[0].split('.')[0].split('_')[1]
    print("batch----------", batch[-1])

    res_all.to_csv('./data/posdata_lot' + str(batch[-1]) + '.csv', encoding='utf-8', index=False, mode='a+')


def generate_pos_lot_batch_csv(batch):
    """
    生成 pos_lot_x.csv
    :param batch: 批次
    :return: 返回生成的 csv文件
    """
    level_files = level_file_name(batch)
    print("level_files----------", level_files)

    names = [
        "feature",
        "sample",
        "precursor_mz",
        "product_mz",
        "rt",
        "area",
        "background",
        "precursor_rt",
        "precursor_rt_window",
        "half_width",
        "peak_height"
    ]
    names = np.array(names)

    for i in range(len(level_files)):
        path = level_files[i]
        # 读文件
        res = pd.read_csv(path, encoding='utf-8', header=0)
        res = res.values  # 或者 res = np.array(res)
        res = res[:, (1, 2, 3, 5, 8, 9, 10, 12, 13, 14, 15)]
        if i == 0:
            print("pos_level_1 path----------", path)
            res = pd.DataFrame(res, columns=names)
            res.to_csv('./data/posdata_lot' + str(batch) + '.csv', encoding='utf-8', index=False, mode='a+')

        else:
            print("pos_level_%d path----------" % (i + 1), path)
            res = pd.DataFrame(res)
            res.to_csv('./data/posdata_lot' + str(batch) + '.csv', encoding='utf-8', index=False, header=None,
                       mode='a+')


dirs = './data'
# 先删除之前的文件夹
shutil.rmtree(dirs, ignore_errors=True)

# 写文件
os.makedirs(dirs)
print("data文件夹,创建成功!\n")

batch_num = calc_batch_num()
print("batch_num----------", batch_num)
if batch_num == 1:
    one_batch_generate_pos_lot_csv()
else:
    for batch in range(1, batch_num + 1):
        generate_pos_lot_batch_csv(batch)
        print("pos_lot_%d.csv 生成成功!\n" % batch)

```

### pos_split_by_PrecursorMz.py

```python
# -*- coding: gbk -*-
# 作者：   29511
# 文件名:  pos_split_by_PrecursorMz.py
# 日期时间：2020/11/26，10:09


def set_remain(PrecursorMz):
    """
    返回列表去重结果 和 剩余结果
    :param PrecursorMz: 原列表 即母离子的mz值列表
    :return: x1为: set集合去重得到的结果
            x2为: 列表减去-x1
            idx为: x1所在原列表中的索引下标
    """
    idx = []
    x1 = sorted(set(PrecursorMz), key=PrecursorMz.index)  # 去重原来顺序不变
    for item in x1:
        idx.append(PrecursorMz.index(item))
    dic = {i: element for i, element in enumerate(PrecursorMz)}  # 给元素变为字典 进行索引批量删除
    [dic.pop(i) for i in idx]
    x2 = list(dic.values())
    return (x1, x2, idx)


"""
    此方法的目的是按照 PrecursorMz(为母离子的mz值)的值 进行整理文件
    因为skyline要求每个csv文件里不能有相同的母离子mz值 
"""
import pandas as pd

# 读文件 不包含header
filename = 'original/pos.csv'
ion = 'pos'
input_data = pd.read_csv(filename, encoding='gbk').values

# header 第一行行名
header = pd.read_csv(filename, encoding='gbk', header=None).values[0, :]

# PrecursorMz为母离子的mz值
PrecursorMz = list(input_data[:, 1])

# 临时变量 copy一份PrecursorMz
tmp = PrecursorMz

# 第一次获得列表的去重结果的索引下标
list_idx = []
set_1 = sorted(set(tmp), key=tmp.index)
for item in set_1:
    list_idx.append(PrecursorMz.index(item))

# 输入的数据转为DataFrame
df = pd.DataFrame(input_data)
print("input_data")
print(df)
print("-" * 100)
print('\n')

# 得到x1 即set
set_data = df.iloc[list_idx, :]
print("out_data")
print(set_data)
print("*" * 100)

# 写文件
file1_name = ion + '_level_1.csv'
set_data.to_csv('./ion/' + file1_name, index=False, header=header)

# 调用函数
x1, x2, idx = set_remain(PrecursorMz)
# 去掉x1所在的行 得到剩下的行 即remain
df = df.drop(index=idx)

# i用来给文件名计数
i = 2
# 循环 x2为空时循环结束
while len(x2):
    PrecursorMz = x2
    x1, x2, idx = set_remain(PrecursorMz)
    # print("x1, x2, idx----------", x1, x2, idx)

    # 删除之后需要重置索引 使其下标从0开始
    df = df.reset_index(drop=True)

    # 得到x1 即set
    set_data = df.iloc[idx, :]
    print(set_data)
    print("*" * 100)

    # 写文件
    write_file_name = ion + "_level_" + str(i) + ".csv"
    set_data.to_csv('./ion/' + write_file_name, index=False, header=header)

    # 去掉x1所在的行 得到剩下的行 即remain
    df = df.drop(index=idx)

    # 文件名计数加1
    i += 1

```

### final_area.py

```python
# -*-coding:gbk-*-
# 作者：   29511
# 文件名:  01_生成final_area.py
# 日期时间：2020/11/27，22:08
import numpy as np
import pandas as pd
import os


def calc_final_area():
    """
    计算所有feature的area
    :return: 存储为 final_area.csv
    """
    posdata_file = ''
    for j in os.listdir('./'):
        if os.path.splitext(j)[0].split('_')[0] == 'posdata':
            posdata_file = j

    print("posdata_file----------", posdata_file)
    if posdata_file:
        # 读csv文件
        input_data = np.array(pd.read_csv(posdata_file))

        # 化合物名称,样本名称,面积
        feature = input_data[:, 0]
        sample = input_data[:, 1]
        area = input_data[:, 5]
        background = input_data[:, 6]
        area = area - background  # area应该减去背景值

        tuples = list(zip(*[list(feature), list(sample)]))  # 将数据组织成元组的格式
        index = pd.MultiIndex.from_tuples(tuples, names=['feature', 'type'])  # 对数据添加多个索引值
        area = pd.DataFrame(area)
        df = pd.DataFrame(area.values, index=index, columns=['Area'])  # 设置列名

        # 堆叠stack
        stacked = df.stack()
        # 取消堆叠
        res = stacked.unstack(1)

        # 写入csv文件
        res.to_csv('final_area.csv')
    else:
        print("posdata_file 不存在!")


def pos_split_csv():
    """
    将final_area.csv按照pos_is.csv进行拆分
    拆分为final_area.csv 和 final_is_area.csv
    注意将项目放到项目根路径下
    :return: 拆分后的两个csv文件
    """
    # 内标表
    if os.path.exists("pos_is.csv"):
        # 获取当前文件路径
        current_path = os.path.abspath("pos_is.csv")
        pos_is = np.array(pd.read_csv(current_path, header=None))[:, 0]

        is_list = []
        for i in pos_is:
            is_list.append(i)

        current_path = os.path.abspath("final_area.csv")
        header = pd.read_csv(current_path, encoding='utf-8', header=None).values[0, :]  # 行名
        header[1] = 'type'

        final_area = pd.read_csv(current_path, encoding='utf-8')
        df = pd.DataFrame(final_area)

        idx = []
        for i in is_list:
            idx.append(df[df['feature'] == i].index.values[0])

        # 对df进行拆分 写入两个文件
        final_is_area_data = df.loc[idx]
        final_is_area_data.to_csv('final_is_area.csv', index=False, header=header)

        final_area_data = df.drop(index=idx)  # 去掉x1所在的行 得到剩下的行
        final_area_data.to_csv('final_area.csv', index=False, header=header)
    else:
        print("pos_is.csv 文件不存在! \n 注意: 请将内标存放到pos_is.csv 文件下, 每个内标占一行!!!")


def fill_nan_to_zero():
    """
    将小于0的和空的都置为0
    :return: 置为0之后的文件
    """
    file_names = ['./final_area.csv', './final_is_area.csv']
    for file_name in file_names:
        if file_name:
            path = file_name
            header = pd.read_csv(path, header=None).values[0, :]  # 第一行行名
            input_data = pd.read_csv(path).values  # 读文件 不包含header
            df = pd.DataFrame(input_data)
            df[df.iloc[:, 2:] < 0] = np.nan  # 小于0的置为nan 从第二列往后
            df = df.fillna(value=0)  # 用0填补空值nan
            # 写文件
            df.to_csv(path, index=False, header=header)
        else:
            print("final_area.csv或final_is_area.csv 不存在或路径不正确!")


if __name__ == '__main__':
    calc_final_area()
    pos_split_csv()
    fill_nan_to_zero()

```

## LDT单个样本版

2020年12月29日16:44:25

### general_neg_bat.py


```python
import os
import pandas as pd

# sky文件
A_file_name = []
# 将当前目录下的所有文件名称读取进来
for j in os.listdir():
    # 判断是否为CSV文件，如果是则存储到列表中
    if os.path.splitext(j)[1] == '.sky':
        A_file_name.append(j)

# eg: neg_level_1.csv文件
D_file_name_list = []
for j in os.listdir('./ion'):
    if os.path.splitext(j)[1] == '.csv':
        D_file_name_list.append(j)

# wiff文件
E_file_name_list = []
for j in os.listdir('./wiff'):
    if os.path.splitext(j)[1] == '.wiff':
        E_file_name_list.append(j)

SPACE = ' '
A = A_file_name[0]
B = A.split('.')[0] + '_tmp.sky'
C = A.split('.')[0] + '_tmp.skyd'

# 进样表文件没有header
filename = os.listdir('./adjust_sample/')
filename = './adjust_sample/' + filename[0]
data = pd.read_csv(filename, encoding='utf-8', header=None)
sample_name_list = data.iloc[:, 0].values.tolist()

res = []
for sample_name in sample_name_list:
    for E in E_file_name_list:
        for D in D_file_name_list:
            F = D.split('.')[0] + '-' + E.split('.')[0] + '_report.csv'
            G = sample_name + '-' + D.split('.')[0] + '.sky'
            s2 = 'copy ' + A + SPACE + B + ' & skylinecmd --in=' + B + ' --import-transition-list=ion/' + D + ' --import-file=wiff/' + E + ' --import-samplename-pattern=' + sample_name + ' --report-name="离子对结果（多个）" --report-file=result/' + sample_name + '-' + F + ' --out=skyline/' + G + ' & del ' + B + SPACE + C
            res.append(s2)
print("共生成批处理命令%d条!" % len(res))

filename = '3.bat'
# 防止追加写入文件 先删除再写入
if os.path.exists(filename):
    print("文件已存在,删除成功!")
    os.remove(filename)
# 写文件
with open(filename, 'a+') as f:
    f.write('\n'.join(res))
f.close()
with open(filename, 'a+') as f:
    f.writelines('\npause')
f.close()
print("文件写入成功!")
```

### generate_neg_lot_batch_csv.py

```python
# -*-coding:utf-8-*- 
# 作者：   29511
# 文件名:  generate_neg_lot_batch_csv.py
# 日期时间：2020年12月29日16:21:11
import os
import shutil
import numpy as np
import pandas as pd


def calc_batch_num_by_wiff():
    """
    通过wiff文件计算有几个批次
    :return: 批次数 int型
    """
    file_count = 0
    for root, dirs, filenames in os.walk('./wiff'):
        for _ in filenames:
            file_count += 1
    return int(file_count // 2)


def one_batch_level_file_name():
    """
    计算一个批次的level文件名
    :param batch:
    :return:
    """
    level_file_name_list = []
    filepath = './result/'
    for file_path, empty_list, file_name_list in os.walk(filepath):
        for i in file_name_list:
            level_file_name_list.append(filepath + i)
    return level_file_name_list


def level_file_name(batch):
    """
    计算每个批次的level文件名
    :param batch:
    :return:
    """
    level_file_name_list = []
    filepath = './result/'
    for file_path, empty_list, file_name_list in os.walk(filepath):
        for i in file_name_list:
            if batch < 10:
                batch_str = 'neg_0' + str(batch)
            else:
                batch_str = 'neg_' + str(batch)
            if batch_str in i:
                level_file_name_list.append(filepath + i)
    return level_file_name_list


def one_batch_generate_neg_lot_csv():
    """
    只有一个批次 生成 neg_lot_x.csv
    :return: 返回生成的 csv文件
    """
    level_files = one_batch_level_file_name()
    names = [
        "feature",
        "sample",
        "precursor_mz",
        "product_mz",
        "rt",
        "area",
        "background",
        "precursor_rt",
        "precursor_rt_window",
        "half_width",
        "peak_height"
    ]
    names = np.array(names)
    res_all = pd.DataFrame(columns=names)
    for path in level_files:
        # 读文件
        res = pd.read_csv(path, encoding='utf-8', header=0)
        res = res.values  # 或者 res = np.array(res)
        res = res[:, (1, 2, 3, 5, 8, 9, 10, 12, 13, 14, 15)]

        print("neg_level_1 path----------", path)
        res = pd.DataFrame(res, columns=names)
        res_all = res_all.append(res)
    wiff_file_name = []
    for j in os.listdir('./wiff'):
        if os.path.splitext(j)[1] == '.wiff':
            wiff_file_name.append(j)
    batch = wiff_file_name[0].split('.')[0].split('_')[1]
    print("batch----------", batch[-1])

    res_all.to_csv('./data/negdata_lot' + str(batch[-1]) + '.csv', encoding='utf-8', index=False, mode='a+')


def generate_neg_lot_batch_csv(batch):
    """
    生成 neg_lot_x.csv
    :param batch: 批次
    :return: 返回生成的 csv文件
    """
    level_files = level_file_name(batch)
    print("level_files----------", level_files)

    names = [
        "feature",
        "sample",
        "precursor_mz",
        "product_mz",
        "rt",
        "area",
        "background",
        "precursor_rt",
        "precursor_rt_window",
        "half_width",
        "peak_height"
    ]
    names = np.array(names)

    for i in range(len(level_files)):
        path = level_files[i]
        # 读文件
        res = pd.read_csv(path, encoding='utf-8', header=0)
        res = res.values  # 或者 res = np.array(res)
        res = res[:, (1, 2, 3, 5, 8, 9, 10, 12, 13, 14, 15)]

        if i == 0:
            print("neg_level_1 path----------", path)
            res = pd.DataFrame(res, columns=names)
            res.to_csv('./data/negdata_lot' + str(batch) + '.csv', encoding='utf-8', index=False, mode='a+')

        else:
            print("neg_level_%d path----------" % (i + 1), path)
            res = pd.DataFrame(res)
            res.to_csv('./data/negdata_lot' + str(batch) + '.csv', encoding='utf-8', index=False, header=None,
                       mode='a+')


dirs = './data'
# 先删除之前的文件夹
shutil.rmtree(dirs, ignore_errors=True)

# 写文件
os.makedirs(dirs)
batch_num = calc_batch_num_by_wiff()
print("batch_num----------", batch_num)
if batch_num == 1:
    one_batch_generate_neg_lot_csv()
else:
    for batch in range(1, batch_num + 1):
        generate_neg_lot_batch_csv(batch)
        print("neg_lot_%d.csv 生成成功!\n" % batch)

```

