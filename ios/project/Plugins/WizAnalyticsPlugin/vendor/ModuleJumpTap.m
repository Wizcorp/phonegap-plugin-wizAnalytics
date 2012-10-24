/* wizAnalytics - JumpTap Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleJumpTap.m for iOS
 *
 *
 */

#import "JumpTapAppReport.h"
#import "ModuleJumpTap.h"
#import "WizDebugLog.h"

@interface ModuleJumpTap ()
@property (nonatomic, retain) NSString *jumpTapKey;
@end

@implementation ModuleJumpTap

- (void)dealloc {
    self.jumpTapKey = nil;
    [super dealloc];
}

#pragma mark - Required WizAnalyticsVendorModule protocol methods

- (id)initWithOptions:(NSDictionary *)options
{
    if ((self = [super init])) {
        WizLog(@"BOOT JumpTap");
        self.jumpTapKey = [options objectForKey:@"JumpTapKey"];
    }
    return self;
}

- (void)startSession
{
    NSLog(@"JUMPTAP START TRACKING");
    [JumpTapAppReport submitReportWithExtraInfo: [NSDictionary dictionaryWithObjectsAndKeys:
                                                  @"download", @"event",    // the revenue from the purchase
                                                  nil]
     ];
}

#pragma mark - Optional WizAnalyticsVendorModule protocol methods

- (void)handleOpenURL:(NSURL *)url
{
    // Track conversion
    [JumpTapAppReport handleApplicationLaunchUrl:url];
}

@end