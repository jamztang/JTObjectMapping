//
//  JTDateMappings.h
//  JTObjectMapping
//
//  Created by James Tang on 07/09/2011.
//  Copyright 2011 CUHK. All rights reserved.
//

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
