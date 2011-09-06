//
//  JTDateMappings.m
//  JTObjectMapping
//
//  Created by James Tang on 07/09/2011.
//  Copyright 2011 CUHK. All rights reserved.
//

#import "JTDateMappings.h"

@implementation JTDateMappings
@synthesize dateFormatString, key;

+ (id <JTDateMappings>)mappingWithKey:(NSString *)key dateFormatString:(NSString *)dateFormatString {
    JTDateMappings *dateMappings = [[JTDateMappings alloc] init];
    dateMappings.dateFormatString = dateFormatString;
    dateMappings.key              = key;
    return [dateMappings autorelease];
}

- (void)dealloc {
    self.dateFormatString = nil;
    self.key = nil;
    [super dealloc];
}

@end
