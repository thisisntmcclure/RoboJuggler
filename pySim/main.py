"""
This is the main function that will eventually balance the ball on
the beam. At the moment I predict that it will need three threads:

1) A thread to handle the graphics
2) A thread to track the ball
3) A thread to control the ramp

-The graphics thread will query the tracking thread for an image of
the setup and it will query the control thread for an estimation of
the current state of the system (position of the ball and beam)

-The tracking thread will use streaming video to locate the ball as
well as the beam, and estimate velocity.

-The control thread will query the tracking thread for the last
measured state (positions, velocities, timestamp), and estimate
the current state in simulation. It will use this information to
control the beam.

**I could imagine splitting the control thread into two separate
threads, one to estimate state and one to control the beam.
"""

from BallBeamGraphics import *
from BallTracking import *
import time
width = 500
height = 500
radius = 10
window = Window(width=width,height=height)
ball = Ball(position=(width/2,height/2),radius=10,window = window)
beam = Beam(center=(width/2,height/2+radius),length=400,window = window)

tracker = Tracker()

window.mainloop()