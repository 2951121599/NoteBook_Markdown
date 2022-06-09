# R语言基础知识

### **使用C()函数**

如果其中一个元素是字符，则非字符值被强制转换为字符类型。

```R
s <- c('apple','red',5,TRUE)
print(s)  # "apple" "red"   "5"     "TRUE" 
```

### 访问向量元素

使用索引访问向量的元素。 []括号用于建立索引。 索引从位置1开始。在索引中给出负值会丢弃来自**result**.   **TRUE**，**FALSE**或0和1的元素，也可用于索引。

```R
t <- c("Sun","Mon","Tue","Wed","Thurs","Fri","Sat")
u <- t[c(2,3,6)]
print(u)  # "Mon" "Tue" "Fri"

v <- t[c(TRUE,FALSE,FALSE,FALSE,FALSE,TRUE,FALSE)]
print(v)  # "Sun" "Fri"

x <- t[c(-2,-5)]  # 不要第2个和第五个
print(x)  # "Sun" "Tue" "Wed" "Fri" "Sat"

y <- t[c(0,0,0,0,0,0,1)]
print(y)

[1] "Sun"
```

### 命名列表元素

列表元素可以给出名称，并且可以使用这些名称访问它们。

```R
list_data <- list(c("Jan","Feb","Mar"), matrix(c(3,9,5,1,-2,8), nrow = 2),
   list("green",12.3))

# Give names to the elements in the list.
names(list_data) <- c("1st Quarter", "A_Matrix", "A Inner list")
```

### 矩阵

矩阵是其中元素以二维矩形布局布置的R对象。 它们包含相同原子类型的元素。 虽然我们可以创建一个只包含字符或只包含逻辑值的矩阵，但它们没有太多用处。 我们使用包含数字元素的矩阵用于数学计算。

使用**matrix()**函数创建一个矩阵。

在R语言中创建矩阵的基本语法是 -

```R
matrix(data, nrow, ncol, byrow, dimnames)
```

以下是所使用的参数的说明 -

- **data**是成为矩阵的数据元素的输入向量。

- **nrow**是要创建的行数。

- **ncol**是要创建的列数。

- **byrow**是一个逻辑线索。 如果为TRUE，则输入向量元素按行排列。

- **dimnames**是分配给行和列的名称。

  

#### 矩阵的创建

创建一个以数字向量作为输入的矩阵

```R
# 元素按行顺序排列
M <- matrix(c(3:14), nrow = 4, byrow = TRUE)
print(M)

# 元素按列顺序排列
N <- matrix(c(3:14), nrow = 4, byrow = FALSE)
print(N)

# 定义列和行名称。
rownames = c("row1", "row2", "row3", "row4")
colnames = c("col1", "col2", "col3")

P <- matrix(c(3:14), nrow = 4, byrow = TRUE, dimnames = list(rownames, colnames))
print(P)
```

```R
     [,1] [,2] [,3]
[1,]    3    4    5
[2,]    6    7    8
[3,]    9   10   11
[4,]   12   13   14
     [,1] [,2] [,3]
[1,]    3    7   11
[2,]    4    8   12
[3,]    5    9   13
[4,]    6   10   14
     col1 col2 col3
row1    3    4    5
row2    6    7    8
row3    9   10   11
row4   12   13   14
```

#### 访问矩阵的元素
可以通过使用元素的列和行索引来访问矩阵的元素。 我们考虑上面的矩阵P找到下面的具体元素。

```R
# Define the column and row names.
rownames = c("row1", "row2", "row3", "row4")
colnames = c("col1", "col2", "col3")

# Create the matrix.
P <- matrix(c(3:14), nrow = 4, byrow = TRUE, dimnames = list(rownames, colnames))

# Access the element at 3rd column and 1st row.
print(P[1,3])

# Access the element at 2nd column and 4th row.
print(P[4,2])

# Access only the  2nd row.
print(P[2,])

# Access only the 3rd column.
print(P[,3])
```

当我们执行上面的代码，它产生以下结果 -

```R
[1] 5
[1] 13
col1 col2 col3 
   6    7    8 
row1 row2 row3 row4 
   5    8   11   14 
```

