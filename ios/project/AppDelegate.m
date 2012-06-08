/* AppDelegate - example
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file AppDelegate.m
 *
 */

#define TESTANALYTICSMODE 1

#import "AppDelegate.h"
#import "MainViewController.h"

#ifdef CORDOVA_FRAMEWORK
    #import <Cordova/CDVPlugin.h>
    #import <Cordova/CDVURLProtocol.h>
#else
    #import "CDVPlugin.h"
    #import "CDVURLProtocol.h"
#endif


@implementation AppDelegate

@synthesize window, viewController;
@synthesize analyticsConfig;



+ (NSMutableDictionary*)getAnalyticsConfig
{
    // Path to the plist (in the application bundle)
    NSString *path;
        
    if (TESTANALYTICSMODE == 0) {
        // production mode
        path = [[NSBundle mainBundle] pathForResource:
                          @"p_analyticsConfig" ofType:@"plist"];
        NSLog(@"--------- --------- ANALYTICS LIVE MODE --------- --------- ");
    } else {
        path = [[NSBundle mainBundle] pathForResource:
                          @"d_analyticsConfig" ofType:@"plist"];
        NSLog(@"--------- --------- ANALYTICS TEST MODE --------- --------- ");
    }
    
    
    // Build dictionary from the plist  
    NSMutableDictionary *analyticsConfig = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    return analyticsConfig;
}


/**
 * This is main kick off after the app inits, the views and Settings are setup here. (preferred - iOS4 and up)
 */
- (BOOL) application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{    
    
    /*
     * Boot Wizard Analytics
     */
    NSMutableDictionary *analConfig = [AppDelegate getAnalyticsConfig];
    _wizAnalytics = [[WizAnalytics alloc] initWithOptions:analConfig]; //lol...
    [_wizAnalytics startAnalyticsSession];
    
    return YES;
}

// this happens while we are running ( in the background, or from within our own app )
// only valid if GGPtest-Info.plist specifies a protocol to handle
- (BOOL) application:(UIApplication*)application handleOpenURL:(NSURL*)url 
{
    if (!url) { 
        return NO; 
    }
    
    
    // send to any Analytics that might need this
    [_wizAnalytics handleOpenURL:url];
    
    return YES;   
}


- (void)applicationDidTerminate:(UIApplication *)application
{
    [_wizAnalytics endAnalyticsSession];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [_wizAnalytics restartAnalyticsSession];
}



- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    [_wizAnalytics endAnalyticsSession];
    
}


- (void) dealloc
{
	[super dealloc];
}

@end
