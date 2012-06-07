/* wizAnalytics - Flurry Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleFlurry.m for iOS
 *
 *
 */

#import "ModuleFlurry.h"
#import "FlurryAnalytics.h"
#import "WizDebugLog.h"

@implementation ModuleFlurry

@synthesize flurryAPIKey = _flurryAPIKey;

- (id)initWithOptions:(NSDictionary *)options
{
    if ((self = [super init])) {
        self.flurryAPIKey = [options objectForKey:@"FlurryKey"];
    }
    return self;
}


- (void)startSession 
{
    WizLog(@"FLURRY START SESSION %@", _flurryAPIKey);
    [FlurryAnalytics startSession:_flurryAPIKey];
}

- (void)logEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata
{
    WizLog(@"FLURRY LOG EVENT %@ DATA %@", eventName, extraMetadata);
    [FlurryAnalytics logEvent:eventName withParameters:extraMetadata];
}

- (void)dealloc 
{
    self.flurryAPIKey = nil;
    [super dealloc];
}




@end