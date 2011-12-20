/*
 * This file is part of the JTObjectMapping package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>

@protocol JTDateMappings <NSObject>

- (NSString *)key;
- (NSString *)dateFormatString;

@end


@interface JTDateMappings : NSObject <JTDateMappings>

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *dateFormatString;

+ (id <JTDateMappings>)mappingWithKey:(NSString *)key dateFormatString:(NSString *)dateFormatString;

@end
