JTObjectMapping
===============

Inspired by RestKit. A very simple helper framework that maps a JSON response from NSDictionary or NSArray to NSObject subclasses.


Usage
-----
Suppose this is a JSON User object response represented in NSDictionary after parsing
<pre>
{
    "create_date" = "1970-01-01T00:00:00+0000";
    "p_age" = 30;
    "p_childs" =     (
        Mary,
        James
    );
    "p_name" = Bob;
    "p_title" = Manager;
    "social_networks" =     {
        facebook = bob;
        twitter = "@bob";
    };
}
</pre>
Define necessary mappings, from a dictionary key to a property keyPath.

    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"name", @"p_name",
                    @"title", @"p_title",
                    @"age", @"p_age",
                    [NSDate mappingWithKey:@"createDate"
                          dateFormatString:@"yyyy-MM-dd'T'hh:mm:ssZ"], @"create_date",
                    [JTSocialNetworkTest mappingWithKey:@"socialNetwork"
                                                mapping:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         @"twitterID", @"twitter",
                                                         @"facebookID", @"facebook",
                                                         nil]], @"social_networks",
                    nil];

Get ready with your JSON use **[NSObject objectFromJSONObject:json mapping:mapping]** to convert.

    NSDictionary *json = <Parsed JSON response from above>;

    //
    // Use +[NSObject objectFromJSONObject:mapping:] to convert 
    // the NSDictionary into your JTUserTest object
    //
    JTUserTest *user = [JTUserTest objectFromJSONObject:json mapping:mapping];


Of course you need to define your own User object with corresponding @synthesize properties, and thats all for what you need.

    // JTUserTest.h
    @class JTSocialNetworkTest;
    
    @interface JTUserTest : NSObject
    
    @property (nonatomic, copy) NSString *name;
    @property (nonatomic, copy) NSString *title;
    @property (nonatomic, copy) NSNumber *age;
    @property (nonatomic, retain) NSDate *createDate;
    @property (nonatomic, retain) NSArray *childs;
    @property (nonatomic, retain) JTSocialNetworkTest *socialNetwork;
    
    @end
    
    // JTUserTest.m
    #import "JTUserTest.h"
    
    @implementation JTUserTest
    @synthesize name, title, age, null;
    @synthesize createDate;
    @synthesize childs, users;
    @synthesize socialNetwork;
    
    @end

For more detailed usage, see **JTObjectMappingTests.m**, will be adding more detailed description soon.

Update Logs
-----------

v1.0.3  
- Add raw array JSON response support

v1.0.2  
- Added NSArray support

v1.0.1  
- Added NSDate support for mappings



Future
------

- Add mapping property from dictionary keyPath support
- Add key to property auto mapping for same name