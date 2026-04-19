#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <mach/mach.h>

uintptr_t get_base() { return (uintptr_t)_dyld_get_image_header(0); }

// دالة الكتابة الاحترافية لمنع الكراش
void write_memory(uintptr_t offset, uint32_t data) {
    uintptr_t address = get_base() + offset;
    vm_protect(mach_task_self(), (vm_address_t)address, sizeof(data), FALSE, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    *(uint32_t *)address = data;
    vm_protect(mach_task_self(), (vm_address_t)address, sizeof(data), FALSE, VM_PROT_READ | VM_PROT_EXECUTE);
}

void apply_all() {
    // حماية (Bypass)
    write_memory(0x6DA2F10, 0xD503201F);
    
    // ثبات سبيكة
    write_memory(0x72A3BC8, 0xD503201F);
    
    // تلوين
    write_memory(0x6B21F40, 0xD503201F);
}

%ctor {
    // تأخير طويل (50 ثانية) للتأكد من استقرار اللعبة
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(50 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        apply_all();
    });
}
