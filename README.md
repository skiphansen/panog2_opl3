# Yamaha OPL3 for the second generation Panologic thin client

This is a port of Saanlima Electronics's port of Greg Taylor's clone of the
OPL3 Yamaha YMF262 FM synthesis sound chip in System Verilog.  

If you don't know what a Panologic thin client is please see [here](https://hackaday.com/2013/01/11/ask-hackaday-we-might-have-some-fpgas-to-hack/) 
and [here](https://github.com/skiphansen/pano_hello_g1) for background.

Magnus of Saanlima Electronics translated Greg Taylor's System Verilog HDL to 
legacy Verilog because Xilinx's ISE doesn't support System Verilog. This is
important for designs based on the Spartan 3 or Spartan 6 FPGAs such as the 
Panologic devices.

Tom Verbeure made a few tweaks and eliminated a bunch of multipliers to get
it to fit on the first generation device which is based on a Spartan 3 FPGA.

The SOC infrastructure for this project is based on Ultraembedded's 
[fpga_test_soc](https://github.com/ultraembedded/fpga_test_soc.git) project.

The interface to the Pano's Wolfson codec is my orignal work.

The eventual plan is to use this core on other projects to do more interesting
things.

## Status
The project builds and the all of the test files from the orignal project play.

## HW Requirements

* A Pano Logic G2 (the one with a DVI port)
* A suitable 5 volt power supply
* A JTAG programmer to load the bitstream into the FPGA.

Note: See this [project](https://github.com/skiphansen/panog1_opl3) for the first generation Pano.

## Software Requirements

To program the SPI flash in the Pano to run this project all you need is 
xc3sprog and GNU make.  You DO NOT need Xilinx's ISE.

If you would like to modify the firmware you'll also need gcc built for 
RISC-V RV32IM.

If you would like to modify the RTL you'll also need Xilinx ISE 14.

The free Webpack version of Xilinx [ISE 14.7](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive-ise.html) is used for development.
Download the latest Windows 10 version which supports the Spartan 6 family of 
chips used in the second generation Panologic device.

## Programming the Pano

Install xc3sprog for your system.  If a binary install isn't available for your
system the original project can be found here: https://sourceforge.net/projects/xc3sprog/.
Sources can be checked out using subversion from https://svn.code.sf.net/p/xc3sprog/code/trunk.

As an alternate if you don't have subversion a fork of the original project
can be found here: https://github.com/Ole2mail/xc3sprog.git .

If your JTAG cable is not a Digilent JTAG-HS2 then you will need to set the
"CABLE" environment variable to your cable type before loading the bit file.

Refer to the supported hardware [web page](http://xc3sprog.sourceforge.net/hardware.php) page or run  xc3sprog -c 
to find the correct cable option for your device.

**IMPORTANT: There are 2 versions of the Pano Logic G2: some use a Spartan 6 
LX150 while others use an LX100. You should be able to distinguish between the 
two by the revision code: LX150 is rev B and LX100 is rev C.  

The bit file and the embedded firmware must be generated for the correct device, 
the binary images are NOT compatible.  The build system uses the PLATFORM 
environment variable to determine the target device.  If the PLATFORM environment 
variable is not set a revision A or B device is assumed.

Set the PLATFORM environment variable to "pano-g2-c" if your device is a 
revision C before running make or specify it on the make command line.

Once xc3sprog has been in installed the bit file and SPI filesystem can be
programmed into the Pano's SPI flash by running "make prog_all".

```
skip@dell-790:~/pano/working/panog2_opl3$ make PLATFORM=pano-g2-c prog_all
make -C fpga prog_fs
make[1]: Entering directory '/home/skip/pano/working/panog2_opl3/fpga'
xc3sprog -c jtaghs2 -v -e -I../pano/cores/xc3sprog/xc6slx100.bit    ../prebuilt/dro_test_spiffs-g2-c.img:w:5111808:bin
XC3SPROG (c) 2004-2011 xc3sprog project $Rev: 774 $ OS: Linux
Free software: If you contribute nothing, expect nothing!
Feedback on success/failure/enhancement requests:
        http://sourceforge.net/mail/?group_id=170565
Check Sourceforge for updates:
        http://sourceforge.net/projects/xc3sprog/develop

Using built-in device list
Using built-in cable list
Cable jtaghs2 type ftdi VID 0x0403 PID 0x6014 Desc "Digilent USB Device" dbus data e8 enable eb cbus data 00 data 60
Using Libftdi, Using JTAG frequency   6.000 MHz from undivided clock
JTAG chainpos: 0 Device IDCODE = 0x04011093     Desc: XC6SLX100
Created from NCD file: top.ncd;UserID=0xFFFFFFFF
Target device: 6slx100fgg484
Created: 2019/11/09 17:34:26
Bitstream length: 8453744 bits
DNA is 0x7950066df552d4ff
done. Programming time 1450.4 ms
JEDEC: 20 20 0x17 0x10
Found Numonyx M25P Device, Device ID 0x2017
256 bytes/page, 32768 pages = 8388608 bytes total
Bulk erase ............................................................... took 73.000 s
Created from NCD file:
Target device:
Created:
Bitstream length: 26214400 bits
Erasing sector 64/65....Writing data page  12799/ 12800 at flash page  32767..
Maximum erase time 754.9 ms, Max PP time 75486 us
Verifying page  12800/ 12800 at flash page  32768
Verify: Success!
USB transactions: Write 118064 read 117545 retries 128161
make[1]: Leaving directory '/home/skip/pano/working/panog2_opl3/fpga'
make -C fpga prog_fpga
make[1]: Entering directory '/home/skip/pano/working/panog2_opl3/fpga'
xc3sprog -c jtaghs2 -v -I../pano/cores/xc3sprog/xc6slx100.bit    ../prebuilt/pano-g2-c.bit
XC3SPROG (c) 2004-2011 xc3sprog project $Rev: 774 $ OS: Linux
Free software: If you contribute nothing, expect nothing!
Feedback on success/failure/enhancement requests:
        http://sourceforge.net/mail/?group_id=170565
Check Sourceforge for updates:
        http://sourceforge.net/projects/xc3sprog/develop

Using built-in device list
Using built-in cable list
Cable jtaghs2 type ftdi VID 0x0403 PID 0x6014 Desc "Digilent USB Device" dbus data e8 enable eb cbus data 00 data 60
Using Libftdi, Using JTAG frequency   6.000 MHz from undivided clock
JTAG chainpos: 0 Device IDCODE = 0x04011093     Desc: XC6SLX100
Created from NCD file: top.ncd;UserID=0xFFFFFFFF
Target device: 6slx100fgg484
Created: 2019/11/09 17:34:26
Bitstream length: 8453744 bits
DNA is 0x7950066df552d4ff
done. Programming time 1450.2 ms
JEDEC: 20 20 0x17 0x10
Found Numonyx M25P Device, Device ID 0x2017
256 bytes/page, 32768 pages = 8388608 bytes total
Created from NCD file: fpga_routed.ncd;UserID=0xFFFFFFFF
Target device: 6slx100fgg484
Created: 2019/12/23 19:12:23
Bitstream length: 19160768 bits
Erasing sector 19/19....Writing data page   9355/  9356 at flash page   9355..
Maximum erase time 749.2 ms, Max PP time 74924 us
Verifying page   9356/  9356 at flash page   9356
Verify: Success!
USB transactions: Write 40743 read 40224 retries 40804
make[1]: Leaving directory '/home/skip/pano/working/panog2_opl3/fpga'
skip@dell-790:~/pano/working/panog2_opl3$
```

## Usage

Once the flash has been update simply power cycle the Pano.  "Music" should
start playing from the build in speaker.  Headphones or an amplified speaker
can be connected to the headphone jack for better sounds.  

The embedded file system contains 23 DRO files captured from various legacy
games that supported the OPL2 and OPL3 chips such as Doom, Doom2, Descent,
Indiana Jones and the Fate of Atlantis, Ace of Aces, etc.  It takes quite a
while to play them all.

To say the least some of the tracks become annoying rather rapidly (by design 
no doubt), but you can skip to the next track by pressing the Pano button.

Playback information is sent to the serial port during playback.


## Serial port 

Ultraembedded's SOC platform includes the ability to load firmware over a 
serial port which is VERY HANDY for code development.  I strongly suggest
building a serial cable to allow the capability to be used.  
Please see the [fpga_test_soc](https://github.com/skiphansen/fpga_test_soc/tree/master/fpga/panologic_g2#serial-port) for more information.

### Building everything from sources

**NB:** While it may be possible to use Windows for development I haven't 
tried it and don't recommend it.

1. Clone the https://github.com/skiphansen/panog2_opl3 repository
2. cd into .../panog2_opl3
3. Make sure the RISC-V GCC (built for RV32IM) is in the PATH.
4. Set the PLATFORM environment variable as appropriate for your device.
4. Run "make build_all".


## Acknowledgement and Thanks
This project uses code from several other projects including:
 - [https://github.com/gtaylormb/opl3_fpga]
 - [https://github.com/Saanlima/Pipistrello]
 - [https://github.com/pellepl/spiffs.git]
 - [https://github.com/ultraembedded/fpga_test_soc.git]

## Pano Links

Link to other Panologic information can be found [here](https://github.com/skiphansen/pano_blocks#pano-links)

## LEGAL 

My original work (the Pano Codec glue code) is released under the GNU General 
Public License, version 2.

