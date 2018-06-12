//
//  SHRootViewController.m
//  SohuOpenSDKDemo
//
//  Created by 许乾隆 on 2017/5/17.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

#import "SHRootViewController.h"
#import "SHPlayerViewController.h"
#import "SHVideoListViewController.h"
#import <SohuVideoFoundation/SVFDownloadKit.h>

@interface SHRootViewController ()

@property (weak, nonatomic) IBOutlet UITextField *vidTx;
@property (weak, nonatomic) IBOutlet UITextField *siteTx;
@property (weak, nonatomic) IBOutlet UIButton *playBtnSohu;

@property (weak, nonatomic) IBOutlet UITextField *urlTx;
@property (weak, nonatomic) IBOutlet UIButton *playBtnOther;

@property (weak, nonatomic) IBOutlet UITextField *aidTx;
@property (weak, nonatomic) IBOutlet UITextField *aidSiteTx;
@property (weak, nonatomic) IBOutlet UIButton *downloadBtn;

@property (weak, nonatomic) IBOutlet UILabel *concurrentLb;

@end

@implementation SHRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vidTx.text = @"3357323";//@"3781149";
    self.siteTx.text = @"1";
    
    self.aidTx.text = @"9316606";
    self.aidSiteTx.text = @"1";
    [self refreshConcurrentLb];
    self.tableView.allowsSelection = YES;
}

- (IBAction)playSohuVideo:(UIButton *)sender {
    NSString *vid = self.vidTx.text;
    NSString *site = self.siteTx.text;
    if (vid.length > 0 && site.length > 0) {
        SHPlayerViewController *vc = [[SHPlayerViewController alloc]initVid:vid site:site];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self warnPlayBtn:sender];
    }
}

- (IBAction)playSohuVideo2:(UIButton *)sender
{
    NSString *vid = self.vidTx.text;
    NSString *site = self.siteTx.text;
    if (vid.length > 0 && site.length > 0) {
        SHPlayerViewController *vc = [[SHPlayerViewController alloc]initVid:vid site:site];
        vc.flag = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self warnPlayBtn:sender];
    }
}

- (IBAction)playOtherVideo:(UIButton *)sender {
    
    NSString *url = self.urlTx.text;
    if (url.length > 0) {
        SHPlayerViewController *vc = [[SHPlayerViewController alloc]initUrl:url];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self warnPlayBtn:sender];
    }
}

- (IBAction)downloadVideos:(UIButton *)sender
{
    NSString *aid = self.aidTx.text;
    NSString *site = self.aidSiteTx.text;
    if (aid.length > 0 && site.length > 0) {
        SHVideoListViewController *vc = [[SHVideoListViewController alloc]initAid:aid site:site];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self warnPlayBtn:sender];
    }
}

- (IBAction)stepped:(UIStepper *)sender {
    [[SVFDownloadManager sharedManager]setMaxConcurrentOperationCount:sender.value];
    [self refreshConcurrentLb];
}

- (void)refreshConcurrentLb
{
    self.concurrentLb.text = [NSString stringWithFormat:@"最大并发数：%ld",(long)[[SVFDownloadManager sharedManager]maxConcurrentOperationCount]];
}

- (void)warnPlayBtn:(UIButton *)sender{
    sender.backgroundColor = [UIColor redColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.backgroundColor = [UIColor lightGrayColor];
    });
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row != 4 || indexPath.section != 2){
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SVFGeneralDownloadViewController *downloadVC = [[SVFGeneralDownloadViewController alloc] init];
    [self.navigationController pushViewController:downloadVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
