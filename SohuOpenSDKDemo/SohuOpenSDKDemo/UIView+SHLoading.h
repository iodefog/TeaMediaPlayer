//
//  UIView+SHLoading.h
//  SohuOpenSDKDemo
//
//  Created by wushang on 2017/6/12.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SHLoading)

///开始Loading
- (void)showLoading:(UIImage *)loadingImage;
///隐藏Loading
- (void)hideLoading;

- (BOOL)isLoading;
@end
