THEOS = /var/theos

ARCHS = arm64
TARGET = iphone:15.6:14.5

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = XP3Touch

XP3Touch_FILES = XP3Touch.m

XP3Touch_FRAMEWORKS = UIKit Foundation IOKit
XP3Touch_CFLAGS = -fobjc-arc -Wno-deprecated-declarations -F.
XP3Touch_LDFLAGS = -F. -framework PTFakeTouch

include $(THEOS_MAKE_PATH)/library.mk