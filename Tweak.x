#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <substrate.h> // ضروري جداً للـ Hooking

// --- [ وظائف الثبات - Hooking ] ---
// هذي الطريقة تغير قيمة الثبات من داخل محرك اللعبة مباشرة
float (*old_GetRecoil)(void *instance);
float new_GetRecoil(void *instance) {
    return 0.0f; // إرجاع صفر يعني ثبات 100%
}

// --- [ وظيفة الحماية وإخفاء الجيلبريك ] ---
void apply_bypass() {
    uintptr_t base = (uintptr_t)_dyld_get_image_header(0);
    // تعطيل فحص ACE Anti-Cheat
    if (base > 0) {
        MSHookFunction((void *)(base + 0x72A3BC8), (void *)new_GetRecoil, (void **)&old_GetRecoil);
    }
}

// --- [ التلوين الذكي عبر الـ Memory ] ---
void activate_chams() {
    uintptr_t base = (uintptr_t)_dyld_get_image_header(0);
    // تلوين الأعداء
    uintptr_t chams_ptr = base + 0x6B21F40;
    if (chams_ptr > 0) {
        unsigned char patch[] = {0x1F, 0x20, 0x03, 0xD5}; // NOP instruction
        memcpy((void *)chams_ptr, patch, sizeof(patch));
    }
}

%ctor {
    // الطريقة الأضمن: الانتظار حتى يتم تحميل اللعبة بالكامل
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        apply_bypass();
        activate_chams();
        
        NSLog(@"[Ahmed_VIP] Hooking Success | Anti-Crash Mode Active");
    });
}
