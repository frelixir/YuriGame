#import <UIKit/UIKit.h>
#import <PTFakeTouch/PTFakeMetaTouch.h>

__attribute__((constructor))
static void constructor() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        CGPoint leftCenter = CGPointMake(screenSize.width / 4.0, screenSize.height / 2.0);
        NSInteger pointId = [PTFakeMetaTouch getAvailablePointId];
        [PTFakeMetaTouch fakeTouchId:pointId AtPoint:leftCenter withTouchPhase:UITouchPhaseBegan];
        [PTFakeMetaTouch fakeTouchId:pointId AtPoint:leftCenter withTouchPhase:UITouchPhaseEnded];
    });
}