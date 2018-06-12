//
//  SVFVideoPlayerHeader.h
//  SohuVideoFoundation
//
//  Created by 许乾隆 on 16/5/12.
//  Copyright © 2016年 sohu-inc. All rights reserved.
//

#ifndef SVFVideoPlayerHeader_h
#define SVFVideoPlayerHeader_h

typedef NS_ENUM(NSUInteger, SVFVideoPlayerScaleMode) {
    SVFVideoPlayerScaleModeNone,
    SVFVideoPlayerScaleModeAspectFit,//Uniform scale until one dimension fits
    SVFVideoPlayerScaleModeAspectFill,//Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents
    SVFVideoPlayerScaleModeFill //Non-uniform scale. Both render dimensions will exactly match the visible bounds
};

typedef NS_ENUM(NSUInteger, SVFVideoPlayerBufferSate) {
    SVFVideoPlayerBufferBegan,//开始缓冲
    SVFVideoPlayerBufferOK,//缓冲完毕
    SVFVideoPlayerBuffering//更新缓冲进度
};

typedef NS_ENUM(NSUInteger, SVFVideoPlayerError) {
    SVFVideoPlayerRequestVideoInfoError,//请求播放地址失败，针对于搜狐的源
    SVFVideoPlayerUnReacheNet, ///无法连接到网络
    SVFVideoPlayerOpenFailed, ///无法打开视频流
    SVFVideoPlayerPlayErr, ///播放过程中出错了
    SVFVideoPlayerPlayForbidden  ///禁止播放，只能在搜狐视频中播
};

#import "SVFVideoResolution.h"

typedef void(^SVFVideoPlayLoadNotifi)(void);
typedef void(^SVFVideoPlayerBufferNotifi)(SVFVideoPlayerBufferSate state,NSInteger progress);
typedef void(^SVFVideoPlayerErrorNotifi)(SVFVideoPlayerError err);
typedef void(^SVFVideoPlay2EndNotifi)(void);
typedef void(^SVFVideoDurationUpdateNotifi)(long long ms);
typedef void(^SVFVideoResolutionUpdateNotifi)(NSArray <SVFVideoResolution *> *resolutions,SVFVideoResolutionType currentType);
typedef void(^SVFBeginLoadingIfNeeded)(void);
typedef void(^SVFEndLoadingIfNeeded)(void);


#endif /* SVFVideoPlayerHeader_h */
