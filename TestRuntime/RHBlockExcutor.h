//
//  RHBlockExcutor.h
//  TestRuntime
//
//  Created by DaFenQI on 2018/3/12.
//  Copyright © 2018年 DaFenQI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RHBlockExcutor : NSObject

- (instancetype)initWithBlock:(dispatch_block_t)block;

@end