### 矩阵计算

使用R运算符对矩阵执行各种数学运算。 操作的结果也是一个矩阵。
对于操作中涉及的矩阵，维度（行数和列数）应该相同。



### 矩阵加法和减法

```R
# Create two 2x3 matrices.
matrix1 <- matrix(c(3, 9, -1, 4, 2, 6), nrow = 2)
print(matrix1)

matrix2 <- matrix(c(5, 2, 0, 9, 3, 4), nrow = 2)
print(matrix2)

# Add the matrices.
result <- matrix1 + matrix2
cat("Result of addition","
")
print(result)

# Subtract the matrices
result <- matrix1 - matrix2
cat("Result of subtraction","
")
print(result)
```

当我们执行上面的代码，它产生以下结果 -

```R
     [,1] [,2] [,3]
[1,]    3   -1    2
[2,]    9    4    6
     [,1] [,2] [,3]
[1,]    5    0    3
[2,]    2    9    4
Result of addition 
     [,1] [,2] [,3]
[1,]    8   -1    5
[2,]   11   13   10
Result of subtraction 
     [,1] [,2] [,3]
[1,]   -2   -1   -1
[2,]    7   -5    2
```

### 矩阵乘法和除法

```ruby
# Create two 2x3 matrices.
matrix1 <- matrix(c(3, 9, -1, 4, 2, 6), nrow = 2)
print(matrix1)

matrix2 <- matrix(c(5, 2, 0, 9, 3, 4), nrow = 2)
print(matrix2)

# Multiply the matrices.
result <- matrix1 * matrix2
cat("Result of multiplication","
")
print(result)

# Divide the matrices
result <- matrix1 / matrix2
cat("Result of division","
")
print(result)
```

当我们执行上面的代码，它产生以下结果 -

```R
     [,1] [,2] [,3]
[1,]    3   -1    2
[2,]    9    4    6
     [,1] [,2] [,3]
[1,]    5    0    3
[2,]    2    9    4
Result of multiplication 
     [,1] [,2] [,3]
[1,]   15    0    6
[2,]   18   36   24
Result of division 
     [,1]      [,2]      [,3]
[1,]  0.6      -Inf 0.6666667
[2,]  4.5 0.4444444 1.5000000
```



### **数组**

数组是可以在两个以上维度中存储数据的R数据对象。 例如 - 如果我们创建一个维度(2，3，4)的数组，则它创建4个矩形矩阵，每个矩阵具有2行和3列。 数组只能存储数据类型。

使用**array()**函数创建数组。 它使用向量作为输入，并使用**dim**参数中的值创建数组。



#### 例

以下示例创建一个由两个3x3矩阵组成的数组，每个矩阵具有3行和3列。

```R
# Create two vectors of different lengths.
vector1 <- c(5,9,3)
vector2 <- c(10,11,12,13,14,15)

# Take these vectors as input to the array.
result <- array(c(vector1,vector2),dim = c(3,3,2))
print(result)
```

当我们执行上面的代码，它产生以下结果 -

```R
, , 1

     [,1] [,2] [,3]
[1,]    5   10   13
[2,]    9   11   14
[3,]    3   12   15

, , 2

     [,1] [,2] [,3]
[1,]    5   10   13
[2,]    9   11   14
[3,]    3   12   15
```

#### 命名列和行

我们可以使用**dimnames**参数给数组中的行，列和矩阵命名。

```R
# Create two vectors of different lengths.
vector1 <- c(5,9,3)
vector2 <- c(10,11,12,13,14,15)
column.names <- c("COL1","COL2","COL3")
row.names <- c("ROW1","ROW2","ROW3")
matrix.names <- c("Matrix1","Matrix2")

# Take these vectors as input to the array.
result <- array(c(vector1,vector2),dim = c(3,3,2),dimnames = list(row.names,column.names,matrix.names))
print(result)
```

当我们执行上面的代码，它产生以下结果 -

```R
, , Matrix1

     COL1 COL2 COL3
ROW1    5   10   13
ROW2    9   11   14
ROW3    3   12   15

, , Matrix2

     COL1 COL2 COL3
ROW1    5   10   13
ROW2    9   11   14
ROW3    3   12   15
```

