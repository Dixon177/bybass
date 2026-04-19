export THEOS_DEVICE_IP = 127.0.0.1
export THEOS_DEVICE_PORT = 2222

# استهداف إصدارات iOS الحديثة
TARGET := iphone:clang:latest:15.0
ARCHS = arm64 arm64e

DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

# اسم المشروع صار Ahmed مثل الصورة
TWEAK_NAME = Ahmed

Ahmed_FILES = Tweak.x
Ahmed_CFLAGS = -fobjc-arc
Ahmed_FRAMEWORKS = UIKit Foundation Security

include $(THEOS_MAKE_PATH)/tweak.mk
