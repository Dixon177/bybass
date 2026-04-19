export THEOS_DEVICE_IP = 127.0.0.1
export THEOS_DEVICE_PORT = 2222

TARGET := iphone:clang:latest:15.0
ARCHS = arm64 arm64e

DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AhmedBypass

AhmedBypass_FILES = Tweak.x
AhmedBypass_CFLAGS = -fobjc-arc
AhmedBypass_LDFLAGS = -undefined dynamic_lookup
AhmedBypass_FRAMEWORKS = UIKit Foundation Security

include $(THEOS_MAKE_PATH)/tweak.mk
