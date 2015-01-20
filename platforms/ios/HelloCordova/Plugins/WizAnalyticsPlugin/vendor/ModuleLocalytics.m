/* wizAnalytics - Localytics Module
 *
 * @author Ally Ogilvie
 * @copyright Wizcorp Inc. [ Incorporated Wizards ] 2015
 * @file ModuleLocalytics.m for iOS
 *
 */

#import "ModuleLocalytics.h"
#import "Localytics.h"
#import "WizDebugLog.h"

@interface ModuleLocalytics ()
@property (nonatomic, retain) NSString *localyticsAPIKey;
@end

@implementation ModuleLocalytics

- (void)dealloc {
    self.localyticsAPIKey = nil;
    [super dealloc];
}

#pragma mark - Required WizAnalyticsVendorModule protocol methods

- (id)initWithOptions:(NSDictionary *)options {
    if ((self = [super init])) {
        self.localyticsAPIKey = [options objectForKey:@"LocalyticsKey"];
    }
    return self;
}

- (void)startSession {
    WizLog(@"LOCALYTICS START SESSION %@", _localyticsAPIKey);
    [Localytics integrate:_localyticsAPIKey];
    [Localytics openSession];
    [Localytics upload];
}

#pragma mark - Optional WizAnalyticsVendorModule protocol methods

- (void)pauseSession {
    [Localytics closeSession];
}

- (void)stopSession {
    [Localytics closeSession];
    [Localytics upload];
}

- (void)resumeSession {
    [Localytics openSession];
    [Localytics upload];
}

- (void)logEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata {
    WizLog(@"LOCALYTICS LOG EVENT %@ DATA %@", eventName, extraMetadata);
    [Localytics tagEvent:eventName attributes:extraMetadata];
}

- (void)logScreen:(NSString *)screenName withExtraMetadata:(NSDictionary *)extraMetadata {
    WizLog(@"LOCALYTICS LOG SCREEN %@", screenName);
    [Localytics tagScreen:screenName];
}

@end