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

// http://stackoverflow.com/questions/1918972/camelcase-to-underscores-and-back-in-objective-c
static inline NSString *JTUnderscoresToCamelCase(NSString *underscores) {
    NSMutableString *output = [NSMutableString string];
    BOOL makeNextCharacterUpperCase = NO;
    for (NSInteger idx = 0; idx < [underscores length]; idx += 1) {
        unichar c = [underscores characterAtIndex:idx];
        if (c == '_') {
            makeNextCharacterUpperCase = YES;
        } else if (makeNextCharacterUpperCase) {
            [output appendString:[[NSString stringWithCharacters:&c length:1] uppercaseString]];
            makeNextCharacterUpperCase = NO;
        } else {
            [output appendFormat:@"%C", c];
        }
    }
    return output;
}

static inline NSString *JTCamelCaseString(NSString *string) {
    return [string stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[string substringToIndex:1] capitalizedString]];
}

static inline NSString *JTGetterToSetter(NSString *keyPath) {
    NSString *setter = [NSString stringWithFormat:@"set%@:", JTCamelCaseString(keyPath)];
    return setter;
}


@implementation NSObject (JTObjectMapping)

- (void)setValueFromDictionary:(NSDictionary *)dict mapping:(NSDictionary *)mapping {
    
    __block NSMutableDictionary *notMapped = [mapping mutableCopy];

    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id newKey = [mapping objectForKey:key];
        if (newKey == nil) {
            // We want to auto reference the NSDictionary key corresponding NSObject property key
            // with the same name defined as in the NSObject subclass.

            // We use setter for auto mapping properties to prevent setting
            // value to readonly properties

            if ([self respondsToSelector:NSSelectorFromString(JTGetterToSetter(key))]) {
                newKey = key;
            } else if ([self respondsToSelector:NSSelectorFromString(JTGetterToSetter(JTUnderscoresToCamelCase(key)))]) {
                newKey = JTUnderscoresToCamelCase(key);
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
    // We should already have proper keyPath support since v1.1
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

@end

@implementation NSObject (JTObjectMappingSubclasses)

// Override this in other classes to perform post-mapping validation/sanitization, etc.
- (void)didMapObjectFromJSON:(id<JTValidJSONResponse>)object {}

- (void)didFailedWhenMappingValue:(NSObject *)value toKey:(NSString *)key originalKey:(NSString *)originalKey {
#if JTOBJECTMAPPING_SHOW_LOG
    NSLog(@"didFailedWhenMappingValue:%@ toKey:%@ originalKey:%@", value, key, originalKey);
#endif
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
