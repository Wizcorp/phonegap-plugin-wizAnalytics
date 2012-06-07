/* wizAnalytics - Millenium Media Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleMillenium.h for iOS
 *
 *
 */

#import <Foundation/Foundation.h>

@interface ModuleMillenium : NSObject {
    NSString *_milleniumAPIKey;
}

@property (nonatomic, retain) NSString *milleniumAPIKey;

- (id)initWithOptions:(NSDictionary *)options;
- (void)handleOpenURL:(NSURL *)url;
@end