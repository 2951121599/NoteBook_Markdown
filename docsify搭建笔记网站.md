## docsify搭建笔记网站

[视频教程: 使用docsify搭建笔记博客](https://b23.tv/fkISrYw)

### 安装node和npm

```shell
cmd 命令行提示符
# 查看版本:
node -v
npm -v

# 配置淘宝源
npm config set registry https://registry.npm.taobao.org/
# 确认配置项
npm config get registry
```



### 安装docsify

```shell
# 安装docsify
npm i docsify-cli -g
```



### 搭建网站

```cmd
# 选择一个存放docs的目录并运行
docsify init ./docs
# 开启服务
docsify serve ./docs
# 浏览器打开网址
http://localhost:3000
```



### cdn替换

jsdelivr的cdn挂了，很多依赖GitHub的网站打不开了

解决方法: 

```python
# 替换CDN 
# docsify的cdn还有unpkg
http://cdn.jsdelivr.net/npm  替换为  http://unpkg.com
# 很多GitHub文件的cdn也用的jsdelivr
http://cdn.jsdelivr.net  替换为  http://fastly.jsdelivr.net

# 如果这个也挂了,打开 https://ipaddress.com/website/raw.githubusercontent.com 将ip地址复制到host文件
# C:\Windows\System32\drivers\etc\hosts

# 其它CDN
https://www.bootcdn.cn/docsify/ (支持国内)
https://cdn.jsdelivr.net/npm/docsify/ (国内外都支持)
https://cdnjs.com/libraries/docsify
https://unpkg.com/browse/docsify/
```














