/*
 * This file is part of the JTObjectMapping package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>


@protocol JTSetMappings <NSObject>

- (NSString *)key;

@end

@interface JTSetMappings : NSObject <JTSetMappings>

@property (nonatomic, copy) NSString *key;

+ (id <JTSetMappings>)mappingWithKey:(NSString *)key;

@end
