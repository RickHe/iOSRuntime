//
//  RHTestClass+MethodSwizzing.m
//  TestRuntime
//
//  Created by DaFenQI on 2018/3/2.
//  Copyright © 2018年 DaFenQI. All rights reserved.
//

#import "RHTestClass+MethodSwizzing.h"
#import <objc/runtime.h>

@implementation RHTestClass (MethodSwizzing)

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        NSLog(@"RHTestClass (MethodSwizzing)");
//    }
//    return self;
//}

+ (void)load {
    NSLog(@"RHTestClass (MethodSwizzing) : %s", __func__);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"RHTestClass");

        SEL originSel = @selector(originMethod);
        SEL destSel = @selector(destMethod);
        
        Method originMethod = class_getInstanceMethod(class, originSel);
        Method destMethod = class_getInstanceMethod(class, destSel);
        
        BOOL didAddMethod =
        class_addMethod(class, originSel, method_getImplementation(destMethod), method_getTypeEncoding(destMethod));
        if (didAddMethod) {
            class_replaceMethod(class, destSel, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        } else {
            method_exchangeImplementations(originMethod, destMethod);
        }
    });
}

+ (void)initialize {
    NSLog(@"RHTestClass(MethodSwizzing) : %s", __func__);
}

- (void)destMethod {
    [self destMethod];
    NSLog(@"%s", __func__);
}

@end
