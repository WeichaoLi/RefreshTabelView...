//
//  UIScrollView+Refresh.m
//  EGOfresh TabelView
//
//  Created by 李伟超 on 15/3/13.
//  Copyright (c) 2015年 LWC. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import <objc/runtime.h>

#define REFRESH_HEADER_HEIGHT 60
#define REFRESH_FOOTER_HERGHT 40

@implementation UIScrollView (Refresh)

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"contentOffset"];
    [self removeObserver:self forKeyPath:@"contentSize"];
}

- (void)addRefreshHandler:(void (^)(void))Handler {
    self.scrollViewDidRefresh = Handler;
    self.isRefresh = NO;
    if (!self.headerRefreshView) {
        self.headerRefreshView = [[HeaderRefreshView alloc] initWithFrame:CGRectMake(0, -REFRESH_HEADER_HEIGHT, self.frame.size.width, REFRESH_HEADER_HEIGHT)];
        self.headerRefreshView.backgroundColor = [UIColor clearColor];
        [self insertSubview:self.headerRefreshView atIndex:0];
    }
    
    //监听
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)addLoadMoreHander:(void (^)(void))Handler {
    self.LoadMore = Handler;
    if (!self.footerLoadMoreView) {
        self.footerLoadMoreView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentSize.height, self.frame.size.width, REFRESH_FOOTER_HERGHT)];
        self.footerLoadMoreView.backgroundColor = [UIColor clearColor];
        [self insertSubview:self.footerLoadMoreView atIndex:0];
        
        UILabel *footerLabel = [[UILabel alloc] initWithFrame:self.footerLoadMoreView.bounds];
        footerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        footerLabel.backgroundColor = [UIColor whiteColor];
        footerLabel.textAlignment = NSTextAlignmentCenter;
        footerLabel.text = NSLocalizedString(@"正在加载...", nil);
        [self.footerLoadMoreView addSubview:footerLabel];
    }
}

- (void)setScrollViewDidRefresh:(RefreshHandler)scrollViewDidRefresh {
    objc_setAssociatedObject(self, @selector(scrollViewDidRefresh), scrollViewDidRefresh, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (RefreshHandler)scrollViewDidRefresh {
    return objc_getAssociatedObject(self, @selector(scrollViewDidRefresh));
}

- (void)setLoadMore:(LoadMoreHandler)LoadMore {
    objc_setAssociatedObject(self, @selector(LoadMore), LoadMore, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (LoadMoreHandler)LoadMore {
    return objc_getAssociatedObject(self, @selector(LoadMore));
}

- (void)setIsRefresh:(BOOL)isRefresh {
    self.headerRefreshView.isRefresh = isRefresh;
}

- (BOOL)isRefresh {
    return self.headerRefreshView.isRefresh;
}

- (void)setHeaderRefreshView:(HeaderRefreshView *)headerRefreshView {
    objc_setAssociatedObject(self, @selector(headerRefreshView),
                             headerRefreshView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HeaderRefreshView *)headerRefreshView {
    return objc_getAssociatedObject(self, @selector(headerRefreshView));
}

- (void)setFooterLoadMoreView:(UIView *)footerLoadMoreView {
    objc_setAssociatedObject(self, @selector(footerLoadMoreView),
                             footerLoadMoreView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)footerLoadMoreView {
    return objc_getAssociatedObject(self, @selector(footerLoadMoreView));
}

#pragma -
#pragma mark - 监听

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self scrollViewDidScroll];
    }else {
        [self.footerLoadMoreView removeFromSuperview];
        self.footerLoadMoreView.frame = CGRectMake(0, self.contentSize.height, self.frame.size.width, 40);
        [self insertSubview:self.footerLoadMoreView atIndex:0];
    }
    
}

- (void)scrollViewDidScroll {
    
    CGSize size = self.contentSize;
    UIEdgeInsets inset = self.contentInset;
    CGFloat currentOffset = self.contentOffset.y + self.frame.size.height - inset.bottom;
    CGFloat maximumOffset = size.height;
    
    /**
     *  上拉加载更多
     */
    if (currentOffset - maximumOffset >= 40) {
        if (!self.isRefresh) {
            self.isRefresh = YES;
            if (self.LoadMore) {
                self.LoadMore();
            }
        }
    }
    
    /**
     *  下拉刷新，更新状态
     */
    if (self.contentOffset.y < - REFRESH_HEADER_HEIGHT - self.contentInset.top) {
        if (self.isDragging) {
            [self.headerRefreshView changeStatus:RefreshDown];
        }else {
            if (!self.isRefresh) {
                self.isRefresh = YES;
                [self.headerRefreshView changeStatus:RefreshLoading];
                
                [UIView animateWithDuration:0.4f animations:^(){
                    self.contentInset = UIEdgeInsetsMake(self.contentInset.top + REFRESH_HEADER_HEIGHT, 0, 0, 0);
                }];
                
                if (self.scrollViewDidRefresh) {
                    self.scrollViewDidRefresh();
                }
            }
        }
        
    }else {
        if (self.isDragging) {
            [self.headerRefreshView changeStatus:RefreshUp];
        }
    }
}

#pragma -
#pragma mark - Public

- (void)scrollViewDidEndRefreshed {
    
    self.isRefresh = NO;
    [self.headerRefreshView resetStatus];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.4f];
    self.contentInset = UIEdgeInsetsMake(self.contentInset.top - REFRESH_HEADER_HEIGHT, 0, 0, 0);
    if (self.contentOffset.y < -self.contentInset.top) {
        self.contentOffset = CGPointMake(0, -self.contentInset.top);
    }
    [UIView commitAnimations];
    
    self.isRefresh = NO;
}

- (void)scrollViewdidendLoadMore {
    self.isRefresh = NO;
}

@end
