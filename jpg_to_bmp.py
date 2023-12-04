from PIL import Image
import struct

# Open the JPG image
jpg_image = Image.open('input.jpg')

# Convert the JPG image to RGB mode
jpg_image_rgb = jpg_image.convert('RGB')

# Get the width and height of the image
width, height = jpg_image.size

# Create a new BMP file in memory (assuming 24-bit BMP without compression)
bmp_data = bytearray()

# BMP header (14 bytes)
bmp_data.extend(struct.pack('<ccIHHI', b'B', b'M', 14 + 40 + width * height * 4, 0, 0, 14 + 40))

# DIB Header (40 bytes - BITMAPINFOHEADER)
bmp_data.extend(struct.pack('<IIIHHIIIIII', 40, width, height, 1, 32, 0, width * height * 4, 0, 0, 0, 0))

# Iterate through each pixel and convert to BMP format
for y in range(height - 1, -1, -1):  # Start from bottom row to top
    for x in range(width):
        r, g, b = jpg_image_rgb.getpixel((x, y))

        # Convert each channel to little-endian hexadecimal and add 'FF' to represent each channel
        pixel_data = struct.pack('<BBBB', b, g, r, 0xFF)

        # Append pixel data to the BMP file
        bmp_data.extend(pixel_data)

# Save the BMP file
with open('output.bmp', 'wb') as bmp_file:
    bmp_file.write(bmp_data)
