/* wizAnalytics - Flurry Module
 *
 * @author Ally Ogilvie
 * @copyright Wizcorp Inc. [ Incorporated Wizards ] 2015
 * @file ModuleFlurry.m for iOS
 *
 */

#import "ModuleFlurry.h"
#import "Flurry.h"

@interface ModuleFlurry ()
@property (nonatomic, retain) NSString *flurryAPIKey;
@end

@implementation ModuleFlurry

- (void)dealloc {
    self.flurryAPIKey = nil;
    [super dealloc];
}

#pragma mark - Required WizAnalyticsVendorModule protocol methods

- (id)initWithOptions:(NSDictionary *)options {
    if ((self = [super init])) {
        self.flurryAPIKey = [options objectForKey:@"FlurryKey"];
    }
    return self;
}

- (void)startSession {
    NSLog(@"FLURRY START SESSION %@", _flurryAPIKey);
    [Flurry startSession:_flurryAPIKey];
}

#pragma mark - Optional WizAnalyticsVendorModule protocol methods

- (void)logEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata {
    NSLog(@"FLURRY LOG EVENT %@ DATA %@", eventName, extraMetadata);
    [Flurry logEvent:eventName withParameters:extraMetadata];
}

@end