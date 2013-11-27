/* WizAnalyticsPlugin - IOS side of the bridge to WizAnalytics JavaScript for Cordova
 *
 * @author Ally Ogilvie
 * @copyright Wizcorp Inc. [ Incorporated Wizards ] 2013
 * @file WizAnalyticsPlugin.h for Cordova
 *
 *
 */

#import <Cordova/CDVPlugin.h>

@interface WizAnalyticsPlugin : CDVPlugin <UIWebViewDelegate> {
}

/* 
 *  Plugin methods
 */
- (void)logEvent:(CDVInvokedUrlCommand*)command;
- (void)logScreen:(CDVInvokedUrlCommand*)command;
- (void)handleOpenURL:(CDVInvokedUrlCommand*)command;

@end
