/* wizAnalytics - IOS controller
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file wizAnalytics.m for iOS
 *
 *
 */

#import "WizAnalytics.h"
#import "WizAnalyticsVendorModule.h"
#import "WizDebugLog.h"
#import "ModuleKontagent.h"
#import "ModuleFlurry.h"
#import "ModuleLocalytics.h"
#import "ModuleAdmob.h"
#import "ModuleInMobi.h"
#import "ModuleMillenium.h"
#import "ModuleSmaato.h"
#import "ModuleAdfonic.h"
#import "ModuleChartboost.h"
#import "ModuleJumpTap.h"
#import "ModuleLeadbolt.h"
#import "ModuleMdotM.h"

@interface WizAnalytics ()
@property (nonatomic, retain) NSMutableArray *loadedModules;
@property (nonatomic, retain) NSObject <WizAnalyticsVendorModule> *kontagentModule;
@end

@implementation WizAnalytics

static WizAnalytics *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (WizAnalytics *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[WizAnalytics alloc] init];
    }
    return sharedInstance;
}

// Get the shared instance and create it using options if necessary.
+ (WizAnalytics *)sharedInstance:(NSDictionary*)options {
    if (sharedInstance == nil) {
        sharedInstance = [[WizAnalytics alloc] initWithOptions:options];
    }
    return sharedInstance;
}

// house keeping
- (void)dealloc
{
    self.loadedModules = nil;
    self.kontagentModule = nil;
    
    [super dealloc];
}

- (id)init
{
    NSAssert(NO, @"Allocating an instance of singleton class not permitted.  Use [WizAnalytics sharedIntance:] instead.");
    return nil;
}

