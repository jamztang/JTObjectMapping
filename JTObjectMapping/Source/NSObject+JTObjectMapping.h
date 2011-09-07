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

@protocol JTValidJSONResponse <NSObject>
@end

@interface NSArray () <JTValidJSONResponse>
@end

@interface NSDictionary () <JTValidJSONResponse>
@end



@interface NSObject (JTObjectMapping)

- (void)setValueFromDictionary:(NSDictionary *)dict mapping:(NSDictionary *)mapping;
+ (id <JTMappings>)mappingWithKey:(NSString *)key mapping:(NSDictionary *)mapping;
+ (id)objectFromJSONObject:(id <JTValidJSONResponse>)object mapping:(NSDictionary *)mapping;

@end


@interface NSDate (JTObjectMapping)

+ (id <JTDateMappings>)mappingWithKey:(NSString *)key dateFormatString:(NSString *)dateFormatString;

@end