##
## This file is part of the libopencm3 project.
##
## Copyright (C) 2014 Frantisek Burian <BuFran@seznam.cz>
##
## This library is free software: you can redistribute it and/or modify
## it under the terms of the GNU Lesser General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This library is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU Lesser General Public License for more details.
##
## You should have received a copy of the GNU Lesser General Public License
## along with this library.  If not, see <http://www.gnu.org/licenses/>.
##

ifeq ($(DEVICE),)
$(warning no DEVICE specified for linker script generator)
endif

LDSCRIPT	= $(DEVICE).ld
DEVICES_DATA = $(OPENCM3_DIR)/ld/devices.data

genlink_family		:=$(shell awk -v PAT="$(DEVICE)" -v MODE="FAMILY" -f $(OPENCM3_DIR)/scripts/genlink.awk $(DEVICES_DATA) 2>/dev/null)
genlink_subfamily	:=$(shell awk -v PAT="$(DEVICE)" -v MODE="SUBFAMILY" -f $(OPENCM3_DIR)/scripts/genlink.awk $(DEVICES_DATA) 2>/dev/null)
genlink_cpu		:=$(shell awk -v PAT="$(DEVICE)" -v MODE="CPU" -f $(OPENCM3_DIR)/scripts/genlink.awk $(DEVICES_DATA) 2>/dev/null)
genlink_fpu		:=$(shell awk -v PAT="$(DEVICE)" -v MODE="FPU" -f $(OPENCM3_DIR)/scripts/genlink.awk $(DEVICES_DATA) 2>/dev/null)
genlink_cppflags	:=$(shell awk -v PAT="$(DEVICE)" -v MODE="CPPFLAGS" -f $(OPENCM3_DIR)/scripts/genlink.awk $(DEVICES_DATA) 2>/dev/null)

CPPFLAGS	+= $(genlink_cppflags)

ARCH_FLAGS	:=-mcpu=$(genlink_cpu)
ifeq ($(genlink_cpu),$(filter $(genlink_cpu),cortex-m0 cortex-m0plus cortex-m3 cortex-m4 cortex-m7))
ARCH_FLAGS    +=-mthumb
endif

ifdef FP_FLAGS
ARCH_FLAGS	+= $(FP_FLAGS)
else
ifeq ($(genlink_fpu),soft)
ARCH_FLAGS	+= -msoft-float
else ifeq ($(genlink_fpu),hard-fpv4-sp-d16)
ARCH_FLAGS	+= -mfloat-abi=hard -mfpu=fpv4-sp-d16
else ifeq ($(genlink_fpu),hard-fpv5-sp-d16)
ARCH_FLAGS      += -mfloat-abi=hard -mfpu=fpv5-sp-d16
else
$(warning No match for the FPU flags)
endif
endif


ifeq ($(genlink_family),)
$(warning $(DEVICE) not found in $(DEVICES_DATA))
endif

# only append to LDFLAGS if the library file exists to not break builds
# where those are provided by different means
ifneq (,$(wildcard $(OPENCM3_DIR)/lib/libopencm3_$(genlink_family).a))
LDLIBS += -lopencm3_$(genlink_family)
else
ifneq (,$(wildcard $(OPENCM3_DIR)/lib/libopencm3_$(genlink_subfamily).a))
LDLIBS += -lopencm3_$(genlink_subfamily)
else
$(warning $(OPENCM3_DIR)/lib/libopencm3_$(genlink_family).a library variant for the selected device does not exist.)
endif
endif

# only append to LDLIBS if the directory exists
ifneq (,$(wildcard $(OPENCM3_DIR)/lib))
LDFLAGS += -L$(OPENCM3_DIR)/lib
else
$(warning $(OPENCM3_DIR)/lib as given be OPENCM3_DIR does not exist.)
endif

# only append include path to CPPFLAGS if the directory exists
ifneq (,$(wildcard $(OPENCM3_DIR)/include))
CPPFLAGS += -I$(OPENCM3_DIR)/include
else
$(warning $(OPENCM3_DIR)/include as given be OPENCM3_DIR does not exist.)
endif
