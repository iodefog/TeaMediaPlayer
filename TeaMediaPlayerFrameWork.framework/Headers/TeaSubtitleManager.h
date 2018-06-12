//
//  TeaSubtitleManager.h
//  TeaApplePlayer
//
//  Created by JwJ on 14-8-11.
//  Copyright (c) 2014年 liweizhou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	DOWNLOAD_MODE_APPEND = 0,
	DOWNLOAD_MODE_INSERT,
	DOWNLOAD_MODE_CLEAR,
} DownloadMode;

typedef enum {
	OBTAIN_SUBTITLE_FAILED = -1,
	OBTAIN_SUBTITLE_SUCCESS = 0,
	OBTAIN_SUBTITLE_LOAD_NOW,
} RetObtainSubtitle;

@protocol NoteObtainFinish <NSObject>
// 获取字幕回调
-(void)messageCallBack:(RetObtainSubtitle) ret :(NSString *)sub_id :(NSString*)path;
@end


@interface TeaSubtitleManager : NSObject {
    id<NoteObtainFinish> noteObtainFinish;
}
@property (nonatomic,assign) id<NoteObtainFinish> noteObtainFinish;

+ (TeaSubtitleManager *)sharedTeaSubtitleManager: (NSString*)cache_path;

- (int) downloadSubtitle: (NSString*) sub_id : (NSString*) url : (DownloadMode) download_mode;

- (int) getSubtitle: (NSString*) sub_id : (NSString*) url;

- (int) removeSubtitle: (NSString*) sub_id;

- (int) removeAll ;

@end
