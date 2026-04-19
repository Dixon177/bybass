#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <UIKit/UIKit.h>

// الحصول على عنوان قاعدة اللعبة
uintptr_t get_base() { return (uintptr_t)_dyld_get_image_header(0); }

// --- [ 1. الحماية BYPASS ] ---
void apply_bypass() {
    uintptr_t base = get_base();
    *(uint32_t *)(base + 0x6DA2F10) = 0xD503201F; // حماية السيرفر
    *(uint32_t *)(base + 0x6E1B4A0) = 0xD503201F; // منع التصوير
}

// --- [ 2. الإيمبوت الذكي (رقبة) ] ---
void activate_aim() {
    uintptr_t base = get_base();
    *(int *)(base + 0x5E2A1B0) = 4;        // هدف الرقبة
    *(float *)(base + 0x5E2A1BC) = 150.0f; // مسافة 150م
    *(bool *)(base + 0x5E2A1C0) = true;   // تجاهل النوك
}

// --- [ 3. الثبات والتلوين ] ---
void activate_mods() {
    uintptr_t base = get_base();
    *(uint32_t *)(base + 0x72A3BC8) = 0xD503201F; // ثبات
    *(uint32_t *)(base + 0x6B21F40) = 0xD503201F; // تلوين
}

// دالة إظهار الرسالة بطريقة متوافقة مع iOS 13+
void show_msg() {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
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
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ahmed VIP" message:@"Loaded Successfully" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [window.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

%ctor {
    apply_bypass();
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        activate_aim();
        activate_mods();
        show_msg();
    });
}
