#!/usr/bin/python
import sys
from math import sqrt
from threading import Thread
import cv
import cv2
import numpy as np
#from cv2.highgui import *
#import Xlib

# Global Variables
#storage = cvCreateMemStorage(0)
#from Xlib import X,display,Xutil
storage=cv.CreateMemStorage(0)
capture = cv.CreateCameraCapture( 0 )
#circles = (0,0,0)

COLOR_RANGE={
'yellow': (cv.Scalar(10, 100, 100, 0), cv.Scalar(40, 255, 255, 0)),\
'red': (cv.Scalar(0, 0, 0, 0), cv.Scalar(190, 255, 255, 0)),\
'blue': (cv.Scalar( 90 , 84 , 69 , 0 ), cv.Scalar( 120 , 255 , 255 , 0)),\
'green': (cv.Scalar( 40 , 80 , 32 , 0), cv.Scalar( 70 , 255 , 255 , 0)),\
'orange': (cv.Scalar( 160 , 100 , 47 , 0 ), cv.Scalar( 179 , 255 , 255 , 0 ))\

}

DISPLAY_COLOR={
'yellow':cv.RGB(255,255,0)
,'red':cv.RGB(255,0,0)
,'blue':cv.RGB(0,0,255)
,'green':cv.RGB(0,110,0)

}


class Tracker(Thread):
   def __init__(self,color,flag):
      Thread.__init__(self)
      self.color=color
      self.display=DISPLAY_COLOR[color]
      self.path=cv.CreateImage((640,480),8,3)
      self.lastx=0
      self.lasty=0
      self.h_min=COLOR_RANGE[color][0]
      self.h_max=COLOR_RANGE[color][1]
      self.flag=flag
      if self.flag:
         cv.NamedWindow(self.color,1) 
   
   def poll(self,img):
      if 1:
         thresh = cv.CreateImage((img.width,img.height), 8, 1 )
         new_img=cv.CreateImage((img.width,img.height),8 ,3 )
         cv.Copy(img,new_img)
         cv.CvtColor(img, new_img, cv.CV_BGR2HSV )
         cv.InRangeS(new_img,self.h_min,self.h_max,thresh)
         cv.Smooth(thresh,thresh,cv.CV_GAUSSIAN,9,9)
         circles = cv2.HoughCircles(np.asarray(thresh[:,:]),cv.CV_HOUGH_GRADIENT,2,100)
         maxRadius=0
         x=0
         y=0
         found=False
         for i in range(len(circles[0])):
            circle=circles[i]
            if circle[2]>maxRadius:
               found=True
               radius=int(circle[2])
               maxRadius=int(radius)
               x=int(circle[0])
               y=int(circle[1])
         if found:
            cv.Circle( img, cv.Point(x,y),3, cv.RGB(0,255,0), -1, 8, 0 )
            cv.Circle( img, cv.Point(x,y),maxRadius, cv.RGB(255,0,0), 3, 8, 0 )
            print self.color+ " Ball found at",x,y
            if self.lastx > 0 and self.lasty > 0:
               cv.Line(self.path,cv.Point(self.lastx,self.lasty),cv.Point(x,y),self.display,5)
            self.lastx=x
            self.lasty=y
         cv.Add(img,self.path,img)
         if self.flag:
            cv.ShowImage(self.color,thresh)

         cv.ShowImage("result",img)
         if( cv.WaitKey( 10 ) >= 0 ):
            return


if __name__ == '__main__':
   cv.NamedWindow( "result", 0 )
   if capture:
      frame_copy = None
   yellow=Tracker("yellow",1)
   green=Tracker("green",1)
   blue=Tracker("blue",1)
   yellow.start()
   green.start()
   blue.start()
   while True:
      img=cv.QueryFrame(capture)
      yellow.poll(img)
      green.poll(img)
      blue.poll(img)
      yellow.join()
      green.join()
      blue.join()
      if cv.WaitKey(10) >=0:
         sys.exit(1)
   cv.DestroyWindow("result")