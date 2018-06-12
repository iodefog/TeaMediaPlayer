//
//  SVWeakProxy.h
//  SohuCoreFoundation

//  Created by qianlongxu on 16/3/9.
//  Copyright © 2016年 sohu-inc. All rights reserved.
//
// 傀儡代理，防止持有target；内部做消息转发；常结合NSTimer使用；

#import <Foundation/Foundation.h>

@interface SVWeakProxy : NSProxy

@property (nonatomic, weak, readonly) id target;

- (instancetype)initWithTarget:(id)target;

+ (instancetype)weakProxyWithTarget:(id)target;

@end
