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
#import <objc/objc-runtime.h>

@interface WizAnalytics ()
@property (nonatomic, retain) NSMutableArray *loadedModules;
@property (nonatomic, retain) WizAnalyticsVendorModule *kontagentModule;
@end

@implementation WizAnalytics

static WizAnalytics *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (WizAnalytics *)sharedInstance {
    if (sharedInstance == nil) {
        NSString *usageMessage = @"WizAnalytics was not launched properly.  The \"launch\" method must be invoked before *any* other plugin method.\n\nDid you forget to call wizAnalytics.launch(options) in JavaScript or [WizAnalyticsPlugin launch:withDict:] in native code before calling any other plugin methods?";
        NSLog(@"%@", usageMessage);
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
        
        WizAnalyticsVendorModule *module;
        
        for ( NSString *key in options ) {
            if ( (![[options valueForKey:key] isEqualToString:@""]) ) {
                NSString *baseName = [[key componentsSeparatedByString:@"Key"] objectAtIndex:0];
                if ( baseName && ![baseName isEqualToString:@"Key"] )
                {
                    // Construct the module and get the class.
                    NSString *moduleName = [NSString stringWithFormat:@"Module%@", baseName];
                    Class moduleClass = NSClassFromString(moduleName);
                    
                    // Allocate the module and load it.
                    module = [((WizAnalyticsVendorModule *)[moduleClass alloc]) initWithOptions:options];
                    if ( module ) {
                        [self.loadedModules addObject:module];
                    } else {
                        // Failed to load module
                        NSArray *vendorModules = ClassGetSubclasses( [WizAnalyticsVendorModule class] );
                        NSLog( @"\nFailed to load WizAnalyticsVendorModule: %@", moduleName );
                        NSLog( @"\nList of available WizAnalyticsVendorModules: %@", vendorModules );
                        NSLog( @"\nDid you forget to link in code containing class: %@ ???", moduleName );
                        NSAssert( NO, @"WizAnalyticsVendorModule %@ not loaded", moduleName );
                    }
                    
                    // Kontagent is special, save a reference to it for later
                    if ( [moduleName isEqualToString:@"ModuleKontagent"] ) {
                        self.kontagentModule = module;
                    }
                }
            }
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
    for ( WizAnalyticsVendorModule *module in [self.loadedModules objectEnumerator] ) {
        [module startSession];
    }
}

- (void)restartAnalyticsSession
{
    for ( WizAnalyticsVendorModule *module in [self.loadedModules objectEnumerator] ) {
        if ( [module respondsToSelector:@selector(resumeSession)] ) {
            [module resumeSession];
        }
    }
}

- (void)pauseAnalyticsSession
{
    for ( WizAnalyticsVendorModule *module in [self.loadedModules objectEnumerator] ) {
        if ( [module respondsToSelector:@selector(pauseSession)] ) {
            [module pauseSession];
        }
    }
}

- (void)endAnalyticsSession
{
    for ( WizAnalyticsVendorModule *module in [self.loadedModules objectEnumerator] ) {
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
    
    for ( WizAnalyticsVendorModule *module in [self.loadedModules objectEnumerator] ) {
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
    for ( WizAnalyticsVendorModule *module in [self.loadedModules objectEnumerator] ) {
        if ( [module respondsToSelector:@selector(logScreen:withExtraMetadata:)] ) {
            [module logScreen:screenName withExtraMetadata:extraMetadata];
        }
    }
}

- (void)handleOpenURL:(NSURL *)url
{
    for ( WizAnalyticsVendorModule *module in [self.loadedModules objectEnumerator] ) {
        if ( [module respondsToSelector:@selector(handleOpenURL:)] ) {
            [module handleOpenURL:url];
        }
    }
}

#pragma - Private Functions

// Get the full list of subclasses for a class and return them in an array.
// http://www.cocoawithlove.com/2010/01/getting-subclasses-of-objective-c-class.html

static NSArray *ClassGetSubclasses(Class parentClass)
{
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    
    classes = malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < numClasses; i++)
    {
        Class superClass = classes[i];
        do
        {
            superClass = class_getSuperclass(superClass);
        } while(superClass && superClass != parentClass);
        
        if (superClass == nil)
        {
            continue;
        }
        
        [result addObject:classes[i]];
    }
    
    free(classes);
    
    return result;
}

@end