//
//  LWC_TableViewViewController.m
//  EGOfresh TabelView
//
//  Created by 李伟超 on 14-10-15.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import "LWC_TableViewViewController.h"
#import "utility/CustomDefine.h"
#import "utility/Debug.h"
#import "PageScrollView.h"
#import "DetailViewController.h"
#import "UIScrollView+Refresh.h"

@implementation LWC_TableViewViewController {
    NSInteger rowCount;
    
    DetailViewController *detailVC;
}

- (id)init {
    if (self = [super init]) {
#ifdef __IPHONE_7_0
//        self.navigationController.navigationBar.translucent = NO;
//        self.extendedLayoutIncludesOpaqueBars = YES;
//        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
#endif
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        self.wantsFullScreenLayout = YES;
#endif
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initializationb
#ifdef __IPHONE_7_0
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            self.navigationController.navigationBar.translucent = NO;
            self.edgesForExtendedLayout = UIRectEdgeNone;
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
#endif
    }
    return self;
}

- (void)loadView {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#ifdef __IPHONE_7_0
//        self.navigationController.navigationBar.translucent = NO;
//        self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
#endif
//#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
//    self.wantsFullScreenLayout = YES;
//#endif
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    rowCount = 13;
    
    if (__IOS_DEVICE >= 7) {
        _myTableView.separatorInset = UIEdgeInsetsZero;
        _myTableView.backgroundColor = [UIColor clearColor];
    }
    
    _myTableView.scrollEnabled = YES;
    _myTableView.scrollsToTop = NO;
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    _myTableView.backgroundColor = [UIColor whiteColor];

//    _HeaderScrollView = [[PageScrollView alloc] initWithFrame:CGRectMake(0, 20, _myTableView.frame.size.width, 190)];
//    _HeaderScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    _HeaderScrollView.backgroundColor = [UIColor redColor];
//    _HeaderScrollView.ImageArray = [NSMutableArray arrayWithObjects:@"0.png", @"1.png", @"2.png", @"3.png", @"4.png", nil];
//    _HeaderScrollView.autoScrolled = NO;
//    _HeaderScrollView.pageViewDelegate = self;
//    _HeaderScrollView.Durations = 2.f;
//
//    _myTableView.tableHeaderView = _HeaderScrollView;
    
    UIView *footerview = [[UIView alloc] initWithFrame:CGRectZero];
    _myTableView.tableFooterView = footerview;
    
    __weak LWC_TableViewViewController *VC = self;
    [_myTableView addRefreshHandler:^(){
        [VC scrollViewDidRefreshing];
    }];
    [_myTableView addLoadMoreHander:^(){
        [VC loadMore];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)dealloc {

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    //config the cell
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (detailVC == nil) {
        detailVC = [[DetailViewController alloc] init];
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - pageScrollViewDelegate

- (void)didSelectedImage:(NSDictionary *)Info {
    if (detailVC == nil) {
        detailVC = [[DetailViewController alloc] init];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - define method

- (void)scrollViewDidRefreshing {
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_myTableView reloadData];
        
        [_myTableView scrollViewDidEndRefreshed];
    });
}

- (void)loadMore {
    
    int64_t delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        [_myTableView beginUpdates];
        rowCount++;
        [_myTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:rowCount-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [_myTableView endUpdates];
        
        [_myTableView scrollViewdidendLoadMore];
    });
}

@end