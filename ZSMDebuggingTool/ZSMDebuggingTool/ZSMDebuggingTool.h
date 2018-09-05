//
//  ZSMDebuggingTool.h
//  ZSMDebuggingTool
//
//  Created by acadsoc on 2018/9/5.
//  Copyright © 2018年 Simon. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for ZSMDebuggingTool.
FOUNDATION_EXPORT double ZSMDebuggingToolVersionNumber;

//! Project version string for ZSMDebuggingTool.
FOUNDATION_EXPORT const unsigned char ZSMDebuggingToolVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <ZSMDebuggingTool/PublicHeader.h>

@interface ZSMDebuggingTool : NSObject

/**
 调用此方法在[AppDelegate application:didFinishLaunchingWithOptions:]方法中。
 两个手指同时点击状态栏弹出调试框。
 */
+ (void)showDebuggingToolWithStatus;

/**
 在任意位置调用弹出调试框。
 */
+ (void)showDebuggingToolWithSender;

@end
