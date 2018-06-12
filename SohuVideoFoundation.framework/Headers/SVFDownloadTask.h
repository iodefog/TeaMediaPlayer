//
//  SVFDownloadTask.h
//  SohuVideoFoundation
//
//  Created by xuqianlong on 2017/6/12.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVFDownloadVideoInfo.h"

typedef enum : NSUInteger {
    SVFDownloadTaskStateWaiting,
    SVFDownloadTaskStateExecuting,
    SVFDownloadTaskStatePaused,
    SVFDownloadTaskStateErr,
    SVFDownloadTaskStateFinished
} SVFDownloadTaskState;

@interface SVFDownloadTask : NSObject

@property (nonatomic, strong) SVFDownloadVideoInfo *videoInfo;
//下载状态变为 SVFDownloadTaskStateErr 时，可以通过err查看具体错误
@property (nonatomic, strong) NSError *err;

+ (instancetype)taskWithVid:(long long)vid site:(NSInteger)site;

+ (instancetype)taskWithVideoInfo:(SVFDownloadVideoInfo *)info;

- (long long)vid;
- (long long)aid;
- (NSInteger)site;

///监听下载进度；任务开始后，每隔一秒回调一次；
- (void)addDownloadProgressNotifi:(void(^)(float p))notifi;
///监听下载速度，单位 Kb/s，任务开始后，每隔一秒回调一次；
- (void)addDownloadSpeedNotifi:(void(^)(double kbps))notifi;
///监听视频信息更新
- (void)addDownloadVideoInfoNotifi:(void(^)(SVFDownloadVideoInfo *videoInfo))notifi;

///获取当前下载进度；
- (float)currentDownloadProgress;
///获取当前下载速度；
- (double)currentDownloadSpeed;

///清理掉所以已经注册的Notifi！(ProgressNotifi,SpeedNotifi,VideoInfoNotifi,StateNotifi)
- (void)cleanAllAddedCallbackNotifi;

@end

@interface SVFDownloadTask (State)

///监听下载状态变化
- (void)addDownloadStateNotifi:(void(^)(SVFDownloadTaskState state))notifi;

///获取当前下载状态；
- (SVFDownloadTaskState)currentDownloadState;

///切换状态
- (void)switchState;

- (BOOL)isExecuting;

- (BOOL)isWaiting;

- (BOOL)isFinished;

- (BOOL)isPaused;

- (BOOL)isErrored;

@end
