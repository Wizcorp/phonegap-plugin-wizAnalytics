/* wizAnalytics - IOS controller
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file wizAnalytics.m for iOS
 *
 *
 */

#import "WizAnalytics.h"


@implementation WizAnalytics

// synthesize modules
@synthesize moduleFlurry        = _ModuleFlurry;
@synthesize moduleLocalytics    = _ModuleLocalytics;



static WizAnalytics *sharedInstance = nil;
// Get the shared instance and create it if necessary.
+ (WizAnalytics *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    return sharedInstance;
}


- (id)initWithOptions:(NSDictionary*)options
{

    if ((self = [super init])) {
        
        /*
         * add modules here
         *
         */
        
        NSLog(@"options here %@", options);
        _ModuleFlurry = [[ModuleFlurry alloc] initWithOptions:options];
        _ModuleLocalytics = [[ModuleLocalytics alloc] initWithOptions:options];
        
        
    }    


    return self;
}

// house keeping
- (void)dealloc
{
    
    
    
    
    
    self.moduleFlurry = nil;
    self.moduleLocalytics = nil;
    
    
    
    [super dealloc];
}

// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}
// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
// Once again - do nothing, as we don't have a retain counter for this object.
- (id)retain {
    return self;
}
// Replace the retain counter so we can never release this object.
- (NSUInteger)retainCount {
    return NSUIntegerMax;
}
// This function is empty, as we don't want to let the user release this object.
- (oneway void)release {
    
}
//Do nothing, other than return the shared instance - as this is expected from autorelease.
- (id)autorelease {
    return self;
}





/*
 * Accessor methods
 * 
 */
+ (void)analyticsEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata
{
    
    NSLog(@"do something %@ - extraMetadata %@", eventName, extraMetadata);

}




/*
 * Session Events add/remove as needed
 */

- (void)startAnalyticsSession {
    
    [_ModuleFlurry startSession];
    [_ModuleLocalytics startSession];
    
}

- (void)restartAnalyticsSession {
    
    [_ModuleLocalytics resumeSession];
    
}

- (void)endAnalyticsSession {
    
    [_ModuleLocalytics stopSession];
    
}

- (void)analyticsEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata {
    
    [_ModuleLocalytics logEvent:eventName withExtraMetadata:extraMetadata];
    [_ModuleFlurry logEvent:eventName withExtraMetadata:extraMetadata];
}


@end