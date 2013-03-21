#! /usr/bin/env python 
 
import cv 
import cv2
import math
import numpy as np
 
gray_window          = "Grayscale Output"
color_tracker_window = "Color Tracker"
filtered_window      = "HSV Output" 

class ColorTracker: 
    
    def __init__(self): 

        # Open Windows
        cv2.namedWindow(color_tracker_window, 1)
        cv2.namedWindow(filtered_window, 1)
        cv2.namedWindow(gray_window, 1)

        # Open webcam stream
        self.VideoCapture = cv2.VideoCapture(0) 
        if self.VideoCapture.open(0):
            print "Opened camera"
        else:
            print "Failed open"
        
    def run(self): 
        while True: 

            # Grab an image from the webcam
            success, img = self.VideoCapture.read() 
            if success:
                print "Grabbed frame:"
            else:
                print "Failed to grab new frame." 


            #convert the image to hsv(Hue, Saturation, Value) so its  
            #easier to determine the color to track(hue) 
            hsv_img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV) 
            
            # Convert HSV image to grayscale (BGR2GRAY collapses three
            #  channels into one, so that still works here)
            hsv_to_gray = cv2.cvtColor(hsv_img, cv2.COLOR_BGR2GRAY)

            # Blur the image to reduce some noise
            gray_image = cv2.GaussianBlur(hsv_to_gray, (7,7),0)                 
            retval, gray_image_thresh = cv2.threshold(gray_image, 150, 255, 0)


            
            circles = cv2.HoughCircles(gray_image, cv.CV_HOUGH_GRADIENT, param1=100, param2=50, dp=1, minDist=200, minRadius=30, maxRadius=110)

            print circles
             
            if circles is not None: 
                for circle in circles[0]:
                    cv2.circle(img,(circle[0], circle[1]), circle[2], color=(0,0,255)) 

            #display the image  
            cv2.imshow(color_tracker_window, img)
            cv2.imshow(gray_window, hsv_to_gray)
            cv2.imshow(filtered_window, gray_image_thresh)

            if cv2.waitKey(5) != -1: 
                break 
                
if __name__=="__main__": 
    color_tracker = ColorTracker() 
    color_tracker.run()