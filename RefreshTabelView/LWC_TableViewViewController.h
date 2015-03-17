//
//  LWC_TableViewViewController.h
//  EGOfresh TabelView
//
//  Created by 李伟超 on 14-10-15.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageScrollView.h"

@interface LWC_TableViewViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,pageScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (strong, nonatomic) PageScrollView *HeaderScrollView;

@end
