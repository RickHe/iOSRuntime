//
//  RHTestClass.m
//  TestRuntime
//
//  Created by DaFenQI on 2018/3/2.
//  Copyright © 2018年 DaFenQI. All rights reserved.
//

#import "RHTestClass.h"
#import <objc/runtime.h>

@interface RHForwardClass : NSObject

- (void)testForwardTarget:(NSString *)str;
- (void)testForwardInvocationNameChanged:(NSString *)str;

@end

@implementation RHForwardClass

- (void)testForwardTarget:(NSString *)str {
    NSLog(@"%s %@", __func__, str);
}

- (void)testForwardInvocationNameChanged:(NSString *)str {
    NSLog(@"%s %@", __func__, str);
}

@end

@interface RHTestClass () {
    NSObject *_ivar;
    RHForwardClass *_forwardClass;
}

@end

const void *kDynamicObjectKey = "kDynamicObjectKey";

@implementation RHTestClass

@dynamic dynamicObject;

- (instancetype)init {
    self = [super init];
    if (self) {
        _forwardClass = [RHForwardClass new];
    }
    return self;
}

#pragma mark - dynamic bind
void dynamicSetObject(id self, SEL selector, NSString *str) {
    objc_setAssociatedObject(self, kDynamicObjectKey, str, OBJC_ASSOCIATION_RETAIN);
}

NSString * dynamicGetObject(id self, SEL selector) {
    return objc_getAssociatedObject(self, kDynamicObjectKey);
}

// dynamic bind
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    BOOL result = NO;
    if (sel == @selector(setDynamicObject:)) {
        SEL sel = @selector(setDynamicObject:);
        Method method = class_getInstanceMethod([self class], @selector(test:));
        class_addMethod([self class], sel, (IMP)dynamicSetObject, method_getTypeEncoding(method));
        result = YES;
    }
    if (sel == @selector(dynamicObject)) {
        SEL sel = @selector(dynamicObject);
        Method method = class_getInstanceMethod([self class], @selector(testGet));
        class_addMethod([self class], sel, (IMP)dynamicGetObject, method_getTypeEncoding(method));
        result = YES;
    }
    
    return result;
}

#pragma mark - forward message
// 转发给消息备用接受者, 必须为其他对象
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(testForwardTarget:)) {
        return _forwardClass;
    }
    return [super forwardingTargetForSelector:aSelector];
}

// 完整转发
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if (anInvocation.selector == @selector(testForwardInvocation:)) {
        // 消息转发给 _forwardClass
//        anInvocation.selector = @selector(testForwardInvocationNameChanged:);
//        [anInvocation invokeWithTarget:_forwardClass];
        
        // 转发给自己
        anInvocation.selector = @selector(testForwardInvocationElse:);
        [anInvocation invoke];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *sig = [super methodSignatureForSelector:aSelector];
    // 消息转发给 _forwardClass
//    if (!sig) {
//        if (aSelector == @selector(testForwardInvocation:)) {
//            sig = [RHForwardClass instanceMethodSignatureForSelector:@selector(testForwardInvocationNameChanged:)];
//        }
//    }
    
    // 转发给自己
    if (!sig) {
        if (aSelector == @selector(testForwardInvocation:)) {
            sig = [RHTestClass instanceMethodSignatureForSelector:@selector(testForwardInvocationElse:)];
        }
    }
    return sig;
}

- (void)testForwardInvocationElse:(NSString *)str {
    NSLog(@"%s %@", __func__, str);
}

#pragma mark - help
- (void)originMethod {
    NSLog(@"%s", __func__);
}

+ (void)load {
    NSLog(@"RHTestClass : %s", __func__);
}

+ (void)initialize {
    NSLog(@"RHTestClass : %s", __func__);
}

- (void)test:(NSString *)test {
    NSLog(@"%@", test);
    
    NSString *immutableString = [NSString stringWithFormat:@"immutableString"];
    NSMutableString *mutableString = [NSMutableString stringWithFormat:@"mutableString"];
    
    self.strongString = immutableString;
    self.copyedString = immutableString;
    NSLog(@"origin str: %p %p", immutableString, &immutableString);
    NSLog(@"strong str: %p %p", self.strongString, &(_strongString));
    NSLog(@"copyed str: %p %p", self.copyedString, &(_copyedString));
    
    self.strongString = mutableString;
    self.copyedString = mutableString;
    NSLog(@"origin str: %p %p", mutableString, &mutableString);
    NSLog(@"strong str: %p %p", self.strongString, &(_strongString));
    NSLog(@"copyed str: %p %p", self.copyedString, &(_copyedString));
}

- (NSString *)testGet {
    return nil;
}

+ (void)test:(NSString *)test {
    NSLog(@"%s", __func__);
}

@end
