import cv2
import numpy as np
import argparse
import os
import glob

def find_sun_position(image):
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    gray = cv2.medianBlur(gray, 5)
    circles = cv2.HoughCircles(gray, cv2.HOUGH_GRADIENT, 1, 20,
                               param1=50, param2=30, minRadius=0, maxRadius=0)
    if circles is not None:
        circles = np.uint16(np.around(circles))
        largest_circle = max(circles[0, :], key=lambda c: c[2])
        center = (largest_circle[0], largest_circle[1])
        radius = largest_circle[2]
        return center, radius
    else:
        return None, None

def crop_and_resize_image(image_path, output_path, output_size=(1024, 1024)):
    image = cv2.imread(image_path)
    if image is None:
        print(f"Failed to load image at {image_path}")
        return
    sun_center, sun_radius = find_sun_position(image)
    if sun_center is None or sun_radius is None:
        print("Sun could not be detected.")
        return

    # Adjust this multiplier to increase the area around the sun in the crop
    crop_margin_multiplier = 3.0  # Increase this value as needed

    crop_margin = sun_radius * crop_margin_multiplier
    start_x = max(sun_center[0] - crop_margin, 0)
    start_y = max(sun_center[1] - crop_margin, 0)
    end_x = min(sun_center[0] + crop_margin, image.shape[1])
    end_y = min(sun_center[1] + crop_margin, image.shape[0])

    cropped_image = image[int(start_y):int(end_y), int(start_x):int(end_x)]
    if cropped_image.size == 0:
        print("Cropped image is empty.")
        return

    resized_image = cv2.resize(cropped_image, output_size, interpolation=cv2.INTER_AREA)
    cv2.imwrite(output_path, resized_image)

def process_folder(input_folder, output_folder):
    # Create the output folder if it does not exist
    os.makedirs(output_folder, exist_ok=True)
    
    # Process all JPEG images in the input folder
    for image_path in glob.glob(os.path.join(input_folder, '*.jpg')):
        filename = os.path.basename(image_path)
        output_path = os.path.join(output_folder, filename)
        print(f"Processing {image_path}...")
        crop_and_resize_image(image_path, output_path)
        print(f"Saved to {output_path}")

def main():
    parser = argparse.ArgumentParser(description='Process all JPEG images in a folder to center the sun, optimized for eclipse images.')
    parser.add_argument('input_folder', type=str, help='Path to the input folder containing images')
    parser.add_argument('output_folder', type=str, help='Path to the output folder for saving processed images')
    args = parser.parse_args()

    process_folder(args.input_folder, args.output_folder)

if __name__ == '__main__':
    main()
