/*
 * This file is part of the JTObjectMapping package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "NSObject+JTObjectMapping.h"
#import "JTMappings.h"
#import "JTDateMappings.h"
#import <objc/runtime.h>

@implementation NSObject (JTObjectMapping)

- (void)setValueFromDictionary:(NSDictionary *)dict mapping:(NSDictionary *)mapping {
    
    __block NSMutableDictionary *notMapped = [mapping mutableCopy];

    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id mapsToValue = [mapping objectForKey:key];
        if (mapsToValue == nil) {
            // We wants to auto reference the NSDictionary key corresponding NSObject property key
            // with the same name defined as in the NSObject subclass.
            if ([[self class] instancesRespondToSelector:NSSelectorFromString(key)]) {
                mapsToValue = key;
            }
        }
        if (mapsToValue != nil) {
            if ([obj isKindOfClass:[NSNull class]]) {
                if ([mapsToValue conformsToProtocol:@protocol(JTMappings)] || [mapsToValue conformsToProtocol:@protocol(JTDateMappings)]) {
                    [self setValue:nil forKey:[mapsToValue key]];
                } else if ([mapsToValue isKindOfClass:[NSString class]]) {
                    [self setValue:nil forKey:mapsToValue];
                } else {
                    NSAssert(NO, @"[mapsToValue class]: %@, for [NSNull null] objects not handled", NSStringFromClass([mapsToValue class]));
                }

            } else {
                if ([mapsToValue conformsToProtocol:@protocol(JTDataMappings)] && [(NSObject *)obj isKindOfClass:[NSString class]]) {
                    // NSData mapping -- turn a string into NSData with the specified encoding
                    // (we must do this check before basic NSString mapping, or it'll be mapped as string instead of data)
                    id <JTDataMappings> map = (id <JTDataMappings>)mapsToValue;
                    NSData *data = [obj dataUsingEncoding:map.stringEncoding allowLossyConversion:map.allowLossy];
                    [self setValue:data forKey:key];
                } else
                    if ([(NSObject *)mapsToValue isKindOfClass:[NSString class]]) {
                    // string mapping
                    if ([obj isKindOfClass:[NSNull class]]) {
                        [self setValue:nil forKey:mapsToValue];
                    } else {
                        [self setValue:obj forKey:mapsToValue];
                    }
                } else if ([mapsToValue conformsToProtocol:@protocol(JTSetMappings)] && [(NSObject *)obj isKindOfClass:[NSArray class]]) {
                    // support turning NSArrays into a NSSets
                    id <JTSetMappings> map = (id <JTSetMappings>)mapsToValue;
                    NSSet *set = [NSSet setWithArray:obj];
                    [self setValue:set forKey:map.key];
                } else if ([mapsToValue conformsToProtocol:@protocol(JTMappings)] && [(NSObject *)obj isKindOfClass:[NSDictionary class]]) {
                    // dictionary mapping
                    id <JTMappings> mappings = (id <JTMappings>)mapsToValue;
                    NSObject *targetObject = [[mappings.targetClass alloc] init];
                    [targetObject setValueFromDictionary:obj mapping:mappings.mapping];
                    [self setValue:targetObject forKey:mappings.key];
                    [targetObject release];
                } else if ([mapsToValue conformsToProtocol:@protocol(JTDateMappings)] && [(NSObject *)obj isKindOfClass:[NSString class]]) {
                    // date mapping by string formatting
                    id <JTDateMappings> mappings = (id <JTDateMappings>)mapsToValue;
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:mappings.dateFormatString];
                    NSDate *date = [formatter dateFromString:obj];
                    [formatter release];
                    [self setValue:date forKey:mappings.key];
                } else if ([mapsToValue conformsToProtocol:@protocol(JTDateEpochMappings)] && [(NSObject *)obj isKindOfClass:[NSNumber class]]) {
                    // date mapping by some fraction of seconds since the epoch
                    id <JTDateEpochMappings> map = (id <JTDateEpochMappings>)mapsToValue;
                    CGFloat secondsFactor = [(NSNumber *)obj floatValue];
                    NSTimeInterval secSinceEpoch = secondsFactor / map.divisorForSeconds; // convert into desired unit of seconds, 1000==milliseconds
                    // create the date and assign it to the object we're mapping
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secSinceEpoch];
                    [self setValue:date forKey:map.key];
                } else if ([(NSObject *)obj isKindOfClass:[NSArray class]]) {
                    if ([mapsToValue conformsToProtocol:@protocol(JTMappings)]) {
                        id <JTMappings> mappings = (id <JTMappings>)mapsToValue;
                        NSObject *object = [mappings.targetClass objectFromJSONObject:obj mapping:mappings.mapping];
                        [self setValue:object forKey:mappings.key];
                    } else {
                        NSMutableArray *array = [NSMutableArray array];
                        for (NSObject *o in obj) {
                            [array addObject:o];
                        }
                        [self setValue:[NSArray arrayWithArray:array] forKey:mapsToValue];
                    }
                } else {
                    NSAssert2(NO, @"[mapsToValue class]: %@, [obj class]: %@ is not handled", NSStringFromClass([mapsToValue class]), NSStringFromClass([obj class])); 
                }

            }
            // Value is mapped, remove from notMapped dict
            [notMapped removeObjectForKey:key];
        }
    }];

    // Likely to be keyPath, enumerate and try add to our object
    // Could cause unexpected result if obj [dict valueForKeyPath:key] is not NSString
#if ! JTOBJECTMAPPING_DISABLE_KEYPATH_SUPPORT
    [notMapped enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id value = [dict valueForKeyPath:key];
        // Only set the property value if we have one to set
        // otherwise this will crash for custom object mappings
        if (value != nil) {
            [self setValue:value forKey:obj];
        }
    }];
#endif

    [notMapped release];
}

+ (id <JTMappings>)mappingWithKey:(NSString *)key mapping:(NSDictionary *)mapping {
    return [JTMappings mappingWithKey:key targetClass:[self class] mapping:mapping];
}

/*
 Instantiate and populate the properties of this class with the JTValidJSONResponse (NSDictionary).
 If this is a dictionary or array, recurse into the json dict and create the corresponding child objects.
 */
