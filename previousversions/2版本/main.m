#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <mach-o/loader.h>
#include <objc/runtime.h>
#include <dlfcn.h>

static NSBundle *guestBundle;

@implementation NSBundle(iOS14)
+ (id)Yi_mainBundle { return guestBundle ?: [self Yi_mainBundle]; }
@end

static void *GetEntry(void *handle) {
    struct mach_header_64 *hdr = dlsym(handle, "_mh_execute_header");
    uint8_t *p = (uint8_t *)hdr + sizeof(*hdr);
    for (int i = 0; i < hdr->ncmds; i++, p += ((struct load_command *)p)->cmdsize)
        if (((struct load_command *)p)->cmd == LC_MAIN)
            return (void *)((uintptr_t)hdr + ((struct entry_point_command *)p)->entryoff);
    return NULL;
}

static int LaunchApp(NSString *name, int argc, char *argv[]) {
    NSBundle *appBundle = [NSBundle bundleWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:[NSString stringWithFormat:@"Applications/%@", name]]];
    guestBundle = appBundle;
    method_exchangeImplementations(class_getClassMethod(NSBundle.class, @selector(mainBundle)), class_getClassMethod(NSBundle.class, @selector(Yi_mainBundle)));
    void *entry = GetEntry(dlopen(appBundle.executablePath.UTF8String, RTLD_LAZY | RTLD_GLOBAL));
    argv[0] = (char *)appBundle.executablePath.UTF8String;
    return ((int (*)(int, char **))entry)(argc, argv);
}

int main(int argc, char *argv[]) {
    @autoreleasepool {
        dlopen("@executable_path/Frameworks/YuriGameUI.dylib", RTLD_LAZY);
        NSString *sel = [NSUserDefaults.standardUserDefaults stringForKey:@"selected"];
        if (sel.length) {
            [NSUserDefaults.standardUserDefaults removeObjectForKey:@"selected"];
            return LaunchApp(sel, argc, argv);
        }
        return UIApplicationMain(argc, argv, nil, @"YiAppDelegate");
    }
}