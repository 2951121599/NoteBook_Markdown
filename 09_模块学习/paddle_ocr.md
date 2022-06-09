## paddle_ocr

### 文字识别code

```python
import paddlehub as hub
import cv2

# 加载移动端预训练模型
# ocr = hub.Module(name="chinese_ocr_db_crnn_mobile")
# 服务端可以加载大模型，效果更好
ocr = hub.Module(name="chinese_ocr_db_crnn_server")

test_img_path = ['1.jpg']
# 读取测试文件夹test.txt中的照片路径
np_images = [cv2.imread(image_path) for image_path in test_img_path]

results = ocr.recognize_text(
    images=np_images,  # 图片数据，ndarray.shape 为 [H, W, C]，BGR格式；
    use_gpu=False,  # 是否使用 GPU；若使用GPU，请先设置CUDA_VISIBLE_DEVICES环境变量
    output_dir='ocr_result',  # 图片的保存路径，默认设为 ocr_result；
    visualization=True,  # 是否将识别结果保存为图片文件；
    box_thresh=0.5,  # 检测文本框置信度的阈值；
    text_thresh=0.5)  # 识别中文文本置信度的阈值；

# for result in results:
#     data = result['data']
#     save_path = result['save_path']
#     for infomation in data:
#         print('text: ', infomation['text'], '\nconfidence: ', infomation['confidence'], '\ntext_box_position: ',
#               infomation['text_box_position'])
data = results[0]['data']
for i in data:
    print(i['text'])
```



### python安装shapely

```python
# 安装完报错：
Could not find module Library\bin\geos_c.dll' (or one of its dependencies)

FileNotFoundError: Could not find module 'C:\Users\cuite\Anaconda3\Library\bin\geos_c.dll' (or one of its dependencies). Try using the full path with constructor syntax.
    
# 解决办法：在这个网址下载geos_c.dll，放到***\Anaconda3\Library\bin目录下面

https://www.dll-files.com/download/d8b5101f07394b4562ef673869395443/geos_c.dll.html?c=aGwxcEZIbXBzUE5nWWlwV3kyaWt4QT09

# 报错参考链接：
https://blog.csdn.net/chenguizhenaza/article/details/113831163
```

