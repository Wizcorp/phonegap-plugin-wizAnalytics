/* WizAnalyticsPlugin - IOS side of the bridge to WizAnalytics JavaScript for Cordova
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
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
