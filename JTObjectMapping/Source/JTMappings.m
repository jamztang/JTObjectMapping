/*
 * This file is part of the JTObjectMapping package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

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
