/* WizAnalyticsVendorModule - Protocol for vendor modules
 *
 * @author Chris Wynn
 * @copyright Wizcorp Inc. [ Incorporated Wizards ] 2015
 * @file WizAnalyticsVendorModule.h for iOS
 *
 *
 */

#import <Foundation/Foundation.h>

@protocol WizAnalyticsVendorModule

@required
- (id)initWithOptions:(NSDictionary *)options;
- (void)startSession;

@optional
- (void)stopSession;
- (void)pauseSession;
- (void)resumeSession;
- (void)logEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata;
- (void)logScreen:(NSString *)screenName withExtraMetadata:(NSDictionary *)extraMetadata;

- (void)handleOpenURL:(NSURL *)url;

@end
