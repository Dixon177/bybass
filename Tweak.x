#import <Foundation/Foundation.h>
#import <mach-o/dyld.h>
#import <sys/sysctl.h>
#import <dlfcn.h>

// --- Anti-Debug & Bypass Section ---
typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
void apply_security() {
    void *handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    ptrace_ptr_t ptrace_ptr = (ptrace_ptr_t)dlsym(handle, "ptrace");
    if (ptrace_ptr) ptrace_ptr(31, 0, 0, 0);
}

%hookf(int, sysctl, int *name, u_int namelen, void *info, size_t *infosize, void *newp, size_t newlen) {
    int ret = %orig;
    if (namelen >= 4 && name[0] == CTL_KERN && name[1] == KERN_PROC && name[2] == KERN_PROC_ALL) {
        memset(info, 0, *infosize);
    }
    return ret;
}

uint32_t (*orig_dyld_image_count)();
uint32_t hook_dyld_image_count() {
    return orig_dyld_image_count() - 1;
}

// --- Anti-Report & Log Block Section ---
%hook TDataCollector
- (void)collectData:(int)dataType { return; }
%end

%hook TLogManager
- (void)uploadLogsToServer:(id)logs { return; }
%end

%hook UIScreen
- (UIView *)snapshotViewAfterScreenUpdates:(BOOL)afterUpdates { return nil; }
%end

%hook TSDKReport
+ (void)saveReportData:(id)data { return; }
%end

%hook ACEDataCollector
- (void)sendReport:(id)arg1 type:(int)arg2 { return; }
%end

// --- Initialization ---
%ctor {
    apply_security();
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Stealth sequence initialized
    });
}
