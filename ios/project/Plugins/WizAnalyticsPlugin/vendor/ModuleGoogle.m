//
//  ModuleGoogle.m
//  exampleWizAnalytics
//
//  Created by Chris Wynn on 4/23/13.
//
//

#import "ModuleGoogle.h"
#import "GAI.h"
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

- (id)initWithOptions:(NSDictionary *)options
{
    if ((self = [super init])) {
        WizLog(@"BOOT GoogleAnalytics");
        self.googleAnalyticsTrackingId = [options objectForKey:@"GoogleKey"];
    }
    return self;
}

- (void)startSession
{
    WizLog(@"GoogleAnalytics START SESSION %@", _googleAnalyticsTrackingId);
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = YES;
    
    // Create tracker instance.
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:self.googleAnalyticsTrackingId];
}

#pragma mark - Optional WizAnalyticsVendorModule protocol methods

- (void)logEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata
{
    WizLog(@"GoogleAnalytics LOG EVENT %@ DATA %@", eventName, extraMetadata);    
    [self.tracker sendEventWithCategory:[extraMetadata objectForKey:@"category"]
                             withAction:[extraMetadata objectForKey:@"action"]
                              withLabel:nil
                              withValue:nil];
}

- (void)logScreen:(NSString *)screenName withExtraMetadata:(NSDictionary *)extraMetadata
{
    WizLog(@"GoogleAnalytics LOG SCREEN %@", screenName);
    [self.tracker sendView:screenName];
}

@end
