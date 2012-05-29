/* wizAnalytics - IOS controller
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file wizAnalytics.h for iOS
 *
 *
 */


#import <Foundation/Foundation.h>


// import modules
#import "ModuleFlurry.h"
#import "ModuleLocalytics.h"



@interface WizAnalytics : NSObject {
    
    
    
    // add modules to interface
    ModuleFlurry    	*_moduleFlurry;  
    ModuleLocalytics    *_moduleLocalytics; 
    
    
    
    
}




// add modules to property
@property (nonatomic, retain) ModuleFlurry      *moduleFlurry;
@property (nonatomic, retain) ModuleLocalytics  *moduleLocalytics;



// init modules
- (id)initWithOptions:(NSDictionary *)options;

- (void)startAnalyticsSession;
- (void)restartAnalyticsSession;
- (void)endAnalyticsSession;
- (void)analyticsEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata;


// Accessor methods
// + (void)analyticsEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata;
+ (id)sharedInstance;

@end