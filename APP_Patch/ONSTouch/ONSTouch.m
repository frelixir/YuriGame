#import <UIKit/UIKit.h>
#import <objc/runtime.h>

UIView* F(UIView *v, Class cls, NSString *t) {
    if ([v isKindOfClass:cls]) {
        if (cls == [UIButton class] && t && ![((UIButton*)v).titleLabel.text isEqualToString:t]) return nil;
        return v;
    }
    for (UIView *s in v.subviews) if ((v = F(s, cls, t))) return v;
    return nil;
}

void new(id self, SEL _cmd, BOOL a) {
    UITableView *tv = (UITableView*)F([self view], [UITableView class], nil);
    [tv.delegate tableView:tv didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIButton *btn = (UIButton*)F([self view], [UIButton class], @"Start");
    [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
}

__attribute__((constructor)) void init() {
    Class cls = NSClassFromString(@"MainViewController");
    class_replaceMethod(cls, @selector(viewDidAppear:), (IMP)new, NULL);
}