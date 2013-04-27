from Tkinter import *
import math
import Image, ImageTk

#TODO: implement the Window.setBackground() method so that it can
#accept an openCV image and display it on the background

class Window:
    def __init__(self,width=500,height=500):
        self.width = width 
        self.height = height
        self.root = Tk()
        self.root.geometry("%sx%d" % (self.width,self.height))
        self.root.resizable(width=False, height=False)
        self.canvas = Canvas(self.root, width=self.width, height=self.height)
        self.canvas.pack()

    def setBackground(self):
        """
        This is not implemented yet, below is some example code that
        converts an openCV image into an image that can be displayed
        in Tkinter but it is untested
        """
        gray_im = cv2.cvtColor(f, cv2.COLOR_RGB2GRAY)
        a = Image.fromarray(gray_im)
        b = ImageTk.PhotoImage(image=a)
        self.canvas.create_image(position=(0,0),image=b)

    def update(self):
        self.canvas.update()

    def mainloop(self):
        self.root.mainloop()

class Beam(object):
    def __init__(self,window=None,length=400,angle=0,center=(250,260),tag='beam'):
        self.length = length
        self.angle = angle
        self.center = center
        self.canvas = window.canvas
        self.calcEndPoints()
        self.canvObj = self.canvas.create_line(*(self.left + self.right), fill='black', tags=(tag))

    def calcEndPoints(self):
        self.left = (self.center[0] - math.cos(self.angle)*self.length/2, self.center[1] + math.sin(self.angle)*self.length/2)
        self.right = (self.center[0] + math.cos(self.angle)*self.length/2, self.center[1] - math.sin(self.angle)*self.length/2)

    def setAngle(self, angle):
        self.angle = angle
        self.calcEndPoints()
        self.canvas.coords(self.canvObj,*(self.left+self.right))

class Ball(object):
    def __init__(self,window=None,radius=10,position=(250,250),tag='ball'):
        self.radius = radius
        self.position = position
        self.canvas = window.canvas
        self.canvObj = self.canvas.create_oval((position[0]-radius,position[1]-radius,position[0]+radius,position[1]+radius), fill='red', tags=(tag))

    def moveTo(self, position):
        self.position = position
        self.canvas.coords(self.canvObj,(self.position[0]-self.radius,self.position[1]-self.radius,self.position[0]+self.radius,self.position[1]+self.radius))        

if __name__ == "__main__":
    window = Window()
    beam = Beam(window=window)
    ball = Ball(window=window)
    window.mainloop()