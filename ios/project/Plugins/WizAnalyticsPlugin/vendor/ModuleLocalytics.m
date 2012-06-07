/* wizAnalytics - Flurry Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleFlurry.m for iOS
 *
 *
 */

#import "ModuleLocalytics.h"
#import "LocalyticsSession.h"
#import "WizDebugLog.h"

@implementation ModuleLocalytics

@synthesize localyticsAPIKey = _localyticsAPIKey;

- (id)initWithOptions:(NSDictionary *)options
{
    if ((self = [super init])) {
        self.localyticsAPIKey = [options objectForKey:@"LocalyticsKey"];
    }
    return self;
}


- (void)startSession 
{
    WizLog(@"LOCALYTICS START SESSION %@", _localyticsAPIKey);
    [[LocalyticsSession sharedLocalyticsSession] startSession:_localyticsAPIKey];
}

- (void)stopSession
{
    [[LocalyticsSession sharedLocalyticsSession] close];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

- (void)resumeSession
{
    [[LocalyticsSession sharedLocalyticsSession] resume];
    [[LocalyticsSession sharedLocalyticsSession] upload];
}

- (void)logEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata
{
    WizLog(@"LOCALYTICS LOG EVENT %@ DATA %@", eventName, extraMetadata);
    [[LocalyticsSession sharedLocalyticsSession] tagEvent:eventName attributes:extraMetadata];
}

- (void)dealloc 
{
    self.localyticsAPIKey = nil;
    [super dealloc];
}




@end