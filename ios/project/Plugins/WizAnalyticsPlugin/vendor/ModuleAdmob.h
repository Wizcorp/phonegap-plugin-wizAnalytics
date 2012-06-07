/* wizAnalytics - Admob Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleAdmob.h for iOS
 *
 *
 */

#import <Foundation/Foundation.h>

@interface ModuleAdmob : NSObject {
    NSString *_admobAPIKey;
}

@property (nonatomic, retain) NSString *admobAPIKey;

- (id)initWithOptions:(NSDictionary *)options;
- (void)startSession;
@end