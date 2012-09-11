/*
 * This file is part of the JTObjectMapping package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "JTDataMappings.h"


@interface JTDataMappings : NSObject <JTValidMappingKey>

@property (nonatomic, copy) NSString *key;
@property (nonatomic) NSStringEncoding stringEncoding;
@property (nonatomic) BOOL allowLossy;

+ (id <JTValidMappingKey>)mappingWithKey:(NSString *)key usingEncoding:(NSStringEncoding)stringEncoding allowLossy:(BOOL)lossy;

@end


@implementation JTDataMappings
@synthesize key = _key, stringEncoding, allowLossy;

/*
 Mapping that allows you to specify NSData the parameters.
 */
+ (id <JTValidMappingKey>)mappingWithKey:(NSString *)key usingEncoding:(NSStringEncoding)stringEncoding allowLossy:(BOOL)lossy {
    JTDataMappings *dataMapping = [[JTDataMappings alloc] init];
    dataMapping.stringEncoding = stringEncoding;
    dataMapping.key = key;
    dataMapping.allowLossy = lossy;
    return [dataMapping autorelease];
}


- (void)dealloc {
    self.key = nil;
    [super dealloc];
}

- (BOOL)transformValue:(NSObject *)oldValue
               toValue:(NSObject **)newValue
                forKey:(NSString **)key {

    if ([oldValue isKindOfClass:[NSString class]]) {
        *newValue   = [(NSString *)oldValue dataUsingEncoding:self.stringEncoding
                             allowLossyConversion:self.allowLossy];
        *key        = self.key;

        return YES;

    } else if ([oldValue isKindOfClass:[NSNull class]]) {
        
        *newValue = nil;
        *key      = self.key;
        
        return YES;
    }
    
    return NO;
}

@end



@implementation NSData (JTValidMappingKey)

+ (id <JTValidMappingKey>)mappingWithKey:(NSString *)key usingEncoding:(NSStringEncoding)stringEncoding allowLossy:(BOOL)lossy {
    return [JTDataMappings mappingWithKey:key usingEncoding:stringEncoding allowLossy:lossy];
}

/*
 Convenience method to match [NSString dataUsingEncoding:allowLossyConversion:] behavior, which is not lossy.
 Reference: https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/Reference/NSString.html#//apple_ref/doc/uid/20000154-dataUsingEncoding_
 */
+ (id <JTValidMappingKey>)mappingWithKey:(NSString *)key usingEncoding:(NSStringEncoding)stringEncoding {
    return [JTDataMappings mappingWithKey:key usingEncoding:stringEncoding allowLossy:NO];
}


@end

