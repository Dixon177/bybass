#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <UIKit/UIKit.h>

// --- [ وظيفة الحصول على عنوان اللعبة الأساسي ] ---
uintptr_t get_base() { 
    return (uintptr_t)_dyld_get_image_header(0); 
}

// --- [ 1. قسم الحماية الشاملة - SECURITY BYPASS ] ---
// مستخرج ومحدث من ملفات الحماية لضمان تخطي فحص ACE
void apply_full_bypass() {
    uintptr_t base = get_base();
    
    // تعطيل فحص الحماية ومنع باند الـ 10 دقائق (Heartbeat Patch)
    *(uint32_t *)(base + 0x6DA2F10) = 0xD503201F; 
    
    // حماية ضد تصوير الشاشة (تمنع نظام ACE من رصد التلوين)
    *(uint32_t *)(base + 0x6E1B4A0) = 0xD503201F;
    
    // إخفاء ملف الـ dylib ومنع اكتشاف أدوات الحقن
    *(uint32_t *)(base + 0x6B1A2C0) = 0xD503201F;
}

// --- [ 2. قسم الإيمبوت المخصص - CUSTOM AIMBOT ] ---
void activate_smart_aim() {
    uintptr_t base = get_base();
    
    // الهدف: الرقبة (Bone ID: 4) لضمان القتل السريع دون إثارة الشك بالهيدشوت
    uintptr_t bone_addr = base + 0x5E2A1B0; 
    *(int *)(bone_addr) = 4; 

    // مسافة العمل: 150 متر (يتوقف الإيمبوت بعد هذه المسافة للأمان)
    uintptr_t dist_addr = base + 0x5E2A1BC;
    *(float *)(dist_addr) = 150.0f;

    // تجاهل الأعداء في حالة السقوط (Ignore Knocked)
    uintptr_t ignore_knock_addr = base + 0x5E2A1C0;
    *(bool *)(ignore_knock_addr) = true;
}

// --- [ 3. قسم التعديلات والخصائص - MOD FEATURES ] ---
void activate_game_mods() {
    uintptr_t base = get_base();
    
    // ثبات السلاح 100% (Vertical & Horizontal Recoil)
    *(uint32_t *)(base + 0x72A3BC8) = 0xD503201F;
    *(uint32_t *)(base + 0x72A3BCC) = 0xD503201F;
    
    // التلوين الذكي (Chams) - رؤية الأعداء خلف الجدران
    *(uint32_t *)(base + 0x6B21F40) = 0xD503201F;
    
    // فتح الفريمات العالية (90 FPS)
    *(uint32_t *)(base + 0x6A1B2C4) = 0xD503201F;
}

// --- [ 4. رسالة الترحيب - تصحيح خطأ keyWindow لنظام iOS 13+ ] ---
void show_welcome_msg() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *activeWindow = nil;
        if (@available(iOS 13.0, *)) {
            for (UIWindowScene* scene in [UIApplication sharedApplication].connectedScenes) {
                if (scene.activationState == UISceneActivationStateForegroundActive) {
                    activeWindow = scene.windows.firstObject;
                    break;
                }
            }
        } else {
            activeWindow = [UIApplication sharedApplication].keyWindow;
        }

        if (activeWindow) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ahmed VIP Project" 
                message:@"تم تفعيل الحماية والخصائص بنجاح\n(Neck Aim | 150m | Anti-Ban)" 
                preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"ابدأ اللعب" style:UIAlertActionStyleDefault handler:nil]];
            [activeWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

// --- [ نقطة الانطلاق والتحكم الزمني ] ---
%ctor {
    // تفعيل الحماية فور تشغيل اللعبة (قبل أي فحص)
    apply_full_bypass();
    
    // تأخير تفعيل الخصائص 30 ثانية لتجاوز لودينج الحماية الأولي
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        activate_smart_aim();
        activate_game_mods();
        show_welcome_msg();
        
        NSLog(@"[Ahmed_VIP] All modules injected successfully.");
    });
}
