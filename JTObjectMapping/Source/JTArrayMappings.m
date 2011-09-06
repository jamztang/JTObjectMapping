//
//  JTArrayMappings.m
//  JTObjectMapping
//
//  Created by James Tang on 07/09/2011.
//  Copyright 2011 CUHK. All rights reserved.
//

#import "JTArrayMappings.h"

@implementation JTArrayMappings

@synthesize targetClass, key;

- (void)dealloc {
    self.targetClass = nil;
    self.key = nil;
    [super dealloc];
}

@end
