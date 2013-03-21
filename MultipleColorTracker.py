#!/usr/bin/python

import sys
from math import sqrt
from threading import Thread
import cv
import cv2
import numpy as np

# Global Variables
VideoCapture = cv2.VideoCapture(1)
circles = (0,0,0)

COLOR_RANGE={
'yellow': ((10, 100, 100), (40, 255, 255)),\
'red': ((0, 0, 0), (190, 255, 255)),\
'blue': (( 70 , 31 , 11), ( 120 , 255 , 255)),\
'green': (( 40 , 80 , 32), (70 , 255 , 255)),\
'orange': (( 160 , 100 , 47), (179 , 255 , 255))\
}

DISPLAY_COLOR={
'yellow':cv.RGB(255,255,0)
,'red':cv.RGB(255,0,0)
,'blue':cv.RGB(0,0,255)
,'green':cv.RGB(0,110,0)
}


class Tracker(Thread):
	def __init__(self, color, flag):
		Thread.__init__(self)
		self.color=color
		self.display=DISPLAY_COLOR[color]
		self.path=np.zeros((480,640,3), dtype=np.uint8)
		self.lastx=0
		self.lasty=0
		self.h_min=COLOR_RANGE[color][0]
		self.h_max=COLOR_RANGE[color][1]
		self.flag=flag
		if self.flag:
			cv2.namedWindow(self.color,1)

	def poll(self, img):
		hsv_img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
		thresh = cv2.inRange(hsv_img, self.h_min, self.h_max)
		thresh = cv2.GaussianBlur(thresh, (9,9), 0)
		circles = cv2.HoughCircles((thresh), cv.CV_HOUGH_GRADIENT,dp=2,minDist=400,minRadius=10, maxRadius=200)

		print circles

		# Drawing Things
		if 1:
			maxRadius = 0
			x = 0
			y = 0
			found = False

			if circles is not None:
				for circle in circles[0]:
					if circle[2] > maxRadius:
						found = True
						radius = int(circle[2])
						maxRadius = int(radius)
						x = int(circle[0])
						y = int(circle[1])

			if found:
				cv2.circle(img, (x,y), 3, cv.RGB(0,255,0), -1, 8, 0)
				cv2.circle(img, (x,y), maxRadius, cv.RGB(255,0,0), 3, 8, 0)
				print self.color + " ball found at: (", x, ",", y, ")"

			if self.flag:
				cv2.imshow(self.color, thresh)

			cv2.imshow("result", img)
			if cv2.waitKey(1) >= 0:
				return

if __name__ == '__main__':
	print "Starting MultipleColorTracker:"

	cv2.namedWindow("Result", 0)
	if VideoCapture:
		frame_copy = None
	yellow = Tracker("yellow", 1)
	green = Tracker("green", 1)
	blue = Tracker("blue", 1)
	blue.start()
	green.start()

	while True:
		try:
			success, img = VideoCapture.read() 
			if success:
				print "Grabbed frame:"
				blue.poll(img)
				green.poll(img)
				blue.join()
				green.join()
			else:
				print "Failed to grab new frame."
			if cv2.waitKey(5) != -1:
				break
		except KeyboardInterrupt, SystemExit:
			break