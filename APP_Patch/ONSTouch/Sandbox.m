#import <Foundation/Foundation.h>
#import "fishhook.h"

static NSArray<NSString *> *(*orig)(NSSearchPathDirectory, NSSearchPathDomainMask, BOOL);

NSArray<NSString *> *redirected(NSSearchPathDirectory d, NSSearchPathDomainMask m, BOOL e) {
    NSArray<NSString *> *p = orig(d, m, e);
    if (d == NSDocumentDirectory && p.count > 0) {
        return @[[[p firstObject] stringByAppendingPathComponent:@"ONSPlayer"]];
    }
    return p;
}

__attribute__((constructor)) static void init() {
    struct rebinding r = {"NSSearchPathForDirectoriesInDomains", redirected, (void **)&orig};
    rebind_symbols(&r, 1);
}