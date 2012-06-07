

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
  Constant string to be used as goal name for reporting Install Goal.
 */
extern NSString *const IM_GOAL_INSTALL;
/**
  Class to send analytics reports to InMobi Ad Tracker.
 */
@interface IMAdTrackerAnalytics : NSObject
/**
  Gets the shared instance of this singleton class.
  @returns a shared instance of the class.
 */
+ (id)imAnalytics;
/**
  Starts an analytics session.
  @param appId App ID
 */
- (void)startSession:(NSString *)appId;
/**
  Reports a Goal name to InMobi Ad Tracker.
  @param goalName Goal name
 */
- (void)reportEvent:(NSString *)goalName;
/**
  Handles the app resume via openURL.
  @param url The URL from the handleOpenURL callback of appdelegate
  @returns YES if it successfully handled the request; NO otherwise
 */
- (BOOL)handleOpenURL:(NSURL *)url;
/**
  Stops the analytics session.
 */
- (void)stopSession;
@end
