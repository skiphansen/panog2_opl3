TARGET       = opl3_test

TOPDIR	     = ../..
include ../include/platform.mk

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

include $(TOPDIR)/pano/make/c_prog.mk

