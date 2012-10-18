/* wizAnalytics - IOS controller
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file wizAnalytics.h for iOS
 *
 *
 */


#import <Foundation/Foundation.h>

@interface WizAnalytics : NSObject

- (void)startAnalyticsSession;
- (void)pauseAnalyticsSession;
- (void)restartAnalyticsSession;
- (void)endAnalyticsSession;

- (void)analyticsEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata;

- (void)analyticsScreenEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata;

- (void)handleOpenURL:(NSURL *)url;


// Accessor methods
+ (id)sharedInstance;
+ (id)sharedInstance:(NSDictionary*)options;

@end