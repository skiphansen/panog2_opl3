# Choice: g1, g2
PANO_SERIES ?= g2

# Set to yes for second generation, rev C (lx100 FPGA)
PANO_REV_C  ?= no

# Set to no to watch the gory details
QUIET        ?= yes

ifeq ($(TOPDIR),)
   $(error TOPDIR not set)
endif

ifeq ($(V),)
   Q=@
endif


# directory related
MAKE_DIR     := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
CORES_DIR    := $(TOPDIR)/cores
PANO_DIR     := $(TOPDIR)/pano
PANO_CORES_DIR := $(PANO_DIR)/cores
PANO_FW_DIR  := $(PANO_DIR)/fw
TOOLS_DIR    := $(PANO_DIR)/tools
CPU_CORE_DIR := $(CORES_DIR)/cpu/riscv
PREBUILT_DIR := $(TOPDIR)/prebuilt
PANO_RTL_DIR := $(TOPDIR)/fpga
RTL_INIT_MEM := $(PANO_RTL_DIR)/firmware.mem

# xc3sprog related
CABLE 	      ?= jtaghs2
XC3SPROG_OPTS ?= -c $(CABLE) -v
XC3SPROG      ?= xc3sprog

# run tool related
TARGET_BAUD ?= 1000000
TARGET_PORT ?= /dev/ttyUSB1
RUN_PREFIX  := $(TOOLS_DIR)/dbg_bridge/run.py -d $(TARGET_PORT) -b $(TARGET_BAUD) -f 


