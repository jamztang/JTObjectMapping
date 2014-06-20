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
#import "JPNestedArrayTest.h"

#define EIGHTEEN_YEARS_IN_SECONDS 567993600

// when the unicode string is mapped with lossy ASCII the elipses character (0x2026) will convert to three periods
#define DATA_STRING_UNICODE @"elipses are unicode characters…periods are not"
#define DATA_STRING_ASCII   @"elipses are unicode characters...periods are not"
#define AVATAR_URL @"http://en.gravatar.com/userimage/11332249/d73901242ae1c7e33bcc7c83257ac165.jpg"

@implementation JTObjectMappingTests
@synthesize json, mapping, object;

- (void)setUp
{
    [super setUp];

    // Set-up code here.

    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"JTObjectMappingTests" ofType:@"json"];
    self.json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonPath]
                                                options:0
                                                  error:NULL];

    NSDictionary *socialNetworkMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                          @"twitterID", @"twitter",
                                          @"facebookID", @"facebook",
                                          nil];
    
    NSString *dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
    
    // Define the mapping between JSON dictionary-keys to the object properties.
    // Note how basic foundation types (NSString, NSDictionary, NSArray, NSSet, NSNumber)
    // are automatically mapped if the json key is the same as the property name.
    // You need to specify a mapping (as below) if the json key and objC property name are different,
    // or if you want to map to a custom object (see the JTUserTest mapping below)
    self.mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"name", @"p_name",
                    @"title", @"p_title",
                    @"age", @"p_age",
                    @"childs", @"p_childs",
                    [JTUserTest mappingWithKey:@"users"
                                       mapping:[NSDictionary dictionaryWithObjectsAndKeys:
                                                @"name", @"p_name",
                                                nil]], @"p_users",
                    // NSSet mapping
                    [NSSet mappingWithKey:@"favoriteColors"], @"favorite_colors",
                    
                    // NSSet keypath
                    @"hashedString", @"hashed.string",
                    [JTUserTest mappingWithKey:@"hashedUser"
                                       mapping:[NSDictionary dictionaryWithObjectsAndKeys:
                                                @"name", @"p_name",
                                                nil]], @"hashed.user",
                    
                    // NSDate mapping -- by format or since the epoch
                    [NSDate mappingWithKey:@"createDate"
                          dateFormatString:dateFormat], @"create_date",
                    // NSDate mapping with seconds since the epoch (1==seconds, 1000==milliseconds)
                    [NSDate mappingWithKey:@"eighteenthBirthday"
                         divisorForSeconds:1], @"eighteenth_birthday",
                    
                    // NSData mapping
                    [NSData mappingWithKey:@"data" usingEncoding:NSUTF8StringEncoding], @"data",
                    // NSData mapping (lossy ascii)
                    [NSData mappingWithKey:@"dataLossy" usingEncoding:NSASCIIStringEncoding allowLossy:YES], @"dataLossy",
                    
                    [NSURL mappingWithKey:@"avatarURL"], @"avatarURL",
                    
                    // This specifies a mapping a child object (JTSocialNetwork) and a child dictionary in the json dictionary
                    // (it too uses a map of json keys to its properties, the `socialNetworkMapping` dictionary)
                    [JTSocialNetworkTest mappingWithKey:@"socialNetwork"
                                                mapping:socialNetworkMapping], @"social_networks",
                    
                    [JPNestedArrayTest mappingWithKey:@"nestedArray"
                                       mapping:[NSDictionary dictionaryWithObjectsAndKeys:
                                                @"array", @"array", nil]], @"nestedArray",

                    @"null", @"p_null",
                    [NSDate mappingWithKey:@"nullDate"
                          dateFormatString:dateFormat], @"null_date",
                    [JTSocialNetworkTest mappingWithKey:@"nullChild"
                                                mapping:socialNetworkMapping], @"null_child",
                    @"nullArray", @"null_array",
                    @"nullSet", @"null_set",
                    @"nullNumber", @"null_number",
                    // missing auto-mapping -- this key doesn't exist in the json, which is fine
                    @"missingString", @"missingString",
                    // missing class-mapping -- this key doesn't exist in the json, which is fine
                    [NSDate mappingWithKey:@"missingDate" divisorForSeconds:1], @"missingDate",
                    
                    @"desc", @"description",

                    nil];

    self.object = [JTUserTest objectFromJSONObject:json mapping:mapping];
}

- (void)tearDown
{
    // Tear-down code here.
    self.json = nil;
    self.mapping = nil;
    self.object = nil;

    [super tearDown];
}

//- (void)testPrintJSON {
//    NSLog(@"%@", self.json);
//}


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
    STAssertNil(self.object.nullDate, @"nullDate should be mapped to nil", nil);
    STAssertNil(self.object.nullArray, @"nullArray should be mapped to nil", nil);
    STAssertNil(self.object.nullSet, @"nullSet should be mapped to nil", nil);
    STAssertNil(self.object.nullChild, @"nullChild should be mapped to nil", nil);
    STAssertNil(self.object.nullNumber, @"nullNumber should be mapped to nil", nil);
}

