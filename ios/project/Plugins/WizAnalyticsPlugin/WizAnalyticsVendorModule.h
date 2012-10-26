/* WizAnalyticsVendorModule - Protocol and base class for vendor modules
 *
 * @author Chris Wynn
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file WizAnalyticsVendorModule.h for iOS
 *
 *
 */

#import <Foundation/Foundation.h>

@protocol WizAnalyticsVendorModuleProtocol

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

@interface WizAnalyticsVendorModule : NSObject <WizAnalyticsVendorModuleProtocol>
@end