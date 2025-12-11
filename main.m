#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <mach/mach.h>
#include <mach-o/dyld.h>
#include <mach-o/loader.h>
#include <objc/runtime.h>
#include <dlfcn.h>
#include <fcntl.h>
#include <unistd.h>

@interface NSUserDefaults(private)
+ (void)setStandardUserDefaults:(id)defaults;
@end

const char **_CFGetProgname(void);
const char **_CFGetProcessPath(void);

static NSBundle *overwrittenBundle;

@implementation NSBundle(LC_iOS12)
+ (id)hooked_mainBundle {
    if (overwrittenBundle) {
        return overwrittenBundle;
    }
    return self.hooked_mainBundle;
}
@end

static int (*appMain)(int, char**);

static void overwriteExecPath(NSString *bundlePath) {
    char *path = (char *)_dyld_get_image_name(0);
    const char *newPath = [bundlePath stringByAppendingPathComponent:@"YuriGame"].UTF8String;
    size_t maxLen = strlen(path);
    size_t newLen = strlen(newPath);
    assert(maxLen >= newLen);
    close(open(newPath, O_CREAT | S_IRUSR | S_IWUSR));
    
    vm_protect(mach_task_self(), (vm_address_t)path, maxLen, false, VM_PROT_READ | VM_PROT_WRITE | VM_PROT_COPY);
    
    bzero(path, maxLen);
    strncpy(path, newPath, newLen);
}

static void *getAppEntryPoint(void *handle, uint32_t imageIndex) {
    uint32_t entryoff = 0;
    const struct mach_header_64 *header = (struct mach_header_64 *)_dyld_get_image_header(imageIndex);
    uint8_t *imageHeaderPtr = (uint8_t*)header + sizeof(struct mach_header_64);
    struct load_command *command = (struct load_command *)imageHeaderPtr;
    for(int i = 0; i < header->ncmds; ++i) {
        if(command->cmd == LC_MAIN) {
            struct entry_point_command ucmd = *(struct entry_point_command *)imageHeaderPtr;
            entryoff = ucmd.entryoff;
            break;
        }
        imageHeaderPtr += command->cmdsize;
        command = (struct load_command *)imageHeaderPtr;
    }
    assert(entryoff > 0);
    return (void *)header + entryoff;
}

static void invokeAppMain(NSString *selectedApp, int argc, char *argv[]) {
    [NSUserDefaults.standardUserDefaults removeObjectForKey:@"selected"];

    NSString *docPath = [NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]
        .lastObject.path;
    NSString *bundlePath = [NSString stringWithFormat:@"%@/Applications/%@", docPath, selectedApp];
    NSBundle *appBundle = [[NSBundle alloc] initWithPath:bundlePath];

    NSString *newHomePath = [NSString stringWithFormat:@"%@/Data/%@", docPath, appBundle.infoDictionary[@"CFBundleIdentifier"]];
    setenv("CFFIXED_USER_HOME", newHomePath.UTF8String, 1);
    setenv("HOME", newHomePath.UTF8String, 1);
    
    NSString *cachePath = [NSString stringWithFormat:@"%@/Library/Caches", newHomePath];
    [NSFileManager.defaultManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    
    [NSUserDefaults setStandardUserDefaults:[[NSUserDefaults alloc] initWithSuiteName:appBundle.bundleIdentifier]];

    const char **path = _CFGetProcessPath();
    const char *oldPath = *path;
    *path = appBundle.executablePath.UTF8String;
    overwriteExecPath(appBundle.bundlePath);

    uint32_t appIndex = _dyld_image_count();
    void *appHandle = dlopen(appBundle.executablePath.UTF8String, RTLD_LAZY|RTLD_LOCAL|RTLD_FIRST);
    if (!appHandle || (uint64_t)appHandle > 0xf00000000000) {
        *path = oldPath;
        return;
    }

    appMain = getAppEntryPoint(appHandle, appIndex);
    if (!appMain) {
        *path = oldPath;
        return;
    }

    if (![appBundle loadAndReturnError:nil]) {
        *path = oldPath;
        return;
    }

    method_exchangeImplementations(class_getClassMethod(NSBundle.class, @selector(mainBundle)), class_getClassMethod(NSBundle.class, @selector(hooked_mainBundle)));
    overwrittenBundle = appBundle;

    NSMutableArray<NSString *> *objcArgv = NSProcessInfo.processInfo.arguments.mutableCopy;
    objcArgv[0] = appBundle.executablePath;
    [NSProcessInfo.processInfo performSelector:@selector(setArguments:) withObject:objcArgv];
    NSProcessInfo.processInfo.processName = appBundle.infoDictionary[@"CFBundleExecutable"];
    *_CFGetProgname() = NSProcessInfo.processInfo.processName.UTF8String;

    argv[0] = (char *)NSBundle.mainBundle.executablePath.UTF8String;
    appMain(argc, argv);
}

int YuriGameMain(int argc, char *argv[]) {
    NSString *selectedApp = [NSUserDefaults.standardUserDefaults stringForKey:@"selected"];
    if (selectedApp) {
        invokeAppMain(selectedApp, argc, argv);
    }

    void *YuriGameUIHandle = dlopen("@executable_path/Frameworks/YuriGameUI.dylib", RTLD_LAZY);
    assert(YuriGameUIHandle);
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, @"LCAppDelegate");
    }
}

int main(int argc, char *argv[]) {
    assert(appMain != NULL);
    return appMain(argc, argv);
}