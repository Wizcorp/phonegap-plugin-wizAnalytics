/* wizAnalytics - Smaato Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleSmaato.m for iOS
 *
 *
 */

#import "ModuleSmaato.h"
#import "SOMADownloadTrack.h" 
#import "OpenUDID.h" 
#import "ODIN.h"

@interface ModuleSmaato ()
//@property (nonatomic, retain) NSString *smaatoAPIKey;
@end

@implementation ModuleSmaato

- (void)dealloc
{
    // self.smaatoAPIKey = nil;
    [super dealloc];
}

#pragma mark - Required WizAnalyticsVendorModule protocol methods

- (id)initWithOptions:(NSDictionary *)options
{
    if ((self = [super init])) {
        // self.smaatoAPIKey = [options objectForKey:@"SmaatoKey"];
    }
    return self;
}

- (void)startSession
{
    NSLog(@"SMAATO START TRACKING");
    SOMADownloadTrack *track = [[SOMADownloadTrack alloc] init];
    [track sendPingToSOMAServer];
    [track release];
}

@end