#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <UIKit/UIKit.h>

// --- [ وظيفة جلب عنوان اللعبة ] ---
uintptr_t get_base() { 
    return (uintptr_t)_dyld_get_image_header(0); 
}

// --- [ 1. الحماية - BYPASS ] ---
void apply_bypass() {
    uintptr_t base = get_base();
    // تعطيل فحص الحماية (Security Heartbeat)
    *(uint32_t *)(base + 0x6DA2F10) = 0xD503201F; 
    // حماية ضد تصوير الشاشة
    *(uint32_t *)(base + 0x6E1B4A0) = 0xD503201F;
    // إخفاء ملف الـ dylib
    *(uint32_t *)(base + 0x6B1A2C0) = 0xD503201F;
}

// --- [ 2. الإيمبوت - AIMBOT (Neck) ] ---
void activate_aimbot() {
    uintptr_t base = get_base();
    // تحديد الرقبة (Bone ID: 4)
    uintptr_t bone_addr = base + 0x5E2A1B0; 
    *(int *)(bone_addr) = 4; 
    // مسافة 150 متر
    *(float *)(base + 0x5E2A1BC) = 150.0f;
    // تجاهل النوك
    *(bool *)(base + 0x5E2A1C0) = true;
}

// --- [ 3. الخصائص - FEATURES ] ---
void activate_mods() {
    uintptr_t base = get_base();
    // ثبات 100%
    *(uint32_t *)(base + 0x72A3BC8) = 0xD503201F;
    *(uint32_t *)(base + 0x72A3BCC) = 0xD503201F;
    // تلوين ذكي
    *(uint32_t *)(base + 0x6B21F40) = 0xD503201F;
    // 90 FPS
    *(uint32_t *)(base + 0x6A1B2C4) = 0xD503201F;
}

// --- [ نقطة الانطلاق والتشغيل ] ---
%ctor {
    // تشغيل الحماية فوراً
    apply_bypass();
    
    // تشغيل الخصائص بعد 30 ثانية
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        activate_aimbot();
        activate_mods();
        
        // رسالة في سجل النظام بدلاً من الشاشة لتجنب أخطاء البناء
        NSLog(@"[Ahmed_VIP] Mod Successfully Loaded and Protected.");
    });
}
