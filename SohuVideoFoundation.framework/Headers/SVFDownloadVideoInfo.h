//
//  SVFDownloadVideoInfo.h
//  SohuVideoFoundation
//
//  Created by xuqianlong on 2017/6/12.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, VideoDefinition) {
    VideoDefinition_Standard    = 2,    // 标清
    VideoDefinition_High        = 1,    // 高清
    VideoDefinition_Ultra       = 21,   // 蓝光
    VideoDefinition_Original    = 31    // 原画
};

@interface SVFDownloadVideoInfo : NSObject <NSCoding>

@property (nonatomic, assign) long long vid;
@property (nonatomic, assign) long long aid;
@property (nonatomic, assign) NSInteger site;
@property (nonatomic, assign) NSInteger cateCode;

@property (nonatomic, assign) NSInteger playOrder;//播放顺序
@property (nonatomic, copy) NSString * videoName;//视频名称
@property (nonatomic, copy) NSString * albumName;//专辑名称
@property (nonatomic, copy) NSString * videoPic;//视频海报

@property (nonatomic, assign) VideoDefinition videoDefinition;
@property (nonatomic, assign) long long totalSize;

@end
