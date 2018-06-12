//
//  SHPlayerViewController.m
//  SohuOpenSDKDemo
//
//  Created by 许乾隆 on 2017/5/8.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

#import "SHPlayerViewController.h"
#import <SohuVideoFoundation/SohuVideoFoundation.h>
#import "SVWeakProxy.h"
#import "Masonry.h"
#import "SHPlaybackOverlay.h"
#import "UIView+SHLoading.h"

#ifndef _weakSelf_
#define _weakSelf_     __weak   __typeof(self) $weakself = self;
#endif

#ifndef _strongSelf_
#define _strongSelf_   __strong __typeof($weakself) self = $weakself;
#endif


@interface SHPlayerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,weak) UIView <SVFVideoPlayerProtocols>* playerView;
@property (nonatomic ,weak) UITableView *tb;

@property (nonatomic ,weak) NSTimer *timer;
@property (nonatomic ,copy) NSString *vid;
@property (nonatomic ,copy) NSString *site;
@property (nonatomic ,copy) NSString *url;

@property (nonatomic ,strong) NSArray *dataSources;
@property (nonatomic ,strong) NSArray *resolutionBtns;

@property (nonatomic ,weak) UIActivityIndicatorView *indicatorView;
@property (nonatomic ,weak) SHPlaybackOverlay *overly;
@property (nonatomic ,strong) NSNumber *duration;

@property (nonatomic, weak) UIView *errorView;
@property (nonatomic, copy) NSString *currentResolutionStr;
@property (nonatomic, strong)NSArray *resolutonArr;
@property (nonatomic, assign) SVFVideoResolutionType currentType;

@end

@implementation SHPlayerViewController

- (instancetype)initVid:(NSString *)vid site:(NSString *)site
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.vid = vid;
        self.site = site;
    }
    return self;
}

- (instancetype)initUrl:(NSString *)url
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.url = url;
    }
    return self;
}

- (void)dealloc
{
    [self.errorView removeFromSuperview];
    self.errorView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareVideoPlayer];
    [self prepareTableView];
    [self makeSubviewCons];
    [self prepareData];
}

- (void)push
{
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
    
//    [[UIDevice currentDevice]setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
//    [UIView animateWithDuration:0.3 animations:^{
//        self.view.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
//        self.view.frame = self.view.window.bounds;
//    }];
//
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    [[UIApplication sharedApplication]setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"push" style:UIBarButtonItemStylePlain target:self action:@selector(push)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.errorView removeFromSuperview];
    [self.playerView resume];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[self.playerView pause];
    //[self.overly pause];
    
    [self.playerView stop];
}

