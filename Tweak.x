#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <dlfcn.h>

// منع اللعبة من اكتشاف المصحح
void apply_security() {
    void *handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
    ptrace_ptr_t ptrace_ptr = (ptrace_ptr_t)dlsym(handle, "ptrace");
    if (ptrace_ptr) ptrace_ptr(31, 0, 0, 0);
}

// تعطيل كواشف البيانات والبلاغات
%hook TDataCollector
- (void)collectData:(int)dataType { return; }
%end

%hook TLogManager
- (void)uploadLogsToServer:(id)logs { return; }
%end

%hook ACEDataCollector
- (void)sendReport:(id)arg1 type:(int)arg2 { return; }
%end

%ctor {
    apply_security();
    
    // تشغيل الحماية بعد 10 ثواني من فتح اللعبة
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"[Ahmed_Bypass] Shield Active.");
    });
}
