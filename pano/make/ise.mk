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
ifeq ($(TOPDIR),)
$(error TOPDIR not set)
endif

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

include $(TOPDIR)/pano/make/common.mk

TOP_MODULE   ?= top

ifeq ($(XILINX_ISE),)
$(error "XILINX_ISE not set - e.g. export XILINX_ISE=/opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64")
endif
TOOL_PATH    := $(XILINX_ISE)

UCF_FILE  = $(PROJECT_DIR)/$(PROJECT).ucf
UCF_FILES := $(foreach _dir,$(SRC_DIR), $(wildcard $(_dir)/*_$(PANO_SERIES).ucf))
SRC_FILES := $(filter-out $(EXCLUDE_SRC),$(foreach _dir,$(SRC_DIR), $(wildcard $(_dir)/*.v)))

###############################################################################
# Rules:
###############################################################################
all: bitstream

BIT_FILE = $(PROJECT_DIR)/${PROJECT}_routed.bit
BSCAN_SPI_BITFILE = $(BSCAN_SPI_DIR)/$(PART_NAME).bit   

bitstream: $(BIT_FILE)

clean:
	rm -rf $(PROJECT_DIR)

$(PROJECT_DIR):
	@mkdir -p $@

###############################################################################
# PROJECT.ut
###############################################################################
$(PROJECT_DIR)/$(PROJECT).ut: | $(PROJECT_DIR)
	@echo "-w" > $@
	@echo "-g DebugBitstream:No" >> $@
	@echo "-g Binary:no" >> $@
	@echo "-g CRC:Enable" >> $@
	@echo "-g ConfigRate:25" >> $@
	@echo "-g ProgPin:PullUp" >> $@
	@echo "-g DonePin:PullUp" >> $@
	@echo "-g TckPin:PullUp" >> $@
	@echo "-g TdiPin:PullUp" >> $@
	@echo "-g TdoPin:PullUp" >> $@
	@echo "-g TmsPin:PullUp" >> $@
	@echo "-g UnusedPin:PullDown" >> $@
	@echo "-g UserID:0xFFFFFFFF" >> $@
	@echo "-g StartUpClk:CClk" >> $@
	@echo "-g DONE_cycle:4" >> $@
	@echo "-g GTS_cycle:5" >> $@
	@echo "-g GWE_cycle:6" >> $@
	@echo "-g LCK_cycle:NoWait" >> $@
	@echo "-g Security:None" >> $@
	@echo "-g DonePipe:No" >> $@
	@echo "-g DriveDone:No" >> $@
ifeq ($(COMPRESS_BITFILE), yes)
	@echo "-g Compress" >> $@
endif

###############################################################################
# PROJECT.xst
###############################################################################
$(PROJECT_DIR)/$(PROJECT).xst: | $(PROJECT_DIR)
	@echo "set -tmpdir \"xst/projnav.tmp\"" > $@
	@echo "set -xsthdpdir \"xst\"" >> $@
	@echo "run" >> $@
	@echo "-ifn $(PROJECT).prj" >> $@
	@echo "-ifmt mixed" >> $@
	@echo "-ofn $(PROJECT)" >> $@
	@echo "-ofmt NGC" >> $@
	@echo "-p $(PART_NAME)-$(PART_SPEED)-$(PART_PACKAGE)" >> $@
	@echo "-top $(TOP_MODULE)" >> $@
	@echo "-opt_mode Speed" >> $@
	@echo "-opt_level 2" >> $@
	@echo "-iuc NO" >> $@
	@echo "-keep_hierarchy No" >> $@
	@echo "-netlist_hierarchy As_Optimized" >> $@
	@echo "-rtlview Yes" >> $@
	@echo "-glob_opt AllClockNets" >> $@
	@echo "-read_cores YES" >> $@
	@echo "-write_timing_constraints YES" >> $@
	@echo "-cross_clock_analysis NO" >> $@
	@echo "-hierarchy_separator /" >> $@
	@echo "-bus_delimiter <>" >> $@
	@echo "-case Maintain" >> $@
	@echo "-slice_utilization_ratio 100" >> $@
	@echo "-bram_utilization_ratio 100" >> $@
	@echo "-fsm_extract YES -fsm_encoding Auto" >> $@
	@echo "-safe_implementation No" >> $@
	@echo "-fsm_style LUT" >> $@
	@echo "-ram_extract Yes" >> $@
	@echo "-ram_style Auto" >> $@
	@echo "-rom_extract Yes" >> $@
	@echo "-shreg_extract YES" >> $@
	@echo "-rom_style Auto" >> $@
	@echo "-auto_bram_packing NO" >> $@
	@echo "-resource_sharing NO" >> $@
	@echo "-async_to_sync NO" >> $@
	@echo "-mult_style Auto" >> $@
	@echo "-iobuf YES" >> $@
	@echo "-max_fanout 500" >> $@
	@echo "-bufg 24" >> $@
	@echo "-register_duplication YES" >> $@
	@echo "-register_balancing Yes" >> $@
	@echo "-move_first_stage YES" >> $@
	@echo "-move_last_stage YES" >> $@
	@echo "-optimize_primitives YES" >> $@
	@echo "-use_clock_enable Auto" >> $@
	@echo "-use_sync_set Auto" >> $@
	@echo "-use_sync_reset Auto" >> $@
	@echo "-iob Auto" >> $@
	@echo "-equivalent_register_removal YES" >> $@
	@echo "-slice_utilization_ratio_maxmargin 5" >> $@
	@echo "-define {$(EXTRA_VFLAGS)}" >> $@

###############################################################################
# PROJECT.prj
###############################################################################
$(PROJECT_DIR)/$(PROJECT).prj: $(PROJECT_DIR)/$(PROJECT).ut $(PROJECT_DIR)/$(PROJECT).xst $(SRC_FILES)
	@touch $@
	@$(foreach _file,$(SRC_FILES),echo "verilog work \"$(abspath $(_file))\"" >> $@;)

###############################################################################
# PROJECT.ucf
###############################################################################
$(UCF_FILE): $(UCF_FILES)
	cat $^ > $@

###############################################################################
# Rule: Synth
###############################################################################
$(PROJECT_DIR)/$(PROJECT).ngc: $(PROJECT_DIR)/$(PROJECT).prj
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
$(PROJECT_DIR)/$(PROJECT).ncd: $(PROJECT_DIR)/$(PROJECT).ngd
	@echo "####################################################################"
	@echo "# ISE: Map"
	@echo "####################################################################"
	@cd $(PROJECT_DIR); $(TOOL_PATH)/map -w -intstyle ise -p $(PART_NAME)-$(PART_PACKAGE)-$(PART_SPEED) \
	-detail -ir off -ignore_keep_hierarchy -pr b -timing -ol high -logic_opt on  \
	-o $(PROJECT).ncd $(PROJECT).ngd $(PROJECT).pcf 

###############################################################################
# Rule: Place and route
###############################################################################
$(PROJECT_DIR)/$(PROJECT)_routed.ncd: $(PROJECT_DIR)/$(PROJECT).ncd
	@echo "####################################################################"
	@echo "# ISE: Place and route"
	@echo "####################################################################"
	@cd $(PROJECT_DIR); $(TOOL_PATH)/par -w -intstyle ise -ol high $(PROJECT).ncd $(PROJECT)_routed.ncd $(PROJECT).pcf

###############################################################################
# Rule: Bitstream
###############################################################################
$(BIT_FILE): $(PROJECT_DIR)/$(PROJECT)_routed.ncd
	@echo "####################################################################"
	@echo "# ISE: Create bitstream"
	@echo "####################################################################"
	@cd $(PROJECT_DIR); $(TOOL_PATH)/bitgen -f $(PROJECT).ut $(PROJECT)_routed.ncd

$(PREBUILT_DIR)/$(PROJECT).bit: $(BIT_FILE)
	@cp $(BIT_FILE) $(PREBUILT_DIR)/$(PROJECT).bit

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
load: $(PREBUILT_DIR)/$(PROJECT).bit
	$(XC3SPROG) $(XC3SPROG_OPTS) $(PREBUILT_DIR)/$(PROJECT).bit

###############################################################################
# Rule: Program Bitstream into SPI flash using XC2PROG
###############################################################################
prog_fpga: $(PREBUILT_DIR)/$(PROJECT).bit
	$(XC3SPROG) $(XC3SPROG_OPTS) -I$(BSCAN_SPI_BITFILE) $(PREBUILT_DIR)/$(PROJECT).bit


