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

@property (nonatomic, strong) NSDictionary *json;
@property (nonatomic, strong) NSDictionary *mapping;
@property (nonatomic, strong) JTUserTest    *object;

@end
