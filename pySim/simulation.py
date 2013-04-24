"""
This is a proof of concept simulation code that will be used to test
the control algorithms for the ball on the beam. It runs in two
threads:

1) A thread to control the graphics
2) A thread to run the simulation

-The graphics thread queries the simulation thread for the ball and
beam positions every 0.03 seconds.

-The simulation thread runs a simulation 0.03 seconds ahead of the
last query and waits until the next query. The control code is
running inside the simulation thread.
"""
from BallBeamGraphics import *
import time
width = 500
height = 500
radius = 10
window = Window(width=width,height=height)
ball = Ball(position=(width/2,height/2),radius=10,window = window)
beam = Beam(center=(width/2,height/2+radius),length=400,window = window)



window.mainloop()