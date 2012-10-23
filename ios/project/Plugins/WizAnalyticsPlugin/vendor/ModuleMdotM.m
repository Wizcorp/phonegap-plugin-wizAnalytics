/* wizAnalytics - MdotM Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleMdotM.m for iOS
 *
 *
 */

#import "ModuleMdotM.h"
#import "WizDebugLog.h"
#import "ODIN.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface ModuleMdotM ()
@property (nonatomic, retain) NSString *mdotmKey;
@property (nonatomic, retain) NSString *mdotmLogin;
@end

@implementation ModuleMdotM

- (void)dealloc
{
    self.mdotmKey = nil;
    self.mdotmLogin = nil;
    [super dealloc];
}

#pragma mark - Required WizAnalyticsVendorModule protocol methods

- (id)initWithOptions:(NSDictionary *)options
{
    if ((self = [super init])) {
        WizLog(@"BOOT MdotM");
        self.mdotmKey = [options objectForKey:@"MdotMKey"];
        self.mdotmLogin = [options objectForKey:@"MdotMLogin"];
    }
    return self;
}

- (void)startSession
{
    WizLog(@"MdotM START TRACKING %@ %@", _mdotmKey , _mdotmLogin);
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
    NSString *odin = ODIN1();
    NSString *IFA;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0.0")) {
        IFA = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        IFA = [[UIDevice currentDevice] uniqueIdentifier];
    }
    
    NSString *appOpenEndpoint = [NSString stringWithFormat:@"http://ads.mdotm.com/ads/trackback.php?advid=%@&deviceid=%@&odin=%@&IFA=%@&appid=%@", _mdotmLogin,  [[UIDevice currentDevice] uniqueIdentifier],  odin, IFA, _mdotmKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:appOpenEndpoint]];
    NSURLResponse *response;
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [pool release];
}

@end