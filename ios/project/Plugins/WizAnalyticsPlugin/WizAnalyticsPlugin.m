/* WizAnalyticsPlugin - IOS side of the bridge to WizAnalytics JavaScript for Cordova
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file WizAnalyticsPlugin.m for Cordova
 *
 *
 */

#import "WizAnalyticsPlugin.h"
#import "WizAnalytics.h"

#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVPlugin.h>
#else
#import "CDVPlugin.h"
#endif



@implementation WizAnalyticsPlugin

- (void)startSession:(NSArray*)arguments withDict:(NSDictionary*)options
{
    
}

- (void)endSession:(NSArray*)arguments withDict:(NSDictionary*)options
{
    
}

- (void)restartSession:(NSArray*)arguments withDict:(NSDictionary*)options
{
    
}

- (void)logEvent:(NSArray*)arguments withDict:(NSDictionary*)options
{
    // Callback
    // NSString *callbackId = [arguments objectAtIndex:0];
    NSString *eventName = [arguments objectAtIndex:1];
    
    WizAnalytics* sharedSingleton = [WizAnalytics sharedInstance];

    if (options) {
        
        [sharedSingleton analyticsEvent:eventName withExtraMetadata:options];
        
	} else {
        
        [sharedSingleton analyticsEvent:eventName withExtraMetadata:nil];
        
        
    }
    
    
}

@end