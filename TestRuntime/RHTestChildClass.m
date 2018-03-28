//
//  RHTestChildClass.m
//  TestRuntime
//
//  Created by DaFenQI on 2018/3/3.
//  Copyright © 2018年 DaFenQI. All rights reserved.
//

#import "RHTestChildClass.h"

@implementation RHTestChildClass

//+ (void)initialize {
//    NSLog(@"RHTestChildClass: %s", __func__);
//}

+ (void)load {
    NSLog(@"RHTestChildClass: %s", __func__);
}

@end
