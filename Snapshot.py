import cv2

imgFile = './test_image.png'
cameraPort = 0

camera = cv2.VideoCapture(cameraPort)
success, img = camera.read()

if success:
	cv2.imwrite(imgFile, img)
	print 'Saved to ' + imgFile
else:
	print 'Error with the camera'

del(camera)