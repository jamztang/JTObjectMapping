/*
 * This file is part of the JTObjectMapping package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "JTMappings.h"
#import "NSObject+JTObjectMapping.h"

@interface JTMappings : NSObject <JTValidMappingKey>

@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSMutableDictionary *mapping;
@property (nonatomic, assign) Class targetClass;

+ (id <JTValidMappingKey>)mappingWithKey:(NSString *)aKey
                             targetClass:(Class)aClass
                                 mapping:(NSMutableDictionary *)aMapping;

@end

@implementation JTMappings
@synthesize key = _key, mapping, targetClass;

+ (id <JTValidMappingKey>)mappingWithKey:(NSString *)aKey targetClass:(Class)aClass mapping:(NSMutableDictionary *)aMapping {
    JTMappings *obj = [[JTMappings alloc] init];
    obj.key         = aKey;
    obj.mapping     = [aMapping mutableCopy];
    obj.targetClass = aClass;
    return [obj autorelease];
}

- (void)dealloc {
    self.key = nil;
    self.mapping = nil;
    self.targetClass = nil;
    [super dealloc];
}

- (BOOL)transformValue:(NSObject *)oldValue
               toValue:(NSObject **)newValue
                forKey:(NSString **)key {
    
    if ([oldValue isKindOfClass:[NSArray class]]) {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in (NSArray *)oldValue) {
            id obj = [self.targetClass objectFromJSONObject:dict mapping:self.mapping];
            [array addObject:obj];
        }

        *newValue = array;
        *key      = self.key;

        return YES;

    } else if ([oldValue isKindOfClass:[NSDictionary class]]) {
        id obj = [self.targetClass objectFromJSONObject:(NSDictionary *)oldValue mapping:self.mapping];
        
        *newValue = obj;
        *key      = self.key;

        return YES;
    } else if ([oldValue isKindOfClass:[NSNull class]]) {
        
        *newValue = nil;
        *key      = self.key;

        return YES;
    }
    
    return NO;
}

@end

#pragma mark -

@implementation NSObject (JTValidMappingKey)

+ (id <JTValidMappingKey>)mappingWithKey:(NSString *)key mapping:(NSMutableDictionary *)mapping {
    return [JTMappings mappingWithKey:key targetClass:[self class] mapping:mapping];
}

@end
