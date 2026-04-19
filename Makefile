export THEOS_DEVICE_IP = 127.0.0.1
export THEOS_DEVICE_PORT = 2222

# استهداف أحدث الأنظمة لضمان التوافق مع iOS 15 وما فوق
TARGET := iphone:clang:latest:15.0
ARCHS = arm64 arm64e

DEBUG = 0
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

# اسم التويك يطابق ملف الـ plist عندك على GitHub
TWEAK_NAME = AhmedBypass

AhmedBypass_FILES = Tweak.x
AhmedBypass_CFLAGS = -fobjc-arc
# إضافة مكتبة Security و QuartzCore لضمان عمل الحماية والرسائل
AhmedBypass_FRAMEWORKS = UIKit Foundation Security QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk
