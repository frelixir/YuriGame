#import <UIKit/UIKit.h>

@interface YiAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@end

@interface TSRootViewController : UITabBarController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) UIImageView *bgImageView;
@end

@interface TSAppTableViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<NSString *> *gameTitles;
@end

@interface TSSettingsListController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation YiAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
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
    navAppearance.backgroundColor = [[UIColor systemBackgroundColor] colorWithAlphaComponent:0.6];
    
    for (UINavigationController *nav in self.viewControllers) {
        nav.navigationBar.standardAppearance = navAppearance;
        nav.navigationBar.scrollEdgeAppearance = navAppearance;
    }
    
    UITabBarAppearance *tabAppearance = [UITabBarAppearance new];
    [tabAppearance configureWithTransparentBackground];
    tabAppearance.backgroundColor = [[UIColor systemBackgroundColor] colorWithAlphaComponent:0.6];
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

static NSString * const cellReuseIdentifier = @"GameCardCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadGameTitles];
    [self setupCollectionView];
}

- (void)loadGameTitles {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths.firstObject;
    NSString *gameDir = [documentsDirectory stringByAppendingPathComponent:@"Game"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    NSMutableArray *titles = [NSMutableArray array];
    
    if ([fileManager fileExistsAtPath:gameDir isDirectory:&isDir] && isDir) {
        NSArray *contents = [fileManager contentsOfDirectoryAtPath:gameDir error:nil];
        for (NSString *file in contents) {
            if ([file.pathExtension isEqualToString:@"txt"]) {
                NSString *title = [file stringByDeletingPathExtension];
                [titles addObject:title];
            }
        }
    }
    
    self.gameTitles = [titles copy];
}

- (void)setupCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 16;
    layout.minimumLineSpacing = 20;
    layout.sectionInset = UIEdgeInsetsMake(16, 16, 16, 16);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
    
    [self.view addSubview:self.collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gameTitles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *cardView = [[UIView alloc] init];
    cardView.translatesAutoresizingMaskIntoConstraints = NO;
    cardView.backgroundColor = [[UIColor systemBackgroundColor] colorWithAlphaComponent:0.8];
    cardView.layer.cornerRadius = 12;
    cardView.layer.shadowColor = [UIColor blackColor].CGColor;
    cardView.layer.shadowOffset = CGSizeMake(0, 2);
    cardView.layer.shadowRadius = 4;
    cardView.layer.shadowOpacity = 0.15;
    [cell.contentView addSubview:cardView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.text = self.gameTitles[indexPath.item];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.textColor = UIColor.labelColor;
    titleLabel.numberOfLines = 0;
    [cardView addSubview:titleLabel];
    
    [NSLayoutConstraint activateConstraints:@[
        [cardView.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor],
        [cardView.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor],
        [cardView.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor],
        [cardView.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor],
        
        [titleLabel.leadingAnchor constraintEqualToAnchor:cardView.leadingAnchor constant:8],
        [titleLabel.trailingAnchor constraintEqualToAnchor:cardView.trailingAnchor constant:-8],
        [titleLabel.bottomAnchor constraintEqualToAnchor:cardView.bottomAnchor constant:-12],
        [titleLabel.heightAnchor constraintGreaterThanOrEqualToConstant:20]
    ]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat spacing = ((UICollectionViewFlowLayout *)collectionViewLayout).minimumInteritemSpacing;
    CGFloat inset = ((UICollectionViewFlowLayout *)collectionViewLayout).sectionInset.left + ((UICollectionViewFlowLayout *)collectionViewLayout).sectionInset.right;
    CGFloat availableWidth = collectionView.bounds.size.width - inset - spacing;
    CGFloat itemWidth = availableWidth / 2.0;
    return CGSizeMake(itemWidth, 140);
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
    cell.backgroundColor = [[UIColor systemBackgroundColor] colorWithAlphaComponent:0.6];
    
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