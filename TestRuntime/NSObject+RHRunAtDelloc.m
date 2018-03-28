//
//  RHTestClass+RHRunAtDelloc.m
//  TestRuntime
//
//  Created by DaFenQI on 2018/3/12.
//  Copyright © 2018年 DaFenQI. All rights reserved.
//

#import "NSObject+RHRunAtDelloc.h"
#import <objc/runtime.h>
#import "RHBlockExcutor.h"

@implementation NSObject (RHRunAtDelloc)

- (void)rh_runAtDealloc:(dispatch_block_t)block {
    RHBlockExcutor *excutor = [[RHBlockExcutor alloc] initWithBlock:block];
    objc_setAssociatedObject(self, "kRHBlockExcutorKey", excutor, OBJC_ASSOCIATION_RETAIN);
}

@end
