//
//  ViewController.m
//  TestRuntime
//
//  Created by DaFenQI on 2018/3/2.
//  Copyright © 2018年 DaFenQI. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "RHTestClass.h"
#import "RHTestChildClass.h"
#import "NSObject+RHRunAtDelloc.h"

@interface ViewController ()

@property(nonatomic, strong) NSString *stringValue;

@end

@implementation ViewController

@synthesize stringValue = _stringValue;

- (void)setStringValue:(NSString *)stringValue {
    _stringValue = stringValue;
}

- (NSString *)stringValue {
    return _stringValue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 获取类名
    [self testGetClassName];

    [self testGetClassIvars];

    [self testGetClassProperty];

    [self testGetClassMethod];

    [self testGetClassProtocol];
    
    [self testMethod];
    
    [self testDynamicResolve];
    
    [self testMessageForward];
}

- (void)testMessageForward {
    RHTestClass *testClass = [RHTestClass new];
    // 快速转发，看是否有备用接受者
    [testClass testForwardTarget:@"forward target"];
    // 完整转发，先获取方法签名，打包成NSInvovation对象，调用forwardInvocation: 方法处理
    [testClass testForwardInvocation:@"forward invocation"];
}

- (void)testDynamicResolve {
    RHTestClass *testClass = [RHTestClass new];
    // 动态绑定，当我们发送一个未实现的消息给对象时，会调用此方法，看用户是否能够动态的添加方法
    testClass.dynamicObject = @"test Dynamic Object";
    NSLog(@"%@", testClass.dynamicObject);
}

- (void)testMethod {
    return;
    // 方法调用
    RHTestClass *testClass = [RHTestClass new];
    NSDate* startDate = [NSDate date];
    for (int i = 0; i < 10000; i++) {
        [testClass test:[NSString stringWithFormat:@"%i", i]];
    }
    double deltaTime = [[NSDate date] timeIntervalSinceDate:startDate];
    NSLog(@"耗时：%f", deltaTime);
    
    // 直接获取函数指针调用
    void (*testIMP)(id, SEL, NSString *);
    testIMP = (void(*)(id, SEL, NSString *))[testClass methodForSelector:@selector(test:)];
    startDate = [NSDate date];
    for (int i = 0; i < 10000; i++) {
        testIMP(testClass, @selector(test:), [NSString stringWithFormat:@"%i", i]);
    }
    deltaTime = [[NSDate date] timeIntervalSinceDate:startDate];
    NSLog(@"耗时：%f", deltaTime);
    
    // 多次调用有方法缓存，所以方法调用和函数指针调用多次耗时相差不大
}

- (Class)getTestClass {
    // get class
    Class class = objc_getClass("RHTestClass");
    class = [RHTestClass class];
    class = NSClassFromString(@"RHTestClass");
    return class;
}

- (void)testGetClassName {
    const char *className = class_getName([self getTestClass]);
    NSLog(@"%s", className);
}

- (void)testGetClassIvars {
    /*
     struct objc_ivar {
         char *name;
         char *type;
         int ivar_offset;
     }
     */
    unsigned int ivarsCount = 0;
    Ivar *ivars = class_copyIvarList([self getTestClass], &ivarsCount);
    
    NSLog(@"ivars start");
    for (int i = 0; i < ivarsCount; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        const char *typeEncoding = ivar_getTypeEncoding(ivar);
        ptrdiff_t offset = ivar_getOffset(ivar);
        NSLog(@"name = %s, typeEncoding = %s offset = %ti", name, typeEncoding, offset);
    }
    NSLog(@"ivars end");
}

- (void)testGetClassProperty {
    /*
     // T 变量类型
     // nonatmic strong 属性特质修饰
     // V 变量名
     typedef struct {
         char *name;
         char *value;
     } objc_property_attribute_t
     
     // 一个属性包括 name和attributes
     typedef struct {
         char *name;
         objc_property_attribute_t *attributes
     } objc_property_t;
     */
    unsigned int propertiesCount = 0;
    objc_property_t *properties = class_copyPropertyList([self getTestClass], &propertiesCount);
    NSLog(@"properties start");
    for (int i = 0; i < propertiesCount; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSLog(@"%s", name);
        unsigned int attributeCount = 0;
        objc_property_attribute_t  *attributes = property_copyAttributeList(property, &attributeCount);
        for (int j = 0; j < attributeCount; j++) {
            objc_property_attribute_t attribute = attributes[j];
            NSLog(@"attri name = %s attri value = %s", attribute.name, attribute.value);
        }
    }
    NSLog(@"properties end");
}

- (void)testGetClassMethod {
    /*
     struct objc_method {
         SEL method_name;
         char *method_types;
         IMP method_imp;
     }
     */
    unsigned int methodsCount = 0;
    Method *methods = class_copyMethodList([self getTestClass], &methodsCount);
    NSLog(@"methods start");
    for (int i = 0; i < methodsCount; i++) {
        Method method = methods[i];
        SEL sel = method_getName(method);
        const char* name = sel_getName(sel);
        NSLog(@"name = %s", name);
        const char *typeEncoding = method_getTypeEncoding(method);
        NSLog(@"typeEncoding = %s", typeEncoding);
        
        unsigned int argumentCount = method_getNumberOfArguments(method);
        for (int i = 0; i < argumentCount; i++) {
            char dst[100] = {};
            method_getArgumentType(method, i, dst, 100);
            NSLog(@"argument %ui = %s", i, dst);
        }
        
        char dst[100] = {};
        method_getReturnType(method, dst, 100);
        NSLog(@"return type = %s", dst);
        
        IMP imp = method_getImplementation(method);
        NSLog(@"imp = %p", imp);
    }
    NSLog(@"methods end");
}

- (void)testGetClassProtocol {
    unsigned int protocolsCount = 0;
    __unsafe_unretained Protocol **protocols = class_copyProtocolList([self getTestClass], &protocolsCount);
    NSLog(@"protocols start");
    for (int i = 0; i < protocolsCount; i++) {
        Protocol *protocol = protocols[i];
        const char *name = protocol_getName(protocol);
        NSLog(@"%s", name);
    }
    NSLog(@"protocols end");
}

@end
