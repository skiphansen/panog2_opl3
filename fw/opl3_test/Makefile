TARGET       = opl3_test
ARCH         = riscv
PLATFORM     = machine-fpga

# hardware defines
BASE_ADDRESS  = 0x0
CPU_KHZ       = 50000
EXTRA_CFLAGS+= -DCPU_KHZ=$(CPU_KHZ)

# UART driver
EXTRA_CFLAGS += -DCONFIG_UARTLITE
EXTRA_CFLAGS += -DCONFIG_UARTLITE_BASE=0x92000000

SRC_DIR      = .
SRC_DIR     += $(CORES_DIR)/core_soc/src_c
SRC_DIR     += $(PANO_FW_DIR)/lib/libstd
SRC_DIR     += $(PANO_CORES_DIR)/g2/opl3/src_c
EXTRA_SRC   += $(PANO_FW_DIR)/common/i2c.c
EXTRA_SRC   += $(PANO_FW_DIR)/common/audio.c
EXTRA_SRC   += $(PANO_FW_DIR)/common/log.c

INCLUDE_PATH += ../include
INCLUDE_PATH += $(PANO_FW_DIR)/common

# build optons
OPT = 2
ENABLE_LST = yes

TOPDIR = ../..
include $(TOPDIR)/pano/make/c_prog.mk

