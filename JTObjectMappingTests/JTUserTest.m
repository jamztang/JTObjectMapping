//
//  JTUserTest.m
//  JTObjectMapping
//
//  Created by james on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JTUserTest.h"

@interface JTUserTest ()
@property (nonatomic, copy) NSString *privateCopy;
@end

@implementation JTUserTest
@synthesize name, title, age;
@synthesize createDate;
@synthesize childs, users;
@synthesize autoString, autoArray;
@synthesize avatarURL;
//@synthesize autoSocialNetwork;
@synthesize socialNetwork;
@synthesize nestedArray;
@synthesize eighteenthBirthday;
@synthesize data, dataLossy;
@synthesize favoriteColors;
@synthesize hashedString;
@synthesize hashedUser;
@synthesize missingDate, missingString;
@synthesize null, nullDate, nullArray, nullSet, nullChild, nullNumber;
@synthesize desc, readonly, readonlyCopy, privateCopy;

@end
