#!/usr/bin/env python
import serial, time

#ser = serial.Serial('/dev/tty.usbserial-FTFB009M', 9600, timeout=1)
ser = serial.Serial('/dev/ttyUSB0', 9600, timeout=1)

while True:
  for val in [ "0", "a", "c", "g", "o" ]:
    ser.write(val)
    time.sleep(0.300)
