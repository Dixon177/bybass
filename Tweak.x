#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>

// وظيفة جلب عنوان اللعبة
uintptr_t get_base() { 
    return (uintptr_t)_dyld_get_image_header(0); 
}

// دالة الكتابة الآمنة
void safe_write(uintptr_t offset, uint32_t data) {
    uintptr_t address = get_base() + offset;
    vm_protect(mach_task_self(), (vm_address_t)address, sizeof(data), FALSE, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    *(uint32_t *)address = data;
    vm_protect(mach_task_self(), (vm_address_t)address, sizeof(data), FALSE, VM_PROT_READ | VM_PROT_EXECUTE);
}

%ctor {
    // تأخير 60 ثانية لضمان استقرار اللعبة والدخول للوبي
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 1. حماية صامتة (Bypass)
        safe_write(0x6DA2F10, 0xD503201F);
        
        // 2. ثبات السلاح (فقط للتجربة)
        safe_write(0x72A3BC8, 0xD503201F);
        
        // 3. التلوين الذكي (فقط للتجربة)
        safe_write(0x6B21F40, 0xD503201F);
        
        NSLog(@"[Ahmed_VIP] Test Build Loaded Successfully.");
    });
}
