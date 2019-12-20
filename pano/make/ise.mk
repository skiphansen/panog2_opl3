include $(dir $(abspath $(lastword $(MAKEFILE_LIST))))/common.mk

###############################################################################
## Params
###############################################################################
XILINX_ISE ?= /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64
EXTRA_VFLAGS ?= 
PROJECT_DIR  ?= build
PROJECT      ?= fpga

###############################################################################
# Checks
###############################################################################
ifeq ($(PANO_SERIES),)
$(error PANO_SERIES not set)
endif

ifeq ($(PANO_SERIES),g2)
  ifeq ($(PANO_REV_C),yes)
    PART_NAME    = xc6slx100
    PART_PACKAGE = fgg484
    PART_SPEED   = 2
  else
    PART_NAME    = xc6slx150
    PART_PACKAGE = fgg484
    PART_SPEED   = 2
  endif
endif

ifeq ($(PART_NAME),)
$(error unknown PANO_SERIES $(PANO_SERIES))
endif

TOP_MODULE   ?= top

ifeq ($(XILINX_ISE),)
$(error "XILINX_ISE not set - e.g. export XILINX_ISE=/opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64")
endif
TOOL_PATH    := $(XILINX_ISE)

SRC_FILES := $(filter-out $(EXCLUDE_SRC),$(foreach _dir,$(SRC_DIR), $(wildcard $(_dir)/*.v)))

###############################################################################
# Rules:
###############################################################################
all: bitstream $(PREBUILT_DIR)/$(PART_NAME).bit

BIT_FILE = $(PROJECT_DIR)/${PROJECT}_routed.bit

bitstream: $(BIT_FILE)

clean:
	rm -rf $(PROJECT_DIR)

$(PROJECT_DIR):
	@mkdir -p $@

###############################################################################
# PROJECT.ut
###############################################################################
$(PROJECT_DIR)/$(PROJECT).ut: | $(PROJECT_DIR)
	if [ -e $(PROJECT).ut ]; then cp $(PROJECT).ut $(PROJECT_DIR); else \
	cp $(MAKE_DIR)/default.ut $(PROJECT_DIR)/$(PROJECT).ut; fi

###############################################################################
# PROJECT.xst
###############################################################################
$(PROJECT_DIR)/$(PROJECT).xst: | $(PROJECT_DIR)
	if [ -e $(PROJECT).xst ]; then cp $(PROJECT).xst $(PROJECT_DIR); else \
	cp $(MAKE_DIR)/default.xst $(PROJECT_DIR)/$(PROJECT).xst; fi

###############################################################################
# PROJECT.prj
###############################################################################
$(PROJECT_DIR)/$(PROJECT).prj: $(PROJECT_DIR)/$(PROJECT).ut $(PROJECT_DIR)/$(PROJECT).xst
	@touch $@
	@$(foreach _file,$(SRC_FILES),echo "verilog work \"$(abspath $(_file))\"" >> $@;)

###############################################################################
# PROJECT.ucf
###############################################################################
UCF_FILE  = $(PROJECT_DIR)/$(PROJECT).ucf
UCF_FILES := $(foreach _dir,$(SRC_DIR), $(wildcard $(_dir)/*_$(PANO_SERIES).ucf))
$(UCF_FILE): $(UCF_FILES)
	cat $^ > $@

###############################################################################
# Rule: Synth
###############################################################################
$(PROJECT_DIR)/$(PROJECT).ngc: $(PROJECT_DIR)/$(PROJECT).prj $(SRC_FILES)
	@echo "####################################################################"
	@echo "# ISE: Synth"
	@echo "####################################################################"
	@mkdir -p $(PROJECT_DIR)/xst/projnav.tmp/
	@cd $(PROJECT_DIR); $(TOOL_PATH)/xst -intstyle ise -ifn $(PROJECT).xst -ofn $(PROJECT).syr

###############################################################################
# Rule: Convert netlist
###############################################################################
$(PROJECT_DIR)/$(PROJECT).ngd: $(PROJECT_DIR)/$(PROJECT).ngc $(UCF_FILE)
	@echo "####################################################################"
	@echo "# ISE: Convert netlist"
	@echo "####################################################################"
	@cd $(PROJECT_DIR); $(TOOL_PATH)/ngdbuild -intstyle ise -dd _ngo -nt timestamp \
	-uc $(abspath $(UCF_FILE)) -p $(PART_NAME)-$(PART_PACKAGE)-$(PART_SPEED) $(PROJECT).ngc $(PROJECT).ngd

###############################################################################
# Rule: Map
###############################################################################
MAP_CMDS ?= -w -intstyle ise -detail -ir off -ignore_keep_hierarchy -pr b -timing -ol high -logic_opt on

$(PROJECT_DIR)/$(PROJECT).ncd: $(PROJECT_DIR)/$(PROJECT).ngd
	@echo "####################################################################"
	@echo "# ISE: Map"
	@echo "####################################################################"
	@cd $(PROJECT_DIR); $(TOOL_PATH)/map $(MAP_CMDS) \
	-p $(PART_NAME)-$(PART_PACKAGE)-$(PART_SPEED) \
	-o $(PROJECT).ncd $(PROJECT).ngd $(PROJECT).pcf 

###############################################################################
# Rule: Place and route
###############################################################################
PAR_CMDS ?= -w -intstyle ise -ol high 
$(PROJECT_DIR)/$(PROJECT)_routed.ncd: $(PROJECT_DIR)/$(PROJECT).ncd
	@echo "####################################################################"
	@echo "# ISE: Place and route"
	@echo "####################################################################"
	@cd $(PROJECT_DIR); $(TOOL_PATH)/par $(PAR_CMDS) $(PROJECT).ncd $(PROJECT)_routed.ncd $(PROJECT).pcf

###############################################################################
# Rule: Bitstream
###############################################################################
$(BIT_FILE): $(PROJECT_DIR)/$(PROJECT)_routed.ncd
	@echo "####################################################################"
	@echo "# ISE: Create bitstream"
	@echo "####################################################################"
	@cd $(PROJECT_DIR); $(TOOL_PATH)/bitgen -f $(PROJECT).ut $(PROJECT)_routed.ncd

$(PREBUILT_DIR)/$(PART_NAME).bit: $(BIT_FILE)
	@cp $(BIT_FILE) $(PREBUILT_DIR)/$(PART_NAME).bit

###############################################################################
# Rule: Bitstream -> binary
###############################################################################
$(PROJECT_DIR)/$(PROJECT).bin: $(BIT_FILE)
	@echo "####################################################################"
	@echo "# ISE: Convert bitstream"
	@echo "####################################################################"
	@cd $(PROJECT_DIR); $(TOOL_PATH)/promgen -u 0x0 $(PROJECT)_routed.bit -p bin -w -b -o $(PROJECT).bin

###############################################################################
# Rule: Load Bitstream using XC2PROG
###############################################################################
load:
	$(XC3SPROG) $(XC3SPROG_OPTS) $(PREBUILT_DIR)/$(PART_NAME).bit

###############################################################################
# Rule: Program Bitstream into SPI flash using XC2PROG
###############################################################################
BSCAN_SPI_BITFILE = $(BSCAN_SPI_DIR)/$(PART_NAME).bit   
prog_fpga: $(PREBUILT_DIR)/$(PROJECT).bit
	$(XC3SPROG) $(XC3SPROG_OPTS) -I$(BSCAN_SPI_BITFILE) $(PREBUILT_DIR)/$(PART_NAME).bit


