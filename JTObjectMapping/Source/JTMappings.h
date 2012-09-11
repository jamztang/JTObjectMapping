/*
 * This file is part of the JTObjectMapping package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "JTValidMappingKey.h"

@interface NSObject (JTValidMappingKey)

// Handly method for + [JTMappings mappingWithKey:targetClass:mapping:]
+ (id <JTValidMappingKey>)mappingWithKey:(NSString *)key mapping:(NSDictionary *)mapping;

@end
