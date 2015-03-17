//
//  HeaderRefreshView.h
//  EGOfresh TabelView
//
//  Created by 李伟超 on 15/3/12.
//  Copyright (c) 2015年 LWC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    RefreshNone = 0,
    RefreshDown,
    RefreshUp,
    RefreshLoading,
}RefreshStatus;

@interface HeaderRefreshView : UIView {
    UILabel *_lastUpdatedLabel;
    UILabel *_statusLabel;
    UIImageView *_arrowImage;
    UIActivityIndicatorView *_activityView;
}

@property (nonatomic, assign) RefreshStatus statu;
@property (nonatomic, assign) BOOL isRefresh;

- (void)resetStatus;
- (void)changeStatus:(RefreshStatus)statu;

@end
