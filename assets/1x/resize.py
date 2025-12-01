import sys
from PIL import Image
import os
import time

def upscale_pixel_art(input_image, output_directory, input_image_path):
    # Double the size
    new_size = (input_image.width * 2, input_image.height * 2)
    resized_image = input_image.resize(new_size, Image.NEAREST)  # NEAREST resampling preserves pixelation

    # Save the resized image
    filename = os.path.basename(input_image_path)
    output_image_path = os.path.join(output_directory, filename)
    resized_image.save(output_image_path)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("No path predefined, enter the paths instead")
        input_path = input("Input image: ")
        output_path = input("Output path: ")
    else:
        input_path = sys.argv[1]
        output_path = sys.argv[2]
    
    input_image = Image.open(input_path)
    upscale_pixel_art(input_image, output_path, input_path)
