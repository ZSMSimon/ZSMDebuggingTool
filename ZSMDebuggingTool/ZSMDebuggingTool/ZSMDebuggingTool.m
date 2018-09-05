//
//  ZSMDebuggingTool.m
//  ZSMDebuggingTool
//
//  Created by acadsoc on 2018/9/5.
//  Copyright © 2018年 Simon. All rights reserved.
//

#import "ZSMDebuggingTool.h"

@interface OverlayWindow : UIWindow

- (UIGestureRecognizerState)state;

@end

@implementation OverlayWindow

- (UIGestureRecognizerState)state {
    return UIGestureRecognizerStateEnded;
}

@end

@implementation ZSMDebuggingTool

+ (void)showDebuggingToolWithStatus {
    
#if DEBUG
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    id overlayClass = NSClassFromString(@"UIDebuggingInformationOverlay");
    [overlayClass performSelector:NSSelectorFromString(@"prepareDebuggingOverlay")];
#pragma clang diagnostic pop
    
#endif
    
}

+ (void)showDebuggingToolWithSender {
    
#if DEBUG
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (@available(iOS 11.0, *)) {
        
        // 模拟两个手指点击状态栏的事件
        
        id overlayClass = NSClassFromString(@"UIDebuggingInformationOverlay");
        [overlayClass performSelector:NSSelectorFromString(@"overlay")];
        id handlerClass = NSClassFromString(@"UIDebuggingInformationOverlayInvokeGestureHandler");
        
        id handler = [handlerClass performSelector:NSSelectorFromString(@"mainHandler")];
        [handler performSelector:NSSelectorFromString(@"_handleActivationGesture:") withObject:[[OverlayWindow alloc] init]];
    } else {
        id overlayClass = NSClassFromString(@"UIDebuggingInformationOverlay");
        id overlay = [overlayClass performSelector:NSSelectorFromString(@"overlay")];
        [overlay performSelector:NSSelectorFromString(@"toggleVisibility")];
    }
#pragma clang diagnostic pop
    
#endif
}

@end
