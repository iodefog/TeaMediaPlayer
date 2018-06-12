//
//  SVFApplication.h
//  SohuVideoFoundation
//
//  Created by 许乾隆 on 2017/5/8.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SVFVideoPlayerProtocols.h"

@interface SVFApplication : NSObject

/**
 单利对象
 */
+ (instancetype)sharedApplication;

/**
 注册方式1.
 使用播放器之前调用该方法，传入正确的配置文件名称；该配置文件需要加入到主工程里；
 配置文件里须要包含： apikey，partner
 @param cname 配置文件名字；
 */
- (void)registerWithConfigName:(NSString *)cname;


/**
 注册方式2. (与方式1,二者选其一即可)
 注册apikey 和 partner（渠道号）

 @param apikey  apikey
 @param partner 渠道号
 */
- (void)registerApiKey:(NSString *)apikey partner:(NSString *)partner;


/**
 * 打印播放器内部调试log， 默认不开启
 */
- (void)setPrintLog:(BOOL)print;

/**
 创建播放器View;
 需要自己管理该View，SVFApplication 只是 new 一个而已；
 */
+ (UIView<SVFVideoPlayerProtocols> *)createVideoPlayer;

@end
