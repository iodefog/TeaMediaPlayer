//
//  SHPlaybackOverlay.m
//  SohuOpenSDKDemo
//
//  Created by 许乾隆 on 2017/6/6.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//
#import "SHPlaybackOverlay.h"
#import "Masonry.h"
#import "SwitchResolutionView.h"

#ifndef _weakSelf_
#define _weakSelf_     __weak   __typeof(self) $weakself = self;
#endif

#ifndef _strongSelf_
#define _strongSelf_   __strong __typeof($weakself) self = $weakself;
#endif

@interface SHPlaybackOverlay ()

@property (nonatomic, weak) UIButton *playPauseBtn;
@property (nonatomic, weak) UILabel  *duration;
@property (nonatomic, weak) UISlider *slider;
@property (nonatomic, copy) NSString *totalDurationStr;
@property (nonatomic, assign) long long totalDuration;
@property (nonatomic, copy) SHPlaybackOverlayScrubHandler scrubHandler;
@property (nonatomic, copy) SHPlaybackOverlayHandler playPauseHandler;
@property (nonatomic, assign) BOOL isBeginedScrub;
@property (nonatomic, weak) UIButton *resolution;
@property (nonatomic, weak) SwitchResolutionView *switchResolutionView;

@end

@implementation SHPlaybackOverlay

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        UIButton * playPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:playPauseBtn];
        self.playPauseBtn = playPauseBtn;
        {
            [playPauseBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
            [playPauseBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];
            [playPauseBtn addTarget:self
                             action:@selector(playorpause:)
                   forControlEvents:UIControlEventTouchUpInside];
            
            [playPauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@12);
                make.bottom.equalTo(@0);
            }];
        }
        
        UISlider *slider = [[UISlider alloc]init];
        [self addSubview:slider];
        self.slider = slider;
        
        {
            [slider mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(playPauseBtn);
                make.left.equalTo(playPauseBtn.mas_right).offset(12);
                make.height.equalTo(@30);
            }];
            
            [slider addTarget:self action:@selector(beginScrubbing:) forControlEvents:UIControlEventTouchDown];
            [slider addTarget:self action:@selector(beginScrubbing:) forControlEvents:UIControlEventTouchDragInside];
            [slider addTarget:self action:@selector(scrub:) forControlEvents:UIControlEventValueChanged];
            [slider addTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchCancel];
            [slider addTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchUpInside];
            [slider addTarget:self action:@selector(endScrubbing:) forControlEvents:UIControlEventTouchUpOutside];
            
        }
        
        UILabel * duration = [[UILabel alloc]init];
        [self addSubview:duration];
        self.duration = duration;
        {
            duration.font = [UIFont systemFontOfSize:14];
            duration.textColor = [UIColor lightGrayColor];
            duration.text = @"--:--";
            
            [duration mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(playPauseBtn);
                make.left.equalTo(slider.mas_right).offset(10);
                make.right.equalTo(@0);
                make.width.equalTo(@85);
            }];
        }
        
        UIButton * resolution = [[UIButton alloc]init];
        [self addSubview:resolution];
        self.resolution = resolution;
        {
            [resolution.titleLabel setFont:[UIFont systemFontOfSize: 14]];
            [resolution setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [resolution setTitle:@"" forState:UIControlStateNormal];
            
            float r = (float)192/255;
            resolution.backgroundColor = [UIColor colorWithRed:r green:r blue:r alpha:0.5];
           
            [resolution.layer setCornerRadius:10];
            [resolution addTarget:self action:@selector(clickedToShowResolutionList) forControlEvents:UIControlEventTouchUpInside];

            _weakSelf_
            [resolution mas_makeConstraints:^(MASConstraintMaker *make) {
                _strongSelf_
                make.bottom.equalTo(duration.mas_top).offset(-5);
                make.right.equalTo(self).offset(-5);
                make.width.equalTo(@50);
                
            }];
        }
        
    }
    return self;
}


- (void)clickedToShowResolutionList
{
    if(self.showResolutions)
    {
        self.showResolutions();
    }

}

- (void)hideorShowResolution
{
    if (self.resolution.hidden){
        self.resolution.hidden = NO;
    }else{
        self.resolution.hidden = YES;
    }
}

