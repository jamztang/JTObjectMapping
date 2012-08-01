/*
 * This file is part of the JTObjectMapping package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>

@protocol JTDataMappings <NSObject>

- (NSString *)key;
- (NSStringEncoding)stringEncoding;
- (BOOL)allowLossy;

@end


@interface JTDataMappings : NSObject <JTDataMappings>

@property (nonatomic, copy) NSString *key;
@property (nonatomic) NSStringEncoding stringEncoding;
@property (nonatomic) BOOL allowLossy;

+ (id <JTDataMappings>)mappingWithKey:(NSString *)key usingEncoding:(NSStringEncoding)stringEncoding allowLossy:(BOOL)lossy;

@end
