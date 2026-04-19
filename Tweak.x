#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <UIKit/UIKit.h>

// --- [ الحصول على عنوان اللعبة الأساسي ] ---
uintptr_t get_base() { 
    return (uintptr_t)_dyld_get_image_header(0); 
}

// --- [ 1. قسم الحماية المستخرجة - BYPASS ] ---
void apply_security_bypass() {
    uintptr_t base = get_base();
    
    // تعطيل فحص الحماية ومنع باند الـ 10 دقائق (أوفستات AWSS3)
    *(uint32_t *)(base + 0x6DA2F10) = 0xD503201F; 
    
    // حماية ضد تصوير الشاشة الأمنية لإخفاء التلوين
    *(uint32_t *)(base + 0x6E1B4A0) = 0xD503201F;
    
    // منع اكتشاف ملف الـ dylib بذاكرة النظام
    *(uint32_t *)(base + 0x6B1A2C0) = 0xD503201F;
}

// --- [ 2. قسم الإيمبوت الذكي - SMART AIMBOT ] ---
void activate_smart_aim() {
    uintptr_t base = get_base();
    
    // تحديد الهدف: الرقبة (Neck Bone) بدل الرأس لتفادي الباند
    uintptr_t bone_addr = base + 0x5E2A1B0; 
    *(int *)(bone_addr) = 4; 

    // تحديد مسافة اللقط: 150 متر فقط
    uintptr_t dist_addr = base + 0x5E2A1BC;
    *(float *)(dist_addr) = 150.0f;

    // تجاهل اللاعبين "النوك" (Ignore Knocked)
    uintptr_t ignore_knock_addr = base + 0x5E2A1C0;
    *(bool *)(ignore_knock_addr) = true;
}

// --- [ 3. قسم الخصائص - FEATURES ] ---
void activate_game_mods() {
    uintptr_t base = get_base();
    
    // ثبات السلاح 100% (Recoil Fix)
    *(uint32_t *)(base + 0x72A3BC8) = 0xD503201F;
    *(uint32_t *)(base + 0x72A3BCC) = 0xD503201F;
    
    // تلوين الأعداء (Smart Chams)
    *(uint32_t *)(base + 0x6B21F40) = 0xD503201F;
    
    // فتح فريمات عالية (90 FPS)
    *(uint32_t *)(base + 0x6A1B2C4) = 0xD503201F;
}

// --- [ 4. رسالة التفعيل - حلال المشاكل (Fix for Build Errors) ] ---
void show_ahmed_alert() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        // تصحيح الخطأ اللي طلعلك بالـ GitHub (دعم iOS 13 وصولاً لـ 18)
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
                message:@"تم تفعيل الحماية والخصائص بنجاح\n(Neck Aimbot - 150m - No Recoil)" 
                preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"دخول" style:UIAlertActionStyleDefault handler:nil]];
            [window.rootViewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

// --- [ نقطة انطلاق الهاك ] ---
%ctor {
    // تفعيل الحماية فوراً عند فتح اللعبة
    apply_security_bypass();
    
    // تشغيل الإيمبوت والخصائص بعد 30 ثانية لضمان الأمان
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        activate_smart_aim();
        activate_game_mods();
        show_ahmed_alert();
        
        NSLog(@"[Ahmed_Project] Bypass & Features Loaded Successfully.");
    });
}
