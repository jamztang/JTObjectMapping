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
@property (nonatomic, strong) NSDate *createDate;
@property (nonatomic, strong) NSDate *eighteenthBirthday;
@property (nonatomic, strong) NSArray *childs;
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSData *dataLossy;
@property (nonatomic, strong) NSSet *favoriteColors;

@property (nonatomic, copy) NSString *hashedString;
@property (nonatomic, strong) JTUserTest *hashedUser;

@property (nonatomic, copy) NSString *autoString;
@property (nonatomic, strong) NSArray *autoArray;
@property (nonatomic, strong) NSArray *nestedArray;
@property (nonatomic, strong) NSArray *missingString;
@property (nonatomic, strong) NSArray *missingDate;
//@property (nonatomic, retain) JTSocialNetworkTest *autoSocialNetwork;

@property (nonatomic, strong) JTSocialNetworkTest *socialNetwork;

@property (nonatomic, copy) NSString *null;
@property (nonatomic, copy) NSNumber *nullNumber;
@property (nonatomic, copy) NSArray *nullArray;
@property (nonatomic, copy) NSSet   *nullSet;
@property (nonatomic, strong) NSDate *nullDate;
@property (nonatomic, strong) JTSocialNetworkTest *nullChild;

@property (nonatomic, copy) NSString *desc;
@property (unsafe_unretained, nonatomic, readonly) NSString *readonly;
@property (nonatomic, readonly, copy) NSString *readonlyCopy;
@property (nonatomic, readonly, copy) NSString *privateCopy;

@end
