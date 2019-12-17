TARGET       = imfplay
ARCH         = riscv
PLATFORM     = machine-fpga

EXTRA_CFLAGS+= -DCPU_KHZ=50000

# UART driver
EXTRA_CFLAGS += -DCONFIG_UARTLITE
EXTRA_CFLAGS += -DCONFIG_UARTLITE_BASE=0x92000000

# SPI driver
EXTRA_CFLAGS += -DCONFIG_SPILITE
EXTRA_CFLAGS += -DCONFIG_SPILITE_BASE=0x93000000

TOPDIR	     = ../../../..
SRC_DIR      = ./ 
SRC_DIR     += $(TOPDIR)/soc/core_soc/src_c
SRC_DIR     += $(TOPDIR)/src_c/drivers
SRC_DIR     += ../spiffs
EXTRA_SRC   += $(PANO_FW_DIR)/common/spiffs_drv.c

BASE_ADDRESS  = 0x0
OPT           = 2

TARGET_PORT ?= /dev/ttyUSB1
RUN_PREFIX  := $(TOPDIR)/run.py -d $(TARGET_PORT) -b 1000000 -f 

# Test file
#DRO_FILE = opl3dro/doom_000.dro
#DRO_FILE = opl3dro/doom_035.dro
#DRO_FILE = opl3dro/doom_036.dro

#DRO_FILE = opl3dro/doom2_000.dro
#DRO_FILE = opl3dro/doom2_001.dro
#DRO_FILE = opl3dro/doom2_002.dro
#DRO_FILE = opl3dro/doom2_003.dro
#DRO_FILE = opl3dro/doom2_013.dro
#DRO_FILE = opl3dro/doom2_014.dro
DRO_FILE = opl3dro/doom2_015.dro
#DRO_FILE = opl3dro/doom2_016.dro
#DRO_FILE = opl3dro/doom2_031.dro
#DRO_FILE = opl3dro/doom2_032.dro
#DRO_FILE = opl3dro/xcom_001.dro

# these don't work (opl3 support needed?)

#OPL3 files
#DRO_FILE = opl3dro/war_000.dro #(doesn't fit in flash, plays if truncated manually
#DRO_FILE = opl3dro/atlantis_000.dro #(doesn't fit in flash)
#DRO_FILE = opl3dro/dott_000.dro

# opl2 file?

CLEAN_FILES += mfs_file.h

MAKE_DIR=../make
include $(MAKE_DIR)/common.mk

BIN2C := $(TOPDIR)/tools/bin2c/bin2c

mfs_file.h: $(BIN2C) Makefile
	$(BIN2C) $(DRO_FILE) mfs_file.h gMfsFile





