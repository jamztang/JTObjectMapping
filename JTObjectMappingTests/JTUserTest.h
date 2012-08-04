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
@property (nonatomic, retain) NSDate *createDate;
@property (nonatomic, retain) NSDate *eighteenthBirthday;
@property (nonatomic, retain) NSArray *childs;
@property (nonatomic, retain) NSArray *users;
@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) NSData *dataLossy;
@property (nonatomic, retain) NSSet *favoriteColors;

@property (nonatomic, copy) NSString *hashedString;

@property (nonatomic, copy) NSString *autoString;
@property (nonatomic, retain) NSArray *autoArray;
@property (nonatomic, retain) NSArray *nestedArray;
@property (nonatomic, retain) NSArray *missingString;
@property (nonatomic, retain) NSArray *missingDate;
//@property (nonatomic, retain) JTSocialNetworkTest *autoSocialNetwork;

@property (nonatomic, retain) JTSocialNetworkTest *socialNetwork;

@property (nonatomic, copy) NSString *null;
@property (nonatomic, copy) NSNumber *nullNumber;
@property (nonatomic, copy) NSArray *nullArray;
@property (nonatomic, copy) NSSet   *nullSet;
@property (nonatomic, retain) NSDate *nullDate;
@property (nonatomic, retain) JTSocialNetworkTest *nullChild;

@end
