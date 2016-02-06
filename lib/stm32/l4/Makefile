##
## This file is part of the libopencm3 project.
##
## Copyright (C) 2015 Karl Palsson <karlp@tweak.net.au>
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

DEVICE		= stm32l4
OPENCM3_DIR     ?= ../../..

#Specific objs
OBJS		= 

# common/shared objs
OBJS            += rcc_common_all.o
OBJS            += gpio_common_all.o gpio_common_f0234.o

include ../../Makefile.include

VPATH += ../:../common