- (void)prepareVideoPlayer
{
    UIView <SVFVideoPlayerProtocols>* playerView = [SVFApplication createVideoPlayer];

    playerView.scaleModel = SVFVideoPlayerScaleModeAspectFit;
    [self.view addSubview:playerView];
    
    self.playerView = playerView;
    
    _weakSelf_
    [playerView observerPlayerError:^(SVFVideoPlayerError err) {
        _strongSelf_
        NSLog(@"播放失败：%lu",(unsigned long)err);
        switch (err) {
            case SVFVideoPlayerPlayForbidden:
                [self addVideoForbiddenViewWithText:@"您要观看的剧集暂时不能播放，\n请到搜狐视频观看"];
                break;
            case SVFVideoPlayerRequestVideoInfoError:
               [self addVideoForbiddenViewWithText:@"请求播放地址失败"];
                break;
            case SVFVideoPlayerPlayErr:
               [self addVideoForbiddenViewWithText:@"播放过程中出错了"];
                break;
            case SVFVideoPlayerOpenFailed:
                [self addVideoForbiddenViewWithText:@"无法打开视频流"];
                break;
            case SVFVideoPlayerUnReacheNet:
                [self addVideoForbiddenViewWithText:@"无法连接到网络"];
                break;
            default:
                break;
        }

    }];
    
    [playerView observerBeginLoading:^{ //开始Loading
        _strongSelf_
        [self.playerView hideLoading];
        UIImage *image = [UIImage imageNamed:@"loading"];
        [self.playerView showLoading:image];
    }];
    
    [playerView observerEndLoading:^{ //结束Loading
        _strongSelf_
        [self.playerView hideLoading];
    }];
    
    [playerView observerBufferState:^(SVFVideoPlayerBufferSate state, NSInteger progress) {
        _strongSelf_
        switch (state) {
            case SVFVideoPlayerBufferBegan:
            {
                if(![self.playerView isLoading]){
                    UIImage *image = [UIImage imageNamed:@"loading"];
                    [self.playerView showLoading:image];
                }
            
//                self.progress.hidden = NO;
//                self.progress.progress = 0;
                [self stopUpdatePlayedTimer];
         
            }
                break;
            case SVFVideoPlayerBuffering:
            {
//                self.progress.progress = progress/100.0;
            }
                break;
            case SVFVideoPlayerBufferOK:
            {
//                self.progress.hidden = YES;
                [self startUpdatePlayedTimer];
                [self.playerView hideLoading];
            }
                break;
        }
    }];

    
    [playerView observerVideoDuration:^(long long ms) {
        _strongSelf_
        self.duration = @(ms);
        [self startUpdatePlayedTimer];
        [self.overly updateTotalDuration:ms / 1000];
    }];
    
    [playerView observerPlay2End:^{
        _strongSelf_
        NSLog(@"---播放结束");
        [self.playerView stop];
        [self addVideoForbiddenViewWithText:@"播放完毕"];
    }];
    
    ///播放  88590768 82965044
    ///http://flv2.bn.netease.com/videolib3/1705/07/bSqdy1374/SD/bSqdy1374-mobile.mp4
    ///http://flv2.bn.netease.com/videolib3/1704/30/PmwAh4370/SD/movie_index.m3u8
    //    http://flv2.bn.netease.com/videolib3/1705/09/yjApP8512/SD/movie_index.m3u8
    ///播放搜狐视频的视频
    //    [playerView resumeVid:@"88590768" site:@"2"];
    //    http://flv2.bn.netease.com/videolib3/1704/30/PmwAh4370/SD/movie_index.m3u8
    //    http://flv2.bn.netease.com/videolib3/1705/07/bSqdy1374/SD/bSqdy1374-mobile.mp4
    
    //    [playerView resumeURL:@"http://flv2.bn.netease.com/videolib3/1705/07/bSqdy1374/SD/bSqdy1374-mobile.mp4"];


    ///搜狐源的清晰度
    [playerView observerVideoResolution:^(NSArray<SVFVideoResolution *> *resolutions,SVFVideoResolutionType currentType) {
        
        _strongSelf_
        self.resolutonArr = resolutions; //顺序不能变
        self.currentType = currentType;
        self.currentResolutionStr = [self resolutionTypeNameOf:currentType];
        if(self.vid && self.overly){
            [self.overly showCurrentResolution:self.currentResolutionStr];
        }
//        CGFloat margin = 30;
//        CGFloat vwidth = (self.view.bounds.size.width - 40 - margin * ([resolutions count]-1)) / [resolutions count];
//        for (UIButton *btn in self.resolutionBtns) {
//            [btn removeFromSuperview];
//        }
//        self.resolutionBtns = nil;
//        
//        NSMutableArray *tmpArr = [NSMutableArray array];
//        
//        for (int i = 0; i < resolutions.count; i++) {
//            SVFVideoResolution *resolution = resolutions[i];
//        
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [btn setTitle:resolution.desc forState:UIControlStateNormal];
//            btn.frame = CGRectMake(i * (vwidth + margin)+ 20, offsetY, vwidth, 30);
//            CGFloat c = 1.0 * i / [resolutions count];
//            
//            btn.backgroundColor = [UIColor colorWithRed:c green:c blue:c alpha:1];
//            
//            [self.view addSubview:btn];
//            btn.tag = resolution.type + 10000;
//            [btn addTarget:self action:@selector(switchResolution:) forControlEvents:UIControlEventTouchUpInside];
//            [tmpArr addObject:btn];
//        }
//        self.resolutionBtns = [tmpArr copy];
    }];
    
    [playerView observerWhenPrepareSubView:^{
        _strongSelf_
        if (self.overly) {
            return;
        }
        SHPlaybackOverlay *overly = [[SHPlaybackOverlay alloc]init];
        [self.view addSubview:overly];
        self.overly = overly;
        overly.showResolutions = ^(){
            _strongSelf_
            [self.overly hideorShowResolution];
            [self.overly addReselutionsView:self.resolutonArr type:self.currentType];
        };
        overly.switchResolutionBlock = ^(id sender){
            _strongSelf_
            [self switchResolution:sender];
        };
        if(self.vid){
            [overly showCurrentResolution:self.currentResolutionStr];
        }else{
            [overly hideorShowResolution];
        }
                
        [overly mas_makeConstraints:^(MASConstraintMaker *make) {
            _strongSelf_
            make.left.equalTo(self.playerView);
            make.right.equalTo(self.playerView);
            make.bottom.equalTo(self.playerView);
            make.top.equalTo(self.playerView);
        }];
        
        [overly addPlayPauseHandler:^(UIControl *ctrl) {
            _strongSelf_
            ///按钮选择时是暂停；
            if (ctrl.isSelected) {
                [self.playerView resume];
                [self startUpdatePlayedTimer];
            }else{
                [self.playerView pause];
                [self stopUpdatePlayedTimer];
            }
            [ctrl setSelected:!ctrl.isSelected];
        }];
        
        [overly addScrubHandler:^(SHOverlayScrubType type, NSInteger value) {
        
            _strongSelf_
            
            switch (type) {
                case SHBeginScrub:
                {
                    [self stopUpdatePlayedTimer];
                }
                    break;
                case SHScrubing:
                {
                    [self.overly updatePlayDuration:value];
                }
                    break;
                case SHEndScrub:
                {
                    ///注意单位ms
                    [self.playerView seekto:value*1000];
                    //[self startUpdatePlayedTimer];
                }
                    break;
            }
        }];
        ///播放的时候resume了，按钮状态保持一致；
        [overly resume];
    }];
    
    ///要在observer添加完毕之后resume；否则observer可能不会回调
    if (self.url) {
        [playerView resumeURL:self.url];
    }else{
        [playerView resumeVid:self.vid site:self.site];
    }
    
/*
当程序 resignActive 的时间就停止播放，这样做不会导致系统播放器黑屏下；
比如：下拉通知栏，上滑
 */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
/*
    使用下面两个通知处理的话，程序 resignActive 的时候仍旧可以播放，但是从后台回到前台时系统播放器会黑屏下；
 
 */
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)prepareTableView
{
    UITableView *tb = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    tb.estimatedRowHeight = 0;
    [self.view addSubview:tb];
    tb.delegate = self;
    tb.dataSource = self;
    [tb registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)prepareData
{
    _dataSources = @[@{@"vid":@"9218631",@"site":@"2"},
                     @{@"vid":@"82965044",@"site":@"2"},
                     @{@"vid":@"89744086",@"site":@"2"},
                     @{@"vid":@"85658498",@"site":@"2"},
                     @{@"url":@"http://flv2.bn.netease.com/videolib3/1705/07/bSqdy1374/SD/bSqdy1374-mobile.mp4"}
                     ];
    [self.tb reloadData];
}

- (void)makeSubviewCons
{
    CGFloat vwidth = self.view.bounds.size.width;
    CGFloat offsetY = 64;
    CGFloat playerH = vwidth / 16.0 * 9;
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(@0);
        make.top.equalTo(@(offsetY));
        make.height.equalTo(@(playerH));
    }];
    
    [self.tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(@0);
        make.top.equalTo(self.playerView.mas_bottom);
        make.bottom.equalTo(@0);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = self.dataSources[indexPath.row];
    
    NSString *vid = info[@"vid"];
    NSString *site = info[@"site"];
    NSString *url = info[@"url"];
    
    if (vid) {
        [self.playerView resumeVid:vid site:site];
    }else{
        [self.playerView resumeURL:url];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *info = self.dataSources[indexPath.row];
    
    NSString *vid = info[@"vid"];
    if (vid) {
        cell.textLabel.text = [@"sohu : " stringByAppendingString:vid];
    }else{
         NSString *url = info[@"url"];
        cell.textLabel.text = [@"other : " stringByAppendingString:url];
    }
}

- (void)applicationWillResignActive:(NSNotification *)notifi
{
    if (self.flag) {
        [self.playerView stopAndReset];
    }else{
        [self.playerView stop];
    }
    
    [self stopUpdatePlayedTimer];
    //[self.overly pause];
}

//- (void)applicationDidEnterBackground:(NSNotification *)notifi
//{
//    if (self.flag) {
//        [self.playerView stopAndReset];
//    }else{
//        [self.playerView stop];
//    }
//    
//    [self stopUpdatePlayedTimer];
//    [self.overly pause];
//}

- (void)applicationDidBecomeActive:(NSNotification *)notifi
{
    ///展示的不是播放器VC，就不要走播放逻辑喽；
    if (![[self.navigationController visibleViewController] isKindOfClass:[self class]]) {
        return;
    }
    if(self.overly){ //如果已经开始播正片
        if([self.overly isPause]){ //且退后台前为暂停状态
            return; //不继续播
        }
    }
    [self.errorView removeFromSuperview];
    [self.playerView resume];
    [self.overly resume];
}

//- (void)applicationWillEnterForeground:(NSNotification *)notifi
//{
//    [self.playerView resume];
//    [self.overly resume];
//}

- (void)startUpdatePlayedTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    SVWeakProxy *weakProxy = [SVWeakProxy weakProxyWithTarget:self];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakProxy selector:@selector(doUpdatePlayedTime) userInfo:nil repeats:YES];
}

