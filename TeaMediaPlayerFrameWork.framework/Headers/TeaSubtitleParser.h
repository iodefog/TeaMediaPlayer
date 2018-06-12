//
//  TeaSubtitleParser.h
//  TeaApplePlayer
//
//  Created by JwJ on 14-8-7.
//  Copyright (c) 2014年 liweizhou. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
ALIGNMENT_BOTTOMLEFT      = 1,
ALIGNMENT_BOTTOMCENTER    = 2,
ALIGNMENT_BOTTOMRIGHT     = 3,
ALIGNMENT_MIDDLELEFT      = 4,
ALIGNMENT_MIDDLECENTER    = 5,
ALIGNMENT_MIDDLERIGHT     = 6,
ALIGNMENT_TOPLEFT         = 7,
ALIGNMENT_TOPCENTER       = 8,
ALIGNMENT_TOPRIGHT        = 9,
}SubtitleAlignment;



@interface TeaSubtitleParser : NSObject

- (BOOL)openSubtitle:(NSString*)path;

- (void)closeSubtitle;

//获取字幕总条数
- (int)getSubtitleTxtCount;

//获取当前字幕的对其方式
- (int)getSubtitleCurAlignment;

//获取当前字幕索引
- (int)getSubtitleCurIdx;

//获取当前字幕
- (NSString*)getSubtitleCurTxt:(long)ts;

//获取指定索引位置的字幕
- (NSString*)getSubtitleTxtByIdx:(int)idx;

//获取当前字幕的开始时间
- (unsigned long)getCurSubtitleStartTime;

//获取当前字幕的结束时间
- (unsigned long)getCurSubtitleEndTime;

@end
