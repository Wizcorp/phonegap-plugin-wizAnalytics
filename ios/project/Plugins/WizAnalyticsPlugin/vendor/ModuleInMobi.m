/* wizAnalytics - InMobiAdTracker Module
 *
 * @author Ally Ogilvie
 * @copyright Wizcorp Inc. [ Incorporated Wizards ] 2013
 * @file ModuleInMobi.m for iOS
 *
 *
 */

#import "ModuleInMobi.h"
#import "InMobi.h"
#import "InMobiAnalytics.h"

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
    [InMobi initialize:_inMobiAPIKey];
}

#pragma mark - Optional WizAnalyticsVendorModule protocol methods

- (void)logEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata
{
    [InMobiAnalytics tagEvent:eventName];
}

@end
