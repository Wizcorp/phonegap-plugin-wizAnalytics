/* wizAnalytics - Localytics Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleLocalytics.h for iOS
 *
 *
 */

#import <Foundation/Foundation.h>

@interface ModuleLocalytics : NSObject {
    NSString *_localyticsAPIKey;
}

@property (nonatomic, retain) NSString *localyticsAPIKey;

- (id)initWithOptions:(NSDictionary *)options;
- (void)startSession;
- (void)stopSession;
- (void)resumeSession;
- (void)logEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata;
@end