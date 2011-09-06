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


- (void)setUp
{
    [super setUp];

    // Set-up code here.
    self.json = [NSDictionary dictionaryWithObjectsAndKeys:
                 @"Bob", @"p_name",
                 @"Manager", @"p_title",
                 [NSArray arrayWithObjects:
                  @"Mary",
                  @"James",
                  nil], @"p_childs",
                 [NSNumber numberWithInt:30], @"p_age",
                 [NSNull null], @"p_null",          // Sometime [NSNull null] object would be returned from the JSON response
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
                    [NSArray mappingWithKey:@"childs"], @"p_childs",
                    [NSDate mappingWithKey:@"createDate"
                          dateFormatString:@"yyyy-MM-dd'T'hh:mm:ssZ"], @"create_date",
                    [JTSocialNetworkTest mappingWithKey:@"socialNetwork"
                                                mapping:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         @"twitterID", @"twitter",
                                                         @"facebookID", @"facebook",
                                                         nil]], @"social_networks",
                    nil];

    self.object = [[[JTUserTest alloc] init] autorelease];
    [self.object setValueFromDictionary:json mapping:mapping];
}

- (void)tearDown
{
    // Tear-down code here.
    
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

@end
