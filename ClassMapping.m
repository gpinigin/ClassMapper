//
//  ClassMapping.m
//  tv-online
//
//  Created by Gleb Pinigin on 2/3/13.
//  Copyright (c) 2013 Gleb Pinigin. All rights reserved.
//

#import "ClassMapping.h"
    
@interface PropertyMapping : NSObject

@property (nonatomic, strong) ClassMapping *mapping;
@property (nonatomic, strong) NSString *objectPath;
@property (nonatomic, strong) NSString *keyPath;

@end

@implementation PropertyMapping
@end


@implementation ClassMapping

- (id)init {
    self = [super init];
    if (self) {
        propertiesMapping = [NSMutableArray array];
        attributesMapping = [NSMutableDictionary dictionary];
    }
    
    return self;
}

+ (id)mappingWithClass:(Class)mappingClass {
    ClassMapping *mapping = [ClassMapping new];
    mapping->mappingClass = mappingClass;
    
    return mapping;
}

- (NSArray *)objects:(id)container {
    NSArray *objects = nil;
    
    if ([container isKindOfClass:[NSArray class]]) {
        objects = [self objectsFromArray:container];
    } else if ([container isKindOfClass:[NSDictionary class]]) {
        objects = [NSArray arrayWithObject:[self objectFromDictionary:container]];
    }
    
    return objects;
}

- (void)addPropertyMapping:(ClassMapping *)mapping fromKeyPath:(NSString *)keyPath
              toObjectPath:(NSString *)objectPath {
    
    PropertyMapping *propertyMapping = [PropertyMapping new];
    propertyMapping.objectPath = objectPath;
    propertyMapping.keyPath = keyPath;
    propertyMapping.mapping = mapping;
    
    [propertiesMapping addObject:propertyMapping];
}

- (void)addAttributeMappingFromKeyPath:(NSString *)keypath toObjectPath:(NSString *)objectPath {
    [attributesMapping setObject:objectPath forKey:keypath];
}

#pragma mark -

- (NSArray *)objectsFromArray:(NSArray *)array {
    NSMutableArray *objects = [NSMutableArray array];
    
    for (id container in array) {
        [objects addObjectsFromArray:[self objects:container]];
    }
    
    return objects;
}

- (id)objectFromDictionary:(NSDictionary *)dictionary {
    id parent = [mappingClass new];
    
    NSArray *allKeys = attributesMapping.allKeys;    
    for (NSString *key in allKeys) {
        NSString *objectKey = [attributesMapping objectForKey:key];
        id mappingValue = [self valueForMappingKey:key inDictionary:dictionary];
        
        [self setPropertyValue:mappingValue forObject:parent withKeyPath:objectKey];
    }
    
    for (PropertyMapping *propertyMapping in propertiesMapping) {        
        id mappingValue = [self valueForMappingKey:propertyMapping.keyPath inDictionary:dictionary];
        NSArray *objects = [propertyMapping.mapping objects:mappingValue];
        
        if ([mappingValue isKindOfClass:[NSArray class]]) {
            [self setPropertyValue:objects forObject:parent withKeyPath:propertyMapping.objectPath];
        } else {
            [self setPropertyValue:[objects objectAtIndex:0] forObject:parent withKeyPath:propertyMapping.objectPath];
        }        
    }   
    
    
    return parent;
}

#pragma mark - mapping to value conversion

/**
 * Description: Find value for mapping key in JSON dictionary
 * Returns: object, otherwise nil if value not found
 */

- (id)valueForMappingKey:(NSString *)key inDictionary:(NSDictionary *)dictionary {
    NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"."];
    NSArray *tokens = [key componentsSeparatedByCharactersInSet:delimiters];
    
    id innerObject = dictionary;
    for(NSString *token in tokens) {
        if (![innerObject isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        
        innerObject = [innerObject objectForKey:token];
    }

    return innerObject;
}

#pragma mark - mapping to object conversion

- (void)setPropertyValue:(id)value forObject:(id)object withKeyPath:(NSString *)keyPath {
    NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"."];
    NSArray *tokens = [keyPath componentsSeparatedByCharactersInSet:delimiters];
    
    for (NSInteger index = 0; index < tokens.count - 1; ++index) {
        object = [object valueForKey:[tokens objectAtIndex:index]];
    }
    
    [object setValue:value forKey:[tokens lastObject]];
}

@end
