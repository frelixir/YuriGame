#import <Foundation/Foundation.h>
#include <crt_externs.h>
#include <string.h>

__attribute__((constructor))
static void init(void) {
    @autoreleasepool {
        NSString *path = [NSString stringWithContentsOfFile:
            [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]
            stringByAppendingPathComponent:@"boot.txt"]
            encoding:NSUTF8StringEncoding error:nil];
        (*_NSGetArgv())[0] = strdup([path UTF8String]);
    }
}