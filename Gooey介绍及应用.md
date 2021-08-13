## Gooey介绍及应用

[Gooey Github地址]([chriskiehl/Gooey: Turn (almost) any Python command line program into a full GUI application with one line (github.com)](https://github.com/chriskiehl/Gooey))

[一行代码将Python程序转换为图形界面应用](https://zhuanlan.zhihu.com/p/352100156)

### 简单介绍

```python
from gooey import Gooey, GooeyParser

# encoding:指定编码方式 program_name:程序名称 language:语言(默认英语)
# 作为一个装饰器添加在函数的前面(核心)
@Gooey(encoding='utf-8', program_name="整理文件小工具-V1.0.0", language='chinese')
def start():
    parser = GooeyParser()
    # "path": 要传递的参数变量 help:提示信息 widget:控件类型(这里使用的是文件夹选择器)
    parser.add_argument("path", help="请选择要整理的文件路径：", widget="DirChooser")  # 一定要用双引号 不然没有这个属性
    args = parser.parse_args()
    return args


if __name__ == '__main__':
    args = start()
    # 解析传递回来的参数变量
    path = args.path
    # 使用参数变量
    print(path)
```

### 应用实例

```python
# 导入相关库
import os
import glob
import shutil
from gooey import Gooey, GooeyParser

# 定义一个文件字典，不同的文件类型，属于不同的文件夹，一共9个大类。
file_dict = {
    '图片': ['jpg', 'png', 'gif', 'webp'],
    '视频': ['rmvb', 'mp4', 'avi', 'mkv', 'flv'],
    "音频": ['cd', 'wave', 'aiff', 'mpeg', 'mp3', 'mpeg-4'],
    '文档': ['xls', 'xlsx', 'csv', 'doc', 'docx', 'ppt', 'pptx', 'pdf', 'txt'],
    '压缩文件': ['7z', 'ace', 'bz', 'jar', 'rar', 'tar', 'zip', 'gz'],
    '常用格式': ['json', 'xml', 'md', 'ximd'],
    '程序脚本': ['py', 'java', 'html', 'sql', 'r', 'css', 'cpp', 'c', 'sas', 'js', 'go'],
    '可执行程序': ['exe', 'bat', 'lnk', 'sys', 'com'],
    '字体文件': ['eot', 'otf', 'fon', 'font', 'ttf', 'ttc', 'woff', 'woff2']
}


# 定义一个函数，传入每个文件对应的后缀。判断文件是否存在于字典file_dict中；
# 如果存在，返回对应的文件夹名；如果不存在，将该文件夹命名为"未知分类"；
def func(suffix):
    for name, type_list in file_dict.items():
        if suffix.lower() in type_list:
            return name
    return "未知分类"


@Gooey(encoding='utf-8', program_name="整理文件小工具-V1.0.0\n\n公众号:数据分析与统计学之美", language='chinese')
def start():
    parser = GooeyParser()
    parser.add_argument("path", help="请选择要整理的文件路径：", widget="DirChooser")  # 一定要用双引号 不然没有这个属性
    args = parser.parse_args()
    # print(args, flush=True)  # 坑点：flush=True在打包的时候会用到
    return args


if __name__ == '__main__':
    args = start()
    path = args.path

    # 递归获取 "待处理文件路径" 下的所有文件和文件夹。
    for file in glob.glob(f"{path}/**/*", recursive=True):
        # 由于我们是对文件分类，这里需要挑选出文件来。
        if os.path.isfile(file):
            # 由于isfile()函数，获取的是每个文件的全路径。这里再调用basename()函数，直接获取文件名；
            file_name = os.path.basename(file)
            suffix = file_name.split(".")[-1]
            # 判断 "文件名" 是否在字典中。
            name = func(suffix)
            # print(func(suffix))
            # 根据每个文件分类，创建各自对应的文件夹。
            if not os.path.exists(f"{path}\\{name}"):
                os.mkdir(f"{path}\\{name}")
            # 将文件复制到各自对应的文件夹中。
            shutil.copy(file, f"{path}\\{name}")

```

```python
from gooey import Gooey, GooeyParser
import pandas as pd
import cv2


@Gooey(encoding='utf-8', program_name="修改离子对信息", language='chinese', image_dir='image')
def main():
    parser = GooeyParser()
    parser.add_argument("Feature", help="请输入离子对", choices=["X133", "X136", "X139", "X141", "X144", "X152", "X154", "X155", "X160", "X166", "X171", "X178", "X183", "X188", "X196", "X296", "X297", "X304", "X312", "X317", "SP51", "SP52", "SP53", "SP54", "SP55", "SP56", "NB51", "NB52", "NB53"], default='X133')  # 一定要用双引号 不然没有这个属性
    parser.add_argument("ExpectRT", help='请输入ExpectRT', default=0)
    # parser.add_argument("Start", help='请输入左侧峰边界', default=2.5)
    # parser.add_argument("End", help='请输入右侧峰边界', default=2.7)
    args = parser.parse_args()
    # print(args, flush=True)  # 坑点：flush=True在打包的时候会用到
    return args


if __name__ == '__main__':
    # 显示图片
    # image_name = 'Q01_NC50_80_1-X166.png'
    # img = cv2.imread(image_name)
    # cv2.imshow(image_name, img)

    args = main()

    half_peak_width = 0.15
    neg_ion_list_filename = 'pos_ion_list_20210111.csv'
    df = pd.read_csv(neg_ion_list_filename, float_precision='round_trip')
    df.set_index(['Feature'], inplace=True, drop=False)

    Feature = args.Feature
    ExpectRT = float(args.ExpectRT)

    df.loc[Feature, 'ExpectRT'] = ExpectRT

    # 添加两列
    df['sub_half_window'] = df['ExpectRT'] - half_peak_width
    df['add_half_window'] = df['ExpectRT'] + half_peak_width
    df = df.round({'sub_half_window': 2, 'add_half_window': 2})

    df.to_csv(neg_ion_list_filename, index=False)
```

