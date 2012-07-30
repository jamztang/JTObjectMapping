/*
 * This file is part of the JTObjectMapping package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "JTSetMappings.h"

@implementation JTSetMappings
@synthesize key;

+ (id <JTSetMappings>)mappingWithKey:(NSString *)key {
    JTSetMappings *map = [[JTSetMappings alloc] init];
    map.key = key;
    return [map autorelease];
}

- (void)dealloc {
    self.key = nil;
    [super dealloc];
}

@end
