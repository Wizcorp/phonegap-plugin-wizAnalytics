/* AppDelegate - example
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file AppDelegate.h
 *
 */

#import <UIKit/UIKit.h>

#ifdef CORDOVA_FRAMEWORK
    #import <Cordova/CDVViewController.h>
#else
    #import "CDVViewController.h"
#endif

#import "WizAnalytics.h"

@interface AppDelegate : NSObject < UIApplicationDelegate > {
    NSMutableDictionary     *analyticsConfig;
    WizAnalytics            *_wizAnalytics;
}



@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) IBOutlet CDVViewController* viewController;
@property (nonatomic, retain) WizAnalytics          *wizAnalytics;
@property (nonatomic, retain) NSMutableDictionary   *analyticsConfig;

+getAnalyticsConfig;

@end

