/*
 * This file is part of the JTObjectMapping package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>
#import "JTDataMappings.h"
#import "JTDateMappings.h"
#import "JTMappings.h"
#import "JTSetMappings.h"
#import "JTURLMappings.h"

@protocol JTValidJSONResponse <NSObject>
@end

@interface NSArray () <JTValidJSONResponse>
@end

@interface NSDictionary () <JTValidJSONResponse>
@end

@interface NSURL () <JTValidJSONResponse>
@end


@interface NSObject (JTObjectMapping)

- (void)setValueFromDictionary:(NSDictionary *)dict mapping:(NSDictionary *)mapping;

+ (id)objectFromJSONObject:(id <JTValidJSONResponse>)object mapping:(NSDictionary *)mapping;

@end


@interface NSObject (JTObjectMappingSubclasses)

// Override in subclasses if needed
- (void)didMapObjectFromJSON:(id<JTValidJSONResponse>)object;

- (void)didFailedWhenMappingValue:(NSObject *)value toKey:(NSString *)key originalKey:(NSString *)originalKey;

@end


#pragma mark -

@interface NSObject (JTValidMappingValue)

- (void)configureSelfToObject:(NSObject *)object forKey:(NSString *)key;
- (BOOL)isValidMappingValue;

@end

@interface NSNull (JTValidMappingValue)

- (void)configureSelfToObject:(NSObject *)object forKey:(NSString *)key;

@end
