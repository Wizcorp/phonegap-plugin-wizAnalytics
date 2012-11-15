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

- (void)logEvent:(NSArray*)arguments withDict:(NSDictionary*)options
{
    NSString *eventName = [arguments objectAtIndex:1];
    
    WizAnalytics* sharedSingleton = [WizAnalytics sharedInstance];
    [sharedSingleton analyticsEvent:eventName withExtraMetadata:options];
}

- (void)logScreen:(NSArray*)arguments withDict:(NSDictionary*)options
{
    NSString *eventName = [arguments objectAtIndex:1];
    
    WizAnalytics* sharedSingleton = [WizAnalytics sharedInstance];
    [sharedSingleton analyticsScreenEvent:eventName withExtraMetadata:options];
}

- (void)handleOpenURL:(NSArray*)arguments withDict:(NSDictionary*)options
{
    NSString *urlString = [arguments objectAtIndex:1];
    NSURL *url = [NSURL URLWithString:urlString];

    WizAnalytics* sharedSingleton = [WizAnalytics sharedInstance];
    [sharedSingleton handleOpenURL:url];
}

@end