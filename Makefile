# Copyright 2018 Eevee <join.aero@gmail.com>. All Rights Reserved.
# License: Apache 2.0. See LICENSE file in root directory.
MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_DIR := $(patsubst %/,%,$(dir $(MKFILE_PATH)))

include CommonDefs.mk

.DEFAULT_GOAL := help

help:
	@echo "Usage:"
	@echo "  make help            show help message"
	@echo "  make init            init project"
	@echo "  make build           build project"
	@echo "  make install         install project"
	@echo "  make clean|cleanall  clean project"
	@echo "Options:"
	@echo "  BUILD_OPTIONS         build options"
	@echo "    e.g. make build BUILD_OPTIONS=-j2"
	@echo "  CMAKE_OPTIONS         cmake options"
	@echo "    e.g. make build CMAKE_OPTIONS=\"-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON\""

.PHONY: help

# deps

submodules:
	@git submodule update --init

.PHONY: submodules

# init

init: submodules
	@$(call echo,Make $@)
	@$(SH) ./scripts/init.sh $(INIT_OPTIONS)

.PHONY: init

# build

build:
	@$(call echo,Make $@)
	@$(call cmake_build,./_build,..,-DCMAKE_INSTALL_PREFIX=$(MKFILE_DIR)/_install)

.PHONY: build

# install

install: build
	@$(call echo,Make $@)
	@$(call make_install,./_build)

.PHONY: install

# clean

clean:
	@$(call echo,Make $@)
	@$(call rm,./_build/)
	@$(call rm,./_output/)
	@$(call rm,./_install/)

cleanall: clean
	@$(FIND) . -type f -name ".DS_Store" -print0 | xargs -0 rm -f

.PHONY: clean cleanall

# others

host:
	@$(call echo,Make $@)
	@echo MKFILE_PATH: $(MKFILE_PATH)
	@echo MKFILE_DIR: $(MKFILE_DIR)
	@echo HOST_OS: $(HOST_OS)
	@echo HOST_ARCH: $(HOST_ARCH)
	@echo HOST_NAME: $(HOST_NAME)
	@echo SH: $(SH)
	@echo ECHO: $(ECHO)
	@echo FIND: $(FIND)
	@echo CC: $(CC)
	@echo CXX: $(CXX)
	@echo MAKE: $(MAKE)
	@echo BUILD_OPTIONS: $(BUILD_OPTIONS)
	@echo BUILD: $(BUILD)
	@echo LDD: $(LDD)
	@echo CMAKE: $(CMAKE)
	@echo CMAKE_OPTIONS: $(CMAKE_OPTIONS)

.PHONY: host
