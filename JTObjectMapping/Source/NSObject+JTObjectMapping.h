//
//  NSObject+JTObjectMapping.h
//  JTObjectMapping
//
//  Created by james on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTMappings.h"
#import "JTDateMappings.h"
#import "JTArrayMappings.h"

@interface NSObject (JTObjectMapping)

- (void)setValueFromDictionary:(NSDictionary *)dict mapping:(NSDictionary *)mapping;
+ (id <JTMappings>)mappingWithKey:(NSString *)key mapping:(NSDictionary *)mapping;

@end


@interface NSDate (JTObjectMapping)

+ (id <JTDateMappings>)mappingWithKey:(NSString *)key dateFormatString:(NSString *)dateFormatString;

@end

@interface NSArray (JTObjectMapping)
+ (id <JTArrayMappings>)mappingWithKey:(NSString *)key;
@end