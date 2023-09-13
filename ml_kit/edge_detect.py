from collections import Counter
import cv2
import pytesseract
import numpy as np

roi_x, roi_y, roi_w, roi_h = -1, -1, -1, -1
drawing = False
image = ''
image_copy = ''

def get_coordinates_vertical(valArray1, valArray2, minVal, maxVal, width, height) -> list:
    line_coordinates = []
    
    # Generate coordinates for the left side
    d = {}        
    for value, count in valArray1:
        y_values_for_x = [y for y, _ in valArray2 if minVal <= y <= maxVal]
        for y in y_values_for_x:
            if y in d:
                continue
            line_coordinates.append((value, y))
            d[y] = 1
            count -= 1
            if count == 0:
                line_coordinates.append((value, y + height))
                break
    
    # Generate coordinates for the right side
    d = {}        
    for value, count in valArray1[::-1]:
        y_values_for_x = [y for y, _ in valArray2 if minVal <= y <= maxVal]
        for y in y_values_for_x:
            if y in d:
                continue
            line_coordinates.append((value + width, y))
            d[y] = 1
            count -= 1
            if count == 0:
                line_coordinates.append((value + width, y + height))
                break
    return line_coordinates

def get_coordinates_horizontal(valArray1, valArray2, minVal, maxVal, width, height) -> list:
    line_coordinates = []
    
    # Generate coordinates for the top side
    d = {}
    for value, count in valArray1:            
        x_values_for_y = [x for x, _ in valArray2 if minVal <= x <= maxVal]
        for x in x_values_for_y:
            if x in d: continue
            line_coordinates.append((x, value))
            d[x] = 1
            count -= 1
            if count == 0:
                line_coordinates.append((x + width, value))
                break
    
    d = {}
    for value, count in valArray1[::-1]:
        x_values_for_y = [x for x, _ in valArray2 if minVal <= x <= maxVal]
        for x in x_values_for_y:
            if x in d:
                continue
            line_coordinates.append((x, value + height))
            d[x] = 1
            count -= 1
            if count == 0:
                line_coordinates.append((x + width, value + height))
                break
    return line_coordinates

def draw_lines_on_image(values, image):
    color, thickness = (0, 0, 0), 3
    
    for point1, point2 in zip(values[:-1], values[1:]):
        cv2.line(image, point1, point2, color, thickness)

def perform_roi_selection(event, x, y, flags, param) -> None:
    global roi_x, roi_y, roi_w, roi_h, drawing, image, image_copy
    
    if event == cv2.EVENT_LBUTTONDOWN:
        drawing = True
        roi_x, roi_y = x, y
    elif event == cv2.EVENT_MOUSEMOVE:
        # Refresh the copy to clear previous rectangles that were drawn
        if drawing:
            image_copy = image.copy()
            cv2.rectangle(image_copy, (roi_x, roi_y), (x, y), (0, 0, 255), 2)
    elif event == cv2.EVENT_LBUTTONUP:
        if drawing:
            drawing = False
            roi_w, roi_h = x - roi_x, y - roi_y

def get_image_region_of_interest(image) -> None:
    global image_copy
    image = image.copy()
    
    cv2.namedWindow('Image with ROI')
    cv2.setMouseCallback('Image with ROI', perform_roi_selection)
    
    while True:
        image_copy = image.copy()
        
        # Draw the current ROI rectangle
        if roi_w > 0 and roi_h > 0:
            cv2.rectangle(image_copy, (roi_x, roi_y), (roi_x + roi_w, roi_y + roi_h), (0, 0, 255), 2)

        cv2.imshow('Image with ROI', image_copy)

        # Check for the "Esc" key press to exit ROI selection. i.e key 27
        key = cv2.waitKey(1) & 0xFF
        if key == 27:
            break
    
