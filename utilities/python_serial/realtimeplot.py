import time
import numpy as np
import matplotlib.pyplot as plt
import serial
fig=plt.figure()
plt.axis([0,1000,0,1024])
ser=serial.Serial("/dev/ttyACM0")
i=0
x=list()
y=list()

plt.ion()
plt.show()

while i <1000:
    temp_y=ser.readline()
    x.append(i)
    y.append(temp_y)
    plt.scatter(i,temp_y)
    i+=1
    plt.draw()
    time.sleep(0.05)