- (void)showCurrentResolution:(NSString *)resolutionStr
{
    [self.resolution setTitle:resolutionStr forState:UIControlStateNormal];
}

- (void)addReselutionsView:(NSArray *) resolutions type:(SVFVideoResolutionType )currentType
{
    if(self.switchResolutionView){
        return;
    }
    CGFloat height = 35 * [resolutions count];
    SwitchResolutionView *srView = [[SwitchResolutionView alloc] init];
    [self addSubview:srView];
    [srView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-25);
        make.right.equalTo(self).offset(-5);
        make.width.equalTo(@50);
        make.height.equalTo(@(height));
    }];
    [srView initWithResolutions:resolutions type:(SVFVideoResolutionType )currentType];
    
    self.switchResolutionView = srView;
    _weakSelf_
    self.switchResolutionView.srBlock = ^(id sender){
        _strongSelf_
        if(self.switchResolutionBlock){
            self.switchResolutionBlock(sender);
        }
        [self hideorShowResolution];
    };
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSwitchView:)];
    [self addGestureRecognizer:tap];
}

- (void)closeSwitchView: (UITapGestureRecognizer *)tap{
    
    if(self.switchResolutionView){
        [self.switchResolutionView removeFromSuperview];
        self.switchResolutionView = nil;
        [self hideorShowResolution];
    }
    [self removeGestureRecognizer:tap];
}


- (void)playorpause:(UIButton *)sender
{
    if(self.playPauseHandler){
        self.playPauseHandler(self.playPauseBtn);
    }
}

- (void)addPlayPauseHandler:(SHPlaybackOverlayHandler)handler
{
    self.playPauseHandler = handler;
}

- (void)beginScrubbing:(UISlider *)sender
{
    self.isBeginedScrub = YES;
    if (self.scrubHandler) {
        NSInteger seconds = self.totalDuration * sender.value;
        self.scrubHandler(SHBeginScrub,seconds);
    }
}

- (void)scrub:(UISlider *)sender
{
    if (!self.isBeginedScrub) {
        return;
    }
    if (self.scrubHandler) {
        NSInteger seconds = self.totalDuration * sender.value;
        self.scrubHandler(SHScrubing,seconds);
    }
}

- (void)endScrubbing:(UISlider *)sender
{
    if (!self.isBeginedScrub) {
        return;
    }
    if (self.scrubHandler) {
        NSInteger seconds = self.totalDuration * sender.value;
        self.scrubHandler(SHEndScrub,seconds);
    }
    self.isBeginedScrub = NO;
}

- (void)addScrubHandler:(SHPlaybackOverlayScrubHandler)handler
{
    self.scrubHandler = handler;
}

- (void)updatePlayDuration:(long long)seconds
{
    if (self.totalDuration <= 0) {
        return;
    }
    
    self.slider.value = 1.0 * seconds / self.totalDuration;
    
    NSString *played = [self formatterDuration:seconds];
    
    self.duration.text = [NSString stringWithFormat:@"%@/%@",played,self.totalDurationStr];
}

- (NSString *)formatterDuration:(long long)seconds
{
    long long min = seconds / 60;
    long long sec = seconds % 60;
    NSString *formated = [NSString stringWithFormat:@"%02ld:%02ld",(long)min,(long)sec];
    return formated;
}

- (void)updateTotalDuration:(long long)seconds
{
  
    self.totalDuration = seconds;
    
    self.totalDurationStr = [self formatterDuration:seconds];
    
    if(self.duration.text.length >= 6){
        NSString *headStr = [self.duration.text substringToIndex:6];
        if(![headStr isEqualToString:@"00:00/"]){
            self.duration.text = [headStr stringByAppendingString:self.totalDurationStr];
        }else{
            self.duration.text = [NSString stringWithFormat:@"00:00/%@",self.totalDurationStr];
        }
    }
    else{
       self.duration.text = [NSString stringWithFormat:@"00:00/%@",self.totalDurationStr];
    }
    
}

- (void)pause
{
    self.playPauseBtn.selected = YES;
}

- (void)resume
{
    self.playPauseBtn.selected = NO;
}

- (BOOL)isPause
{
    return self.playPauseBtn.selected;
}

@end
