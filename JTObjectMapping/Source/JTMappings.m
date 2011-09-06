//
//  JTMappings.m
//  JTObjectMapping
//
//  Created by james on 9/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "JTMappings.h"

@implementation JTMappings
@synthesize key, mapping, targetClass;

+ (id <JTMappings>)mappingWithKey:(NSString *)aKey targetClass:(Class)aClass mapping:(NSDictionary *)aMapping {
    JTMappings *obj = [[JTMappings alloc] init];
    obj.key         = aKey;
    obj.mapping     = aMapping;
    obj.targetClass = aClass;
    return [obj autorelease];
}

- (void)dealloc {
    self.key = nil;
    self.mapping = nil;
    self.targetClass = nil;
    [super dealloc];
}

@end
