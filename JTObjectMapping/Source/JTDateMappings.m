/*
 * This file is part of the JTObjectMapping package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

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
