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

@implementation ModuleSmaato

@synthesize smaatoAPIKey = _smaatoAPIKey;

- (id)initWithOptions:(NSDictionary *)options
{
    if ((self = [super init])) {
        // self.smaatoAPIKey = [options objectForKey:@"SmaatoKey"];
    }
    return self;
}


- (void)startTracking
{
    NSLog(@"SMAATO START TRACKING");
    SOMADownloadTrack *track = [[SOMADownloadTrack alloc] init];
    [track sendPingToSOMAServer];
    [track release];
}

- (void)dealloc 
{
    // self.smaatoAPIKey = nil;
    [super dealloc];
}




@end