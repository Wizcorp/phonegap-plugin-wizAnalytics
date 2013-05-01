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
#import <AdSupport/AdSupport.h>

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
    NSString *eventID = @"startSession";
    NSString *odin = ODIN1();
    NSString *usertoken;
    if ( [[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)] ) {
        usertoken = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    } else {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        usertoken = [(NSString *)string autorelease];
    }
    NSString *aid = @"";
    NSString *ate = @"0";
    if ( [ASIdentifierManager respondsToSelector:@selector(sharedManager)] ) {
        ASIdentifierManager *identifierManager = [ASIdentifierManager sharedManager];
        aid = [[identifierManager advertisingIdentifier] UUIDString];
        ate = [identifierManager isAdvertisingTrackingEnabled] ? @"1" : @"0";
    }
    NSString *appOpenEndpoint = [NSString stringWithFormat:@"http://ads.mdotm.com/ads/trackback.php?advid=%@&odin=%@&aid=%@&ate=%@&usertoken=%@&appid=%@&eventID=%@", _mdotmLogin, odin, aid, ate, usertoken, _mdotmKey, eventID];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:appOpenEndpoint]];
    NSURLResponse *response;
    NSError *error = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    [pool release];
}

@end