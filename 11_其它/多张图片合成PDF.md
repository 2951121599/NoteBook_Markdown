## 多张图片合成PDF

### PIL

>图像不是很清晰

```python
import os
from PIL import Image


def combine2pdf(neg_folder_path, pos_folder_path, pdfFilePath):
    png_files = []
    images = []
    for file in os.listdir(neg_folder_path):
        if 'png' in file:
            png_files.append(os.path.join(neg_folder_path, file))
    for file in os.listdir(pos_folder_path):
        if 'png' in file:
            png_files.append(os.path.join(pos_folder_path, file))
    for file in png_files:
        im = Image.open(file)
        # Pillow can't save RGBA images to pdf,make sure the image is RGB
        if im.mode == "RGBA":
            im = im.convert("RGB")
        images.append(im)
    images[0].save(pdfFilePath, save_all=True, quality=100, append_images=images[1:])


if __name__ == "__main__":
    batch = '20210812'
    neg_ion_path = os.path.join(batch, 'neg')
    pos_ion_path = os.path.join(batch, 'pos')
    for sample in os.listdir(neg_ion_path):
        neg_sample_path = os.path.join(neg_ion_path, sample)
        pos_sample_path = os.path.join(pos_ion_path, sample)
        sample_pdf_file = os.path.join(batch, sample + '.pdf')
        combine2pdf(neg_sample_path, pos_sample_path, sample_pdf_file)
        print("%s pdf合并完成" % sample)
    print('共%s个 success!' % len(os.listdir(neg_ion_path)))

```

### fpdf

> 合成图片清晰, 但是速度很慢

```python
import os
from PIL import Image
from fpdf import FPDF

pdf = FPDF()
sdir = "./test2/"
w, h = 0, 0
img_list = [os.path.join(sdir, x) for x in os.listdir(sdir)]
for i in range(1, len(img_list) + 1):
    fname = img_list[i - 1]
    print("fname----------", fname)

    if os.path.exists(fname):
        if i == 1:
            cover = Image.open(fname)
            w, h = cover.size
            pdf = FPDF(unit="pt", format=[w, h])
        image = fname
        pdf.add_page()
        pdf.image(image, 0, 0, w, h)
    else:
        print("File not found:", fname)
    print("processed %d" % i)
pdf.output("output2.pdf", "F")
print("done")
```

### img2pdf

> 合成的PDF不够清晰
>
> 对png四通道, 需要转换为三通道

```python
import glob
import img2pdf

with open("06_img2pdf_jpg.pdf", "wb") as f:
    f.write(img2pdf.convert(glob.glob("jpg/*.jpg")))
```

### reportlab (推荐)

> 自定义图像大小, 生成速度快, 图像质量高

```python
import os
import PIL
from reportlab.pdfgen import canvas
from reportlab.lib.pagesizes import landscape


def genpdf(filename, pagesizes):
    pdf = canvas.Canvas(filename)
    pdf.setPageSize(pagesizes)
    return pdf


def save_img_to_pdf(pdf, image, x, y, w, h):
    pdf.drawImage(image, x, y, w, h)
    pdf.showPage()


if __name__ == '__main__':
    pdf_size = (1920, 1080)
    my_pdf = genpdf('00_reportlab推荐.pdf', pdf_size)
    folder = '20210812/neg/Q_QC_MFE02_1'
    filelist = os.listdir(folder)
    for filename in filelist:
        img = PIL.Image.open(folder + '/' + filename)
        img_w, img_h = img.size  # 1024 768

        img_x = (landscape(pdf_size)[0] - img_w) / 2  # 448
        img_y = (landscape(pdf_size)[1] - img_h) / 2  # 156

        save_img_to_pdf(my_pdf, folder + '/' + filename, x=img_x, y=img_y, w=img_w, h=img_h)
    my_pdf.save()

```

