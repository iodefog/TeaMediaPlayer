//
//  TeaUtils.h
//  TeaApplePlayer
//
//  Created by 周立伟 on 15/1/14.
//  Copyright (c) 2015年 liweizhou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^TeaUtilsLogBlock)(NSString * str);

@interface TeaUtils : NSObject

+ (void)setLog:(BOOL)isLog;
//#ifdef IOS_FRAMEWORK
///注册block，接收播放器日志
+ (void)receiveLog:(TeaUtilsLogBlock)block;
//#endif



@end
