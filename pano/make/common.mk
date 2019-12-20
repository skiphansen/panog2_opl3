MAKE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

ifeq ($(TOPDIR),)
   $(error TOPDIR not set)
endif

# directory related
CORES_DIR    := $(TOPDIR)/cores
PANO_DIR     := $(TOPDIR)/pano
PANO_CORES_DIR := $(PANO_DIR)/cores
PANO_FW_DIR  := $(PANO_DIR)/fw
TOOLS_DIR    := $(PANO_DIR)/tools
CPU_CORE_DIR := $(CORES_DIR)/cpu/riscv
PREBUILT_DIR := $(TOPDIR)/prebuilt

# xc3sprog related
CABLE 	      ?= jtaghs2
XC3SPROG_OPTS ?= -c $(CABLE) -v
XC3SPROG      ?= xc3sprog

# run tool related
TARGET_BAUD ?= 1000000
TARGET_PORT ?= /dev/ttyUSB1
RUN_PREFIX  := $(TOOLS_DIR)/dbg_bridge/run.py -d $(TARGET_PORT) -b $(TARGET_BAUD) -f 


