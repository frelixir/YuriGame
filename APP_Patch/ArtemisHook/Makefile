THEOS = /var/theos
ARCHS = arm64
TARGET = iphone:15.6:14.5

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = ArtemisHook

ArtemisHook_FILES = ArtemisHook.m fishhook.c

ArtemisHook_CFLAGS = -fobjc-arc
ArtemisHook_FRAMEWORKS = Foundation

include $(THEOS_MAKE_PATH)/library.mk