- (void)stopUpdatePlayedTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)doUpdatePlayedTime
{
    long long playedTime = [self.playerView currentPlayedTime]/1000;
    [self.overly updatePlayDuration:playedTime];
}

- (void)switchResolution:(UIButton *)sender
{
    SVFVideoResolutionType type = (sender.tag - 10000);
    self.currentType = type;
    [self.overly showCurrentResolution:[self resolutionTypeNameOf:type]];
    [self.playerView switchVideoResolution:type];
    
    [self.overly resume];
}

- (NSString *)resolutionTypeNameOf:(SVFVideoResolutionType)type
{
    for(SVFVideoResolution *resolution in self.resolutonArr){
        if (type == resolution.type){
            return resolution.desc;
        }
    }
    return @"默认";
}

- (void)addVideoForbiddenViewWithText:(NSString *)text
{
    CGFloat vwidth = self.view.bounds.size.width;
    CGFloat offsetY = 64;
     CGFloat playerH = vwidth / 16.0 * 9;
    UIView  *errorView = [[UIView alloc] initWithFrame:CGRectMake(0,offsetY, vwidth,playerH)];
    
    errorView.frame = CGRectMake(0, offsetY, vwidth, playerH);
    errorView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
   
    [self.view addSubview:errorView];
    errorView.backgroundColor = [UIColor grayColor];
    self.errorView = errorView;
    
    UILabel *lb = [[UILabel alloc] init];
    [self.errorView addSubview:lb];
    _weakSelf_
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        _strongSelf_
        make.center.equalTo(self.errorView);
    }];
    lb.text = text;
    lb.numberOfLines = 2;
    lb.textColor = [UIColor redColor];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
