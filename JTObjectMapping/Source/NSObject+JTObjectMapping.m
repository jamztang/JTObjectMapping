//
//  NSObject+JTObjectMapping.m
//  JTObjectMapping
//
//  Created by james on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSObject+JTObjectMapping.h"
#import "JTMappings.h"
#import "JTDateMappings.h"

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
            } else if ([mapsToValue conformsToProtocol:@protocol(JTDateMappings)] && [(NSObject *)obj isKindOfClass:[NSString class]]) {
                id <JTDateMappings> mappings = (id <JTDateMappings>)mapsToValue;
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:mappings.dateFormatString];
                NSDate *date = [formatter dateFromString:obj];
                [formatter release];
                [self setValue:date forKey:mappings.key];
            } else if ([mapsToValue conformsToProtocol:@protocol(JTArrayMappings)] && [(NSObject *)obj isKindOfClass:[NSArray class]]) {
                id <JTArrayMappings> mappings = (id <JTArrayMappings>)mapsToValue;
                NSMutableArray *array = [NSMutableArray array];
                for (NSObject *o in obj) {
                    if ([o isKindOfClass:[NSString class]]) {
                        [array addObject:o];
                    } else {
                        
                    }
                }
                [self setValue:array forKey:mappings.key];
            } else {
                NSAssert2(NO, @"[mapsToValue class]: %@, [obj class]: %@ is not handled", NSStringFromClass([mapsToValue class]), NSStringFromClass([obj class])); 
            }
        }
    }];
}

+ (id <JTMappings>)mappingWithKey:(NSString *)key mapping:(NSDictionary *)mapping {
    return [JTMappings mappingWithKey:key targetClass:[self class] mapping:mapping];
}

@end


@implementation NSDate (JTObjectMapping)

+ (id <JTMappings>)mappingWithKey:(NSString *)key mapping:(NSDictionary *)mapping {
    [NSException raise:@"JTObjectMappingException" format:@"Please use +[NSDate mappingWithKey:dateFormatString:] instead."];
    return nil;
}

+ (id <JTDateMappings>)mappingWithKey:(NSString *)key dateFormatString:(NSString *)dateFormatString {
    return [JTDateMappings mappingWithKey:key dateFormatString:dateFormatString];
}

@end

@implementation NSArray (JTObjectMapping)

+ (id <JTArrayMappings>)mappingWithKey:(NSString *)key {
    JTArrayMappings *mappings = [[JTArrayMappings alloc] init];
    mappings.key = key;
    return [mappings autorelease];
}

@end