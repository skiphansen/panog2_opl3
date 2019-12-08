TARGET       = opl3_test
ARCH         = riscv
PLATFORM     = machine-fpga

EXTRA_CFLAGS+= -DCPU_KHZ=50000

# UART driver
EXTRA_CFLAGS += -DCONFIG_UARTLITE
EXTRA_CFLAGS += -DCONFIG_UARTLITE_BASE=0x92000000

# SPI driver
EXTRA_CFLAGS += -DCONFIG_SPILITE
EXTRA_CFLAGS += -DCONFIG_SPILITE_BASE=0x93000000

TOPDIR	     = ../../
SRC_DIR      = ./ 
SRC_DIR     += $(TOPDIR)/fpga/core_soc/src_c
EXTRA_SRC   += ../common/i2c.c

INCLUDE_PATH += ../common

BASE_ADDRESS  = 0x0
OPT           = 2

TARGET_PORT ?= /dev/ttyUSB1
RUN_PREFIX  := $(TOPDIR)/tools/run/run.py -d $(TARGET_PORT) -b 1000000 -f 

MAKE_DIR=../make

include $(MAKE_DIR)/common.mk



