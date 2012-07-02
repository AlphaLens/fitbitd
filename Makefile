.SECONDEXPANSION:

VER_MAJ := 0
VER_MIN := 1

RELEASE ?= 0

DESTDIR ?= /usr

ifeq ($(RELEASE),1)
CFLAGS += -DDEBUG=0
VER_GIT :=
else
CFLAGS += -DDEBUG=1 -g
VER_GIT := $(shell git rev-parse --short HEAD || echo git)
endif

DIR_OUT := out
DIR_BIN := $(DIR_OUT)/bin
DIR_OBJ := $(DIR_OUT)/obj

AR := ar
CC := gcc

CFLAGS += \
	-Wall -Werror -O2 \
	-DVERSION=\"$(VER_MAJ).$(VER_MIN)$(addprefix ~,$(VER_GIT))\" \
	-I.

define local-dir
$(strip \
	$(eval _mkfile := $$(lastword $$(MAKEFILE_LIST))) \
	$(patsubst %/,%,$(dir $(_mkfile))))
endef

.PHONY: all
all:

.PHONY: clean
clean:

.PHONY: clobber
clobber:
	rm -rf $(DIR_OUT)

include libant/Makefile
include libfitbit/Makefile
include fitbitd/Makefile

.PHONY: install
install: all
	mkdir -p "$(DESTDIR)/bin"
	cp -v "$(fitbitd_target)" "$(DESTDIR)/bin/fitbitd"
