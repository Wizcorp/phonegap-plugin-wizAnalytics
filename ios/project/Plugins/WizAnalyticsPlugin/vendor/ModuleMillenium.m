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

@implementation ModuleMillenium

@synthesize milleniumAPIKey = _milleniumAPIKey;

- (id)initWithOptions:(NSDictionary *)options
{
    if ((self = [super init])) {
        self.milleniumAPIKey = [options objectForKey:@"MilleniumKey"];
    }
    return self;
}


- (void)handleOpenURL:(NSURL *)url
{
    // Track conversion
    [[MMAdvertiser sharedSDK] trackConversionWithGoalId:_milleniumAPIKey];
    // Set any info you want to pass to the overlay
    [[MMAdvertiser sharedSDK] setValue:@"test_value" forKey:@"test_key"];
    // Have the branded app SDK look at the url and open an overlay if needed
    // parameters will contain the parse URL query string key/value pairs
    NSDictionary *parameters = [[MMAdvertiser sharedSDK] parseURL:url];
}

- (void)dealloc 
{
    self.milleniumAPIKey = nil;
    [super dealloc];
}




@end