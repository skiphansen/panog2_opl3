# Yamaha OPL3 for the second generation Panologic thin client

This is a port of Saanlima Electronics's port of Greg Taylor's clone of the
OPL3 Yamaha YMF262 FM synthesis sound chip in System Verilog.  

If you don't know what a Panologic thin client is please see [here](https://hackaday.com/2013/01/11/ask-hackaday-we-might-have-some-fpgas-to-hack/) 
and [here](https://github.com/skiphansen/pano_hello_g1) for background.

Magnus of Saanlima Electronics translated Greg Taylor's System Verilog HDL to 
legacy Verilog because Xilinx's ISE doesn't support System Verilog. This is
important for designs based on the Spartan 3 or Spartan 6 FPGAs such as the 
Panologic devices.

I created an interface to the Pano's Wolfson codec.

I had initially given up on the Pano G1 after the first cut didn't fit 
because it ran out of multiplers. When I mentioned this to Tom Verbeure he 
spent a few minutes studying the HDL then made a few tweaks and eliminated a 
bunch of multipliers.  It now fits by a good margin (28% utilization including
a RISC-V core, VGA and other glue logic).

The eventual plan is to use this core on other projects to do more interesting
things.

## Status
The project builds and the all of the test files from the orginal project play.
This is a work in progress.  The rev C (xc6slx100 part) is not supported
currently, but support will be added shortly.

## HW Requirements

* A Pano Logic G2 (the one with a DVI port)
* A suitable 5 volt power supply
* A JTAG programmer to load the bitstream into the FPGA.
* A serial port compatible with 5 volt logic levels.

Please see fpga_test_soc for the [pano](https://github.com/skiphansen/fpga_test_soc/blob/master/fpga/panologic_g2/README.md) for 
more information on the needed cable.

## Software Requirements

* xc3sprog
* GNU make

If you would like to play with the firmware you'll also need:

* gcc built for RISC-V RV32IM

If you would like to play with the RTL you'll also need:
* Xilinx [ISE 14.7](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive-ise.html)

The free Webpack version of Xilinx [ISE 14.7](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive-ise.html) is used for development.
Download the latest Windows 10 version which supports the Spartan 6 family of 
chips used in the second generation Panologic device.

### Building bitfile from sources

**NB:** While it may be possible to use Windows for development I haven't 
tried it and don't recommend it.

1. Clone the https://github.com/skiphansen/panog2_opl3 repository
2. cd into .../panog2_opl3/fpga
3. If you have a **REV B** Pano with the larger FPGA then just run "make".

### Building the firmware 

To build the firmware, make sure the RISC-V GCC (built for RV32IM) is in the 
PATH, then:

1. cd into .../panog2_opl3/fw/imfplay
2. run make.


## Acknowledgement and Thanks
This project uses code from several other projects including:
 - [https://github.com/gtaylormb/opl3_fpga]
 - [https://github.com/Saanlima/Pipistrello]
 - [https://github.com/pellepl/spiffs.git]
 - [https://github.com/ultraembedded/fpga_test_soc.git]

## LEGAL 

My original work (the Pano Codec glue code) is released under the GNU General 
Public License, version 2.

