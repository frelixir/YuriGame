THEOS = /var/theos
ARCHS = arm64
TARGET = iphone:15.6:14.0

include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = YuriGameUI

$(LIBRARY_NAME)_FILES = LCAppDelegate.m LCRootViewController.m

$(LIBRARY_NAME)_CFLAGS = -fobjc-arc
$(LIBRARY_NAME)_FRAMEWORKS = UIKit

$(LIBRARY_NAME)_INSTALL_PATH = /Applications/YuriGame.app/Frameworks

include $(THEOS_MAKE_PATH)/library.mk