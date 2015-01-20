/* WizAnalyticsPlugin - IOS side of the bridge to WizAnalytics JavaScript for Cordova
 *
 * @author Ally Ogilvie
 * @copyright Wizcorp Inc. [ Incorporated Wizards ] 2015
 * @file WizAnalyticsPlugin.m for Cordova
 *
 *
 */

#import "WizAnalyticsPlugin.h"
#import "WizAnalytics.h"

@implementation WizAnalyticsPlugin

- (void)logEvent:(CDVInvokedUrlCommand *)command {
    NSString *eventName = [command.arguments objectAtIndex:0];
    NSDictionary *options = [command.arguments objectAtIndex:1];
    
    WizAnalytics* sharedSingleton = [WizAnalytics sharedInstance];
    [sharedSingleton analyticsEvent:eventName withExtraMetadata:options];
}

- (void)logScreen:(CDVInvokedUrlCommand *)command {
    NSString *eventName = [command.arguments objectAtIndex:0];
    NSDictionary *options = [command.arguments objectAtIndex:1];
    
    WizAnalytics* sharedSingleton = [WizAnalytics sharedInstance];
    [sharedSingleton analyticsScreenEvent:eventName withExtraMetadata:options];
}

- (void)handleOpenURL:(CDVInvokedUrlCommand *)command {
    NSString *urlString = [command.arguments objectAtIndex:0];
    NSURL *url = [NSURL URLWithString:urlString];

    WizAnalytics* sharedSingleton = [WizAnalytics sharedInstance];
    [sharedSingleton handleOpenURL:url];
}

@end