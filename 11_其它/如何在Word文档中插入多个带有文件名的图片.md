## 如何在Word文档中插入多个带有文件名的图片？

> 在Word文档中，可以使用“插入”功能一次快速插入多张图片。 
>
> 但是，有时在插入图片时需要插入文件路径和名称作为标题。 

**使用VBA代码插入多个带文件名的图片**

安装``wps``的VBA宏

以下VBA代码可以帮助您在插入图像时插入文件路径和名称作为标题，请按以下步骤操作：

1. 按住  **ALT + F11** 键打开 **Microsoft Visual Basic应用程序** 窗口。
2. 然后，单击 **插页** > **模块**，将以下代码复制并粘贴到打开的空白模块中：VBA代码：使用文件名插入多张图片

```vb
Sub PicWithCaption()


Dim xFileDialog As FileDialog
Dim xPath, xFile As Variant
On Error Resume Next
Set xFileDialog = Application.FileDialog(msoFileDialogFolderPicker)
If xFileDialog.Show = -1 Then
xPath = xFileDialog.SelectedItems.Item(1)
If xPath <> "" Then
            xFile = Dir(xPath & "\*.*")
Do While xFile <> ""
If UCase(Right(xFile, 3)) = "PNG" Or _
UCase(Right(xFile, 3)) = "TIF" Or _
UCase(Right(xFile, 3)) = "JPG" Or _
UCase(Right(xFile, 3)) = "GIF" Or _
UCase(Right(xFile, 3)) = "BMP" Then
With Selection
                        .InlineShapes.AddPicture xPath & "\" & xFile, False, True
.InsertAfter vbCrLf
.MoveDown wdLine
.Text = xPath & "\" & xFile & Chr(10)
.MoveDown wdLine
End With
End If
xFile = Dir()
Loop
End If
End If
End Sub
```

3. 然后按 **F5** 键以运行此代码，将显示“浏览”窗口，请选择包含要插入图像的文件夹
4. 然后点击 **OK** 按钮，所选文件夹中的所有图像都已插入到Word文档中，并且文件路径和名称也已作为标题插入

选择开发工具 > VB宏 > 编辑 > 模块 > F5 执行 > 选择文件夹

![Image](C:\Users\cuite\Documents\GitHub\NoteBook_Markdown\images\Image.png)

![Image](C:\Users\cuite\Documents\GitHub\NoteBook_Markdown\images\Image-16451531470941.png)