#### 访问数组元素

```R
# Create two vectors of different lengths.
vector1 <- c(5,9,3)
vector2 <- c(10,11,12,13,14,15)
column.names <- c("COL1","COL2","COL3")
row.names <- c("ROW1","ROW2","ROW3")
matrix.names <- c("Matrix1","Matrix2")

# Take these vectors as input to the array.
result <- array(c(vector1,vector2),dim = c(3,3,2),dimnames = list(row.names,
   column.names, matrix.names))

# Print the third row of the second matrix of the array.
print(result[3,,2])

# Print the element in the 1st row and 3rd column of the 1st matrix.
print(result[1,3,1])

# Print the 2nd Matrix.
print(result[,,2])
```

当我们执行上面的代码，它产生以下结果 -

```R
COL1 COL2 COL3 
   3   12   15 
[1] 13
     COL1 COL2 COL3
ROW1    5   10   13
ROW2    9   11   14
ROW3    3   12   15
```

#### 操作数组元素

由于数组由多维构成矩阵，所以对数组元素的操作通过访问矩阵的元素来执行。

```R
# Create two vectors of different lengths.
vector1 <- c(5,9,3)
vector2 <- c(10,11,12,13,14,15)

# Take these vectors as input to the array.
array1 <- array(c(vector1,vector2),dim = c(3,3,2))

# Create two vectors of different lengths.
vector3 <- c(9,1,0)
vector4 <- c(6,0,11,3,14,1,2,6,9)
array2 <- array(c(vector1,vector2),dim = c(3,3,2))

# create matrices from these arrays.
matrix1 <- array1[,,2]
matrix2 <- array2[,,2]

# Add the matrices.
result <- matrix1+matrix2
print(result)
```

当我们执行上面的代码，它产生以下结果 -

```R
     [,1] [,2] [,3]
[1,]   10   20   26
[2,]   18   22   28
[3,]    6   24   30
```

#### 跨数组元素的计算

我们可以使用**apply()**函数在数组中的元素上进行计算。

#### 语法

```R
apply(x, margin, fun)
```

以下是所使用的参数的说明 -

- **x**是一个数组。
- **margin**是所使用的数据集的名称。
- **fun**是要应用于数组元素的函数。

#### 例

我们使用下面的**apply()**函数计算所有矩阵中数组行中元素的总和。

```R
# Create two vectors of different lengths.
vector1 <- c(5,9,3)
vector2 <- c(10,11,12,13,14,15)

# Take these vectors as input to the array.
new.array <- array(c(vector1,vector2),dim = c(3,3,2))
print(new.array)

# 使用apply计算所有矩阵的行和。
result <- apply(new.array, c(1), sum)
print(result)
```

当我们执行上面的代码，它产生以下结果 -

```R
, , 1

     [,1] [,2] [,3]
[1,]    5   10   13
[2,]    9   11   14
[3,]    3   12   15

, , 2

     [,1] [,2] [,3]
[1,]    5   10   13
[2,]    9   11   14
[3,]    3   12   15

[1] 56 68 60
```



### 数据帧

数据帧是表或二维阵列状结构，其中每一列包含一个变量的值，并且每一行包含来自每一列的一组值。
以下是数据帧的特性。

- 列名称应为非空。
- 行名称应该是唯一的。
- 存储在数据帧中的数据可以是数字，因子或字符类型。
- 每个列应包含相同数量的数据项。

#### 创建数据帧

```R
# Create the data frame.
emp.data <- data.frame(
   emp_id = c (1:5), 
   emp_name = c("Rick","Dan","Michelle","Ryan","Gary"),
   salary = c(623.3,515.2,611.0,729.0,843.25), 
   
   start_date = as.Date(c("2012-01-01", "2013-09-23", "2014-11-15", "2014-05-11",
      "2015-03-27")),
   stringsAsFactors = FALSE
)
# Print the data frame.			
print(emp.data) 
```

当我们执行上面的代码，它产生以下结果 -

