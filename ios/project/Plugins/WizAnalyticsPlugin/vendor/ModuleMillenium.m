/* wizAnalytics - Flurry Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleMillenium.m for iOS
 *
 *
 */

#import "ModuleMillenium.h"
#import "MMAdvertiser.h"

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
    // startSession is a required protocol method so it is included here (even though it does nothing)
}

#pragma mark - Optional WizAnalyticsVendorModule protocol methods

- (void)handleOpenURL:(NSURL *)url
{
    // Track conversion
    [[MMAdvertiser sharedSDK] trackConversionWithGoalId:_milleniumAPIKey];
    // Set any info you want to pass to the overlay
    [[MMAdvertiser sharedSDK] setValue:@"test_value" forKey:@"test_key"];
    // Have the branded app SDK look at the url and open an overlay if needed
    // parseURL returns an NSDictionary of parameters that will contain the parse URL query string key/value pairs
    // (this result can be saved and used if required)
    [[MMAdvertiser sharedSDK] parseURL:url];
}

@end