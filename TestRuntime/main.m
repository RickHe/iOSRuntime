//
//  main.m
//  TestRuntime
//
//  Created by DaFenQI on 2018/3/2.
//  Copyright © 2018年 DaFenQI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "RHTestClass.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSLog(@"%s", __func__);
        for (int i = 0; i < argc; i++) {
            char *str = argv[i];
            NSLog(@"%s", str);
        }
        
//        RHTestClass *testClass = [[RHTestClass alloc] init];
//        [testClass performSelector:@selector(viewDidLoad)];
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
