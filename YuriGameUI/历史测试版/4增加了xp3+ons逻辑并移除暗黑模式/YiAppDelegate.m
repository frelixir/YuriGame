#import <UIKit/UIKit.h>

@interface YiAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@interface TSRootViewController : UITabBarController <UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImageView *bgImageView;
@end

@interface TSAppTableViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
@end

@interface TSSettingsListController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation YiAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    self.window.rootViewController = [TSRootViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end

@implementation TSRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBackground];
    [self setupTabs];
    [self setupAppearance];
}

- (void)setupBackground {
    self.bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:self.bgImageView atIndex:0];
    
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:@"wallpaper"];
    self.bgImageView.image = data ? [UIImage imageWithData:data] : [UIImage imageNamed:@"default_bg"];
}

- (void)setupTabs {
    UIViewController *vc1 = [self wrap:[TSAppTableViewController new] title:@"游戏库" image:@"gamecontroller"];
    UIViewController *vc3 = [self wrap:[TSSettingsListController new] title:@"设置" image:@"gearshape"];
    
    self.viewControllers = @[vc1, vc3];
}

- (UINavigationController *)wrap:(UIViewController *)vc title:(NSString *)title image:(NSString *)imageName {
    vc.title = title;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [UIImage systemImageNamed:imageName];
    return nav;
}

- (void)setupAppearance {
    UINavigationBarAppearance *navAppearance = [UINavigationBarAppearance new];
    [navAppearance configureWithTransparentBackground];
    navAppearance.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    
    for (UINavigationController *nav in self.viewControllers) {
        nav.navigationBar.standardAppearance = navAppearance;
        nav.navigationBar.scrollEdgeAppearance = navAppearance;
    }
    
    UITabBarAppearance *tabAppearance = [UITabBarAppearance new];
    [tabAppearance configureWithTransparentBackground];
    tabAppearance.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    self.tabBar.standardAppearance = tabAppearance;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    
    if (img) {
        NSData *data = UIImageJPEGRepresentation(img, 1.0);
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"wallpaper"];
        self.bgImageView.image = img;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end

@implementation TSAppTableViewController
{
    UICollectionView *_collectionView;
    NSArray<NSString *> *_gameTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadGameFiles];
    [self setupCollectionView];
}

- (void)loadGameFiles {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = paths.firstObject;
    NSString *gameDir = [documents stringByAppendingPathComponent:@"Game"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSMutableArray *titles = [NSMutableArray array];
    
    if ([fm fileExistsAtPath:gameDir]) {
        NSError *error;
        NSArray *files = [fm contentsOfDirectoryAtPath:gameDir error:&error];
        if (!error) {
            for (NSString *file in files) {
                if ([file.pathExtension isEqualToString:@"txt"]) {
                    NSString *title = [file stringByDeletingPathExtension];
                    [titles addObject:title];
                }
            }
        }
    }
    
    _gameTitles = [titles copy];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 12;
    layout.minimumInteritemSpacing = 12;
    layout.sectionInset = UIEdgeInsetsMake(16, 16, 16, 16);
    
    CGFloat width = (self.view.bounds.size.width - 16 * 3) / 2.0;
    layout.itemSize = CGSizeMake(width, width * 2.0 / 3.0);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GameCell"];
    
    [self.view addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _gameTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GameCell" forIndexPath:indexPath];
    
    for (UIView *subview in cell.contentView.subviews) {
        [subview removeFromSuperview];
    }
    
    cell.contentView.layer.cornerRadius = 12;
    cell.contentView.layer.masksToBounds = YES;
    cell.contentView.layer.borderWidth = 1;
    cell.contentView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1.0].CGColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [UIImage imageNamed:@"default_bg1"];
    [cell.contentView addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = _gameTitles[indexPath.item];
    titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = 2;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    titleLabel.layer.shadowOpacity = 0.8;
    titleLabel.layer.shadowRadius = 2;
    [cell.contentView addSubview:titleLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [titleLabel.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:10],
        [titleLabel.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-10],
        [titleLabel.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor constant:-10]
    ]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = _gameTitles[indexPath.item];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = paths.firstObject;
    NSString *gameDir = [documents stringByAppendingPathComponent:@"Game"];
    NSString *filePath = [gameDir stringByAppendingPathComponent:[title stringByAppendingPathExtension:@"txt"]];
    
    NSError *error;
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (!content) return;
    
    NSArray *lines = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    NSString *selected = nil;
    NSString *path = nil;
    for (NSString *line in lines) {
        NSString *trimmed = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimmed hasPrefix:@"1:"]) {
            selected = [[trimmed substringFromIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        } else if ([trimmed hasPrefix:@"2:"]) {
            path = [[trimmed substringFromIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
    }
    if (!selected || !path) return;
    
    if (![selected isEqualToString:@"XP3Player.appex"] && ![selected isEqualToString:@"ONSPlayer.appex"]) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:selected forKey:@"selected"];
    
    NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    NSString *preferencesDir = [libraryPath stringByAppendingPathComponent:@"Preferences"];
    [[NSFileManager defaultManager] createDirectoryAtPath:preferencesDir withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *xmlPath = [preferencesDir stringByAppendingPathComponent:@"recentpath.xml"];
    NSString *xmlContent = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<RecentPathList>\n    <Item Path=\"%@\"/>\n</RecentPathList>", path];
    [xmlContent writeToFile:xmlPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    if ([selected isEqualToString:@"ONSPlayer.appex"]) {
        NSFileManager *fm = [NSFileManager defaultManager];
        BOOL isDir;
        if ([fm fileExistsAtPath:path isDirectory:&isDir]) {
            [fm setAttributes:@{NSFilePosixPermissions: @(0755)} ofItemAtPath:path error:nil];
            NSString *parent = [path stringByDeletingLastPathComponent];
            NSArray *contents = [fm contentsOfDirectoryAtPath:parent error:nil];
            for (NSString *item in contents) {
                NSString *fullPath = [parent stringByAppendingPathComponent:item];
                if (![fullPath isEqualToString:path]) {
                    [fm setAttributes:@{NSFilePosixPermissions: @(0655)} ofItemAtPath:fullPath error:nil];
                }
            }
        }
    }
    
    [self attemptOpenURL];
}

- (void)attemptOpenURL {
    NSURL *url = [NSURL URLWithString:@"yurigame://"];
    if ([[UIApplication sharedApplication] openURL:url]) {
        exit(0);
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self attemptOpenURL];
        });
    }
}

@end

@implementation TSSettingsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTable];
}

- (void)setupTable {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.tableView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    cell.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"自定义主题";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"版本";
                cell.detailTextLabel.text = @"1.0";
                break;
            case 1:
                cell.textLabel.text = @"作者";
                cell.detailTextLabel.text = @"KoiYuri";
                break;
            default:
                cell.textLabel.text = @"QQ群";
                cell.detailTextLabel.text = @"3142499905";
                break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIImagePickerController *picker = [UIImagePickerController new];
        picker.delegate = (id)self.tabBarController;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

@end