# اسم الجهاز اللي راح يسوي الـ Compile (خارجي)
TARGET := iphone:clang:latest:14.0
ARCHS = arm64 arm64e

# اسم المشروع (الناتج النهائي)
TWEAK_NAME = AWSS3

# الملفات البرمجية (ملف التويك مالتك)
AWSS3_FILES = Tweak.x
AWSS3_CFLAGS = -fobjc-arc -w

# المكتبات المطلوبة من النظام
AWSS3_FRAMEWORKS = UIKit Foundation CoreGraphics Security

# إعدادات المطور (أحمد VIP)
INSTALL_TARGET_PROCESSES = ShadowTrackerExtra

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 ShadowTrackerExtra"
