# wiring
## locations
My intention is for the pixhawk, airspeed sensor, power module, and arduino to be mounted near / in the bed of the truck. The load cell amplifiers have enough wire slack to be 
mounted about 6-7 feet above the truck bed, and the load cell itself should reach the full 13 feet above the truck bed.

## load cell to pre-amp
The load cell has 3 black wires coming off of it which are about 6 feet long. Each wire is labeled X, Y, or Z where it terminates, and they should each have a 6 pin green connector attached to them.
Insert the green connector into the 6-pin side of the appropriate pre-amp (they are keyed and should only go in one way).

## pre-amp to pixhawk
At the end of the bundle of long wires attached to the pixhawk, you should find 3 similar green connectors which each have 9 pins. These should also be labeled X, Y, and Z and should go into the other
side of the matching pre-amp.

## other pixhawk connections
The airspeed sensor should be plugged into the `I2C` port of the pixhawk. The arduino goes into `TELEM2`, the telemetry antenna goes into `TELEM3`, and the power module plugs into `POWER2`.

## power module
The input side of the power module should be connected to a 4S lipo. The output side should connect to the side of the bundle of wires which is closest to the pixhawk (there should be no need to ever disconnect this).

# setup and calibration
## connecting to the pixhawk from a laptop
Turn on the logging system by plugging in the 4S lipo once everything else is wired. Connect the other telemetry module to a computer with mission planner installed (there should be a usb cable already attached).
In mission planner, select the correct COM port, make sure the baud rate is set to 57600, and click connect. Hopefully it connects... Under the data screen, click on the Messages tab. You should see a message every half second
with the current load cell readings. If you don't, disconnect the lipo and recheck all the connections. If that doesn't work call me. 

Later, to actually start logging values, go to the actions tab on the same screen and click `Arm / Disarm`; click the button again to stop logging.

## load cell calibration
To calibrate the load cells, we'll use a combination of the offset screws on the pre-amps and the live readings from mission planner. 

With the system powered on and mission planner connected, set the load cell in its final but unloaded state. Then, turn the offset screws on each pre-amp until the mission planner values read 0 for each axis. 
If you reach a point where the value stops changing even when you keep turning the potentiometer, contact me.



