//
//  NSURL+JTURLMapping.m
//  JTObjectMapping
//
//  Created by Vladimir Shevchenko on 11/14/13.
//
//

#import "JTURLMappings.h"

@interface JTURLMappings : NSObject <JTValidMappingKey>

@property (nonatomic, copy) NSString *key;

@end

@implementation JTURLMappings

+ (id <JTValidMappingKey>)mappingWithKey:(NSString *)key
{
    JTURLMappings *map = [[JTURLMappings alloc] init];
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
    
    if ([oldValue isKindOfClass:[NSString class]]) {
        
        NSURL *url = [NSURL URLWithString:(NSString *)oldValue];
        *newValue = url;
        *key      = self.key;
        
        return (url != nil);
        
    } else if ([oldValue isKindOfClass:[NSNull class]]) {
        
        *newValue = nil;
        *key      = self.key;
        
        return YES;
    }
    
    return NO;
}

@end

@implementation NSURL (JTURLMappings)

+ (id <JTValidMappingKey>)mappingWithKey:(NSString *)key
{
    return [JTURLMappings mappingWithKey:key];
}

@end
