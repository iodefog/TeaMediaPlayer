//
//  TeaMeidaTranscoderDelegate.h
//  TeaMediaPlayer
//
//  Created by dengxuezheng on 6/7/16.
//  Copyright © 2016 zhouliwei. All rights reserved.
//

#ifndef TeaMeidaTranscoderDelegate_h
#define TeaMeidaTranscoderDelegate_h

#import <Foundation/Foundation.h>

@protocol TeaMeidaTranscoderDelegate <NSObject>

@optional

- (void)OnTranscodeComplete;

- (void)OnTranscodeFail:(NSInteger) codecid :(NSString*) codec;

- (void)OnTranscodeFail;

- (void)OnTranscodeProgress:(float)progress;

@end

#endif /* TeaMeidaTranscoderDelegate_h */
