//
//  NSURL+JTURLMapping.h
//  JTObjectMapping
//
//  Created by Vladimir Shevchenko on 11/14/13.
//
//

#import <Foundation/Foundation.h>
#import "JTValidMappingKey.h"

@interface NSURL (JTValidMappingKey)

+ (id <JTValidMappingKey>)mappingWithKey:(NSString *)key;

@end
