/* wizAnalytics - Millenium Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleMillenium.m for iOS
 *
 *
 */

#import "ModuleMillenium.h"
#import "MMSDK.h"

@interface ModuleMillenium ()
@property (nonatomic, retain) NSString *milleniumAPIKey;
@end

@implementation ModuleMillenium

- (void)dealloc
{
    self.milleniumAPIKey = nil;
    [super dealloc];
}

#pragma mark - Required WizAnalyticsVendorModule protocol methods

- (id)initWithOptions:(NSDictionary *)options
{
    if ((self = [super init])) {
        self.milleniumAPIKey = [options objectForKey:@"MilleniumKey"];
    }
    return self;
}

- (void)startSession
{
    [MMSDK initialize];
}

#pragma mark - Optional WizAnalyticsVendorModule protocol methods

- (void)logEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata
{
    [MMSDK trackEventWithId:eventName];
}

- (void)handleOpenURL:(NSURL *)url
{
    // Track conversion
    [MMSDK trackConversionWithGoalId:_milleniumAPIKey];
}

@end