def identify_square_pattern(image):
    # Convert the image to grayscale
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

    # Preprocess the image (e.g., thresholding)
    _, thresh = cv2.threshold(gray, 128, 255, cv2.THRESH_BINARY)

    # Find contours in the preprocessed image
    contours, _ = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    pattern_image = image.copy()
    corners = []
    for contour in contours:
        # Approximate the contour to a polygon
        epsilon = 0.02 * cv2.arcLength(contour, True)
        approx = cv2.approxPolyDP(contour, epsilon, True)

        # Check if the polygon has 4 vertices (a square)
        if len(approx) == 4:
            x, y, w, h = cv2.boundingRect(contour)
            aspect_ratio = float(w) / h

            # Check if the aspect ratio is close to 1 (square)
            if 0.8 <= aspect_ratio <= 1.1:
                corners.append((x, y, w, h))
                # Store the corner points
                cv2.drawContours(pattern_image, [contour], -1, (0, 0, 255), 2)
                text = f"{x},\n{y}\n,{w}\n,{h}"
                # cv2.putText(pattern_image, text, (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.3, (0, 0, 255), 1)

    contour_coordinates = sorted(corners, key=lambda v: (v[0], v[1], v[2], v[3]))

    # Extract individual values for x, and y
    x_values = [x for x, _, _, _ in contour_coordinates]
    y_values = [y for _, y, _, _ in contour_coordinates]        

    # Step 3: Count occurrences of each unique value for x, and y
    x_counter = Counter(x_values)
    y_counter = Counter(y_values)

    extreme_x_values = [value for value, count in x_counter.items() if count >= 2]
    extreme_y_values = [value for value, count in y_counter.items() if count >= 2]

    # Calculate the minimum and maximum values of the extreme X and Y values
    min_x, max_x = min(extreme_x_values), max(extreme_x_values)
    min_y, max_y = min(extreme_y_values), max(extreme_y_values)

    # Step 4: Filter out extreme points based on the threshold
    threshold = 2

    extreme_x_values = [(value, count) for value, count in x_counter.items() if count >= threshold]
    extreme_y_values = [(value, count) for value, count in y_counter.items() if count >= threshold]

    # Print the extreme points for each criterion
    print("Extreme X values:", extreme_x_values)
    print("Extreme Y values:", extreme_y_values)        

    width, height =  abs(extreme_x_values[1][0] - extreme_x_values[2][0]), abs(extreme_y_values[1][0] - extreme_y_values[2][0])

    # Generate coordinates for the right and left side
    line_coordinates = get_coordinates_vertical(extreme_x_values, extreme_y_values, min_y, max_y, width, height)

    left_side_points = [
        point for point in line_coordinates if point[0] in [min_x, min_x + width]
    ]
    right_side_points = [
        point for point in line_coordinates if point[0] in [max_x, max_x + width]
    ]    

    # Generate coordinates for the top and bottom side
    line_coordinates = get_coordinates_horizontal(extreme_y_values, extreme_x_values, min_x, max_x, width, height)

    top_side_points = [
        point for point in line_coordinates if point[1] in [min_y, min_y + height]
    ]
    bottom_side_points = [
        point for point in line_coordinates if point[1] in [max_y, max_y + height]
    ]
    
    #Draw lines on each sides
    draw_lines_on_image(left_side_points, pattern_image)
    draw_lines_on_image(right_side_points, pattern_image)
    draw_lines_on_image(top_side_points, pattern_image)
    draw_lines_on_image(bottom_side_points, pattern_image)
    
    print(left_side_points)
    print(right_side_points)
    print(top_side_points)
    print(bottom_side_points)
    
    # Create a blank mask
    mask = np.zeros_like(pattern_image, dtype=np.uint8)

    # Draw lines on the mask for each side
    for points in [left_side_points, right_side_points, top_side_points, bottom_side_points]:
        for i in range(len(points) - 1):
            cv2.line(mask, points[i], points[i + 1], (255, 255, 255), 1)

    # Find contours in the mask
    contours, _ = cv2.findContours(cv2.cvtColor(mask, cv2.COLOR_BGR2GRAY), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    
    if contours:
        # largest contour (assuming it's the polygon we want to crop)
        largest_contour = max(contours, key=cv2.contourArea)

        # Create a mask for the largest contour
        mask = np.zeros_like(pattern_image, dtype=np.uint8)
        cv2.drawContours(mask, [largest_contour], 0, (255, 255, 255), thickness=cv2.FILLED)

        # Apply the mask to crop the original image
        pattern_image = cv2.bitwise_and(pattern_image, mask)
                        
    return pattern_image
    
def get_data_from_image(image_path) -> None:
    global image, image_copy
    
    # Load Image
    image = cv2.imread(image_path)
    
    # Resize the original image to a manageable size for display
    resize_factor = 0.2  # Adjust this factor as needed
    resized_image = cv2.resize(image, None, fx=resize_factor, fy=resize_factor)
    
    # Get Region of Interest
    get_image_region_of_interest(resized_image)
    
    scale_x = image.shape[1] / resized_image.shape[1]
    scale_y = image.shape[0] / resized_image.shape[0]
    
    original_region_start = (int(roi_x * scale_x), int(roi_y * scale_y))
    original_region_end = (int(roi_w * scale_x), int(roi_h * scale_y))
    
    # Crop the selected region from the original image
    image_copy = image[original_region_start[1]:original_region_start[1] + original_region_end[1], original_region_start[0]:original_region_start[0] + original_region_end[0]]
    
    # Apply the pattern identification function
    # resize_factor = 0.3  # Adjust this factor as needed
    # resized_p_image = cv2.resize(image_copy, None, fx=resize_factor, fy=resize_factor)
    pattern_identified_image = identify_square_pattern(image_copy)
    
    # OCR Step
    
    cv2.imshow('Image with OCR Text', pattern_identified_image)
    cv2.imwrite('cOIP.jpg', pattern_identified_image)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

if __name__ == "__main__":
    image_path = "ml_kit/OIP.jpg"
    get_data_from_image(image_path)
