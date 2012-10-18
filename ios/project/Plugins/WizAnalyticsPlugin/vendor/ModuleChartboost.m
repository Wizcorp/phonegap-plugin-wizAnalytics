/* wizAnalytics - Chartboost Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleChartboost.m for iOS
 *
 *
 */

#import "ModuleChartboost.h"
#import "Chartboost.h"
#import "WizDebugLog.h"

@interface ModuleChartboost ()
@property (nonatomic, retain) NSString *chartboostKey;
@property (nonatomic, retain) NSString *chartboostSig;
@end

@implementation ModuleChartboost

- (void)dealloc
{
    self.chartboostKey = nil;
    self.chartboostSig = nil;
    [super dealloc];
}

#pragma mark - Required WizAnalyticsVendorModule protocol methods

- (id)initWithOptions:(NSDictionary *)options
{
    if ((self = [super init])) {
        WizLog(@"BOOT Chartboost");
        self.chartboostKey = [options objectForKey:@"ChartboostKey"];
        self.chartboostSig = [options objectForKey:@"ChartboostSig"];
    }
    return self;
}

- (void)startSession
{
    WizLog(@"Chartboost START SESSION %@ %@", _chartboostKey , _chartboostSig);
    
    Chartboost *cb = [Chartboost sharedChartboost];
    cb.appId = _chartboostKey;
    cb.appSignature = _chartboostSig;

    [cb startSession];

    [cb showInterstitial];
}

@end