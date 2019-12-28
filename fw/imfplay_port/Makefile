include ../../project.mk

TARGET       = imfplay

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

include $(TOPDIR)/pano/make/c_prog.mk

.PHONY: filesystem

PREBUILT := $(TOPDIR)/prebuilt
G2_FS 	 := $(PREBUILT)/dro_test_spiffs.img
G2_C_FS  := $(PREBUILT)/dro_test_spiffs-g2-c.img

filesystem: $(G2_FS) $(G2_C_FS)

$(G2_FS): $(MKSPIFFS)
	$(Q)$(MKSPIFFS)  -c opl3dro -b 131072 -p 256 -s 7733248 $@ > $(TTY)

$(G2_C_FS): $(MKSPIFFS)
	$(Q)$(MKSPIFFS) -c opl3dro -b 65536 -p 256 -s 3276800 $@ > $(TTY)

