//
//  LWCAppDelegate.h
//  EGOfresh TabelView
//
//  Created by 李伟超 on 14-10-15.
//  Copyright (c) 2014年 LWC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LWC_TableViewViewController;

@interface LWCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navC;
@property (weak, nonatomic) IBOutlet LWC_TableViewViewController *viewController;

@end
