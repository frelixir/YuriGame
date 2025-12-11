#import <UIKit/UIKit.h>

@interface LCRootViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray<NSString *> *objects;
@property (nonatomic, strong) NSString *frameworksPath;

@end

@implementation LCRootViewController

- (void)loadView {
    [super loadView];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    self.frameworksPath = [[NSBundle mainBundle] pathForResource:@"Frameworks" ofType:nil];
    
    self.objects = [[fm contentsOfDirectoryAtPath:self.frameworksPath error:nil] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id object, NSDictionary *bindings) {
        return [object hasSuffix:@".app.framework"];
    }]].mutableCopy;
    
    for (NSInteger i = 0; i < self.objects.count; i++) {
        NSString *fullName = self.objects[i];
        if ([fullName hasSuffix:@".framework"]) {
            NSString *appName = [fullName substringToIndex:fullName.length - @".framework".length];
            self.objects[i] = appName;
        }
    }
    
    self.title = @"YuriGame";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = self.objects[indexPath.row];
    return cell;
}

- (void)attemptOpenURLWithCount:(NSInteger)count {
    if (count >= 8) {
        exit(0);
    }
    
    NSURL *url = [NSURL URLWithString:@"yurigame://"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            if (success) {
                exit(0);
            } else {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self attemptOpenURLWithCount:count + 1];
                });
            }
        }];
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self attemptOpenURLWithCount:count + 1];
        });
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *selectedApp = self.objects[indexPath.row];
    [NSUserDefaults.standardUserDefaults setObject:selectedApp forKey:@"selected"];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"应用已选择" 
                                                                   message:[NSString stringWithFormat:@"已选择应用: %@", selectedApp]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self attemptOpenURLWithCount:0];
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

@end