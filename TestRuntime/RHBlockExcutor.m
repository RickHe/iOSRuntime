

//
//  RHBlockExcutor.m
//  TestRuntime
//
//  Created by DaFenQI on 2018/3/12.
//  Copyright © 2018年 DaFenQI. All rights reserved.
//

#import "RHBlockExcutor.h"

@interface RHBlockExcutor () {
    dispatch_block_t _block;
}

@end

@implementation RHBlockExcutor

- (instancetype)initWithBlock:(dispatch_block_t)block {
    self = [super init];
    if (self) {
        _block = block;
    }
    return self;
}

- (void)dealloc {
    if (_block) {
        _block();
    }
    _block = nil;
}

@end
