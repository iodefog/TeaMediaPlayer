//
//  SHLoading.h
//  SohuOpenSDKDemo
//
//  Created by wushang on 2017/6/12.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHLoading : UIView

+ (instancetype)loadingWithImage:(UIImage *) image;

- (void)startLoadingAnimation;

- (void)stopLoadingAnimation;

@end
