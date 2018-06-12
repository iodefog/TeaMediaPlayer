//
//  SHLoading.m
//  SohuOpenSDKDemo
//
//  Created by wushang on 2017/6/12.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

#import "SHLoading.h"
#import "Masonry.h"

#ifndef _weakSelf_
#define _weakSelf_     __weak   __typeof(self) $weakself = self;
#endif

#ifndef _strongSelf_
#define _strongSelf_   __strong __typeof($weakself) self = $weakself;
#endif

@interface SHLoading ()

@property (nonatomic, weak) UIImageView *loadingImage;

@end


@implementation SHLoading

+(instancetype)loadingWithImage:(UIImage *)image
{
    return [[self alloc] initWithLoadingImage:image];
}

- (instancetype)initWithLoadingImage:(UIImage *) image{
    
    self = [super init];
    
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        _weakSelf_
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            _strongSelf_
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        imageView.image = image;
        
        self.loadingImage = imageView;
        
    }
    
    return self;
    
}

- (void)startLoadingAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    animation.toValue = [NSNumber numberWithFloat:4 * M_PI]; // 终止角度
    animation.removedOnCompletion = NO;
    animation.autoreverses = NO;
    animation.repeatCount = CGFLOAT_MAX;
    animation.duration = 5;
    animation.fillMode = kCAFillModeForwards;
    [self.loadingImage.layer addAnimation:animation forKey:@"rotateCircle"];
}

- (void)stopLoadingAnimation
{
    [self.loadingImage.layer removeAnimationForKey:@"rotateCircle"];
}

@end
