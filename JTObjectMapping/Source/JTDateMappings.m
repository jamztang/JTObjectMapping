/*
 * This file is part of the JTObjectMapping package.
 * (c) James Tang <mystcolor@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "JTDateMappings.h"

@implementation JTDateMappings
@synthesize dateFormatString, key = _key;

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

- (BOOL)transformValue:(NSObject *)oldValue
               toValue:(NSObject **)newValue
                forKey:(NSString **)key {

    if ([oldValue isKindOfClass:[NSString class]]) {

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:self.dateFormatString];

        NSDate *date = [formatter dateFromString:(NSString *)oldValue];
        [formatter release];

        *newValue = date;
        *key = self.key;

        return YES;

    } else if ([oldValue isKindOfClass:[NSNull class]]) {
        
        *newValue = nil;
        *key      = self.key;
        
        return YES;
    }

    return NO;
}

@end



@implementation JTDateEpochMappings
@synthesize key = _key, divisorForSeconds;

+ (id <JTDateEpochMappings>)mappingWithKey:(NSString *)key divisorForSeconds:(NSTimeInterval)divisorForSeconds {
    JTDateEpochMappings *epochMapping = [[JTDateEpochMappings alloc] init];
    epochMapping.key = key;
    epochMapping.divisorForSeconds = divisorForSeconds;
    return [epochMapping autorelease];
}

- (void)dealloc {
    self.key = nil;
    [super dealloc];
}

- (BOOL)transformValue:(NSObject *)oldValue
               toValue:(NSObject **)newValue
                forKey:(NSString **)key {
    
    if ([oldValue isKindOfClass:[NSNumber class]]) {

        NSTimeInterval secondsFactor = [(NSNumber *)oldValue doubleValue];
        // convert into desired unit of seconds, but be sure to round if necessary, eg. 1000==milliseconds
        // (otherwise 19999 milliseconds will be off by a second because it will be rounded down instead of up)
        // Reference: http://stackoverflow.com/a/4926468/168594
        NSTimeInterval secSinceEpoch = (secondsFactor + self.divisorForSeconds - 1) / self.divisorForSeconds;
        // create the date and assign it to the object we're mapping
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:secSinceEpoch];

        *newValue = date;
        *key = self.key;

        return YES;

    } else if ([oldValue isKindOfClass:[NSNull class]]) {
        
        *newValue = nil;
        *key      = self.key;
        
        return YES;
    }
    

    return NO;
}

@end