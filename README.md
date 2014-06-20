JTObjectMapping
===============

Inspired by RestKit. A very simple objective-c framework that maps a JSON response from NSDictionary or NSArray to NSObject subclasses for iOS.

Install
-------

### Original method

Copy all files in JTObjectMapping/ into your project.

### CocoaPods

`$ pod search JTObjectMapping`, you should be able to specify the right version in your Podfile. Here's more information about [CocoaPods][].

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
    "social_networks" = {
        "twitter" = "@mystcolor";
        "facebook" = "yourFacebookID";
    }
}
</pre>

Get ready with your JSON use **[NSObject objectFromJSONObject:json mapping:mapping]** to convert.

    ...
    NSDictionary *json = <Parsed JSON response from above>;

    //
    // Use +[NSObject objectFromJSONObject:mapping:] to convert 
    // the NSDictionary into your JTUserTest object
    //
    JTUserTest *user = [JTUserTest objectFromJSONObject:json mapping:mapping];
    ...

Define necessary mappings, from a dictionary key to a property keyPath.

    // Define the mapping of a nested custom object - JTSocialNetworkTest
    NSDictionary *socialNetworkMapping = [NSDictionary dictionaryWithObjectsAndKeys:
                                               @"twitterID", @"twitter",
                                               @"facebookID", @"facebook",
                                           nil];

    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"name", @"p_name",
                    @"title", @"p_title",
                    @"age", @"p_age",
                    @"childs", @"p_childs",                    
                    [NSDate mappingWithKey:@"createDate"
                          dateFormatString:@"yyyy-MM-dd'T'HH:mm:ssZ"], @"create_date",
                    [JTSocialNetworkTest mappingWithKey:@"socialNetwork"
                                                mapping:socialNetworkMapping], @"social_networks",
                    nil];


Of course you need to define your own User object with corresponding @synthesize properties, and thats all for what you need.


    // JTSocialNetworkTest.h

    @interface JTSocialNetworkTest
    @property (nonatomic, copy) NSString *twitter;
    @property (nonatomic, copy) NSString *facebook;
    @end

    // JTSocialNetworkTest.m
    @implementation
    @end

    // JTUserTest.h
    
    @interface JTUserTest : NSObject
    
    @property (nonatomic, copy) NSString *name;
    @property (nonatomic, copy) NSString *title;
    @property (nonatomic, copy) NSNumber *age;
    @property (nonatomic, strong) NSDate *createDate;
    @property (nonatomic, strong) NSArray *childs;
    @property (nonatomic, strong) JTSocialNetworkTest *socialNetwork;
    
    @end
    
    // JTUserTest.m
    #import "JTUserTest.h"
    
    @implementation JTUserTest
    @end

For more detailed usage, see **JTObjectMappingTests.m**, will be adding more detailed description soon.

Update Logs
-----------

v1.1.2
- Added auto mapping from underscores to CamelCases (e.g. full\_name -> fullName)

v1.1.1
- Added URL support, thanks to [@TheSantaClaus][] and adding the test
  cases nicely.

v1.1
- Refactored JTObjectMapping. Now extending custom mappings are much more cleaner.
- Proper keyPath support.

v1.0.7
- Added JTSetMapping and JTDateEpochMappings, thanks to [@zcharter][] for making this happen!

v1.0.6
- Added experimental keypath support. use `#define JTOBJECTMAPPING_DISABLE_KEYPATH_SUPPORT = 1` to disable it.

v1.0.5  
- Fixed nested array causing crash

v1.0.4  
- Added auto NSDictionary value to NSObject property mapping with the same key defined  
- Fixed false possible JSON response in NSArray use case

v1.0.3   
- Add raw array JSON response support

v1.0.2   
- Added NSArray support

v1.0.1  
- Added NSDate support for mappings


[CocoaPods]:https://github.com/CocoaPods/CocoaPods
[@zcharter]:https://github.com/zcharter
[@TheSantaClaus]:https://github.com/TheSantaClaus




[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/jamztang/jtobjectmapping/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

