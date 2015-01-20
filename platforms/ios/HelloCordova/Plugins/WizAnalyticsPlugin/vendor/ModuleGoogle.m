//
//  ModuleGoogle.m
//  exampleWizAnalytics
//
//  Created by Chris Wynn on 4/23/13.
//
//

#import "ModuleGoogle.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"
#import "WizDebugLog.h"

@interface ModuleGoogle ()
@property (nonatomic, retain) NSString *googleAnalyticsTrackingId;
@property (nonatomic, retain) id<GAITracker> tracker;
@end

@implementation ModuleGoogle

- (void)dealloc
{
    self.googleAnalyticsTrackingId = nil;
    self.tracker = nil;
    [super dealloc];
}

#pragma mark - Required WizAnalyticsVendorModule protocol methods

- (id)initWithOptions:(NSDictionary *)options {
    if ((self = [super init])) {
        WizLog(@"BOOT GoogleAnalytics");
        self.googleAnalyticsTrackingId = [options objectForKey:@"GoogleKey"];
    }
    return self;
}

- (void)startSession {
    WizLog(@"GoogleAnalytics START SESSION %@", _googleAnalyticsTrackingId);
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;

    // Create tracker instance.
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:self.googleAnalyticsTrackingId];
}

#pragma mark - Optional WizAnalyticsVendorModule protocol methods

- (void)logEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata {
    WizLog(@"GoogleAnalytics LOG EVENT %@ DATA %@", eventName, extraMetadata);
    [self.tracker send:[[GAIDictionaryBuilder
                         createEventWithCategory:[extraMetadata objectForKey:@"category"]
                         action:[extraMetadata objectForKey:@"action"]
                         label:nil
                         value:nil] build]];
}

- (void)logScreen:(NSString *)screenName withExtraMetadata:(NSDictionary *)extraMetadata {
    WizLog(@"GoogleAnalytics LOG SCREEN %@", screenName);
    [self.tracker set:kGAIScreenName value:screenName];
}

@end
