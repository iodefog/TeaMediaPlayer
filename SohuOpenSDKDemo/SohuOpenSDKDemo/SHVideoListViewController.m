//
//  SHVideoListViewController.m
//  SohuOpenSDKDemo
//
//  Created by wushang on 2017/6/27.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

#import "SHVideoListViewController.h"
#import <SohuVideoFoundation/SohuVideoFoundation.h>

#ifndef _weakSelf_
#define _weakSelf_     __weak   __typeof(self) $weakself = self;
#endif

#ifndef _strongSelf_
#define _strongSelf_   __strong __typeof($weakself) self = $weakself;
#endif

@interface SHVideoListViewController ()
@property (nonatomic ,copy) NSString *aid;
@property (nonatomic ,copy) NSString *site;
@property (nonatomic ,weak) SVFAlbumDownLoadView *albumView;
@end

@implementation SHVideoListViewController

- (instancetype)initAid:(NSString *)aid site:(NSString *)site
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.aid = aid;
        self.site = site;
    }
    return self;
}

- (void)dealloc
{
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.albumView checkDownloadState];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark 准备专辑下载视图
- (void)prepareCollectionView
{
    SVFAlbumDownLoadView *albumView = [[SVFAlbumDownLoadView alloc] initWithAid:self.aid site:self.site];
    
    albumView.frame = CGRectMake(0, 64, self.view.bounds.size.width,self.view.bounds.size.height - 64);
    [self.view addSubview: albumView];
    self.albumView = albumView;
}

@end
