library(ggplot2)
library(ggrepel)
library(tidyquant)
library(grid)
library(DT)
library(readxl)
library(ggplotify)
library(plotly)
library(GGally)
library(caret)
# library(funModeling)
library(ggpubr)
library(reshape2)
library(tidyr)
library(tidyverse)

rowMin = function(x) {
  apply(x, 1, min)
}


rowMax = function(x) {
  apply(x, 1, max)
}

rowSd = function(x) {
  apply(x, 1, sd)
}

rowMedian = function(x) {
  apply(x, 1, median)
}

rowSqrMean = function(x) {
  apply(x^2, 1, mean)
}

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

rowAbsMinus <- function(x) {
  apply(x, 1, function(x) {
    (
      signif(abs(x[1] - x[2]), 3)
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


rowRecoveryCheck <- function(x) {
  apply(x, 1, function(x)(
    if(length(abs(as.numeric(x[x != "-"]))) == 6){
      max(abs(as.numeric(x[x != "-"])))
    } else {
      100
    })
  )
}


rowCheck <- function(x) {
  apply(x, 1, function(x)
    (
      if (x[4] == "1") {
        x[1] * x[2] * x[3]
      } else {
        x[1] * x[2]
      })
  )
}


# 绘制渲染表格
func_drawTable <- function(data){
  DT::datatable(
    data,
    # rownames = FALSE, # 不呈现行号
    filter = 'top',
    extensions = c('Buttons', 'KeyTable', 'FixedColumns', 'AutoFill', 'ColReorder'),
    options = list(keys = TRUE,
                   pageLength = 100,  # 每页显示多少条数据
                   dom = 'Bfrtip',
                   buttons = list(
                     c('copy', 'csv', 'excel'), list(extend = 'colvis', columns = c(2:ncol(data)))
                   ),
                   autoFill = TRUE,
                   # scrollY = 1000,
                   scrollX  = TRUE,
                   fixedColumns = list(leftColumns = 2, rightColumns = 1),
                   colReorder = TRUE,
                   deferRender = TRUE
    )
  )
  
}


# 计算QC的CV
func_calQc_CV <- function(qc_data, qc_prefix) {
  # qc_data_ratio <- qc_data_ratio + 1e-10
  qc_data <- qc_data[, grep(qc_prefix, colnames(qc_data))]
  qc_data_rsd <- transform(qc_data, rsd = rowCv(qc_data))
  qc_data_rsd$check_result  <- factor(1 * (round(as.numeric(as.character(qc_data_rsd$rsd)), 2) <= 15) )
  return(qc_data_rsd)
}


# 绘制相关性图
drawCorrPlot <- function(type, adata, bdata, caption="", number_cex = 1, t1_cex = 1, c1_cex = 1) {
  
  library(corrplot)
  require(psych)
  # png(filename = paste0(type, "_pearson.png"), width=960, height=960)
  mm_crc <- corr.test(adata, bdata, method = "pearson", adjust = "none", ci = FALSE)
  corrplot(
    mm_crc$r,
    diag = TRUE,  # 是否展示对角线上的结果，默认为TRUE
    method = "number",  # 指定可视化的方法，可以是圆形、方形、椭圆形、数值、阴影、颜色或饼图形
    number.cex = number_cex,
    tl.cex = t1_cex,  # 指定文本标签的大小
    cl.cex = c1_cex,  # 右侧颜色刻度标签数字大小
    title = paste0(caption, "(Pearson)"),  # 若使用标题title必须加mar=c(0, 0, 1, 0)，不然标题显示不全
    mar = c(1, 0, 2, 0)  # 设置图距离（下，左，上，右）四个边缘的距离
  )
  # dev.off()
  
  # png(filename = paste0(type, "_spearman.png"), width=960, height=960)
  mm_crc <- corr.test(adata, bdata, method = "spearman", adjust = "none", ci = FALSE)
  corrplot(
    mm_crc$r,
    method = "number",
    number.cex = number_cex,
    tl.cex = t1_cex,  # 指定文本标签的大小
    cl.cex = c1_cex,  # 右侧颜色刻度标签数字大小
    title = paste0(caption, "(Spearman)"),
    mar = c(1, 0, 2, 0)  # 设置图距离（下，左，上，右）四个边缘的距离
  )
  # dev.off()
  
  dat_all_ratio <- NULL
  for (i in 1:(ncol(adata))) {
    name1 <- colnames(adata)[i]
    dat_all <- NULL
    for (j in 1:ncol(bdata)) {
      name2 <- colnames(bdata)[j]
      data1 <- adata[, i]
      data2 <- bdata[, j]
      cos <- signif(sum(data1 * data2) / (sqrt(sum(data1^2)) * sqrt(sum(data2^2))), 5)
      
      dat <- data.frame(cos)
      rownames(dat) <- name1
      colnames(dat) <- name2
      
      if (is.null(dat_all)) {
        dat_all <- dat
      } else {
        dat_all <- cbind(dat_all, dat)
      }
    }
    
    if (is.null(dat_all_ratio)) {
      dat_all_ratio <- dat_all
    } else {
      dat_all_ratio <- rbind(dat_all_ratio, dat_all)
    }
  }
  # png(filename = paste0(type, "_cosine.png"), width=960, height=960)
  corrplot(
    corr = as.matrix(dat_all_ratio),
    method = "number",
    number.cex = number_cex,
    tl.cex = t1_cex,  # 指定文本标签的大小
    cl.cex = c1_cex,  # 右侧颜色刻度标签数字大小
    title = paste0(caption, "(Cosine)"),
    mar = c(1, 0, 2, 0)  # 设置图距离（下，左，上，右）四个边缘的距离
  )
  # dev.off()
}


# 计算两个df对应列的相关性
calc_corr <- function(a_data, b_data) {
  require(ggplot2)
  require(psych)
  all_corr <- NULL
  mul_raw_data <- NULL
  for(i in 1:length(a_data)){
    x1 <- a_data[i]
    x2 <- b_data[i]
    corr_pearson <- round(as.numeric(corr.test(x1, x2, method = "pearson", adjust = "none", ci = FALSE)$r), 3)
    corr_spearman <- round(as.numeric(corr.test(x1, x2, method = "spearman", adjust = "none", ci = FALSE)$r), 3)
    corr_cosine <- signif(sum(x1 * x2) / (sqrt(sum(x1^2)) * sqrt(sum(x2^2))), 3)
    
    raw_data <- cbind(corr_pearson, corr_spearman, corr_cosine)
    mul_raw_data <- rbind(mul_raw_data, raw_data)
  }
  all_corr <- cbind(colnames(a_data), mul_raw_data)
  colnames(all_corr)[1] <- 'sample'
  return(data.frame(all_corr))
}


# 计算两个df转置后对应feature列的相关性
calc_corr_t <- function(a_data, b_data) {
  require(ggplot2)
  require(psych)
  all_corr <- NULL
  mul_raw_data <- NULL
  for(i in 1:length(a_data)){
    x1 <- a_data[i]
    x2 <- b_data[i]
    corr_cosine <- signif(sum(x1 * x2) / (sqrt(sum(x1^2)) * sqrt(sum(x2^2))), 3)
    corr_pearson <- round(as.numeric(corr.test(x1, x2, method = "pearson", adjust = "none", ci = FALSE)$r), 3)
    corr_spearman <- round(as.numeric(corr.test(x1, x2, method = "spearman", adjust = "none", ci = FALSE)$r), 3)
    
    raw_data <- cbind(corr_cosine, corr_pearson, corr_spearman)
    mul_raw_data <- rbind(mul_raw_data, raw_data)
  }
  all_corr <- cbind(colnames(a_data), mul_raw_data)
  colnames(all_corr)[1] <- 'feature'
  return(data.frame(all_corr))
}

