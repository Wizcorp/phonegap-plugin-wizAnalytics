/* wizAnalytics - IOS controller
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file wizAnalytics.m for iOS
 *
 *
 */

#import "WizAnalytics.h"
#import "WizDebugLog.h"


@implementation WizAnalytics

// synthesize modules
@synthesize moduleKontagent     = _ModuleKontagent;
@synthesize moduleFlurry        = _ModuleFlurry;
@synthesize moduleLocalytics    = _ModuleLocalytics;
@synthesize moduleAdmob         = _ModuleAdmob;
@synthesize moduleInMobi        = _ModuleInMobi;
@synthesize moduleMillenium     = _ModuleMillenium;
@synthesize moduleSmaato        = _ModuleSmaato;


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
        
        WizLog(@"Analytics config %@", options);
        if ([options valueForKey:@"KontagentKey"]) {
            _ModuleKontagent = [[ModuleKontagent alloc] initWithOptions:options];
        } else {
            _ModuleKontagent = nil;
        }
        if ([options valueForKey:@"FlurryKey"]) {
            WizLog(@"yes");
            _ModuleFlurry = [[ModuleFlurry alloc] initWithOptions:options];
        } else {
            _ModuleFlurry = nil;
        }
        if ([options valueForKey:@"LocalyticsKey"]) {
            _ModuleLocalytics = [[ModuleLocalytics alloc] initWithOptions:options];
        } else {
            _ModuleLocalytics = nil;
        }
        if ([options valueForKey:@"AdmobKey"]) {
            _ModuleAdmob = [[ModuleAdmob alloc] initWithOptions:options];
        } else {
            _ModuleAdmob = nil;
        }
        if ([options valueForKey:@"InMobiKey"]) {
            _ModuleInMobi = [[ModuleInMobi alloc] initWithOptions:options];
        } else {
            _ModuleInMobi = nil;
        }
        if ([options valueForKey:@"MilleniumKey"]) {
            _ModuleMillenium = [[ModuleMillenium alloc] initWithOptions:options];
        } else {
            _ModuleMillenium = nil;
        }
        if ([options valueForKey:@"SmaatoKey"]) {
            _ModuleSmaato = [[ModuleSmaato alloc] initWithOptions:options];
        } else {
            _ModuleSmaato = nil;
        }
        
        
        
        
        
    }    


    return self;
}

// house keeping
- (void)dealloc
{
    
    
    
    
    self.moduleKontagent = nil;
    self.moduleFlurry = nil;
    self.moduleLocalytics = nil;
    self.moduleAdmob = nil;
    self.moduleInMobi = nil;
    self.moduleMillenium = nil;
    self.moduleSmaato = nil;
    
    
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
 * Session Events add/remove as needed
 */

- (void)startAnalyticsSession {
    
    [_ModuleKontagent startSession];
    [_ModuleFlurry startSession];
    [_ModuleLocalytics startSession];
    [_ModuleAdmob startSession];
    [_ModuleInMobi startSession];
    [_ModuleSmaato startTracking]; 
    
    
}

- (void)restartAnalyticsSession {
    
    [_ModuleLocalytics resumeSession];
    
}

- (void)endAnalyticsSession {
    
    [_ModuleLocalytics stopSession];
    [_ModuleInMobi stopSession];
    [_ModuleKontagent stopSession];
    
}

- (void)analyticsEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata {
    
    [_ModuleLocalytics logEvent:eventName withExtraMetadata:extraMetadata];
    [_ModuleFlurry logEvent:eventName withExtraMetadata:extraMetadata];
    [_ModuleKontagent logEvent:eventName withExtraMetadata:extraMetadata];
}

- (void)handleOpenURL:(NSURL *)url
{
    [_ModuleMillenium handleOpenURL:url];
    [_ModuleInMobi handleOpenURL:url];
}

@end