This directory contains the files need to download Xinlinx binary configuration files
from a Mac to an Alchitry Au FPGA development board.  Before using any of these these 
files, you should install this package:
https://www.ftdichip.com/old2020/Drivers/D2XX/MacOSX/D2xxHelper_v2.0.0.pkg

This will prevent the MacOS from automatically loading a driver for the Au board and
locking out the loader program.

Once you've done that, you need to install the drivers with
./install-drivers.sh
This will copy some files to /usr/local/lib and /usr/local/include.  It only needs to be 
done once.

After that, the commands are:
./list.sh   - list any Alchitry boards attached.  If you've attached a single board, it
              should return
              Devices: 
                0: Alchitry Au
                1: Unknown
              Found Au as device 0.
              
./load-bin.sh (config-file)   - do a volatile configuration of the Achitry board
./load-flash.sh (config-file) - load a config file to the PROM, so it will load
                                load at power up.
                                
You can test both of these with 'io-counter.bin', which is included in the directory.
This will make the segment displays on the Alchitry-Io board count.  The first three
DIP switches control the direction, speed, and DEC/HEX, respectively.  

Version History:

02-FEB-2021	EjP		Original release