```R
 emp_id    emp_name     salary     start_date
1     1     Rick        623.30     2012-01-01
2     2     Dan         515.20     2013-09-23
3     3     Michelle    611.00     2014-11-15
4     4     Ryan        729.00     2014-05-11
5     5     Gary        843.25     2015-03-27
```

#### 获取数据帧的结构

通过使用str()函数可以看到数据帧的结构。

```R
# Create the data frame.
emp.data <- data.frame(
   emp_id = c (1:5), 
   emp_name = c("Rick","Dan","Michelle","Ryan","Gary"),
   salary = c(623.3,515.2,611.0,729.0,843.25), 
   
   start_date = as.Date(c("2012-01-01", "2013-09-23", "2014-11-15", "2014-05-11",
      "2015-03-27")),
   stringsAsFactors = FALSE
)
# Get the structure of the data frame.
str(emp.data)
```

当我们执行上面的代码，它产生以下结果 -

```R
'data.frame':   5 obs. of  4 variables:
 $ emp_id    : int  1 2 3 4 5
 $ emp_name  : chr  "Rick" "Dan" "Michelle" "Ryan" ...
 $ salary    : num  623 515 611 729 843
 $ start_date: Date, format: "2012-01-01" "2013-09-23" "2014-11-15" "2014-05-11" ...
```

#### 数据框中的数据摘要

可以通过应用**summary()**函数获取数据的统计摘要和性质。

```R
# Create the data frame.
emp.data <- data.frame(
   emp_id = c (1:5), 
   emp_name = c("Rick","Dan","Michelle","Ryan","Gary"),
   salary = c(623.3,515.2,611.0,729.0,843.25), 
   
   start_date = as.Date(c("2012-01-01", "2013-09-23", "2014-11-15", "2014-05-11",
      "2015-03-27")),
   stringsAsFactors = FALSE
)R
# Print the summary.
print(summary(emp.data))  
```

当我们执行上面的代码，它产生以下结果 -

```R
     emp_id    emp_name             salary        start_date        
 Min.   :1   Length:5           Min.   :515.2   Min.   :2012-01-01  
 1st Qu.:2   Class :character   1st Qu.:611.0   1st Qu.:2013-09-23  
 Median :3   Mode  :character   Median :623.3   Median :2014-05-11  
 Mean   :3                      Mean   :664.4   Mean   :2014-01-14  
 3rd Qu.:4                      3rd Qu.:729.0   3rd Qu.:2014-11-15  
 Max.   :5                      Max.   :843.2   Max.   :2015-03-27 
```

#### 从数据帧提取数据

使用列名称从数据框中提取特定列。

```R
# Create the data frame.
emp.data <- data.frame(
   emp_id = c (1:5),
   emp_name = c("Rick","Dan","Michelle","Ryan","Gary"),
   salary = c(623.3,515.2,611.0,729.0,843.25),
   
   start_date = as.Date(c("2012-01-01","2013-09-23","2014-11-15","2014-05-11",
      "2015-03-27")),
   stringsAsFactors = FALSE
)
# Extract Specific columns.
result <- data.frame(emp.data$emp_name,emp.data$salary)  # 通过$ 寻找下一个属性
print(result)
```

当我们执行上面的代码，它产生以下结果 -

```R
  emp.data.emp_name emp.data.salary
1              Rick          623.30
2               Dan          515.20
3          Michelle          611.00
4              Ryan          729.00
5              Gary          843.25
```

先提取前两行，然后提取所有列

```R
# Create the data frame.
emp.data <- data.frame(
   emp_id = c (1:5),
   emp_name = c("Rick","Dan","Michelle","Ryan","Gary"),
   salary = c(623.3,515.2,611.0,729.0,843.25),
   
   start_date = as.Date(c("2012-01-01", "2013-09-23", "2014-11-15", "2014-05-11",
      "2015-03-27")),
   stringsAsFactors = FALSE
)
# Extract first two rows.
result <- emp.data[1:2,]
print(result)
```

当我们执行上面的代码，它产生以下结果 -

```R
  emp_id    emp_name   salary    start_date
1      1     Rick      623.3     2012-01-01
2      2     Dan       515.2     2013-09-23
```

