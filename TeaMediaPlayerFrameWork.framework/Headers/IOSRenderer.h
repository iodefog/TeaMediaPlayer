
#ifndef _IOSRenderer
#define _IOSRenderer

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol IOSRendererDelegate <NSObject>

- (void)onViewReadyToRender;

@end

@interface IOSRenderer : UIView {
}
@property (nonatomic, assign) id<IOSRendererDelegate> delegate;

- (int)getViewportWidth;

- (int)getViewportHeight;

- (void)getContext;

- (void)render;

- (void)setVideoSize:(CGSize)size;

- (void)updateViewFrame:(CGRect)frame;

- (void)reset;

- (void)destoryFrameRenderBuffer;

@end

#endif
