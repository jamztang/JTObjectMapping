//
//  JTObjectMappingTests.h
//  JTObjectMappingTests
//
//  Created by james on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

@class JTUserTest;

@interface JTObjectMappingTests : SenTestCase

@property (nonatomic, retain) NSDictionary *json;
@property (nonatomic, retain) NSDictionary *mapping;
@property (nonatomic, retain) JTUserTest    *object;

@end
