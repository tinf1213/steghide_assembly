from PIL import Image
import struct

# 開啟 JPG 圖片
jpg_image = Image.open('input.jpg')

# 調整圖片大小為 600x400
resized_image = jpg_image.resize((600, 400))

# 轉換為 RGB 模式
resized_image_rgb = resized_image.convert('RGB')

# 取得調整後圖片的寬度和高度
width, height = resized_image.size

# 創建一個新的 BMP 文件（假設為 24 位 BMP 沒有壓縮）
bmp_data = bytearray()

# BMP 標頭（14 個字節）
bmp_data.extend(struct.pack('<ccIHHI', b'B', b'M', 14 + 40 + width * height * 4, 0, 0, 14 + 40))

# DIB 標頭（40 個字節 - BITMAPINFOHEADER）
bmp_data.extend(struct.pack('<IIIHHIIIIII', 40, width, height, 1, 32, 0, width * height * 4, 0, 0, 0, 0))

# 遍歷每個像素並轉換為 BMP 格式
for y in range(height - 1, -1, -1):  # 由底部向上遍歷
    for x in range(width):
        r, g, b = resized_image_rgb.getpixel((x, y))

        # 將每個通道轉換為小端十六進制並添加 'FF' 代表每個通道
        pixel_data = struct.pack('<BBBB', b, g, r, 0xFF)

        # 將像素數據添加到 BMP 文件
        bmp_data.extend(pixel_data)

# 保存 BMP 文件
with open('output.bmp', 'wb') as bmp_file:
    bmp_file.write(bmp_data)