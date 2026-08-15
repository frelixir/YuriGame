#import <Foundation/Foundation.h>
#include <crt_externs.h>
#include <string.h>

__attribute__((constructor))
static void init(void) {
    @autoreleasepool {
        NSString *boot = [NSString stringWithContentsOfFile:
            [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject]
            stringByAppendingPathComponent:@"boot.txt"]
            encoding:NSUTF8StringEncoding error:nil];
        if (!boot) return;
        NSRange r = [boot rangeOfString:@":"];
        if (r.location == NSNotFound) return;
        NSString *dir = [[boot substringFromIndex:r.location+1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (!dir.length) return;

        char **argv = *_NSGetArgv();
        argv[0] = strdup([dir UTF8String]);
    }
}