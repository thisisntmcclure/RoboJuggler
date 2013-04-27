from datetime import datetime

class Tracker():
	"""
	This object has the following responsibilities:
	1)Accept images from an image source
	2)Associate the image with a timestamp
	3)Pass the image back to the graphics object
	4)Locate the ball and the beam with openCV image processing
	5)notify the simulator of the ball position, ball velocity, and
	beam position
	"""
	def __init__(self, graphics, simulator):
		self.lastX = 250
		self.lastY = 250
		self.simulator = simulator
		self.lastTime = datetime.now()

	def pixelsToMeters(self,pixelCoords):
		#TODO: fix me so that this actually converts from pixels to coordinates in meters
		#TODO: maybe calibrate the camera automatically upon initialization
		return pixelCoords