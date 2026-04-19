#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <UIKit/UIKit.h>

// وظيفة جلب عنوان اللعبة - الطريقة الأكثر استقراراً
uintptr_t get_base() {
    return (uintptr_t)_dyld_get_image_header(0);
}

// دالة الكتابة الآمنة على الذاكرة (تمنع الكراش)
void patch_offset(uintptr_t offset, uint32_t data) {
    uintptr_t address = get_base() + offset;
    if (address > get_base()) {
        *(uint32_t *)address = data;
    }
}

// 1. الحماية (Bypass)
void apply_bypass() {
    patch_offset(0x6DA2F10, 0xD503201F); // Security Heartbeat
    patch_offset(0x6E1B4A0, 0xD503201F); // Anti-Screenshot
}

// 2. الخصائص الأساسية
void apply_features() {
    // ثبات السلاح
    patch_offset(0x72A3BC8, 0xD503201F);
    patch_offset(0x72A3BCC, 0xD503201F);
    
    // تلوين ذكي
    patch_offset(0x6B21F40, 0xD503201F);

    // إعدادات الإيمبوت (الرقبة - 150م)
    uintptr_t base = get_base();
    *(int *)(base + 0x5E2A1B0) = 4;        // Neck
    *(float *)(base + 0x5E2A1BC) = 150.0f; // 150m
}

%ctor {
    // تفعيل الحماية فوراً
    apply_bypass();
    
    // تأخير تفعيل الخصائص 40 ثانية (لضمان تجاوز اللودينج بسلام)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(40 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        apply_features();
        NSLog(@"[Ahmed_VIP] System Stabilized & Loaded.");
    });
}
