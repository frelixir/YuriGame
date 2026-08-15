#import <Foundation/Foundation.h>
#import "fishhook.h"
#include <crt_externs.h>
#include <string.h>

static NSString *bootPath;
static NSArray<NSString *> *(*orig)(NSSearchPathDirectory, NSSearchPathDomainMask, BOOL);

NSArray<NSString *> *redirected(NSSearchPathDirectory d, NSSearchPathDomainMask m, BOOL e) {
    NSArray<NSString *> *p = orig(d, m, e);
    if (d == NSDocumentDirectory) {
        NSString *newPath = [bootPath stringByAppendingPathComponent:@"savedata"];
        [[NSFileManager defaultManager] createDirectoryAtPath:newPath withIntermediateDirectories:YES attributes:nil error:nil];
        return @[newPath];
    }
    return p;
}

__attribute__((constructor)) static void init() {
    @autoreleasepool {
        NSString *path = [NSString stringWithContentsOfFile:
            [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]
            stringByAppendingPathComponent:@"boot.txt"]
            encoding:NSUTF8StringEncoding error:nil];
        bootPath = path;
        (*_NSGetArgv())[0] = strdup([path UTF8String]);
        struct rebinding r = {"NSSearchPathForDirectoriesInDomains", (void *)redirected, (void **)&orig};
        rebind_symbols(&r, 1);
    }
}