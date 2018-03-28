//
//  RHTestClass.h
//  TestRuntime
//
//  Created by DaFenQI on 2018/3/2.
//  Copyright © 2018年 DaFenQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHTestClass : NSObject  {
    int _father;
}

@property(nonatomic, strong) NSObject *object;

@property(nonatomic, strong) NSString *strongString;
@property(nonatomic, copy) NSString *copyedString;

// 动态解析
@property(nonatomic, strong) NSString *dynamicObject;

// method swizzing
- (void)originMethod;

- (void)test:(NSString *)test;
- (void)testForwardTarget:(NSString *)str;
- (void)testForwardInvocation:(NSString *)str;

+ (void)test:(NSString *)test;

@end
