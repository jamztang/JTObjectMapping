//
//  NSObject+JTObjectMapping.m
//  JTObjectMapping
//
//  Created by james on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSObject+JTObjectMapping.h"
#import "JTMappings.h"

@implementation NSObject (JTObjectMapping)

- (void)setValueFromDictionary:(NSDictionary *)dict mapping:(NSDictionary *)mapping {
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id mapsToValue = [mapping objectForKey:key];
        if (mapsToValue != nil) {
            if ([(NSObject *)mapsToValue isKindOfClass:[NSString class]]) {
                if ([obj isKindOfClass:[NSNull class]]) {
                    [self setValue:nil forKey:mapsToValue];
                } else {
                    [self setValue:obj forKey:mapsToValue];
                }
            } else if ([mapsToValue conformsToProtocol:@protocol(JTMappings)] && [(NSObject *)obj isKindOfClass:[NSDictionary class]]) {
                id <JTMappings> mappings = (id <JTMappings>)mapsToValue;
                NSObject *targetObject = [[mappings.targetClass alloc] init];
                [targetObject setValueFromDictionary:obj mapping:mappings.mapping];
                [self setValue:targetObject forKey:mappings.key];
                [targetObject release];
            } else {
                NSAssert2(NO, @"[mapsToValue class]: %@, [obj class]: %@ is not handled", NSStringFromClass([mapsToValue class]), NSStringFromClass([obj class])); 
            }
        }
    }];
}

@end
