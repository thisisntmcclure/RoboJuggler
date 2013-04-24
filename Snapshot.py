import cv2

imgFile = './test_image.png'
cameraPort = 1
windowName = 'Preview'

cv2.namedWindow(windowName)

camera = cv2.VideoCapture(cameraPort)
while cv2.waitKey(5) == -1:
	success, img = camera.read()
	if success:
		cv2.imshow(windowName,img)

cv2.imwrite(imgFile, img)
print 'Saved to ' + imgFile

del(camera)