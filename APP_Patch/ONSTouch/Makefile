THEOS = /var/theos
ARCHS = arm64
TARGET = iphone:15.6:14.5

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = ONSTouch

ONSTouch_FILES = Sandbox.m fishhook.c ONSTouch.m

ONSTouch_CFLAGS = -fobjc-arc
ONSTouch_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/library.mk