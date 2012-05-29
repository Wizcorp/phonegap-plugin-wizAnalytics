/* wizAnalytics - Flurry Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleFlurry.h for iOS
 *
 *
 */

#import <Foundation/Foundation.h>

@interface ModuleFlurry : NSObject {
    NSString *_flurryAPIKey;
}

@property (nonatomic, retain) NSString *flurryAPIKey;

- (id)initWithOptions:(NSDictionary *)options;
- (void)startSession;
- (void)logEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata;
@end