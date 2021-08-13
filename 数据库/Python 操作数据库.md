## Python 操作数据库

### 连接数据库进行查询

```python
# -*- coding:UTF-8 -*-
import pymysql
import pandas as pd

preoject_uuid = '402880e8784573da017845788af10000'

# 连接数据库
db = pymysql.connect(host='localhost',
                     port=3306,
                     user='root',
                     password='123456',
                     database='zjap',
                     charset='utf8')

# 生成游标对象 (操作数据库，执行sql语句)
cur = db.cursor()

# 查询CV数据 不包含SP和NB
sql = "select feature, rsd " \
      "from zp_qc_data " \
      "where project_uuid = %s" \
      "and instr(feature, 'SP') = 0 " \
      "and instr(feature, 'NB') = 0 " \
      "order by feature asc;"
try:
    # 执行语句
    cur.execute(sql, [preoject_uuid])
    # 获取所有查询结果
    all_row = cur.fetchall()
    df = pd.DataFrame(list(all_row))
except Exception as e:
    df = pd.DataFrame()
    print("e----------", e)

# 关闭游标和数据库连接
cur.close()
db.close()
```

