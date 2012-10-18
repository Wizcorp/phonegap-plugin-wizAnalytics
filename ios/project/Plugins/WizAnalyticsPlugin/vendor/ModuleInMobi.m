/* wizAnalytics - InMobiAdTracker Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleInMobi.m for iOS
 *
 *
 */

#import "ModuleInMobi.h"
#import "IMAdTrackerAnalytics.h"
#import "IMAdTrackerUtil.h"

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
    [[IMAdTrackerAnalytics imAnalytics] startSession:_inMobiAPIKey];
    // [[IMAdTrackerAnalytics imAnalytics] reportInstallGoal];

}

#pragma mark - Optional WizAnalyticsVendorModule protocol methods

- (void)stopSession
{
    // [[IMAdTrackerAnalytics imAnalytics] reportInstallGoal];

    
}

- (void)handleOpenURL:(NSURL *)url
{
    if (!url) return;
    // Let the Ad Tracker SDK look at the URL. //
    // [[IMAdTrackerAnalytics adAnalytics] handleOpenURL:url];

}

- (void)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if (!url) return;
    // Let the Ad Tracker SDK look at the URL. //
    [[IMAdTrackerAnalytics adAnalytics] handleOpenURL:url];
    
}

@end