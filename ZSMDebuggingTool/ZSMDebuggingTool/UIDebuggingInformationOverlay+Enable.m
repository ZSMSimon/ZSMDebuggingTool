//
//  UIDebuggingInformationOverlay+Enable.m
//  ZSMDebuggingTool
//
//  Created by acadsoc on 2018/9/5.
//  Copyright © 2018年 Simon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

/*
 在iOS 11中，苹果添加了额外的检查来禁用这个覆盖，除非设备是一个内部设备。为了解决这个问题，我们把
 -[UIDebuggingInformationOverlay init]方法(如果现在返回nil该设备是非内部的)和
 +[UIDebuggingInformationOverlay prepareDebuggingOverlay]方法剔除。
 */

#if defined(DEBUG) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_11_0

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@interface UIWindow (PrivateMethods)
- (void)_setWindowControlsStatusBarOrientation:(BOOL)orientation;
@end

@interface FakeWindowClass : UIWindow
@end

@implementation FakeWindowClass

- (instancetype)initSwizzled {
    self = [super init];
    if (self) {
        [self _setWindowControlsStatusBarOrientation:NO];
    }
    return self;
}

@end

@implementation NSObject (UIDebuggingInformationOverlayEnable)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"UIDebuggingInformationOverlay");
        [FakeWindowClass swizzleSelector:@selector(init) newSelector:@selector(initSwizzled) forClass:cls isClassMethod:NO];
        [self swizzleSelector:@selector(prepareDebuggingOverlay) newSelector:@selector(prepareDebuggingOverlaySwizzled) forClass:cls isClassMethod:YES];
    });
}

+ (void)swizzleSelector:(SEL)originalSelector newSelector:(SEL)swizzledSelector forClass:(Class)class isClassMethod:(BOOL)isClassMethod {
    Method originalMethod = NULL;
    Method swizzledMethod = NULL;
    
    if (isClassMethod) {
        originalMethod = class_getClassMethod(class, originalSelector);
        swizzledMethod = class_getClassMethod([self class], swizzledSelector);
    } else {
        originalMethod = class_getInstanceMethod(class, originalSelector);
        swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
    }
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

+ (void)prepareDebuggingOverlaySwizzled {
    id overlayClass = NSClassFromString(@"UIDebuggingInformationOverlayInvokeGestureHandler");
    id handler = [overlayClass performSelector:NSSelectorFromString(@"mainHandler")];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:handler action:@selector(_handleActivationGesture:)];
    tapGesture.numberOfTouchesRequired = 2;
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = handler;
    
    UIView *statusBarWindow = [[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
    [statusBarWindow addGestureRecognizer:tapGesture];
}

@end
#pragma clang diagnostic pop

#endif
