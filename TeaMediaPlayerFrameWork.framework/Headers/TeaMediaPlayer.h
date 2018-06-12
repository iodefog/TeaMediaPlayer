//
//  TeaMediaPlayer.h
//  TeaApplePlayer
//
//  Created by liweizhou on 14-4-18.
//  Copyright (c) 2014年 liweizhou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <GLKit/GLKit.h>
#import "TeaMediaPlayerDelegate.h"
#import "TeaMediaPlayerItem.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#ifdef TEA_IOS_CACHE
#import "TeaVideoView.h"
#else
#import "IOSRenderer.h"
#endif

typedef enum {
    TEA_MEDIA_PLAYER_FIRST = 0,
    TEA_MEDIA_PLAYER_SECOND
}TeaMediaPLayerIndex;

typedef enum {
    STATE_IDLE = 0,
    STATE_INITIALIZED,            // initPlayer
    STATE_OPENING,                // item load
    STATE_OPENED,                 // item load finished
    STATE_SEEKING,                // seeking gap 0.2ms
    STATE_BUFFERING,              // loading
    STATE_PAUSED = 6,
    STATE_PLAY_WAIT,              // prepared
    STATE_PLAYING,
    STATE_PLAY_COMPLETE,
    STATE_CLOSING,                 //10
    STATE_CLOSED,                 // stop
    STATE_REOPEN,
//    STATE_PREOPEN,                //to protect clear cache files ok
    STATE_END
}PlayerState;

typedef enum {
    TeaPlayerItemServiceTypeDefault = 1,
    TeaPlayerItemServiceTypeNoServer = 2
}TeaPlayerItemServiceType;

typedef enum {
    TEA_UNKNOWN_PLAYER = 0,
    TEA_HARDWARE_PLAYER = 2,
    TEA_SYSTEM_PLAYER = 4,
    TEA_SOFTWARE_PLAYER = 8
}PlayerType;

typedef enum {
    ERROR_OPEN = 0,
    ERROR_UNREACH_NETWORK,
    ERROR_PLAY
}ErrorType;

enum {
    TeaMovieScalingModeNone,       // No scaling
    TeaMovieScalingModeAspectFit,  // Uniform scale until one dimension fits
    TeaMovieScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents
    TeaMovieScalingModeFill,        // Non-uniform scale. Both render dimensions will exactly match the visible bounds
    TeaMovieScalingModeAspectWidthFit//Uniform scale until the width fits
};
typedef NSInteger TeaMovieScalingMode;

@interface TeaMediaPlayer : NSObject <IOSRendererDelegate>

@property (nonatomic, readonly) PlayerType mCurrentPlayerType;
@property (nonatomic, assign) id<TeaMediaPlayerDelegate> delegate;
@property (nonatomic, retain) TeaMediaPlayerItem *playerItem;
@property (nonatomic, readonly, assign) TeaPlayerItemServiceType serviceType;
@property (nonatomic, assign) TeaMediaPLayerIndex playerIndex;
//AirPlay
@property (nonatomic, assign) BOOL allowsAirPlay;
@property (nonatomic, readonly, getter=isAirPlayVideoActive) BOOL airPlayVideoActive;

//获取单例
+ (TeaMediaPlayer *)sharedInstance;

//设置播放信息
- (void)setDataSource:(TeaMediaPlayerItem *)item;

//初始化播放器
- (BOOL)initPlayer;

//准备播放
- (BOOL)prepareAsync;

//获取时长
- (long long)getDuration;

//获取当前播放位置
- (long long)getPlayPostion;

//获取播放的view
- (UIView *)getPlayerView;

//开始播放
- (BOOL)play;

//暂停播放
- (BOOL)pause;

//停止播放
- (BOOL)stop;

//从某一位置播放
- (BOOL)seekTo:(long)msec;

//销毁播放器
- (BOOL)releasePlayer;

//获取视频宽高
- (CGSize)getVideoSize;

- (void)resetPlayer;

//获取当前下载时速度
- (long)getDownloadSpeed;

//获取视频已经缓存的文件时长
- (long long)getCacheDuration;

//清除缓存目录中所有缓存文件
- (void)clearCachedFiles:(NSString*)path;

//设置最大缓存空间/M，当前播放视频缓存时间/s，预加载视频缓存时间/s=，缓存目录位置
- (void)setMaxCacheSpace:(long)size
            maxCacheTime:(long)time
          maxPreloadTime:(long)ptime
          cacheDirectory:(NSString *)path
               userAgent:(NSString *)ua;

//获取当前缓存的文件大小，单位是字节（B）返回-1是调用失败，需要在非播放情况下调用
- (long long)getCacheStoreSize:(NSString *)path;

//添加预加载的视频
- (BOOL)addPreloadVideoItems:(NSArray *)items;

//停止预加载
- (void)stopPreloadVideo;

- (BOOL)isCacheVideo:(TeaMediaPlayerItem *)item;

- (BOOL)isCachePerfectVideoVid:(NSString *) vid
                          site:(NSString *) site
                       defType:(NSInteger)defType
                          path:(NSString *)path;

- (void)updateVideoViewFrame:(CGRect)frame;

- (void)setMPVolumeView:(MPVolumeView *)volumeView;

- (MPVolumeView *)getMPVolumeView;

- (void)setScalingMode:(TeaMovieScalingMode)scalingMode;

- (void)appDidBecomeActiveWillPlayNewVideo;


- (void)setPictureInPicturePlayback:(BOOL)enable;

- (long)getAudioBytesPerSecond;

- (long)getVideoBytesPerSecond;

- (long)getMovieBitrate;

- (long)getBufferLength;

- (long)getVideoFrameRate;

- (void)setVolume:(long)value;

- (NSString *)getUserInfo;

@end
