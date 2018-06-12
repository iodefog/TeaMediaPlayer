//
//  SohuOpenSDKDemoTests.m
//  SohuOpenSDKDemoTests
//
//  Created by xuqianlong on 2017/6/14.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <SohuVideoFoundation/SohuVideoFoundation.h>

@interface SohuOpenSDKDemoTests : XCTestCase

@end

@implementation SohuOpenSDKDemoTests

- (void)setUp {
    [super setUp];
    [[SVFDownloadManager sharedManager]setupDownloadManager];
    
    [[SVFDownloadManager sharedManager]startAllDownloadTasks];
    
    [[SVFDownloadManager sharedManager]setMaxConcurrentOperationCount:3];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAddDownloadTask {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [[SVFDownloadManager sharedManager]addTaskWithVid:3357323 site:1 competion:^(NSError *err) {
        if(err){
            NSLog(@"添加任务失败：%@",err);
        }
    }];
    
}

//aid 9316606
//vid 3679786
//vid 3679783
//vid 3679793


//aid 5755603
//vid 1278580



- (void)testAddAndRemoveDownloadTasks
{
    [self doAddAndRemoveDownloadTasks];
    [[NSRunLoop currentRunLoop]run];
}

- (void)doAddAndRemoveDownloadTasks
{
    [[SVFDownloadManager sharedManager]addTaskWithVid:3679786 site:1 competion:^(NSError *err) {
        NSLog(@"添加任务3679786：%@",err);
    }];
    
    [[SVFDownloadManager sharedManager]addTaskWithVid:3679783 site:1 competion:^(NSError *err) {
        NSLog(@"添加任务3679783：%@",err);
    }];
    
    [[SVFDownloadManager sharedManager]addTaskWithVid:3679793 site:1 competion:^(NSError *err) {
        NSLog(@"添加任务3679793：%@",err);
    }];
    
    NSArray <SVFDownloadTask *>*unFinishedArr = [[SVFDownloadManager sharedManager]allUnFinishedTaskArr];
    
    NSLog(@"unFinishedArr:%@",unFinishedArr);
    for (SVFDownloadTask *task in unFinishedArr) {
        [task addDownloadStateNotifi:^(SVFDownloadTaskState state) {
            if(state == SVFDownloadTaskStateFinished){
                ///移除任务
                [[SVFDownloadManager sharedManager]removeDownloadTaskWithAid:9316606];
                [self doAddAndRemoveDownloadTasks];
            }
        }];
        
        [task addDownloadProgressNotifi:^(float p) {
            NSLog(@"下载进度：%g",p);
        }];
    }
    
    NSLog(@"unFinishedArr:%@",unFinishedArr);
    
    NSAssert([unFinishedArr count] <= 3, @"fuck");

}
- (void)testAddThenStartDownloadTask {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [[SVFDownloadManager sharedManager]addTaskWithVid:3357323 site:1 competion:^(NSError *err) {
        if(err){
            NSLog(@"添加任务失败：%@",err);
        }
    }];
    
    NSArray <SVFDownloadTask *>*unFinishedArr = [[SVFDownloadManager sharedManager]allUnFinishedTaskArr];
    
    for (SVFDownloadTask *task in unFinishedArr) {
        [task addDownloadSpeedNotifi:^(double kbps) {
            NSLog(@"下载速度：%g",kbps);
        }];
        
        [task addDownloadProgressNotifi:^(float p) {
            NSLog(@"下载进度：%g",p);
        }];
    }

    
    [[NSRunLoop currentRunLoop]run];
   
}

- (void)testStartAllDownloadTasks
{
    
    NSArray <SVFDownloadTask *>*unFinishedArr = [[SVFDownloadManager sharedManager]allUnFinishedTaskArr];
    
    for (SVFDownloadTask *task in unFinishedArr) {
        [task addDownloadSpeedNotifi:^(double kbps) {
            NSLog(@"下载速度：%g",kbps);
        }];
        
        [task addDownloadProgressNotifi:^(float p) {
            NSLog(@"下载进度：%g",p);
        }];
    }
    
    [[SVFDownloadManager sharedManager]startAllDownloadTasks];
    
    [[NSRunLoop currentRunLoop]run];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
