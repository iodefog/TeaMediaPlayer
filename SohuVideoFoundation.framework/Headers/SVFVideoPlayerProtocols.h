//
//  SVFVideoPlayerProtocols.h
//  SohuVideoFoundation
//
//  Created by 许乾隆 on 16/5/16.
//  Copyright © 2016年 sohu-inc. All rights reserved.
//

#import "SVFVideoPlayerHeader.h"
#import "SVFVideoResolution.h"

#ifndef SVFVideoPlayerProtocols_h
#define SVFVideoPlayerProtocols_h

@class SVFDownloadTask;
//播放器协议
@protocol SVFVideoPlayerProtocols <NSObject>

@optional;


@property (nonatomic, assign) SVFVideoPlayerScaleMode scaleModel;


//===============================【play control】========================================================//

/**
 开始（继续）播放
 第一次开始播放须要调用 resumeVid:(NSString *)vid site:(NSString *)site ！因为需要指定vid和site.
 */
- (void)resume;

/**
 暂停
 */
- (void)pause;

/**
 停止播放,进入后台，进入别的页面后调用；调用resume后可从停止位置继续播放；
 */
- (void)stop;

/**
 与 stop 的区别是resume后从头开始播放；
 */
- (void)stopAndReset;

/**
 播放搜狐视频的源
 
 @param vid 搜狐视频的vid
 @param site 视频来源
 @param startPos 播放起始点。秒/单位
 */
- (void)resumeVid:(NSString *)vid site:(NSString *)site startPos:(NSInteger)startPos;
- (void)resumeVid:(NSString *)vid site:(NSString *)site;


/**
 播放非搜狐视频的源

 @param url 视频地址
 */
- (void)resumeURL:(NSString *)url;

/*
 播放使用下载框架下载好的视频
 */
- (void)resumeTask:(SVFDownloadTask *)task;

//===============================【player observer】========================================================//

//开始Loading回调
- (void)observerBeginLoading:(SVFBeginLoadingIfNeeded)notifi;
//结束Loading回调
- (void)observerEndLoading:(SVFEndLoadingIfNeeded)notifi;


/**
 注册缓冲回调

 @param notifi 缓冲状态变化时回调
 */
- (void)observerBufferState:(SVFVideoPlayerBufferNotifi)notifi;

/**
 注册错误回调

 @param notifi 发生错误、错误结束是回调
 */
- (void)observerPlayerError:(SVFVideoPlayerErrorNotifi)notifi;

/**
 注册视频时长更新回调

 @param notifi 获取到视频时长后回调
 */
- (void)observerVideoDuration:(SVFVideoDurationUpdateNotifi)notifi;


/**
 注册搜狐源视频清晰度更新回调

 @param notifi 获取到视频信息后回调
 */
- (void)observerVideoResolution:(SVFVideoResolutionUpdateNotifi)notifi;

///切换清晰度
- (void)switchVideoResolution:(SVFVideoResolutionType)type;

///可以添加overlay了
- (void)observerWhenPrepareSubView:(dispatch_block_t)notifi;

/**
 视频播放到尽头回调

 @param notifi 播完了
 */
- (void)observerPlay2End:(SVFVideoPlay2EndNotifi)notifi;


/// 必须在 observerVideoDuration 回调之后才能调用；
///视频总时长(ms)
- (long long)videoDuration;
/// 获取已缓冲时长(ms)
- (long long)getCacheDuration;
///已经播放的时长(ms)
- (long)currentPlayedTime;

///seek(ms)
- (void)seekto:(long long)ms;

///播放器是否静音
- (void)setMute:(BOOL)mute;

///设置播放的默认清晰度，SDK默认是高清【只有搜狐的源才有效】
- (void)setDefaultResolution:(SVFVideoResolutionType)type;
- (SVFVideoResolutionType)currentResolution;


@end

#endif
