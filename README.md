# iOSRuntime

### runtime基本概念

##### property attribute
```
// T 变量类型
// nonatmic strong 属性特质修饰
// V 变量名
typedef struct {
    char *name;
    char *value;
} objc_property_attribute_t
```
##### property
```
// 一个属性包括 name和attributes
typedef struct {
    char *name;
    objc_property_attribute_t *attributes
} objc_property_t;
```
##### example
```
unsigned int propertyCount = 0;
objc_property_t *properties = class_copyPropertyList(self.class, &propertyCount);
for (int i = 0; i < propertyCount; i++) {
    objc_property_t property = properties[i];
    const char *name = property_getName(property);
    NSLog(@“property name = %s", name);
    unsigned int attributeCount = 0;
    objc_property_attribute_t attributes = property_copyAttributeList(property, &attributeCount);
    for (int j = 0; j < attributeCount; j++) {
        objc_property_attribute_t attribute = attributes[j];
        const char *name = attribute.name;
        const char *value = attribute.value;
        NSLog(@"attri name = %s attri value = %s", attribute.name, attribute.value);
    }
}
```
##### ivar
```
struct objc_ivar {
    char *name;
    char *type;
    int ivar_offset;
}
```
##### example
```
unsigned int ivarCount = 0;
Ivar *ivars = class_copyIvarList(self.class, &ivarCount);
for (int i = 0; i < ivarCount; i++) {
    Ivar ivar = ivars[i];
    const char *name = ivar_getName(ivar);
    const char *typeEncoding = ivar_getTypeEncoding(ivar);
    ptrdiff_t offset = ivar_getOffset(ivar);
    NSLog(@"name = %s, typeEncoding = %s offset = %ti", name, typeEncoding, offset);
}
```

__@property = ivar + getter + setter;__

##### method 
```
struct objc_method {
    SEL method_name;
    char *method_types;
    IMP method_imp;
}
```
##### example
```
unsigned int methodCount = 0;
Method *methods = class_copyMethodList(self.class, &methodCount);
for (int i = 0; i < methodCount; i++) {
    Method method = methods[i];
    // get method_name
    SEL sel = method_getName(method);
    const char *methodName = sel_getName(sel);
    NSLog(@“name = %s”, methodName);

    // get typeEncoding 
    // example - (void)test; 方法的typeEncoding = v16@0:8
    // v 返回值void偏移量16，@ 方法的第一个参数self偏移量0，：方法的第二个参数SEL偏移量8
    const char *typeEncoding = method_getTypeEncoding(method);
    NSLog(@“typeEncoding = %s”, typeEncoding);

    // argument type encoding
    unsigned int argumentCount = method_getNumberOfArguments(method);
    for (int j = 0; j < argumentCount; j++) {
        char dst[100] = {};
        method_getArgumentType(method, i, dst, 100);
        NSLog(@“argument %i type encoding = %s”, j, dst);
    }

    // return type encoding 
    char dst[100] = {};
    method_getReturnType(method, dst, 100);
    NSLog(@“return type encoding = %s”, dst);
    
    // IMP
    IMP imp = method_getImplementation(methid);
    NSLog(@“IMP = %p”, imp);
}
```
