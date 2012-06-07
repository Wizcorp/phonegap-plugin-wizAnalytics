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
#import "ModuleKontagent.h"
#import "ModuleFlurry.h"
#import "ModuleLocalytics.h"
#import "ModuleAdmob.h"
#import "ModuleInMobi.h"
#import "ModuleMillenium.h"
#import "ModuleSmaato.h"


@interface WizAnalytics : NSObject {
    
    
    
    // add modules to interface
    ModuleKontagent     *_moduleKontagent;
    ModuleFlurry    	*_moduleFlurry;  
    ModuleLocalytics    *_moduleLocalytics; 
    ModuleAdmob         *_moduleAdmob; 
    ModuleInMobi        *_moduleInMobi; 
    ModuleMillenium     *_moduleMillenium; 
    ModuleSmaato        *_moduleSmaato; 
    
    
    
}




// add modules to property
@property (nonatomic, retain) ModuleKontagent   *moduleKontagent;
@property (nonatomic, retain) ModuleFlurry      *moduleFlurry;
@property (nonatomic, retain) ModuleLocalytics  *moduleLocalytics;
@property (nonatomic, retain) ModuleAdmob       *moduleAdmob;
@property (nonatomic, retain) ModuleInMobi      *moduleInMobi;
@property (nonatomic, retain) ModuleMillenium   *moduleMillenium;
@property (nonatomic, retain) ModuleSmaato      *moduleSmaato;





// init modules
- (id)initWithOptions:(NSDictionary *)options;

- (void)startAnalyticsSession;
- (void)restartAnalyticsSession;
- (void)endAnalyticsSession;
- (void)analyticsEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata;
- (void)handleOpenURL:(NSURL *)url;


// Accessor methods
+ (id)sharedInstance;

@end