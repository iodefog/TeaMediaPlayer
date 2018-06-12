//
//  SVFAlbumDownLoadView.h
//  SohuVideoFoundation
//
//  Created by wushang on 2017/6/21.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface SVFAlbumDownLoadView : UIView<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

- (instancetype)initWithAid:(NSString *)aid site:(NSString *)site;
- (void)checkDownloadState; //检查是否有下载过的： 已下载的标绿
- (void)prepareView;

@end
