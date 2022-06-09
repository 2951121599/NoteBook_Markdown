## Pandas的index索引

### index索引，修改索引，将DataFrame某列设为索引

```python

# coding=utf-8
import numpy as np
import pandas as pd
 
 
df = pd.DataFrame(np.arange(12, 24).reshape((3, 4)), index=["a", "b", "c"], columns=["WW", "XX", "YY", "ZZ"])
print(df)
'''
   WW  XX  YY  ZZ
a  12  13  14  15
b  16  17  18  19
c  20  21  22  23
'''
 
 
# 查看索引 (索引是可以重复的)
print(df.index)  # Index(['a', 'b', 'c'], dtype='object')
 
# 修改索引
df.index = ["aa", "bb", "cc"]   # []列表的长度必须与df行数一致。
print(df)
'''
    WW  XX  YY  ZZ
aa  12  13  14  15
bb  16  17  18  19
cc  20  21  22  23
'''
 
# 根据索引重新构建数据
df2 = df.reindex(["aa", "pp"])  # 索引存在就正常显示数据，不存在的索引其数据就是NaN
print(df2)
'''
      WW    XX    YY    ZZ
aa  12.0  13.0  14.0  15.0
pp   NaN   NaN   NaN   NaN
'''
 
# 将某列设置为索引
df3 = df.set_index("YY")  # 将"YY"列设为索引（默认同时删除"YY"列的数据）
print(df3)
'''
    WW  XX  ZZ
YY
14  12  13  15
18  16  17  19
22  20  21  23
'''
 
df4 = df.set_index("YY", drop=False)  #  drop=False 表示保留原先"YY"列的数据。(默认为True)
print(df4)
'''
    WW  XX  YY  ZZ
YY
14  12  13  14  15
18  16  17  18  19
22  20  21  22  23
'''
 
# unique()某列去重后的内容
print(df["ZZ"].unique())  # [15 19 23]  ndarray类型
 
df.index = ["ll", "ll", "mm"]  # 索引可以重复
# 去重后的索引
print(df.index.unique())  # Index(['ll', 'mm'], dtype='object')
 
# index索引对象可以转换成列表类型
print(list(df.index))  # ['ll', 'll', 'mm']
```

### 复合索引，通过复合索引取值

```python
# coding=utf-8
import numpy as np
import pandas as pd
 
 
df = pd.DataFrame(np.arange(12, 24).reshape((3, 4)), index=["a", "b", "c"], columns=["WW", "XX", "YY", "ZZ"])
print(df)
'''
   WW  XX  YY  ZZ
a  12  13  14  15
b  16  17  18  19
c  20  21  22  23
'''
 
 
# 复合索引 将多列设置为索引
df2 = df.set_index(["XX", "YY"])  # 如果只设置一列不需要[]，如果设置多列需要[]
print(df2)
'''
       WW  ZZ
XX YY
13 14  12  15
17 18  16  19
21 22  20  23
'''
 
print(df2.index)  # 复合索引
'''
MultiIndex(levels=[[13, 17, 21], [14, 18, 22]],
           codes=[[0, 1, 2], [0, 1, 2]],
           names=['XX', 'YY'])
--levels表示去重后的索引
'''
 
 
# Series类型的复合索引
s1 = df2["WW"]  # Series类型 (只取了一列)。  df2[["WW"]]是DataFrame类型
print(s1)  # Series类型
'''
XX  YY
13  14    12
17  18    16
21  22    20
Name: WW, dtype: int64
'''
 
# 根据复合索引取值
print(s1[13][14])  # 12  索引可以重复，一个索引可能对应多个值(如果对应多个值返回Series类型)
print(s1[13, 14])  # 12  与上一句等同
print(s1[13])  # Series类型。 如果想通过"YY"索引取值，可以先swaplevel()交换索引次序再取值。
'''
YY
14    12
Name: WW, dtype: int64
'''
# 通过复合索引修改
s1[13][14] = 55
print(s1)
'''
XX  YY
13  14    55
17  18    16
21  22    20
Name: WW, dtype: int64
'''
 
# swaplevel()交换索引先后次序。
s2 = s1.swaplevel()  # 将"YY"索引放前，"XX"索引放后
print(s2)
'''
YY  XX
14  13    12
18  17    16
22  21    20
Name: WW, dtype: int64
'''
 
 
# DataFrame的复合索引
print(df2)
'''
       WW  ZZ
XX YY
13 14  12  15
17 18  16  19
21 22  20  23
'''
 
# DataFrame通过复合索引取值
print(df2.loc[13].loc[14])  # Series类型。  索引可以重复，可能对应多个值(DataFrame类型)
'''
WW    12
ZZ    15
Name: 14, dtype: int64
'''
print(df2.loc[13])  # DataFrame类型。  如果想通过"YY"索引取值，可以先swaplevel()交换索引次序再取值。
'''
    WW  ZZ
YY
14  12  15
'''
 
# swaplevel()交换索引先后次序。
df3 = df2.swaplevel()  # 将"YY"索引放前，"XX"索引放后
print(df3)
'''
       WW  ZZ
YY XX
14 13  12  15
18 17  16  19
22 21  20  23
'''
```

