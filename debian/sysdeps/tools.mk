ifeq ($(cross_compiling),yes)
CC     = $(DEB_HOST_GNU_TYPE)-gcc
BUILD_CC = gcc
else
CC     = gcc
BUILD_CC = $(CC)
endif
