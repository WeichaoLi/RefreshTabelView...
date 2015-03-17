//
//  DetailViewController.m
//  EGOfresh TabelView
//
//  Created by 李伟超 on 14-10-15.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import "DetailViewController.h"
#import "utility/CustomDefine.h"
#import "utility/Debug.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIRefreshControl *refreshcontrol = [[UIRefreshControl alloc]initWithFrame:CGRectMake(0, -64, self.view.frame.size.width, 64)];
//    refreshcontrol.attributedTitle = [[NSAttributedString alloc] initWithString:@"11111" attributes:[NSDictionary dictionaryWithObjectsAndKeys:@"11",@"font", nil]];
//    [_mytableview addSubview:refreshcontrol];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
