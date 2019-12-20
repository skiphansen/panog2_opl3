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

TOPDIR	     = ../..
SRC_DIR      = .
SRC_DIR     += $(CORES_DIR)/core_soc/src_c
SRC_DIR     += $(PANO_FW_DIR)/lib/libstd
SRC_DIR     += $(PANO_CORES_DIR)/g2/opl3/src_c
SRC_DIR     += $(TOPDIR)/src_c/drivers
EXTRA_SRC   += $(PANO_FW_DIR)/common/i2c.c
EXTRA_SRC   += $(PANO_FW_DIR)/common/audio.c
EXTRA_SRC   += $(PANO_FW_DIR)/common/log.c
SRC_DIR     += ../spiffs
EXTRA_SRC   += $(PANO_FW_DIR)/common/spiffs_drv.c

INCLUDE_PATH += ../include
INCLUDE_PATH += $(PANO_FW_DIR)/common

BASE_ADDRESS  = 0x0
OPT           = 2
ENABLE_LST = yes

include $(TOPDIR)/pano/make/c_prog.mk



