/*
 * This file is part of the JTObjectMapping package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "JTSetMappings.h"

@interface JTSetMappings : NSObject <JTValidMappingKey>

@property (nonatomic, copy) NSString *key;

+ (id <JTValidMappingKey>)mappingWithKey:(NSString *)key;

@end


@implementation JTSetMappings
@synthesize key = _key;

+ (id <JTValidMappingKey>)mappingWithKey:(NSString *)key {
    JTSetMappings *map = [[JTSetMappings alloc] init];
    map.key = key;
    return [map autorelease];
}

- (void)dealloc {
    self.key = nil;
    [super dealloc];
}

- (BOOL)transformValue:(NSObject *)oldValue
               toValue:(NSObject **)newValue
                forKey:(NSString **)key {

    if ([oldValue isKindOfClass:[NSArray class]]) {
        
        *newValue = [NSSet setWithArray:(NSArray *)oldValue];
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

@implementation NSSet (JTValidMappingKey)

+ (id <JTValidMappingKey>)mappingWithKey:(NSString *)key {
    return [JTSetMappings mappingWithKey:key];
}

@end
