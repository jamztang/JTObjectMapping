//
//  JTArrayMappings.h
//  JTObjectMapping
//
//  Created by James Tang on 07/09/2011.
//  Copyright 2011 CUHK. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JTArrayMappings <NSObject>

- (NSString *)key;
- (Class)targetClass;

@end


@interface JTArrayMappings : NSObject <JTArrayMappings>

@property (nonatomic, copy) NSString *key;
@property (nonatomic, assign) Class targetClass;

@end
