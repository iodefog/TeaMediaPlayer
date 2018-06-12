//
//  AppDelegate.m
//  SohuOpenSDKDemo
//
//  Created by 许乾隆 on 2017/5/8.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

#import "AppDelegate.h"
#import <SohuVideoFoundation/SohuVideoFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
// 注册应用
// 方式一、
//    [[SVFApplication sharedApplication] registerWithConfigName:@"SohuPlayerConfig.plist"];
    
    // 方式二、
    [[SVFApplication sharedApplication] registerApiKey:@"621d7cd50fbf2d125b5c153d45fa33bc" partner:@"130066"];
    
    [[SVFDownloadManager sharedManager] setupDownloadManagerWithOptions:nil]; //初始化下载器
    
    ///下载过程中网络发生了变化时，来询问下当前网络是否允许重试
    [[SVFDownloadManager sharedManager] currentNetworkConnectionShouldResumeTask:^BOOL{
        
        ///你可以使用自己的 Reachability，也可以使用下载框架提供的 SCReachability；
        
        SCReachStatus status = [[SCReachability sharedReachability]reachStatus];
        switch (status) {
            case SCReachableViaWiFi:
            {
                return YES;
            }
                break;
            case SCReachableViaWWAN:
            {
                ///根据产品策略来定，这里返回NO意味着，下载过程中由 WiFi 变为 WWAN 时不允许继续下载！！
                return NO;
            }
                break;
            case SCNotReachable:
            {
                return NO;
            }
                break;
        }
    }];
    
    ///检测网络变化
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(networkChanged) name:kSCReachabilityReachStatusChanged object:nil];
    
    ///主动调下，根据当前网络决定是否开始下载
    [self networkChanged];
    return YES;
}

- (void)networkChanged
{
    SCReachStatus reachStatus = [[SCReachability sharedReachability]reachStatus];
    switch (reachStatus) {
        case SCReachableViaWiFi:
        {
            [[SVFDownloadManager sharedManager]startAllDownloadTasks];
        }
            break;
        case SCReachableViaWWAN:
        case SCNotReachable:
        {
            ///先暂停所有任务
            [[SVFDownloadManager sharedManager]pauseAllDownloadTasks];
        }
            break;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[SVFDownloadManager sharedManager]pauseAllDownloadTasks];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    SCReachStatus status = [[SCReachability sharedReachability]reachStatus];
    switch (status) {
        case SCReachableViaWiFi:
        {
            [[SVFDownloadManager sharedManager]startAllDownloadTasks];
        }
            break;
        case SCReachableViaWWAN:
        case SCNotReachable:
        {
            [[SVFDownloadManager sharedManager]pauseAllDownloadTasks];
        }
            break;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