用第2和第4列提取第3和第5行

```R
# Create the data frame.
emp.data <- data.frame(
   emp_id = c (1:5), 
   emp_name = c("Rick","Dan","Michelle","Ryan","Gary"),
   salary = c(623.3,515.2,611.0,729.0,843.25), 
   
	start_date = as.Date(c("2012-01-01", "2013-09-23", "2014-11-15", "2014-05-11",
      "2015-03-27")),
   stringsAsFactors = FALSE
)

# Extract 3rd and 5th row with 2nd and 4th column.
result <- emp.data[c(3,5),c(2,4)]  # 用第2和第4列提取第3和第5行
print(result)
```

当我们执行上面的代码，它产生以下结果 -

```R
  emp_name start_date
3 Michelle 2014-11-15
5     Gary 2015-03-27
```

#### 扩展数据帧

可以通过添加列和行来扩展数据帧。

##### 添加列

只需使用新的列名称添加列向量。

```R
# Create the data frame.
emp.data <- data.frame(
   emp_id = c (1:5), 
   emp_name = c("Rick","Dan","Michelle","Ryan","Gary"),
   salary = c(623.3,515.2,611.0,729.0,843.25), 
   
   start_date = as.Date(c("2012-01-01", "2013-09-23", "2014-11-15", "2014-05-11",
      "2015-03-27")),
   stringsAsFactors = FALSE
)

# Add the "dept" coulmn.
emp.data$dept <- c("IT","Operations","IT","HR","Finance")
v <- emp.data
print(v)
```

当我们执行上面的代码，它产生以下结果 -

```R
  emp_id   emp_name    salary    start_date       dept
1     1    Rick        623.30    2012-01-01       IT
2     2    Dan         515.20    2013-09-23       Operations
3     3    Michelle    611.00    2014-11-15       IT
4     4    Ryan        729.00    2014-05-11       HR
5     5    Gary        843.25    2015-03-27       Finance
```

##### 添加行

要将更多行永久添加到现有数据帧，我们需要引入与现有数据帧相同结构的新行，并使用**rbind()**函数。
在下面的示例中，我们创建一个包含新行的数据帧，并将其与现有数据帧合并以创建最终数据帧。



```R
# Create the first data frame.
emp.data <- data.frame(
   emp_id = c (1:5), 
   emp_name = c("Rick","Dan","Michelle","Ryan","Gary"),
   salary = c(623.3,515.2,611.0,729.0,843.25), 
   
   start_date = as.Date(c("2012-01-01", "2013-09-23", "2014-11-15", "2014-05-11",
      "2015-03-27")),
   dept = c("IT","Operations","IT","HR","Finance"),
   stringsAsFactors = FALSE
)

# Create the second data frame
emp.newdata <- 	data.frame(
   emp_id = c (6:8), 
   emp_name = c("Rasmi","Pranab","Tusar"),
   salary = c(578.0,722.5,632.8), 
   start_date = as.Date(c("2013-05-21","2013-07-30","2014-06-17")),
   dept = c("IT","Operations","Fianance"),
   stringsAsFactors = FALSE
)

# Bind the two data frames.
emp.finaldata <- rbind(emp.data,emp.newdata)
print(emp.finaldata)
```

当我们执行上面的代码，它产生以下结果 -

```R
  emp_id     emp_name    salary     start_date       dept
1      1     Rick        623.30     2012-01-01       IT
2      2     Dan         515.20     2013-09-23       Operations
3      3     Michelle    611.00     2014-11-15       IT
4      4     Ryan        729.00     2014-05-11       HR
5      5     Gary        843.25     2015-03-27       Finance
6      6     Rasmi       578.00     2013-05-21       IT
7      7     Pranab      722.50     2013-07-30       Operations
8      8     Tusar       632.80     2014-06-17       Fianance
```

### For循环

#### 语法

在R中创建一个for循环语句的基本语法是 

```R
for (变量 in 条件) {
   循环体
}

v <- LETTERS[1:4]
for ( i in v) {
   print(i)
}

[1] "A"
[1] "B"
[1] "C"
[1] "D"
```

