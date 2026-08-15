#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <mach-o/dyld.h>
#include <mach-o/loader.h>
#include <objc/runtime.h>
#include <dlfcn.h>
#include <unistd.h>

NSBundle *guestBundle;

@implementation NSBundle(iOS14)
+ (id)Yi_mainBundle { return guestBundle ?: [self Yi_mainBundle]; }
@end

static void *GetAppEntry(uint32_t imageIndex) {
    const struct mach_header_64 *hdr = (const struct mach_header_64 *)_dyld_get_image_header(imageIndex);
    uint8_t *ptr = (uint8_t *)hdr + sizeof(struct mach_header_64);
    for (int i = 0; i < hdr->ncmds; ++i) {
        struct load_command *cmd = (struct load_command *)ptr;
        if (cmd->cmd == LC_MAIN) {
            struct entry_point_command ec = *(struct entry_point_command *)ptr;
            return (void *)((uintptr_t)hdr + ec.entryoff);
        }
        ptr += cmd->cmdsize;
    }
    return NULL;
}

static void invokeAppMain(NSString *selectedApp, int argc, char *argv[]) {
    [NSUserDefaults.standardUserDefaults removeObjectForKey:@"selected"];
    NSString *doc = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].lastObject.path;
    NSString *bundlePath = [NSString stringWithFormat:@"%@/Applications/%@", doc, selectedApp];
    NSBundle *appBundle = [[NSBundle alloc] initWithPath:bundlePath];
    NSString *dataPath = [NSString stringWithFormat:@"%@/%@", doc, appBundle.bundleIdentifier];
    setenv("CFFIXED_USER_HOME", dataPath.UTF8String, 1);
    setenv("HOME", dataPath.UTF8String, 1);
    for (NSString *d in @[@"Library/Caches", @"Library/Preferences", @"Documents"]) {
        [NSFileManager.defaultManager createDirectoryAtPath:[dataPath stringByAppendingPathComponent:d]
                                withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *tmp = [dataPath stringByAppendingPathComponent:@"tmp"];
    remove(tmp.UTF8String);
    symlink(getenv("TMPDIR"), tmp.UTF8String);
    guestBundle = appBundle;
    method_exchangeImplementations(
        class_getClassMethod(NSBundle.class, @selector(mainBundle)),
        class_getClassMethod(NSBundle.class, @selector(Yi_mainBundle))
    );
    uint32_t idx = _dyld_image_count();
    dlopen(appBundle.executablePath.UTF8String, RTLD_LAZY | RTLD_GLOBAL);
    void *entry = GetAppEntry(idx);
    [appBundle loadAndReturnError:nil];
    argv[0] = (char *)appBundle.executablePath.UTF8String;
    ((int (*)(int, char **))entry)(argc, argv);
}

int YuriGameMain(int argc, char *argv[]) {
    @autoreleasepool {
        dlopen("@executable_path/Frameworks/YuriGameUI.dylib", RTLD_LAZY);
        NSString *sel = [NSUserDefaults.standardUserDefaults stringForKey:@"selected"];
        if (sel.length > 0) invokeAppMain(sel, argc, argv);
        return UIApplicationMain(argc, argv, nil, @"YiAppDelegate");
    }
}

int main(int argc, char *argv[]) {
    return YuriGameMain(argc, argv);
}