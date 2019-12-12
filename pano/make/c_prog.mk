###############################################################################
# Inputs
###############################################################################
# SRC_DIR
SRC_DIR ?= .
# INCLUDE_PATH
# TARGET
TARGET ?= target
# EXTRA_CFLAGS
# EXTRA_LIBS
# EXTRA_LIBDIRS
# GCC_PREFIX     = arch-toolchain-
# OPT            = [0-2]
OPT ?= 0
# FPIC           = yes | no
# RUN_PREFIX
# RUN_ARGS
# ARCH
# ARCH_CFLAGS
# ARCH_LFLAGS
# COMPILER       = g++ | gcc

###############################################################################
# Checks
###############################################################################
ifeq ($(TOPDIR),)
$(error TOPDIR not set)
endif

include $(TOPDIR)/pano/make/common.mk

ifeq ($(MAKE_DIR),)
   $(error Missing MAKE_DIR)
endif

###############################################################################
# Arch options
###############################################################################
ifneq ($(ARCH),)
  TARGET_IS_LIB=no
  include $(MAKE_DIR)/$(ARCH).mk
endif

###############################################################################
# Variables
###############################################################################
ifneq ($(ARCH),)
  ARCH_TGT_DIR=$(ARCH)
else
  ARCH_TGT_DIR=linux
endif

BUILD_DIR      ?= build

###############################################################################
# Variables: GCC
###############################################################################
QUIET        ?= yes

GCC_PREFIX   ?= 
COMPILER     ?= g++

ifeq ($(QUIET),yes)
GCC          = @$(GCC_PREFIX)$(COMPILER)
OBJCOPY      = @$(GCC_PREFIX)objcopy
OBJDUMP      = @$(GCC_PREFIX)objdump
else
GCC          = $(GCC_PREFIX)$(COMPILER)
OBJCOPY      = $(GCC_PREFIX)objcopy
OBJDUMP      = $(GCC_PREFIX)objdump
endif

###############################################################################
# Variables: Compilation flags
###############################################################################

# Additional include directories
INCLUDE_PATH += $(SRC_DIR)

# Flags
CFLAGS       = $(ARCH_CFLAGS) -O$(OPT)
ifeq ($(FPIC), yes)
CFLAGS       += -fpic
endif
CFLAGS       += $(patsubst %,-I%,$(INCLUDE_PATH))
CFLAGS       += $(EXTRA_CFLAGS)

LFLAGS       += $(ARCH_LFLAGS)
LFLAGS       += $(patsubst %,-L%,$(EXTRA_LIBDIRS))
LFLAGS       += $(EXTRA_LIBS)
LFLAGS 	     += -Wl,-Map=$(BUILD_DIR)/$(TARGET).map

###############################################################################
# Variables: Lists of objects, source and deps
###############################################################################
# SRC / Object list
src2obj       = $(BUILD_DIR)/$(patsubst %$(suffix $(1)),%.o,$(notdir $(1)))
src2dep       = $(BUILD_DIR)/$(patsubst %,%.d,$(notdir $(1)))

SRC          := $(BOOT_SRC) $(EXTRA_SRC) $(foreach src,$(SRC_DIR),$(wildcard $(src)/*.cpp)) $(foreach src,$(SRC_DIR),$(wildcard $(src)/*.c))
OBJ          ?= $(foreach src,$(SRC),$(call src2obj,$(src)))
DEPS         ?= $(foreach src,$(SRC),$(call src2dep,$(src)))

###############################################################################
# Rules: Compilation macro
###############################################################################
# Dependancy generation
DEPFLAGS      = -MT $$@ -MMD -MP -MF $(call src2dep,$(1))

define template_c
$(call src2obj,$(1)): $(1) | $(BUILD_DIR)/ $(BUILD_DIR)/
	@echo "# Compiling $(notdir $(1))"
	$(GCC) $(CFLAGS) $(DEPFLAGS) -c $$< -o $$@
endef

###############################################################################
# Rules
###############################################################################
BUILD_TARGETS = $(BUILD_DIR)/$(TARGET)

ifeq ($(ENABLE_BIN),yes)
  BUILD_TARGETS += $(BUILD_DIR)/$(TARGET).bin
endif
ifeq ($(ENABLE_LST),yes)
  BUILD_TARGETS += $(BUILD_DIR)/$(TARGET).lst
endif

all: $(BUILD_TARGETS)

$(BUILD_DIR)/:
	@mkdir -p $@

$(foreach src,$(SRC),$(eval $(call template_c,$(src))))

$(BUILD_DIR)/$(TARGET): $(OBJ) | $(BUILD_DIR)/ 
	@echo "# Building $(notdir $@)"
	$(GCC) -o $(BUILD_DIR)/$(TARGET) $(OBJ) $(LFLAGS)

$(BUILD_DIR)/$(TARGET).bin: $(BUILD_DIR)/$(TARGET)
	@echo "# Building $(notdir $@)"
	$(OBJCOPY) -O binary $< $@

$(BUILD_DIR)/$(TARGET).lst: $(BUILD_DIR)/$(TARGET)
	@echo "# Building $(notdir $@)"
	$(OBJDUMP) -d $< > $@

run:
	$(RUN_PREFIX) $(BUILD_DIR)/$(TARGET) $(RUN_ARGS)

clean:
	rm -rf $(BUILD_DIR)

load:
	make -C $(TOPDIR)/fpga load

###############################################################################
# Rules: Dependancies
###############################################################################
EXCLUDE_DEPS := clean
ifeq (0, $(words $(findstring $(MAKECMDGOALS), $(EXCLUDE_DEPS))))
-include $(DEPS)
endif
