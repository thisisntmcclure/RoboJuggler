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
import BBGraphics, BBSimulation, BBController
import time
from datetime import datetime, timedelta
#graphics
width = 500
height = 500
radius = 10
window = BBGraphics.Window(width=width,height=height)
ball = BBGraphics.Ball(position=(width/2,height/2),radius=10,window = window)
beam = BBGraphics.Beam(center=(width/2,height/2+radius),length=400,window = window)
#simulation
ball = BBSimulation.Ball(mass=0.010, radius=0.026, I=4.5e-6)
beam = BBSimulation.Beam(length=0.15)
controller = BBController.Controller()
initState = BBSimulation.State(time = datetime.now(), rPos = (1,0), rVel = 0)
simulator = BBSimulation.Simulator(controller=controller, initState=initState)


window.mainloop()