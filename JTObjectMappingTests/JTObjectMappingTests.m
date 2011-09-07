//
//  JTObjectMappingTests.m
//  JTObjectMappingTests
//
//  Created by james on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JTObjectMappingTests.h"
#import "NSObject+JTObjectMapping.h"
#import "JTUserTest.h"
#import "JTSocialNetworkTest.h"

@implementation JTObjectMappingTests
@synthesize json, mapping, object;
@synthesize userArray;


- (void)setUp
{
    [super setUp];

    // Set-up code here.
    self.json = [NSDictionary dictionaryWithObjectsAndKeys:
                 @"Bob", @"p_name",
                 @"Manager", @"p_title",

                 [NSNumber numberWithInt:30], @"p_age",
                 [NSNull null], @"p_null",          // Sometime [NSNull null] object would be returned from the JSON response

                 [NSArray arrayWithObjects:
                  @"Mary",
                  @"James",
                  nil], @"p_childs",

                 [NSArray arrayWithObjects:
                  [NSDictionary dictionaryWithObjectsAndKeys:
                   @"John", @"p_name", nil],
                  [NSDictionary dictionaryWithObjectsAndKeys:
                   @"Doe", @"p_name", nil],
                  nil], @"p_users",

                 @"1970-01-01T00:00:00+0000", @"create_date",

                 [NSDictionary dictionaryWithObjectsAndKeys:
                  @"@bob", @"twitter",
                  @"bob", @"facebook",
                  nil], @"social_networks",
                 nil];

    
    self.mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"name", @"p_name",
                    @"title", @"p_title",
                    @"age", @"p_age",
                    @"null", @"p_null",
                    @"childs", @"p_childs",
                    [JTUserTest mappingWithKey:@"users"
                                       mapping:[NSDictionary dictionaryWithObjectsAndKeys:
                                                @"name", @"p_name",
                                                nil]], @"p_users",
                    [NSDate mappingWithKey:@"createDate"
                          dateFormatString:@"yyyy-MM-dd'T'hh:mm:ssZ"], @"create_date",
                    [JTSocialNetworkTest mappingWithKey:@"socialNetwork"
                                                mapping:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         @"twitterID", @"twitter",
                                                         @"facebookID", @"facebook",
                                                         nil]], @"social_networks",
                    nil];

    self.object = [JTUserTest objectFromJSONObject:json mapping:mapping];


    // Test if the JSON response is raw array
    NSArray *jsonArray = [NSArray arrayWithObjects:
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"John", @"p_name", nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:
                           @"Doe", @"p_name", nil],
                          nil];

    self.userArray = [NSArray objectFromJSONObject:jsonArray mapping:self.mapping];
}

- (void)tearDown
{
    // Tear-down code here.
    self.userArray = nil;
    self.json = nil;
    self.mapping = nil;
    self.object = nil;

    [super tearDown];
}

- (void)testTitle {
    STAssertTrue([self.object.title isEqual:@"Manager"], @"title = %@ fails to equal %@", self.object.title, @"Manager");
}

- (void)testName {
    STAssertTrue([self.object.name isEqual:@"Bob"], @"name = %@ fails to equal %@", self.object.name, @"Bob");
}

- (void)testAge {
    STAssertTrue([self.object.age isEqualToNumber:[NSNumber numberWithInt:30]], @"age = %@ fails to equal %@", self.object.age, [NSNumber numberWithInt:30]);
}

- (void)testSocialTwitter {
    STAssertTrue([self.object.socialNetwork.twitterID isEqual:@"@bob"], @"twitterID = %@ fails to equal %@", self.object.socialNetwork.twitterID, @"@bob");
}

- (void)testSocialFacebook {
    STAssertTrue([self.object.socialNetwork.facebookID isEqual:@"bob"], @"facebookID = %@ fails to equal %@", self.object.socialNetwork.facebookID, @"bob");
}

- (void)testNull {
    STAssertNil(self.object.null, @"null should be mapped to nil", nil);
}

- (void)testCreateDate {
    STAssertTrue([self.object.createDate isEqual:[NSDate dateWithTimeIntervalSince1970:0]], @"date %@ != %@", self.object.createDate, [NSDate dateWithTimeIntervalSince1970:0]);
}

- (void)testChilds {
    STAssertTrue([self.object.childs count] == 2, @"Should have two childs", nil);
    STAssertTrue([[self.object.childs objectAtIndex:0] isEqual:@"Mary"], @"%@ != Mary", [self.object.childs objectAtIndex:0]);
    STAssertTrue([[self.object.childs objectAtIndex:1] isEqual:@"James"], @"%@ != James", [self.object.childs objectAtIndex:1]);
}

- (void)testUsers {
    STAssertTrue([self.object.users count] == 2, @"Should have two users", nil);

    JTUserTest *userJohn = [self.object.users objectAtIndex:0];
    STAssertTrue([userJohn isKindOfClass:[JTUserTest class]], @"%@ != [JTUserTest class]", [userJohn class]);
    STAssertTrue([userJohn.name isEqual:@"John"], @"%@ != John", userJohn.name);

    JTUserTest *userDoe = [self.object.users objectAtIndex:1];
    STAssertTrue([userDoe isKindOfClass:[JTUserTest class]], @"%@ != [JTUserTest class]", [userDoe class]);
    STAssertTrue([userDoe.name isEqual:@"Doe"], @"%@ != Doe", userDoe.name);
}

- (void)testUserArray {
    STAssertTrue([self.userArray count] == 2, @"Should have two users", nil);

    JTUserTest *userJohn = [self.object.users objectAtIndex:0];
    STAssertTrue([userJohn isKindOfClass:[JTUserTest class]], @"%@ != [JTUserTest class]", [userJohn class]);
    STAssertTrue([userJohn.name isEqual:@"John"], @"%@ != John", userJohn.name);
    
    JTUserTest *userDoe = [self.object.users objectAtIndex:1];
    STAssertTrue([userDoe isKindOfClass:[JTUserTest class]], @"%@ != [JTUserTest class]", [userDoe class]);
    STAssertTrue([userDoe.name isEqual:@"Doe"], @"%@ != Doe", userDoe.name);
}

@end
