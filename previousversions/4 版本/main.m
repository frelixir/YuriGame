#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <mach-o/loader.h>
#include <objc/runtime.h>
#include <dlfcn.h>

static NSBundle *guestBundle;

@implementation NSBundle(iOS14)
+ (id)Yi_mainBundle { return guestBundle ?: [self Yi_mainBundle]; }
@end

int main(int argc, char *argv[]) {
    dlopen("@executable_path/Frameworks/YuriGameUI.dylib", RTLD_LAZY);

    NSString *sel = [NSUserDefaults.standardUserDefaults stringForKey:@"selected"];
    if (!sel) return UIApplicationMain(argc, argv, nil, @"YiAppDelegate");

[NSUserDefaults.standardUserDefaults removeObjectForKey:@"selected"];

    NSBundle *appBundle = [NSBundle bundleWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/Applications/%@", sel]];

    guestBundle = appBundle;

method_exchangeImplementations(class_getClassMethod(NSBundle.class, @selector(mainBundle)), class_getClassMethod(NSBundle.class, @selector(Yi_mainBundle)));

    struct mach_header_64 *hdr = dlsym(dlopen(appBundle.executablePath.UTF8String, RTLD_LAZY), "_mh_execute_header");
    struct load_command *cmd = (void *)hdr + sizeof(*hdr);
    while (cmd->cmd != LC_MAIN) cmd = (void *)cmd + cmd->cmdsize;

    argv[0] = (char *)appBundle.executablePath.UTF8String;
    return ((int (*)(int, char **))((uintptr_t)hdr + ((struct entry_point_command *)cmd)->entryoff))(argc, argv);
}