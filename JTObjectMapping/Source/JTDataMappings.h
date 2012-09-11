/*
 * This file is part of the JTObjectMapping package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "JTValidMappingKey.h"

@interface NSData (JTValidMappingKey)

// Handly method for +[JTDataMappings mappingWithKey:usingEncoding:allowLossy:]
+ (id <JTValidMappingKey>)mappingWithKey:(NSString *)key usingEncoding:(NSStringEncoding)stringEncoding allowLossy:(BOOL)lossy;

// convenience method
+ (id <JTValidMappingKey>)mappingWithKey:(NSString *)key usingEncoding:(NSStringEncoding)stringEncoding;

@end