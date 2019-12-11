TARGET       = blinky
ARCH         = riscv
PLATFORM     = machine-fpga

EXTRA_CFLAGS+= -DCPU_KHZ=75000

# UART driver
EXTRA_CFLAGS += -DCONFIG_UARTLITE
EXTRA_CFLAGS += -DCONFIG_UARTLITE_BASE=0x92000000

TOPDIR	     = ../../
PANO_DIR     = $(TOPDIR)/pano
PANO_FW_DIR  = $(PANO_DIR)/fw
MAKE_DIR     = $(PANO_DIR)/make
CORES_DIR     = $(TOPDIR)/cores
SRC_DIR      = ./ 
SRC_DIR     += $(CORES_DIR)/core_soc/src_c
SRC_DIR     += $(PANO_FW_DIR)/lib/libstd

INCLUDE_PATH += ../include
INCLUDE_PATH += $(PANO_FW_DIR)/common

BASE_ADDRESS  = 0x0
OPT           = 2
CPU_KHZ       = 75000

TARGET_PORT ?= /dev/ttyUSB1
RUN_PREFIX  := $(TOPDIR)/pano/tools/run/run.py -d $(TARGET_PORT) -b 1000000 -f 

ENABLE_LST=yes

include $(MAKE_DIR)/common.mk