+ (id)objectFromJSONObject:(id<JTValidJSONResponse>)object mapping:(NSDictionary *)mapping {
    id returnObject = nil;
    if ([object isKindOfClass:[NSDictionary class]]) {
        // the json object is a dict -- create a new dict with the objects we can map from its contents
        returnObject = [[[[self class] alloc] init] autorelease];
        [returnObject setValueFromDictionary:(NSDictionary *)object mapping:mapping];
    } else if ([object isKindOfClass:[NSArray class]]) {
        // the json object is an array -- create a new array with the objects we can map from its contents
        NSMutableArray *array = [NSMutableArray array];
        for (NSObject *dict in (NSArray *)object) {
            NSParameterAssert([dict isKindOfClass:[NSDictionary class]]);
            NSObject *newObj = [[self class] objectFromJSONObject:(NSDictionary *)dict mapping:mapping];
            [array addObject:newObj];
        }
        returnObject = [NSArray arrayWithArray:array];
    }

    // let objects do post-mapping validation, etc
    // (it's safe to call without checking respondsToSelector:, because we have an no-op method defined in this category)
    [returnObject didMapObjectFromJSON];
    return returnObject;
}

// Override this in other classes to perform post-mapping validation/sanitization, etc.
- (void)didMapObjectFromJSON {}

@end


@implementation NSDate (JTObjectMapping)

+ (id <JTMappings>)mappingWithKey:(NSString *)key mapping:(NSDictionary *)mapping {
    [NSException raise:@"JTObjectMappingException" format:@"Please use +[NSDate mappingWithKey:dateFormatString:] instead."];
    return nil;
}

+ (id <JTDateMappings>)mappingWithKey:(NSString *)key dateFormatString:(NSString *)dateFormatString {
    return [JTDateMappings mappingWithKey:key dateFormatString:dateFormatString];
}

+ (id <JTDateEpochMappings>)mappingWithKey:(NSString *)key divisorForSeconds:(CGFloat)divisorForSeconds {
    return [JTDateEpochMappings mappingWithKey:key divisorForSeconds:divisorForSeconds];
}

@end


@implementation NSSet (JTObjectMapping)

+ (id <JTSetMappings>)mappingWithKey:(NSString *)key {
    return [JTSetMappings mappingWithKey:key];
}

@end


@implementation NSData (JTDataMappings)

+ (id <JTDataMappings>)mappingWithKey:(NSString *)key usingEncoding:(NSStringEncoding)stringEncoding allowLossy:(BOOL)lossy {
    return [JTDataMappings mappingWithKey:key usingEncoding:stringEncoding allowLossy:lossy];
}

/*
 Convenience method to match [NSString dataUsingEncoding:allowLossyConversion:] behavior, which is not lossy.
 Reference: https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/doc/uid/20000154-dataUsingEncoding_
 */
+ (id <JTDataMappings>)mappingWithKey:(NSString *)key usingEncoding:(NSStringEncoding)stringEncoding {
    return [JTDataMappings mappingWithKey:key usingEncoding:stringEncoding allowLossy:NO];
}


@end