- (id)initWithOptions:(NSDictionary*)options
{
    if ((self = [super init])) {
        WizLog(@"Analytics config %@", options);
        
        self.loadedModules = [[NSMutableArray alloc] initWithCapacity:[options count]];
        
        NSObject <WizAnalyticsVendorModule> *module;
        
        // Load the specified modules.
        if ( ([options valueForKey:@"KontagentKey"]) && (![[options valueForKey:@"KontagentKey"] isEqualToString:@""]) ) {
            module = [[ModuleKontagent alloc] initWithOptions:options];
            [self.loadedModules addObject:module];
            self.kontagentModule = module;
        }
        
        if ( ([options valueForKey:@"FlurryKey"]) && (![[options valueForKey:@"FlurryKey"] isEqualToString:@""]) ) {
            module = [[ModuleFlurry alloc] initWithOptions:options];
            [self.loadedModules addObject:module];
        }
        
        if ( ([options valueForKey:@"LocalyticsKey"]) && (![[options valueForKey:@"LocalyticsKey"] isEqualToString:@""]) ) {
            module = [[ModuleLocalytics alloc] initWithOptions:options];
            [self.loadedModules addObject:module];
        }
        
        if ( ([options valueForKey:@"AdmobKey"]) && (![[options valueForKey:@"AdmobKey"] isEqualToString:@""]) ) {
            module = [[ModuleAdmob alloc] initWithOptions:options];
            [self.loadedModules addObject:module];
        }
        
        if ( ([options valueForKey:@"InMobiKey"]) && (![[options valueForKey:@"InMobiKey"] isEqualToString:@""]) ) {
            module = [[ModuleInMobi alloc] initWithOptions:options];
            [self.loadedModules addObject:module];
        }
        
        if ( ([options valueForKey:@"MilleniumKey"]) && (![[options valueForKey:@"MilleniumKey"] isEqualToString:@""]) ) {
            module = [[ModuleMillenium alloc] initWithOptions:options];
            [self.loadedModules addObject:module];
        }
        
        if ( ([options valueForKey:@"SmaatoKey"]) && (![[options valueForKey:@"SmaatoKey"] isEqualToString:@""]) ) {
            [self.loadedModules addObject:module];
        }
        
        if ( ([options valueForKey:@"AdfonicKey"]) && (![[options valueForKey:@"AdfonicKey"] isEqualToString:@""]) ) {
            module = [[ModuleAdfonic alloc] initWithOptions:options];
            [self.loadedModules addObject:module];
        }
        
        if ( ([options valueForKey:@"ChartboostKey"]) && (![[options valueForKey:@"ChartboostKey"] isEqualToString:@""]) ) {
            module = [[ModuleChartboost alloc] initWithOptions:options];
            [self.loadedModules addObject:module];
        }
        
        if ( ([options valueForKey:@"JumpTapKey"]) && (![[options valueForKey:@"JumpTapKey"] isEqualToString:@""]) ) {
            WizLog(@"jump tap works");
            module = [[ModuleJumpTap alloc] initWithOptions:options];
            [self.loadedModules addObject:module];
        }

        if ( ([options valueForKey:@"LeadboltKey"]) && (![[options valueForKey:@"LeadboltKey"] isEqualToString:@""]) ) {
            module = [[ModuleLeadbolt alloc] initWithOptions:options];
            [self.loadedModules addObject:module];
        }
        
        if ( ([options valueForKey:@"MdotMKey"]) && (![[options valueForKey:@"MdotMKey"] isEqualToString:@""]) ) {
            module = [[ModuleMdotM alloc] initWithOptions:options];
            [self.loadedModules addObject:module];
        }
    }

    return self;
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

- (void)startAnalyticsSession
{
    for ( id <WizAnalyticsVendorModule> module in [self.loadedModules objectEnumerator] ) {
        [module startSession];
    }
}

- (void)restartAnalyticsSession
{
    for ( NSObject <WizAnalyticsVendorModule> *module in [self.loadedModules objectEnumerator] ) {
        if ( [module respondsToSelector:@selector(resumeSession)] ) {
            [module resumeSession];
        }
    }
}

- (void)pauseAnalyticsSession
{
    for ( NSObject <WizAnalyticsVendorModule> *module in [self.loadedModules objectEnumerator] ) {
        if ( [module respondsToSelector:@selector(pauseSession)] ) {
            [module pauseSession];
        }
    }
}

- (void)endAnalyticsSession
{
    for ( NSObject <WizAnalyticsVendorModule> *module in [self.loadedModules objectEnumerator] ) {
        if ( [module respondsToSelector:@selector(stopSession)] ) {
            [module stopSession];
        }
    }
}

- (void)analyticsEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata {

    NSMutableDictionary *dataForLogging = [[NSMutableDictionary alloc] initWithDictionary:extraMetadata];
    
    // Log kontagent module event before others
    if ( self.kontagentModule ) {
        [self.kontagentModule logEvent:eventName withExtraMetadata:dataForLogging];
    }

    if ([dataForLogging objectForKey:@"kontagent"]) {
        // remove this data before other SDKs log it
        [dataForLogging removeObjectForKey:@"kontagent"];
    }
    
    for ( NSObject <WizAnalyticsVendorModule> *module in [self.loadedModules objectEnumerator] ) {
        if ( [module respondsToSelector:@selector(logEvent:withExtraMetadata:)] ) {
            // Skip kontagent as it has already been logged
            if ( ![module isEqual:self.kontagentModule] ) {
                [module logEvent:eventName withExtraMetadata:dataForLogging];
            }
        }
    }
    
    [dataForLogging release];
}

- (void)analyticsScreenEvent:(NSString *)screenName withExtraMetadata:(NSDictionary *)extraMetadata
{
    for ( NSObject <WizAnalyticsVendorModule> *module in [self.loadedModules objectEnumerator] ) {
        if ( [module respondsToSelector:@selector(logScreen:withExtraMetadata:)] ) {
            [module logScreen:screenName withExtraMetadata:extraMetadata];
        }
    }
}

- (void)handleOpenURL:(NSURL *)url
{
    for ( NSObject <WizAnalyticsVendorModule> *module in [self.loadedModules objectEnumerator] ) {
        if ( [module respondsToSelector:@selector(handleOpenURL:)] ) {
            [module handleOpenURL:url];
        }
    }
}

@end