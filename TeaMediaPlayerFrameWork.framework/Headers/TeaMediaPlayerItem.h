//
//  TeaMediaPlayerItem.h
//  TeaApplePlayer
//
//  Created by liweizhou on 14-4-18.
//  Copyright (c) 2014年 liweizhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeaMediaPlayerItem : NSObject

@property (nonatomic, copy) NSString *path; //视频地址
@property (nonatomic, copy) NSString *vid; //视频vid
@property (nonatomic, copy) NSString *site; //视频site，极路由相关
@property (nonatomic, assign) NSInteger startPos; //开始播放位置
@property (nonatomic, assign) NSInteger defType; //视频清晰度
@property (nonatomic, assign) NSInteger playerType; //解码器类型
@property (nonatomic, assign) NSInteger serviceType;
@property (nonatomic, assign) BOOL isCaptionVideo;
@property (nonatomic, copy) NSString *otherIdInfo;
@property (nonatomic, copy) NSString *xxkey;
@property (nonatomic, assign) BOOL is360Vr;  //360全景视频
@property (nonatomic, assign) BOOL isLiveMedia; //是否为直播
@property (nonatomic, assign) BOOL unplayAudio; //是否播放音频
@property (nonatomic, assign) BOOL isForHuyou; //狐友控制开关
@property (nonatomic, assign) int duration; //狐友缓存时长
@property (nonatomic, assign) NSUInteger bufferingTime; //第一次播放缓冲时长，单位s 最大10s 默认为0
@property (nonatomic, assign) BOOL fastOpenFlag;
@property (nonatomic, copy) NSString * owner;
-(TeaMediaPlayerItem*)copyItem;
@end

@interface TeaMediaPlayerPreloadVideo : NSObject

@property (nonatomic, copy) NSString *vid;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *otherIdInfo;
@property (nonatomic, copy) NSString *site;
@property (nonatomic, assign) NSInteger defType;
@property (nonatomic, assign) NSInteger pos;
@property (nonatomic, assign) BOOL isCaptionVideo;
@property (nonatomic, assign) BOOL is360Vr;
@end
