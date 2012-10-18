/* WizAnalyticsPlugin - IOS side of the bridge to WizAnalytics JavaScript for Cordova
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file WizAnalyticsPlugin.h for Cordova
 *
 *
 */

#ifdef CORDOVA_FRAMEWORK
#import <Cordova/CDVPlugin.h>
#else
#import "CDVPlugin.h"
#endif


@interface WizAnalyticsPlugin : CDVPlugin <UIWebViewDelegate> {
}

/* 
 *  Plugin methods
 */
- (void)launch:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)startSession:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)pauseSession:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)endSession:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)restartSession:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)logEvent:(NSArray*)arguments withDict:(NSDictionary*)options;
- (void)logScreen:(NSArray*)arguments withDict:(NSDictionary*)options;

@end