#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <dlfcn.h>
#import <UIKit/UIKit.h>

// --- 1. حماية النظام ومنع اكتشاف المصحح (Anti-Debug) ---
void apply_security() {
    void *handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
    ptrace_ptr_t ptrace_ptr = (ptrace_ptr_t)dlsym(handle, "ptrace");
    if (ptrace_ptr) ptrace_ptr(31, 0, 0, 0); // PT_DENY_ATTACH
}

// --- 2. منع اللعبة من اكتشاف ملف الـ dylib (Stealth) ---
uint32_t (*orig_dyld_image_count)();
uint32_t hook_dyld_image_count() {
    return orig_dyld_image_count() - 1; 
}

// --- 3. منع إرسال بيانات الغش والبلاغات (Anti-Report) ---
%hook TDataCollector
- (void)collectData:(int)dataType { return; }
%end

%hook TLogManager
- (void)uploadLogsToServer:(id)logs { return; }
%end

%hook ACEDataCollector
- (void)sendReport:(id)arg1 type:(int)arg2 { return; }
%end

%hook TSDKReport
+ (void)saveReportData:(id)data { return; }
%end

// --- 4. تعطيل تصوير الشاشة عند البلاغ ---
%hook UIScreen
- (UIView *)snapshotViewAfterScreenUpdates:(BOOL)afterUpdates { return nil; }
%end

// --- 5. تزييف معلومات الجهاز لتجنب باند الهاردوير ---
%hook UIDevice
- (NSString *)name { return @"iPhone"; }
- (NSString *)systemVersion { return @"16.0"; }
- (NSString *)model { return @"iPhone15,2"; }
%end

// --- تشغيل الحماية ---
%ctor {
    apply_security();
    
    // تأخير الحقن لضمان استقرار اللعبة
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"[Ahmed_Bypass_V2] Ultra Shield Active & Stealth Engaged.");
    });
}
