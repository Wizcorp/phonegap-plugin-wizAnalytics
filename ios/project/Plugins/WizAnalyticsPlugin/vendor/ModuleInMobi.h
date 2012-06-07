/* wizAnalytics - InMobiAdTracker Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleInMobi.h for iOS
 *
 *
 */

#import <Foundation/Foundation.h>

@interface ModuleInMobi : NSObject {
    NSString *_inMobiAPIKey;
}

@property (nonatomic, retain) NSString *inMobiAPIKey;

- (id)initWithOptions:(NSDictionary *)options;
- (void)startSession;
- (void)stopSession;
- (void)handleOpenURL:(NSURL *)url;
@end