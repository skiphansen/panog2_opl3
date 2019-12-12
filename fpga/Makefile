###############################################################################
## Makefile
###############################################################################
CPU        ?= riscv

# Choice: [rv32i, rv32i_spartan6, rv32im, rv32imsu]
RISCV_CORE  ?= rv32i_spartan6

# Choice: g1, g2
PANO_SERIES ?= g2

# Set to yes for second generation, rev C (lx100 FPGA)
PANO_REV_C  ?= no

SRC_DIR       = .
SRC_DIR      += $(CORES_DIR)/core_soc/src_v
SRC_DIR      += $(CORES_DIR)/dbg_bridge/src_v
SRC_DIR      += $(CORES_DIR)/cpu/riscv/core/$(RISCV_CORE)
SRC_DIR      += $(CORES_DIR)/cpu/riscv/top_tcm_wrapper
#SRC_DIR      += $(PANO_CORES_DIR)/g2/opl3/src_v

EXTRA_VFLAGS += CPU_SELECT_RISCV=1

# EXCLUDE_SRC - list of core files with local replacments
EXCLUDE_SRC += $(CORES_DIR)/core_soc/src_v/axi4lite_dist.v
EXCLUDE_SRC += $(CORES_DIR)/core_soc/src_v/core_soc.v

BSCAN_SPI_DIR = $(PANO_CORES_DIR)/xc3sprog

COMPRESS_BITFILE = yes

.PHONY: init_and_build

TOPDIR = ..
include $(TOPDIR)/pano/make/ise.mk

#${CORES_README}:
#	git submodule init
#	git submodule update



