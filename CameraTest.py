#! /usr/bin/env python 
 
import cv 
import math
 
color_tracker_window = "Color Tracker" 
threshold_window = "Threshold View"

class ColorTracker: 
    
    def __init__(self): 
        cv.NamedWindow( color_tracker_window, 1 )
        cv.NamedWindow( threshold_window, 1 ) 
        self.capture = cv.CaptureFromCAM(0) 
        
    def run(self): 
        while True: 
            img = cv.QueryFrame( self.capture ) 
                        
            #blur the source image to reduce color noise 
            cv.Smooth(img, img, cv.CV_BLUR, 3); 
            
            #convert the image to hsv(Hue, Saturation, Value) so its  
            #easier to determine the color to track(hue) 
            hsv_img = cv.CreateImage(cv.GetSize(img), 8, 3) 
            cv.CvtColor(img, hsv_img, cv.CV_BGR2HSV) 
            
            #limit all pixels that don't match our criteria, in this case we are  
            #looking for purple but if you want you can adjust the first value in  
            #both turples which is the hue range(120,140).  OpenCV uses 0-180 as  
            #a hue range for the HSV color model 
            thresholded_img =  cv.CreateImage(cv.GetSize(hsv_img), 8, 1) 
            cv.InRangeS(hsv_img, (100, 80, 80), (120, 255, 255), thresholded_img) 
            
            #determine the objects moments and check that the area is large  
            #enough to be our object 
            thresholded_img_mat = cv.GetMat(thresholded_img)
            moments = cv.Moments(thresholded_img_mat, 0) 
            area = cv.GetCentralMoment(moments, 0, 0) 
            
            #there can be noise in the video so ignore objects with small areas 
            if(area > 2000): 
                #determine the x and y coordinates of the center of the object 
                #we are tracking by dividing the 1, 0 and 0, 1 moments by the area 
                x = int(cv.GetSpatialMoment(moments, 1, 0)/area) 
                y = int(cv.GetSpatialMoment(moments, 0, 1)/area) 
            
                print 'x: ' + str(x) + ' y: ' + str(y) + ' area: ' + str(area) 
                
                #create an overlay to mark the center of the tracked object 
                #overlay = cv.CreateImage(cv.GetSize(img), 8, 3) 
                
                cv.Circle(img, (x, y), 1, (0, 255, 0), 20) 
                cv.Circle(thresholded_img, (x, y), 1, (255, 255, 255), 20) 
                #cv.Add(img, overlay, img) 
                #add the thresholded image back to the img so we can see what was  
                #left after it was applied 
                #cv.Merge(thresholded_img_mat, None, None, None, img) 
             
            #display the image  
            cv.ShowImage(color_tracker_window, img)
            cv.ShowImage(threshold_window, thresholded_img) 
            
            if cv.WaitKey(10) == 27: 
                break 
                
if __name__=="__main__": 
    color_tracker = ColorTracker() 
    color_tracker.run()