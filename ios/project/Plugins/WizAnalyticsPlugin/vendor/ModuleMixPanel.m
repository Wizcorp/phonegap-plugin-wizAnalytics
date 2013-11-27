/* wizAnalytics - Smaato Module
 *
 * @author Ally Ogilvie
 * @copyright Wizcorp Inc. [ Incorporated Wizards ] 2013
 * @file ModuleMixPanel.m for iOS
 *
 *
 */

#import "ModuleMixPanel.h"
#import "Mixpanel.h"
@interface ModuleMixPanel ()
@property (nonatomic, retain) NSString *mixPanelAPIKey;
@property (nonatomic, retain) Mixpanel *mixpanel;
@end

@implementation ModuleMixPanel

- (void)dealloc
{
    self.mixPanelAPIKey = nil;
    self.mixpanel = nil;
    [super dealloc];
}

#pragma mark - Required WizAnalyticsVendorModule protocol methods

- (id)initWithOptions:(NSDictionary *)options
{
    if ((self = [super init])) {
        self.mixPanelAPIKey = [options objectForKey:@"MixPanelKey"];
    }
    return self;
}

- (void)startSession
{
    self.mixpanel = [Mixpanel sharedInstanceWithToken:self.mixPanelAPIKey];
    NSLog(@"MIXPANEL START TRACKING");
}

- (void)logEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata
{
    if (extraMetadata != nil) {
        [self.mixpanel track:eventName properties:extraMetadata];
    } else {
        [self.mixpanel track:eventName];
    }
}

@end