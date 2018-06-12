//
//  SHPlayerViewController.h
//  SohuOpenSDKDemo
//
//  Created by 许乾隆 on 2017/5/8.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHPlayerViewController : UIViewController

@property (nonatomic, assign) BOOL flag;

- (instancetype)initVid:(NSString *)vid site:(NSString *)site;

- (instancetype)initUrl:(NSString *)url;

@end

