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

    NSDictionary *mapping = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"name", @"p_name",
                    @"title", @"p_title",
                    @"age", @"p_age",
                    @"childs", @"p_childs",                    
                    [NSDate mappingWithKey:@"createDate"
                          dateFormatString:@"yyyy-MM-dd'T'hh:mm:ssZ"], @"create_date",
                    nil];


Of course you need to define your own User object with corresponding @synthesize properties, and thats all for what you need.

    // JTUserTest.h
    
    @interface JTUserTest : NSObject
    
    @property (nonatomic, copy) NSString *name;
    @property (nonatomic, copy) NSString *title;
    @property (nonatomic, copy) NSNumber *age;
    @property (nonatomic, retain) NSDate *createDate;
    @property (nonatomic, retain) NSArray *childs;
    
    @end
    
    // JTUserTest.m
    #import "JTUserTest.h"
    
    @implementation JTUserTest
    @synthesize name, title, age;
    @synthesize createDate;
    @synthesize childs;
    
    @end

For more detailed usage, see **JTObjectMappingTests.m**, will be adding more detailed description soon.

Update Logs
-----------

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


