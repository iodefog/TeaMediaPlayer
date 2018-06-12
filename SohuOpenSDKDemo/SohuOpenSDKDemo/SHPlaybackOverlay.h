//
//  SHPlaybackOverlay.h
//  SohuOpenSDKDemo
//
//  Created by 许乾隆 on 2017/6/6.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SohuVideoFoundation/SohuVideoFoundation.h>

typedef enum : NSUInteger {
    SHBeginScrub,
    SHScrubing,
    SHEndScrub
} SHOverlayScrubType;

typedef void(^SHPlaybackOverlayHandler)(UIControl *ctrl);
typedef void(^SHPlaybackOverlayScrubHandler)(SHOverlayScrubType type,NSInteger value);
typedef void(^SHShowResolutionBlock)() ;
typedef void(^SHSwitchResolutionBlock)(id sender);
@interface SHPlaybackOverlay : UIView

- (void)addPlayPauseHandler:(SHPlaybackOverlayHandler)handler;
- (void)addScrubHandler:(SHPlaybackOverlayScrubHandler)handler;

- (void)updateTotalDuration:(long long)seconds;
- (void)updatePlayDuration:(long long)seconds;

- (void)pause;
- (void)resume;

- (void)showCurrentResolution:(NSString *)resolutionStr;
@property (nonatomic, strong) SHSwitchResolutionBlock switchResolutionBlock;
@property (nonatomic, strong) SHShowResolutionBlock showResolutions;
- (void)addReselutionsView:(NSArray *) resolutions type:(SVFVideoResolutionType )currentType;
- (void)hideorShowResolution;

- (BOOL)isPause; //播放按钮当前的状态 YES Pause NO Play

@end
