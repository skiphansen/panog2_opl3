include ../../project.mk

TARGET       = spiffs_test

SRC_DIR      = .
SRC_DIR     += $(CORES_DIR)/core_soc/src_c
SRC_DIR     += $(PANO_FW_DIR)/lib/libstd
SRC_DIR     += ../spiffs
EXTRA_SRC   += $(PANO_FW_DIR)/common/log.c
EXTRA_SRC   += $(PANO_FW_DIR)/common/spiffs_drv.c

INCLUDE_PATH += ../include
INCLUDE_PATH += $(PANO_FW_DIR)/common

# build optons
OPT           = 2
ENABLE_LST=yes

TOPDIR = ../..

include $(TOPDIR)/pano/make/c_prog.mk

prog_fs:
	make -C $(TOPDIR)/fpga prog_fs


