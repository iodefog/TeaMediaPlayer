//
//  TeaMeidaTranscoder.h
//  TeaMediaPlayer
//
//  Created by dengxuezheng on 6/7/16.
//  Copyright © 2016 zhouliwei. All rights reserved.
//

#ifndef TeaMeidaTranscoder_h
#define TeaMeidaTranscoder_h

#import <Foundation/Foundation.h>
#import "TeaMeidaTranscoderDelegate.h"

@interface TeaMediaInfo : NSObject

@property (nonatomic, assign) NSUInteger videoWidth;
@property (nonatomic, assign) NSUInteger videoHeight;
@property (nonatomic, assign) NSUInteger pixAspectWidth;
@property (nonatomic, assign) NSUInteger pixAspectHeight;
@property (nonatomic, assign) NSUInteger videoRotate;
@property (nonatomic, assign) NSUInteger audioSimpleRate;
@property (nonatomic, assign) NSUInteger audioChannels;
@property (nonatomic, assign) NSString * videoCodec;
@property (nonatomic, assign) NSString * audioCodec;
@end

@interface TeaMediaTransCoder: NSObject

@property (nonatomic, assign) id<TeaMeidaTranscoderDelegate> delegate;

+ (instancetype)sharedInstance;

//- (void)startTransCodeByPath:(NSString *)v_strVideoPath andSavePath:(NSString *)v_strSavePath;

//- (void)cancelTransCode;

- (void)startSoftTransCodeByPath:(NSString *)v_strVideoPath andSavePath:(NSString *)v_strSavePath watermarkPath:(NSString *)v_wVideoPath;

- (void)startSoftTransCodeByPath:(NSString *)v_strVideoPath andSavePath:(NSString *)v_strSavePath;

- (void)startTransOldCodeByPath:(NSString *)v_strVideoPath andSavePath:(NSString *)v_strSavePath;

- (void)cancelSoftTransCode;

- (void)setTransCodeScaleW:(long)width H:(long)height;

- (void)setTransCodeCropW:(long)width H:(long)height;

- (BOOL)getMediaInfo:(TeaMediaInfo *)info path:(NSString *)path;
@end
#endif /* TeaMeidaTranscoder_h */
