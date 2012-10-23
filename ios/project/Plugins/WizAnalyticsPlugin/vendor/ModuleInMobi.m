/* wizAnalytics - InMobiAdTracker Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleInMobi.m for iOS
 *
 *
 */

#import "ModuleInMobi.h"
#import "IMAdTracker.h"

@interface ModuleInMobi ()
@property (nonatomic, retain) NSString *inMobiAPIKey;
@end

@implementation ModuleInMobi

- (void)dealloc
{
    self.inMobiAPIKey = nil;
    [super dealloc];
}

#pragma mark - Required WizAnalyticsVendorModule protocol methods

- (id)initWithOptions:(NSDictionary *)options
{
    if ((self = [super init])) {
        self.inMobiAPIKey = [options objectForKey:@"InMobiKey"];
    }
    return self;
}

- (void)startSession
{
    NSLog(@"InMobi START SESSION %@", _inMobiAPIKey);
    [IMAdTracker initWithAppID:_inMobiAPIKey];
    [IMAdTracker reportAppDownloadGoal];
}

#pragma mark - Optional WizAnalyticsVendorModule protocol methods

- (void)logEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata
{
    [IMAdTracker reportCustomGoal:eventName];
}

@end
