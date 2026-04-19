#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>

// --- [ الماكرو الاحترافي للكتابة على الذاكرة ] ---
#define PATCH(offset, data) write_memory(get_real_offset(offset), data)

uintptr_t get_real_offset(uintptr_t offset) {
    static uintptr_t base = 0;
    if (base == 0) base = (uintptr_t)_dyld_get_image_header(0);
    return base + offset;
}

void write_memory(uintptr_t address, uint32_t data) {
    if (!address) return;
    mach_port_t task = mach_task_self();
    vm_protect(task, (vm_address_t)address, 4, FALSE, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    *(uint32_t *)address = data;
    vm_protect(task, (vm_address_t)address, 4, FALSE, VM_PROT_READ | VM_PROT_EXECUTE);
}

// --- [ المحرك الأساسي للهاك ] ---

void load_premium_logic() {
    // 1. قسم الحماية (Bypass) - ضروري لمنع الكراش
    PATCH(0x6DA2F10, 0xD503201F); 
    PATCH(0x6E1B4A0, 0xD503201F); 
    PATCH(0x6B1A2C0, 0xD503201F); 

    // 2. تفعيل التلوين (Smart Chams / Wallhack) 
    // هذا السطر هو المسؤول عن صبغ اللاعبين بألوان واضحة خلف الجدران
    PATCH(0x6B21F40, 0xD503201F); 

    // 3. ثبات السلاح (Recoil Control)
    PATCH(0x72A3BC8, 0xD503201F); 
    PATCH(0x72A3BCC, 0xD503201F); 

    // 4. الإيمبوت الذكي (Neck - 150m)
    uintptr_t base = (uintptr_t)_dyld_get_image_header(0);
    *(int *)(base + 0x5E2A1B0) = 4;        // هدف الرقبة
    *(float *)(base + 0x5E2A1BC) = 150.0f; // مسافة اللقط
    *(bool *)(base + 0x5E2A1C0) = true;    // تجاهل النووك
}

%ctor {
    // تأخير التفعيل لضمان تخطي فحص ACE بنجاح
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        load_premium_logic();
        NSLog(@"[Ahmed_VIP] All Features (Including Chams) Injected.");
    });
}
