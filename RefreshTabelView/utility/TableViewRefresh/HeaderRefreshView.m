//
//  HeaderRefreshView.m
//  EGOfresh TabelView
//
//  Created by 李伟超 on 15/3/12.
//  Copyright (c) 2015年 LWC. All rights reserved.
//

#import "HeaderRefreshView.h"

@implementation HeaderRefreshView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _lastUpdatedLabel=label;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont boldSystemFontOfSize:13.0f];
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _statusLabel=label;
        
        _arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(25.f, (frame.size.height - 55)/2, 30, 55)];
        _arrowImage.image = [UIImage imageNamed:@"Refresh.bundle/blackArrow.png"];
        _arrowImage.backgroundColor = [UIColor whiteColor];
        [self addSubview:_arrowImage];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        _activityView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin;
        _activityView.frame = CGRectMake(25.0f, (frame.size.height - 30.f)/2, 30.0f, 30.0f);
        [self addSubview:_activityView];
        
        [self setStatu:RefreshNone];
    }
    
    return self;
}

#pragma -
#pragma mark - public method

- (void)setStatu:(RefreshStatus)statu {
    _statu = statu;
}

- (void)resetStatus {
    [self changeStatus:RefreshNone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    _lastUpdatedLabel.text = [NSString stringWithFormat:@"上次更新:%@",[dateFormatter stringFromDate:[NSDate date]]];
}

- (void)changeStatus:(RefreshStatus)statu{
    switch (statu) {
        case RefreshNone:
            [_activityView stopAnimating];
            _activityView.hidden = YES;
            _arrowImage.hidden = NO;
            _statusLabel.text = NSLocalizedString(@"拖动以刷新", nil);
            break;
        case RefreshUp:{
            if (!_isRefresh && _statu != statu) {
                _statusLabel.text = NSLocalizedString(@"拖动以刷新", nil);
                
                [UIView animateWithDuration:0.2f animations:^(){
                    _arrowImage.transform = CGAffineTransformIdentity;
                }completion:nil];
            }
        }
            break;
        case RefreshDown:{
            if (!_isRefresh && _statu != statu) {
                _statusLabel.text = NSLocalizedString(@"释放以刷新", nil);
                
                [UIView animateWithDuration:0.2f animations:^(){
                    _arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                }completion:nil];
            }
        }
            break;
        case RefreshLoading:{
                if (_statu != statu) {
                    _arrowImage.hidden = YES;
                    _activityView.hidden = NO;
                    [_activityView startAnimating];
                    _statusLabel.text = NSLocalizedString(@"正在刷新...", nil);
                }
            }
            break;
        default:
            break;
    }
    self.statu = statu;
}

@end
