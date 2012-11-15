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
#import <objc/runtime.h>

@interface WizAnalytics ()
@property (nonatomic, retain) NSMutableArray *loadedModules;
@property (nonatomic, retain) NSObject <WizAnalyticsVendorModule> *kontagentModule;
+ (void)load;
- (void)startAnalyticsSession;
- (void)restartAnalyticsSession;
- (void)pauseAnalyticsSession;
- (void)endAnalyticsSession;
- (void)willTerminate:(NSNotification *)notification;
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

#pragma - Class Methods

+ (void)load
{
    // Create the singleton and start session when this class is added to the run-time.
    [[WizAnalytics sharedInstance] startAnalyticsSession];
}

#pragma - Instance Methods

// house keeping
- (void)dealloc
{
    [[WizAnalytics sharedInstance] endAnalyticsSession];
    
    // Stop the instance from observing all notification center notifications.
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    self.loadedModules = nil;
    self.kontagentModule = nil;

    [super dealloc];
}

- (void)willTerminate:(NSNotification *)notification
{
    [[WizAnalytics sharedInstance] endAnalyticsSession];
    
    // Stop the instance from observing all notification center notifications.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    if ( sharedInstance != nil ) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"[%@ %@] cannot be called; use +[%@ %@] instead",
         NSStringFromClass([self class]), NSStringFromSelector(_cmd),
         NSStringFromClass([self class]), NSStringFromSelector(@selector(sharedInstance))];
    } else if ((self = [super init])) {
        // Get options from the wizAnalytics.plist (in the application bundle)
        NSString *path = [[NSBundle mainBundle] pathForResource:@"wizAnalytics" ofType:@"plist"];
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        
        if ( options == nil ) {
            [NSException raise:NSInternalInconsistencyException
                        format:@"Missing wizAnalytics.plist -- required when using the wizAnalytics plugin.  Please add it to your application bundle."];
        }

        WizLog(@"Analytics config %@", options);
        
        self.loadedModules = [[NSMutableArray alloc] initWithCapacity:[options count]];
        
        NSObject <WizAnalyticsVendorModule> *module;
        
        for ( NSString *key in options ) {
            if ( (![[options valueForKey:key] isEqualToString:@""]) ) {
                // Determine if the key string ends with the substring "Key"
                // If so, determine the basename to use when constructing the module name.
                NSString *baseName = nil;
                NSRange range = NSMakeRange([key length]-3, 3);
                if ( [[key substringWithRange:range] isEqualToString:@"Key"] ) {
                    baseName = [key substringToIndex:[key length]-3];
                }

                if ( baseName && ![baseName isEqualToString:@""] )
                {
                    // Construct the module and get the class.
                    NSString *moduleName = [NSString stringWithFormat:@"Module%@", baseName];
                    Class moduleClass = NSClassFromString(moduleName);
                    
                    // Allocate the module and load it.
                    module = [((NSObject <WizAnalyticsVendorModule> *)[moduleClass alloc]) initWithOptions:options];
                    if ( module ) {
                        [self.loadedModules addObject:module];
                    } else {
                        // Failed to load module so find and print all loaded modules.
                        NSArray *vendorModules = ProtocolGetClasses( "WizAnalyticsVendorModule" );
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
        
        // Register the instance to observe didEnterBackground notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pauseAnalyticsSession)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    
        // Register the instance to observe didBecomeActive notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(restartAnalyticsSession)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
                
        // Register for willTerminate notifications here so that we can observer terminate
        // events and end the session.  This isn't strictly required (and may not be called
        // according to the docs).
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(willTerminate:)
                                                     name:UIApplicationWillTerminateNotification
                                                   object:nil];
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
    for ( NSObject <WizAnalyticsVendorModule> *module in [self.loadedModules objectEnumerator] ) {
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

#pragma - Private Functions

// Get the full list of classes that conform to a protocol.
// Derived from the notes on this page:
// http://www.cocoawithlove.com/2010/01/getting-subclasses-of-objective-c-class.html

static NSArray *ProtocolGetClasses(char *protocolName)
{
    // Get count of number of classes definitions registered with Objective-C runtime.
    int numClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
    
    // Get all classes definitions registered with Objective-C runtime.
    classes = malloc(sizeof(Class) * numClasses);
    numClasses = objc_getClassList(classes, numClasses);
    
    // Results array.
    NSMutableArray *result = [NSMutableArray array];
    
    // Get the protocol by name.
    Protocol *protocol = objc_getProtocol(protocolName);
    if ( !protocol ) {
        return result;
    }
    
    // Check if each class conforms to the protocol, if so add to the array list.
    for (NSInteger i = 0; i < numClasses; i++)
    {
        if ( class_conformsToProtocol(classes[i], protocol) ) {
            [result addObject:classes[i]];
        }
    }
    
    free(classes);
    
    return result;
}

@end