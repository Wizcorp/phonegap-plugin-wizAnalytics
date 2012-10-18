/* wizAnalytics - Leadbolt Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleLeadbolt.m for iOS
 *
 *
 */

#import "ModuleLeadbolt.h"
#import "WizDebugLog.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface ModuleLeadbolt ()
@property (nonatomic, retain) NSString *leadboltKey;
@property (nonatomic, retain) NSString *leadboltAdId;
@property (nonatomic, retain) NSString *leadboltGroup;
@end

@implementation ModuleLeadbolt

- (void)dealloc
{
    self.leadboltKey = nil;
    self.leadboltAdId = nil;
    self.leadboltGroup = nil;
    [super dealloc];
}

#pragma mark - Required WizAnalyticsVendorModule protocol methods

- (id)initWithOptions:(NSDictionary *)options
{
    if ((self = [super init])) {
        WizLog(@"BOOT Leadbolt");
        self.leadboltKey = [options objectForKey:@"LeadboltKey"];
        self.leadboltAdId = [options objectForKey:@"LeadboltAdId"];
        self.leadboltGroup = [options objectForKey:@"LeadboltGroup"];
    }
    return self;
}

- (void)startSession
{
    WizLog(@"Leadbolt START TRACKING %@ %@ %@", _leadboltKey , _leadboltAdId, _leadboltGroup);
    
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
    NSString *ip = [self getIPAddress];
    NSString *appOpenEndpoint = [NSString stringWithFormat:@"http://ad.leadbolt.net/conv?advertiser_id=%@&key=%@&client_ip=%@&pf=1&dev_id=%@&group=%@", _leadboltAdId, _leadboltKey, ip, [[UIDevice currentDevice] uniqueIdentifier], _leadboltGroup ];
    
    WizLog(@"Leadbolt endpoint %@", appOpenEndpoint);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:appOpenEndpoint]];
    [request setHTTPMethod:@"POST"];
    
    NSURLResponse *response;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *string = [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
    WizLog(@"Leadbolt responseData: %@", string);
    
    
    [pool release];

    
}

#pragma mark - Private methods

// Get IP Address
- (NSString *)getIPAddress {    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];               
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

@end