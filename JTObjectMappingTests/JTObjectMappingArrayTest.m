//
//  JTObjectMappingArrayTest.m
//  JTObjectMapping
//
//  Created by James Tang on 12/09/2011.
//  Copyright 2011 CUHK. All rights reserved.
//

#import "JTObjectMappingArrayTest.h"
#import "NSObject+JTObjectMapping.h"
#import "JTUserTest.h"

@implementation JTObjectMappingArrayTest
@synthesize userArray;

- (void)setUp
{
    [super setUp];
    
    // Test if the JSON response is raw array
    // Here we simply use a stripped down version of user object in this array
    NSArray *jsonArray = [NSArray arrayWithObjects:
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"John", @"name", nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"Doe", @"name", nil],
                          nil];
    
    // We don't needed to define mapping because new JTObjectMapping supports 
    // auto referencing to the corresponding property key with the same name.
    self.userArray = [JTUserTest objectFromJSONObject:jsonArray mapping:nil];
}

- (void)tearDown
{
    // Tear-down code here.
    self.userArray = nil;
    
    [super tearDown];
}

- (void)testUserArray {
    STAssertTrue([self.userArray count] == 2, @"Should have two users", nil);
    
    JTUserTest *userJohn = [self.userArray objectAtIndex:0];
    STAssertTrue([userJohn isKindOfClass:[JTUserTest class]], @"%@ != [JTUserTest class]", [userJohn class]);
    STAssertEqualObjects(userJohn.name, @"John", nil, nil);
    
    JTUserTest *userDoe = [self.userArray objectAtIndex:1];
    STAssertTrue([userDoe isKindOfClass:[JTUserTest class]], @"%@ != [JTUserTest class]", [userDoe class]);
    STAssertEqualObjects(userDoe.name, @"Doe", nil, nil);
}


@end
