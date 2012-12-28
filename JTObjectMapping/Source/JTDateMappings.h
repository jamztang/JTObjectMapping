/*
 * This file is part of the JTObjectMapping package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "JTValidMappingKey.h"

@interface NSDate (JTValidMappingKey)

// Handly method for + [JTDateMappings mappingWithKey:dateFormatString:]
+ (id <JTValidMappingKey>)mappingWithKey:(NSString *)key dateFormatString:(NSString *)dateFormatString;

// Handly method for + [JTDateMappings mappingWithKey:dateFormatter:]
+ (id <JTValidMappingKey>)mappingWithKey:(NSString *)key dateFormatter:(NSDateFormatter *)dateFormatter;

// Handly method for + [JTDateMappings mappingWithKey:divisorForSeconds:]
+ (id <JTValidMappingKey>)mappingWithKey:(NSString *)key divisorForSeconds:(float)divisorForSeconds;

@end
