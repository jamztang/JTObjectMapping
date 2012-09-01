/*
 * This file is part of the JTObjectMapping package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>

@protocol JTValidMappingKey;

@protocol JTMappings <NSObject, JTValidMappingKey>

- (NSString *)key;
- (NSMutableDictionary *)mapping;
- (Class)targetClass;

@end



@interface JTMappings : NSObject <JTMappings>

@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSMutableDictionary *mapping;
@property (nonatomic, assign) Class targetClass;

+ (id <JTMappings>)mappingWithKey:(NSString *)aKey
                      targetClass:(Class)aClass
                          mapping:(NSMutableDictionary *)aMapping;

@end
