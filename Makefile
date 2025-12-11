THEOS = /var/theos
ARCHS = arm64
TARGET = iphone:15.6:14.0

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = YuriGame

$(APPLICATION_NAME)_FILES = main.m

$(APPLICATION_NAME)_LDFLAGS = -e _YuriGameMain
$(APPLICATION_NAME)_CFLAGS = -fobjc-arc
$(APPLICATION_NAME)_FRAMEWORKS = UIKit

$(APPLICATION_NAME)_CODESIGN_FLAGS = -Sentitlements.xml

include $(THEOS_MAKE_PATH)/application.mk

after-stage::
	@mv $(THEOS_STAGING_DIR)/Applications/YuriGame.app/YuriGame \
		$(THEOS_STAGING_DIR)/Applications/YuriGame.app/YuriGame_PleaseDoNotShortenTheExecutableNameBecauseItIsUsedToReserveSpaceForOverwritingThankYou