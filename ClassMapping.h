//
//  ClassMapping.h
//
//  Created by Gleb Pinigin on 2/3/13.
//  Copyright (c) 2013 Gleb Pinigin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassMapping : NSObject {
@private
    Class mappingClass;
    NSMutableArray *propertiesMapping;
    NSMutableDictionary *attributesMapping;
}

+ (id)mappingWithClass:(Class)mappingClass;

- (NSArray *)objects:(id)container;

- (void)addPropertyMapping:(ClassMapping *)mapping fromKeyPath:(NSString *)keyPath
              toObjectPath:(NSString *)objectPath;
- (void)addAttributeMappingFromKeyPath:(NSString *)keypath toObjectPath:(NSString *)objectPath;

@end
