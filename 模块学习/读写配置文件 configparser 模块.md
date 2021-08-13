# Python3 读写配置文件 configparser 模块

### 

[TOC]

## 1、configparser 简介

configparser 是 Pyhton 标准库中用来解析配置文件的模块，并且内置方法和字典非常接近。

配置文件的格式如下：

```shell
[logoninfo]
addr=zhangsan
passwd=lisi
popserver=emain

[logging]
level=2
path= "/root"
server="login"

[mysql]
host=127.0.0.1
port=3306
user=root
password=123456
123456789101112131415
```

“[ ]” 包含的为 section，section 下面为类似于 key-value 的配置内容；
configparser 默认支持 '=', ':' 两种分隔，下面这种也是合法了

```shell
[mysql]
host:127.0.0.1
port:3306
user:root
password:123456
12345
```

## 2、读取文件内容

- 初始化实例：使用 configparser 首先需要初始化实例，并读取配置文件
- 获取所有 sections
- 获取指定 section 的 keys
- 获取指定 key 的 value
- 获取指定 section 的 keys & values
- 检查 section 是否存在
- 检查指定 section 中 key 是否存在
- 检查指定 section 指定 key 的 value

下面直接在代码中一一实现上述功能

```python
import configparser

# 初始化实例
conf = configparser.ConfigParser()
conf.read('config.ini')

# 获取所有 sections
sections = conf.sections()  # 获取配置文件中所有sections，sections是列表
print(sections)

# 获取指定 section 的 keys
option = conf.options(conf.sections()[0])  # 获取某个section下的所有选项或value，
# 等价于 option = conf.options('logoninfo')
print(option)

# 获取指定 key 的 value
value = conf.get('logoninfo', 'addr')   # 根据section和value获取key值
# 等价于value = conf.get(conf.sections()[0], conf.options(conf.sections()[0])[0])
print(value)

# 获取指定 section 的 keys & values
item = conf.items('logoninfo')
print(item)

# 检查 section 是否存在
print("xxxxxxxxxxxxxx")
print('logging' in conf)
# 或者 print('logging' in conf.sections())

# 检查指定 section 中 key 是否存在
print("addr" in conf["logoninfo"])

# 检查指定 section 指定 key 的 value
print("zhangsan" in conf["logoninfo"]["addr"]) #等于 "zhangsan" == conf["logoninfo"]["addr"]
123456789101112131415161718192021222324252627282930313233
```

## 3、生成配置文件

```python
import configparser                     # 引入模块

config = configparser.ConfigParser()    #实例化一个对象

config["logoninfo"] = {                 # 类似于操作字典的形式
    'addr': "zhangsan",
    'passwd': "lisi",
    'popserver': "emain"
}

config['logging'] = {
    "level": '2',
    "path": "/root",
    "server": "login",
    'User': 'Atlan'
}

config['mysq'] = {
    'host': '127.0.0.1',
    'port': '3306',
    'user': 'root',
    'password': '123456'
}

with open('config.ini', 'w') as configfile:
    config.write(configfile)
1234567891011121314151617181920212223242526
```

## 4、修改配置文件

```python
import configparser

config = configparser.ConfigParser()			# 实例化一个对象

config.read('config.ini')                       # 读文件

config.add_section('yuan')                      # 添加 section

config.remove_section('mysq.org')               # 删除 section
config.remove_option('logoninfo', "popserver")  # 删除一个配置项

config.set('logging', 'level', '3')				# 修改执行 section 指定 key 的 value
config.set('yuan', 'k2', '22222')				# 添加一个配置项
with open('config.ini', 'w') as f:
    config.write(f)
```