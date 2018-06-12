//
//  UIView+SHLoading.m
//  SohuOpenSDKDemo
//
//  Created by wushang on 2017/6/12.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

#import "UIView+SHLoading.h"
#import "SHLoading.h"
#import "Masonry.h"

@implementation UIView (SHLoading)

- (void)showLoading:(UIImage *)loadingImage
{
    SHLoading *loading = [self viewWithTag:158224545];
    if (!loading) {
        loading = [SHLoading loadingWithImage:loadingImage];
        loading.tag = 158224545;
        [self addSubview:loading];
          __weak typeof (self) weakSelf = self;
        [loading mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(200, 200));
        }];
        [loading startLoadingAnimation];
    }
}

- (BOOL)isLoading
{
    SHLoading *loading = [self viewWithTag:158224545];
    if(loading) return YES;
    return  NO;
}
- (void)hideLoading
{
    SHLoading *loading = [self viewWithTag:158224545];
    if ([loading isKindOfClass:[SHLoading class]]) {
        [loading stopLoadingAnimation];
        [loading removeFromSuperview];
    }
}


@end
