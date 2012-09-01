/*
 * This file is part of the JTObjectMapping package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "JTValidMappingKey.h"

@protocol JTDateMappings <NSObject>

- (NSString *)key;
- (NSString *)dateFormatString;

@end


@interface JTDateMappings : NSObject <JTDateMappings, JTValidMappingKey>

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *dateFormatString;

+ (id <JTDateMappings>)mappingWithKey:(NSString *)key dateFormatString:(NSString *)dateFormatString;

@end



// For epoch dates in (some fraction) of seconds
@protocol JTDateEpochMappings <NSObject>

- (NSString *)key;
- (NSTimeInterval)divisorForSeconds;


@end

@interface JTDateEpochMappings : NSObject <JTDateEpochMappings, JTValidMappingKey>
@property (nonatomic, copy) NSString *key;
@property (nonatomic) NSTimeInterval divisorForSeconds;
// You must specify the fraction of seconds you want: 1==seconds, 1000==milliseconds, etc.
+ (id <JTDateEpochMappings>)mappingWithKey:(NSString *)key divisorForSeconds:(NSTimeInterval)divisorForSeconds;

@end
