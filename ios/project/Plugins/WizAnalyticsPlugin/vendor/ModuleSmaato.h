/* wizAnalytics - Smaato Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleSmaato.h for iOS
 *
 *
 */

#import <Foundation/Foundation.h>

@interface ModuleSmaato : NSObject {
    NSString *_smaatoAPIKey;
}

@property (nonatomic, retain) NSString *smaatoAPIKey;

- (id)initWithOptions:(NSDictionary *)options;
- (void)startTracking;
@end