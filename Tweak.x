#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <UIKit/UIKit.h>

// --- [ وظيفة جلب عنوان اللعبة الأساسي ] ---
uintptr_t get_base() { 
    return (uintptr_t)_dyld_get_image_header(0); 
}

// --- [ 1. قسم الحماية - SECURITY BYPASS ] ---
void apply_bypass() {
    uintptr_t base = get_base();
    // تعطيل فحص الحماية ومنع باند 10 دقائق (مستخرج من ملف AWSS3)
    *(uint32_t *)(base + 0x6DA2F10) = 0xD503201F; 
    // حماية ضد تصوير الشاشة لإخفاء الهاك عن نظام ACE
    *(uint32_t *)(base + 0x6E1B4A0) = 0xD503201F;
    // منع اكتشاف ملف الـ dylib المحقون
    *(uint32_t *)(base + 0x6B1A2C0) = 0xD503201F;
}

// --- [ 2. قسم الإيمبوت الذكي - SMART AIMBOT ] ---
void activate_aimbot() {
    uintptr_t base = get_base();
    // تحديد الهدف: الرقبة (Bone ID: 4) لتقليل نسبة الهيدشوت وتجنب الباند
    uintptr_t bone_addr = base + 0x5E2A1B0; 
    *(int *)(bone_addr) = 4; 
    // تحديد المسافة: 150 متر فقط لضمان الأمان
    *(float *)(base + 0x5E2A1BC) = 150.0f;
    // تجاهل اللاعبين "النوك"
    *(bool *)(base + 0x5E2A1C0) = true;
}

// --- [ 3. قسم الخصائص - FEATURES ] ---
void activate_mods() {
    uintptr_t base = get_base();
    // ثبات السلاح 100% (Vertical & Horizontal)
    *(uint32_t *)(base + 0x72A3BC8) = 0xD503201F;
    *(uint32_t *)(base + 0x72A3BCC) = 0xD503201F;
    // تلوين ذكي للأعداء (Smart Chams)
    *(uint32_t *)(base + 0x6B21F40) = 0xD503201F;
    // فتح الفريمات 90 FPS
    *(uint32_t *)(base + 0x6A1B2C4) = 0xD503201F;
}

// --- [ 4. رسالة التفعيل - إصلاح مشكلة iOS 13+ و keyWindow ] ---
void show_welcome_msg() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        // البحث عن النافذة النشطة بطريقة متوافقة مع SDK 18.5 والأنظمة الجديدة
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
                if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                    window = windowScene.windows.firstObject;
                    break;
                }
            }
        } else {
            window = [UIApplication sharedApplication].keyWindow;
        }

        if (window) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ahmed VIP" 
                message:@"تم تفعيل الحماية والخصائص بنجاح\n(Smart Aimbot - Neck - 150m)" 
                preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"استمرار" style:UIAlertActionStyleDefault handler:nil]];
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

// --- [ نقطة الانطلاق والتشغيل ] ---
%ctor {
    // تفعيل الحماية (Bypass) فوراً عند تشغيل التطبيق
    apply_bypass();
    
    // تفعيل الخصائص بعد 30 ثانية لضمان الأمان التام وتخطي فحص البداية
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        activate_aimbot();
        activate_mods();
        show_welcome_msg();
        
        NSLog(@"[Ahmed_Log] Everything Loaded Successfully.");
    });
}
