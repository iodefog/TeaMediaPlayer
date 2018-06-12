//
//  SwitchResolutionView.m
//  SohuOpenSDKDemo
//
//  Created by wushang on 2017/6/9.
//  Copyright © 2017年 sohu-inc. All rights reserved.
//

#import "SwitchResolutionView.h"
#import "Masonry.h"


#ifndef _weakSelf_
#define _weakSelf_     __weak   __typeof(self) $weakself = self;
#endif

#ifndef _strongSelf_
#define _strongSelf_   __strong __typeof($weakself) self = $weakself;
#endif

@interface SwitchResolutionView()

@property (nonatomic ,strong) NSArray *resolutionBtns;

@end


@implementation SwitchResolutionView

- (void) initWithResolutions:(NSArray<SVFVideoResolution *> *)resolutions type:(SVFVideoResolutionType )currentType
{
    {
        float r = (float)192/255;
        self.backgroundColor = [UIColor colorWithRed:r green:r blue:r alpha:0.5];
        [self.layer setCornerRadius:10];
        
        [self setFrame:CGRectZero];
        for (UIButton *btn in self.resolutionBtns) {
            [btn removeFromSuperview];
        }
        self.resolutionBtns = nil;

        NSMutableArray *tmpArr = [NSMutableArray array];
        UIButton *lastBtn = nil;
        for (int i = 0; i < resolutions.count; i++) {
            SVFVideoResolution *resolution = resolutions[i];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:resolution.desc forState:UIControlStateNormal];
           
            [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
            
            if(currentType == (resolution.type)){
                btn.backgroundColor = [UIColor darkGrayColor];
                btn.layer.cornerRadius = 7.5;
            }else{
                 btn.backgroundColor = [UIColor clearColor];
            }
            [self addSubview:btn];
            _weakSelf_
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                _strongSelf_
                if(lastBtn){
                    make.bottom.equalTo(lastBtn.mas_top).offset(-5);
                }else{
                    make.bottom.equalTo(self.mas_bottom).offset(-5);
                }
                make.centerX.equalTo(self);
                make.width.equalTo(@(50));
            }];
            lastBtn = btn;
            btn.tag = (resolution.type )+ 10000;
            [btn addTarget:self action:@selector(switchResolution:) forControlEvents:UIControlEventTouchUpInside];
            [tmpArr addObject:btn];
            
        }
        //self.resolutionBtns = [tmpArr copy];
    }
    
}


- (void)switchResolution:(id)sender
{
    if(self.srBlock)
    {
        self.srBlock(sender);
    }
    [self removeFromSuperview];
}

@end
