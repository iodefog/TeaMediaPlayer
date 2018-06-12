//
//  TeaMediaPlayerDelegate.h
//  TeaApplePlayer
//
//  Created by liweizhou on 14-4-18.
//  Copyright (c) 2014年 liweizhou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TeaMediaPlayerDelegate <NSObject>

@optional


//通知可以播放此视频
- (void)onOpenSucess;

//播放出错
- (void)onErrorReport:(long)code arg:(void *)arg;

//播放准备完毕，可以直接调用play开始播放
- (void)onPrepared;

//通知视频时长
- (void)onUpdateDuration:(long long)duration;

//开始缓冲
- (void)onBufferingStart:(long)bufferType;

//缓冲进度
- (void)onBufferingUpdate:(long)percent;

//缓冲完毕
- (void)onBufferingOk;

//通知播放当前进度
- (void)onUpdatePlayPosition:(long long)pos;

//通知qos数据
- (void)onCatonAnalysis:(NSString *)info;

//播放完毕
- (void)onComplete;

//通知seeking状态
- (void)onSeekingForward;

//通知seeking状态
- (void)onSeekingBackward;

- (void)onFirstFrame;

//极路由清晰度回调
- (void)onRouterQuality:(NSInteger)quality;

//AirPlay状态回调
- (void)onAirPlayActiveDidChange:(NSInteger)info;

//通知视频宽高，ios未使用
- (void)onVideoSizeChanged:(CGSize)size;

//通知播放器类型切换，ios未使用
- (void)onDecodeTypeChange:(long)type;

//通知播放器类型统计上报，ios未使用
- (void)onDecoderStatusReport:(long)bitFlag info:(NSString *)info;

//仅开发测试使用
- (void)onShowPlayerMessage:(NSString *)info;

//向上层查询当前是否是后台状态，如果是后台的状态返回true 否则返回false
- (BOOL)getBackgroundStatus;

@end
