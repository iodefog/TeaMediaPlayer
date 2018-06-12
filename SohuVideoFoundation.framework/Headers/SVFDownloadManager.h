//
//  SVFDownloadManager.h
//  SohuVideoFoundation
//
//  Created by xuqianlong on 2017/6/12.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

/**
 * 以下公开接口必须在主线程调用，因为 SVFDownloadManager 不是线程安全的！
 */

#import <Foundation/Foundation.h>
#import "SVFDownloadTask.h"

@interface SVFDownloadConfig : NSObject

@property (nonatomic, copy) NSString *downloadPath;  //下载路径

@end

@interface SVFDownloadManager : NSObject

///最大并发任务数，默认是1；
@property (nonatomic ,assign) NSUInteger maxConcurrentOperationCount;

///单利
+ (instancetype)sharedManager;

///启动App的时候调用; 初始化数据库等操作; 传入下载配置信息(可选);
- (void)setupDownloadManagerWithOptions:(SVFDownloadConfig *)downloadConfig;

///已经完成的任务
- (NSArray <SVFDownloadTask *>*)allFinishedTaskArr;
///未完成的任务
- (NSArray <SVFDownloadTask *>*)allUnFinishedTaskArr;

/**
 添加下载任务

 @param vid 视频vid
 @param site 视频site
 */
- (void)addTaskWithVid:(long long)vid site:(NSString *)site competion:(void(^)(NSError * err))completion;

/**
 添加下载任务

 @param videoInfo 视频信息model，这些属性是必须的：vid,site，封面图和视频名称！
 */
- (void)addTaskWithVideoInfo:(SVFDownloadVideoInfo *)videoInfo competion:(void(^)(NSError * err))completion;
/**
 删除指定task
 * 会删除相应的ts文件
 @param task 必须是Manager管理的task
 */
- (void)removeDownloadTask:(SVFDownloadTask *)task;


/**
 根据 vid 删除任务

 @param vid 视频id
 */
- (void)removeDownloadTaskWithVid:(long long)vid;

/**
 根据 aid 删除该专辑【已完成】的任务
 
 @param aid 视频专辑
 */
- (void)removeDownloadTaskWithAid:(long long)aid;

@end


@interface SVFDownloadManager (SwitchTask)

///开始所有任务
- (void)startAllDownloadTasks;

///暂停所有任务
- (void)pauseAllDownloadTasks;

///暂停指定任务
- (void)pauseTask:(SVFDownloadTask *)task;

///恢复指定任务
- (void)resumeTask:(SVFDownloadTask *)task;

@end

typedef BOOL (^SVFShouldResumeBlock)(void);

@interface SVFDownloadManager (NetworkObserver)

///下载过程中网络发生了变化时，来询问下当前网络是否恢复下载任务
- (void)currentNetworkConnectionShouldResumeTask:(SVFShouldResumeBlock)block;

@end
