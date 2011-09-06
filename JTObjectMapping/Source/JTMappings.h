//
//  JTMappings.h
//  JTObjectMapping
//
//  Created by james on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol JTMappings <NSObject>

- (NSString *)key;
- (NSDictionary *)mapping;
- (Class)targetClass;

@end



@interface JTMappings : NSObject <JTMappings>

@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSDictionary *mapping;
@property (nonatomic, assign) Class targetClass;

+ (id <JTMappings>)mappingWithKey:(NSString *)aKey
                      targetClass:(Class)aClass
                          mapping:(NSDictionary *)aMapping;

@end
