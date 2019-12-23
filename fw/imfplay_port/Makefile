TARGET       = imfplay

TOPDIR	     = ../..
include ../include/platform.mk

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

OPT           = 2
ENABLE_LST    = yes

BUILD_TARGETS += ../firmware.mem

include $(TOPDIR)/pano/make/c_prog.mk

