//
//  JTUserTest.h
//  JTObjectMapping
//
//  Created by james on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JTSocialNetworkTest;

@interface JTUserTest : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSNumber *age;
@property (nonatomic, copy) NSString *null;
@property (nonatomic, retain) NSDate *createDate;
@property (nonatomic, retain) NSArray *childs;
@property (nonatomic, retain) NSArray *users;

@property (nonatomic, copy) NSString *autoString;
@property (nonatomic, retain) NSArray *autoArray;
@property (nonatomic, retain) NSArray *nestedArray;
//@property (nonatomic, retain) JTSocialNetworkTest *autoSocialNetwork;

@property (nonatomic, retain) JTSocialNetworkTest *socialNetwork;

@end
