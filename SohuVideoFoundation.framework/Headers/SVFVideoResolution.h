//
//  SVFVideoResolution.h
//  SohuVideoFoundation
//
//  Created by 许乾隆 on 2017/5/11.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SVFVideoResolutionTypeNormalNone  = 0,           // 无效
    SVFVideoResolutionTypeSuper       = (1 << 0),    // 超清
    SVFVideoResolutionTypeHight       = (1 << 1),    // 高清
    SVFVideoResolutionTypeNormal      = (1 << 2),    // 标清
    SVFVideoResolutionTypeOrigin      = (1 << 3),    // 原画
} SVFVideoResolutionType;


@interface SVFVideoResolution : NSObject

///清晰度名称：高清
@property (nonatomic, copy)NSString *desc;
@property (nonatomic, assign)SVFVideoResolutionType type;

@end
