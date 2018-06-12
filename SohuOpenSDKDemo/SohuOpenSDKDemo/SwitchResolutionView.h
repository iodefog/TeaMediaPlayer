//
//  SwitchResolutionView.h
//  SohuOpenSDKDemo
//
//  Created by wushang on 2017/6/9.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SohuVideoFoundation/SohuVideoFoundation.h>
typedef void(^switchResolutionBlock)(id sender);
@interface SwitchResolutionView : UIView

-(void) initWithResolutions:(NSArray<SVFVideoResolution *> *) resolutions type:(SVFVideoResolutionType )currentType;
@property (nonatomic, strong)switchResolutionBlock srBlock;

@end
