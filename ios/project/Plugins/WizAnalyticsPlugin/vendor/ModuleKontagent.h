/* wizAnalytics - Kontagent Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleKontagent.h for iOS
 *
 *
 */

#import <Foundation/Foundation.h>

@interface ModuleKontagent : NSObject {
    NSString *_kontagentAPIKey;
}

@property (nonatomic, retain) NSString *kontagentAPIKey;

- (id)initWithOptions:(NSDictionary *)options;
- (void)startSession;
- (void)stopSession;
- (void)logEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata;
@end