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
#import "JTValidMappingKey.h"

@implementation NSObject (JTObjectMapping)

- (void)setValueFromDictionary:(NSDictionary *)dict mapping:(NSDictionary *)mapping {
    
    __block NSMutableDictionary *notMapped = [mapping mutableCopy];

    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id newKey = [mapping objectForKey:key];
        if (newKey == nil) {
            // We want to auto reference the NSDictionary key corresponding NSObject property key
            // with the same name defined as in the NSObject subclass.
            if ([[self class] instancesRespondToSelector:NSSelectorFromString(key)]) {
                newKey = key;
            }
        }

        if ([newKey conformsToProtocol:@protocol(JTValidMappingKey)]) {

            if ([obj isValidMappingValue]) {

                NSObject *realValue  = nil;
                NSString *realKey    = nil;

                if ([newKey transformValue:obj
                                   toValue:&realValue
                                    forKey:&realKey]) {

                    [realValue configureSelfToObject:self forKey:realKey];
                    [notMapped removeObjectForKey:key];
                    
                } else {
//                    NSLog(@"obj cannot be transformed: %@", obj);

                    [self didFailedWhenMappingValue:obj
                                              toKey:realKey
                                        originalKey:newKey];
                }
            } else {
//                NSLog(@"obj not a valid value: %@", obj);

                [self didFailedWhenMappingValue:obj
                                          toKey:nil
                                    originalKey:newKey];
            }
        } else {
//            NSLog(@"newKey not a valid key: %@", newKey);

            [self didFailedWhenMappingValue:obj
                                      toKey:nil
                                originalKey:newKey];
        }
    }];

    // Likely to be keyPath, enumerate and try add to our object
    // Could cause unexpected result if obj [dict valueForKeyPath:key] is not NSString
#if ! JTOBJECTMAPPING_DISABLE_KEYPATH_SUPPORT
    [notMapped enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {

        id value = [dict valueForKeyPath:key];
        id newKey = obj;

        if ([newKey conformsToProtocol:@protocol(JTValidMappingKey)]) {

            if ([value isValidMappingValue]) {

                NSObject *realValue  = nil;
                NSString *realKey    = nil;

                if ([newKey transformValue:value
                                   toValue:&realValue
                                    forKey:&realKey]) {
                    [realValue configureSelfToObject:self forKey:realKey];
                } else {
//                    NSLog(@"value cannot be transformed: %@", value);
                    
                    [self didFailedWhenMappingValue:value
                                              toKey:realKey
                                        originalKey:newKey];
                }
            } else {
//                NSLog(@"value not a valid value: %@", value);

                [self didFailedWhenMappingValue:value
                                          toKey:nil
                                    originalKey:newKey];
            }

        } else {
//            NSLog(@"newKey not a valid key: %@", newKey);
            
            [self didFailedWhenMappingValue:value
                                      toKey:nil
                                originalKey:newKey];
        }
    }];
#endif

    [notMapped release];
}

+ (id <JTMappings>)mappingWithKey:(NSString *)key mapping:(NSMutableDictionary *)mapping {
    return [JTMappings mappingWithKey:key targetClass:[self class] mapping:mapping];
}


/*
 Instantiate and populate the properties of this class with the JTValidJSONResponse (NSDictionary).
 If this is a dictionary or array, recurse into the json dict and create the corresponding child objects.
 */
+ (id)objectFromJSONObject:(id<JTValidJSONResponse>)object mapping:(NSMutableDictionary *)mapping {
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
    [returnObject didMapObjectFromJSON:object];
    return returnObject;
}

// Override this in other classes to perform post-mapping validation/sanitization, etc.
- (void)didMapObjectFromJSON:(id<JTValidJSONResponse>)object {}

- (void)didFailedWhenMappingValue:(NSObject *)value toKey:(NSString *)key originalKey:(NSString *)originalKey {
#if JTOBJECTMAPPING_SHOW_LOG
    NSLog(@"didFailedWhenMappingValue:%@ toKey:%@ originalKey:%@", value, key, originalKey);
#endif
}

@end


@implementation NSDate (JTObjectMapping)

+ (id <JTMappings>)mappingWithKey:(NSString *)key mapping:(NSMutableDictionary *)mapping {
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


#pragma mark -

@implementation NSObject (JTValidMappingValue)

- (void)configureSelfToObject:(NSObject *)object forKey:(NSString *)key {
    [object setValue:self forKey:key];
}

- (BOOL)isValidMappingValue {
    return YES;
}

@end

@implementation NSNull (JTValidMappingValue)

- (void)configureSelfToObject:(NSObject *)object forKey:(NSString *)key {
    [object setValue:nil forKey:key];
}

@end