- (void)testCreateDate {
    STAssertTrue([self.object.createDate isEqual:[NSDate dateWithTimeIntervalSince1970:46800]], @"date %@ != %@", self.object.createDate, [NSDate dateWithTimeIntervalSince1970:46800]);
}

// Test date with seconds since Epoch
- (void)testEpochDate {
    NSDate *date18 = [NSDate dateWithTimeIntervalSince1970:EIGHTEEN_YEARS_IN_SECONDS];
    STAssertTrue([self.object.eighteenthBirthday isEqual:date18], @"date %@ != %@", self.object.eighteenthBirthday, date18);
}

- (void)testData {
    // test lossless data -- will still contain the elipses (0x2026) character
    NSString *notLossy = [[NSString alloc] initWithData:self.object.data encoding:NSUTF8StringEncoding];
    STAssertTrue([DATA_STRING_UNICODE isEqualToString:notLossy], @"data string didn't convert");
    // test lossy conversion to ascii -- the elipses will convert to three periods
    NSString *lossy = [[NSString alloc] initWithData:self.object.dataLossy encoding:NSASCIIStringEncoding];
    STAssertTrue([DATA_STRING_ASCII isEqualToString:lossy], @"data string didn't convert");
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
    STAssertEqualObjects(userJohn.name, @"John", nil, nil);

    JTUserTest *userDoe = [self.object.users objectAtIndex:1];
    STAssertTrue([userDoe isKindOfClass:[JTUserTest class]], @"%@ != [JTUserTest class]", [userDoe class]);
    STAssertEqualObjects(userDoe.name, @"Doe", nil, nil);
}

- (void)testSet {
    NSSet *colors = self.object.favoriteColors;
    STAssertTrue([colors isKindOfClass:[NSSet class]], @"%@ != [NSSet class]", [colors class]);
    STAssertTrue([colors containsObject:@"green"], @"%@ should contain 'green'", colors);
    STAssertTrue([colors containsObject:@"blue"], @"%@ should contain 'blue'", colors);
}

- (void)testURL {
    NSURL *url = self.object.avatarURL;
    STAssertTrue([url isKindOfClass:[NSURL class]], @"%@ != [NSURL class]", [url class]);
    STAssertTrue([url.absoluteString isEqualToString:AVATAR_URL], @"%@ != %@", url.absoluteString, AVATAR_URL);
}

- (void)testKeyPath {
    STAssertEqualObjects(self.object.hashedString, @"string", nil, nil);
    
    JTUserTest *user = [[JTUserTest alloc] init];
    user.name        = @"John";

    STAssertEqualObjects(self.object.hashedUser.name, user.name, nil, nil);
}

- (void)testMissingJSON {
    STAssertNil(self.object.missingString, @"missingString should be nil");
    STAssertNil(self.object.missingDate, @"missingDate should be nil");
}

- (void)testAutoMapping {
    STAssertEqualObjects(self.object.autoString, @"yes", nil, nil);
}

- (void)testAutoArray {
    NSArray *array = [NSArray arrayWithObjects:
                      @"Object1",
                      @"Object2",
                      nil];
    STAssertEqualObjects(self.object.autoArray, array, nil, nil);
}

- (void)testAutoUnderscoreToCamelCase {
    STAssertEqualObjects(self.object.autoUnderscoreToCamelCase, @1, nil, nil);
}

//- (void)testAutoMapObject {
//    JTSocialNetworkTest *network = [[JTSocialNetworkTest alloc] init];
//    network.twitterID = @"@bob";
//    network.facebookID = @"bob";
//    STAssertEqualObjects(self.object.autoSocialNetwork, network, nil, nil);
//    [network release];
//}

- (void)testNestedArray {
    STAssertTrue([self.object.nestedArray count] == 2, @"Should have two apis", nil);
    
    JPNestedArrayTest *api = [self.object.nestedArray objectAtIndex:0];
    STAssertTrue([api isKindOfClass:[JPNestedArrayTest class]], @"%@ != [JPAPITests class]", [api class]);
    
    NSArray *expectedArray = [NSArray arrayWithObjects:@"one", @"two", nil];
    STAssertEqualObjects(api.array, expectedArray, nil, nil);

    JPNestedArrayTest *api2 = [self.object.nestedArray objectAtIndex:1];
    STAssertTrue([api2 isKindOfClass:[JPNestedArrayTest class]], @"%@ != [JPAPITests class]", [api2 class]);
    
    NSArray *expectedArray2 = [NSArray arrayWithObjects:@"three", @"four", nil];
    STAssertEqualObjects(api2.array, expectedArray2, nil, nil);
}

- (void)testPreserved {
    STAssertEqualObjects(self.object.desc, @"Description", nil);
}

- (void)testReadonly {
    STAssertNil(self.object.readonly, nil);
    STAssertNil(self.object.readonlyCopy, nil);
    STAssertEqualObjects(self.object.privateCopy, @"PrivateCopy", nil);
}

@end
