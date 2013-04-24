from datetime import datetime

class Tracker():
	def __init__(self):
		self.lastX = 250
		self.lastY = 250
		self.lastTime = datetime.now()

	def pixelsToMeters(self,pixelCoords):
		#TODO: fix me so that this actually converts from pixels to coordinates in meters
		#TODO: maybe calibrate the camera automatically upon initialization
		return pixelCoords