#import "LCAppDelegate.h"
#import "LCRootViewController.h"

@implementation LCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *frameworksPath = [[NSBundle mainBundle] privateFrameworksPath];
    NSString *documentsApplicationsPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"Applications"];
    
    if ([fileManager fileExistsAtPath:frameworksPath]) {
        NSError *error = nil;
        NSArray *frameworkContents = [fileManager contentsOfDirectoryAtPath:frameworksPath error:&error];
        
        for (NSString *item in frameworkContents) {
            if ([item hasSuffix:@".app.framework"]) {
                NSString *frameworkFolderPath = [frameworksPath stringByAppendingPathComponent:item];
                BOOL isDirectory = NO;
                
                if ([fileManager fileExistsAtPath:frameworkFolderPath isDirectory:&isDirectory] && isDirectory) {
                    NSString *appName = [item substringToIndex:item.length - @".framework".length];
                    NSString *targetAppPath = [documentsApplicationsPath stringByAppendingPathComponent:appName];
                    
                    if (![fileManager fileExistsAtPath:documentsApplicationsPath]) {
                        [fileManager createDirectoryAtPath:documentsApplicationsPath withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    
                    if (![fileManager fileExistsAtPath:targetAppPath]) {
                        [fileManager createDirectoryAtPath:targetAppPath withIntermediateDirectories:YES attributes:nil error:nil];
                    }
                    
                    NSArray *frameworkItems = [fileManager contentsOfDirectoryAtPath:frameworkFolderPath error:nil];
                    
                    for (NSString *frameworkItem in frameworkItems) {
                        NSString *sourceItemPath = [frameworkFolderPath stringByAppendingPathComponent:frameworkItem];
                        NSString *targetItemPath = [targetAppPath stringByAppendingPathComponent:frameworkItem];
                        
                        if (![fileManager fileExistsAtPath:targetItemPath]) {
                            [fileManager createSymbolicLinkAtPath:targetItemPath withDestinationPath:sourceItemPath error:nil];
                        }
                    }
                }
            }
        }
    }
    
    LCRootViewController *viewController = [[LCRootViewController alloc] init];
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _rootViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    _window.rootViewController = _rootViewController;
    [_window makeKeyAndVisible];
    return YES;
}

@end