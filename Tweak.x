#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <UIKit/UIKit.h>
#import <sys/sysctl.h>

// --- [ الوصول لقاعدة بيانات اللعبة ] ---
uintptr_t get_base() { return (uintptr_t)_dyld_get_image_header(0); }

// --- [ 1. قسم الحماية - BYPASS ] ---
// هذي الحماية اللي سحبناها من ملف AWSS3 لمنع الباند
void apply_security_bypass() {
    uintptr_t base = get_base();
    
    // تعطيل فحص الحماية (Security Heartbeat) لنسخة 4.3.0
    *(uint32_t *)(base + 0x6DA2F10) = 0xD503201F; 
    
    // إخفاء التعديلات عن نظام تصوير الشاشة (Anti-Cheat Screenshot)
    *(uint32_t *)(base + 0x6E1B4A0) = 0xD503201F;
    
    // حماية إخفاء ملف الـ dylib المحقون
    *(uint32_t *)(base + 0x6B1A2C0) = 0xD503201F;
}

// --- [ 2. قسم الخصائص - FEATURES ] ---

// أ- الثبات (Recoil)
void activate_recoil() {
    uintptr_t base = get_base();
    *(uint32_t *)(base + 0x72A3BC8) = 0xD503201F;
    *(uint32_t *)(base + 0x72A3BCC) = 0xD503201F;
}

// ب- التلوين الذكي (Smart Chams)
void activate_smart_chams() {
    uintptr_t base = get_base();
    *(uint32_t *)(base + 0x6B21F40) = 0xD503201F;
}

// ج- الإيمبوت الذكي (Neck Aimbot)
void activate_smart_aimbot() {
    uintptr_t base = get_base();
    
    // تحديد الهدف: الرقبة (Bone ID: 4)
    uintptr_t bone_addr = base + 0x5E2A1B0; 
    *(int *)(bone_addr) = 4; 

    // المسافة: 150 متر فقط
    uintptr_t dist_addr = base + 0x5E2A1BC;
    *(float *)(dist_addr) = 150.0f;

    // تجاهل النوك
    uintptr_t ignore_knock_addr = base + 0x5E2A1C0;
    *(bool *)(ignore_knock_addr) = true;
}

// د- فريمات 90 FPS
void activate_fps() {
    uintptr_t base = get_base();
    *(uint32_t *)(base + 0x6A1B2C4) = 0xD503201F;
}

// --- [ رسالة التفعيل ] ---
void show_welcome_msg() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ahmed VIP" 
            message:@"تم تفعيل الحماية والخصائص بنجاح\n(Security Bypass + Smart Aimbot)" 
            preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"تم" style:UIAlertActionStyleDefault handler:nil]];
        [window.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

// --- [ نقطة الانطلاق والتشغيل ] ---
%ctor {
    // تشغيل الحماية فوراً وبدون تأخير
    apply_security_bypass();
    
    // تفعيل الخصائص بعد 30 ثانية لضمان الأمان
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        activate_recoil();
        activate_smart_chams();
        activate_smart_aimbot();
        activate_fps();
        
        show_welcome_msg();
        
        NSLog(@"[Ahmed_Project] Fully Protected & Loaded.");
    });
}
