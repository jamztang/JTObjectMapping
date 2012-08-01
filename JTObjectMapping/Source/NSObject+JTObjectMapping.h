/*
 * This file is part of the JTObjectMapping package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>
#import "JTMappings.h"
#import "JTDateMappings.h"
#import "JTSetMappings.h"
#import "JTDataMappings.h"

@protocol JTValidJSONResponse <NSObject>
@end

@interface NSArray () <JTValidJSONResponse>
@end

@interface NSDictionary () <JTValidJSONResponse>
@end



@interface NSObject (JTObjectMapping)

- (void)setValueFromDictionary:(NSDictionary *)dict mapping:(NSDictionary *)mapping;
+ (id <JTMappings>)mappingWithKey:(NSString *)key mapping:(NSDictionary *)mapping;
+ (id)objectFromJSONObject:(id <JTValidJSONResponse>)object mapping:(NSDictionary *)mapping;
- (void)didMapObjectFromJSON;

@end


@interface NSDate (JTObjectMapping)

+ (id <JTDateMappings>)mappingWithKey:(NSString *)key dateFormatString:(NSString *)dateFormatString;
+ (id <JTDateEpochMappings>)mappingWithKey:(NSString *)key divisorForSeconds:(CGFloat)divisorForSeconds;

@end


@interface NSSet (JTObjectMapping)

+ (id <JTSetMappings>)mappingWithKey:(NSString *)key;

@end


@interface NSData (JTDataMappings)

+ (id <JTDataMappings>)mappingWithKey:(NSString *)key usingEncoding:(NSStringEncoding)stringEncoding allowLossy:(BOOL)lossy;
// convenience method
+ (id <JTDataMappings>)mappingWithKey:(NSString *)key usingEncoding:(NSStringEncoding)stringEncoding;

@end