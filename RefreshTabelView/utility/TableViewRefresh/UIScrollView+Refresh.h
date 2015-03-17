//
//  UIScrollView+Refresh.h
//  EGOfresh TabelView
//
//  Created by 李伟超 on 15/3/13.
//  Copyright (c) 2015年 LWC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderRefreshView.h"

typedef void(^RefreshHandler)(void);
typedef void(^LoadMoreHandler)(void);

@interface UIScrollView (Refresh)

@property (nonatomic, copy) RefreshHandler scrollViewDidRefresh;
@property (nonatomic, copy) LoadMoreHandler LoadMore;

@property (nonatomic, assign) BOOL isRefresh;
//@property (nonatomic, assign) BOOL isLoading;
@property (retain, nonatomic) HeaderRefreshView *headerRefreshView;
@property (retain, nonatomic) UIView *footerLoadMoreView;

/**
 *  一定要调用的方法
 */
- (void)addRefreshHandler:(void (^)(void))Handler;  //处理刷新
- (void)addLoadMoreHander:(void (^)(void))Handler;  //处理加载更多

/**
 *  结束  刷新
 */
- (void)scrollViewDidEndRefreshed;
/**
 *
 *结束  加载更多
 */
- (void)scrollViewdidendLoadMore;

@end
