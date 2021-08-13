## logger模块使用

### 定义日志模板

```python
# log_template.py
import configparser
import logging
import os

os.environ['NUMEXPR_MAX_THREADS'] = '16'
logger = logging.getLogger(__name__)
DATE_FORMAT = "%m/%d/%Y %H:%M:%S"
config = configparser.ConfigParser()
config.read('config.ini')
batch = config['batch_info']['batch']
# 默认级别是warning
logging.basicConfig(level=logging.INFO,
                    filename=os.path.join(batch, batch + '.log'),
                    filemode='a',
                    format='%(asctime)s - %(filename)s[line:%(lineno)d] - %(levelname)s: %(message)s',
                    datefmt=DATE_FORMAT)
```

### 使用模板

```python
from log_template import logger
from tkinter import Tk, messagebox

# 窗口显示错误信息
def show_error(root, error_info):
    root.withdraw()  # 实现主窗口隐藏
    messagebox.showerror("错误信息", error_info)  # 显示错误
    logger.error(error_info)  # 记录错误日志
    sys.exit()  # 程序退出
```



