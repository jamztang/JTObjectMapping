/*
 * This file is part of the JTObjectMapping package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "JTDataMappings.h"

@implementation JTDataMappings
@synthesize key, stringEncoding, allowLossy;



/*
 Mapping that allows you to specify NSData the parameters.
 */
+ (id <JTDataMappings>)mappingWithKey:(NSString *)key usingEncoding:(NSStringEncoding)stringEncoding allowLossy:(BOOL)lossy {
    JTDataMappings *dataMapping = [[JTDataMappings alloc] init];
    dataMapping.stringEncoding = stringEncoding;
    dataMapping.key = key;
    dataMapping.allowLossy = lossy;
    return [dataMapping autorelease];
}


- (void)dealloc {
    self.key = nil;
    [super dealloc];
}

@end
