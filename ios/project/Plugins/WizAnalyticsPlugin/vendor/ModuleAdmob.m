/* wizAnalytics - Admob Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleAdmob.m for iOS
 *
 *
 */

#import "ModuleAdmob.h"
#import <CommonCrypto/CommonDigest.h>
#import <AdSupport/AdSupport.h>

@interface ModuleAdmob ()
@property (nonatomic, retain) NSString *admobAPIKey;
@end

@implementation ModuleAdmob

- (void)dealloc
{
    self.admobAPIKey = nil;
    [super dealloc];
}

#pragma mark - Required WizAnalyticsVendorModule protocol methods

- (id)initWithOptions:(NSDictionary *)options
{
    if ((self = [super init])) {
        self.admobAPIKey = [options objectForKey:@"AdmobKey"];
    }
    return self;
}

- (void)startSession 
{
    NSLog(@"ADMOB START SESSION %@", _admobAPIKey);
    
    [self performSelectorInBackground:@selector(reportAppOpenToAdMob) withObject:nil];
    
}

#pragma mark - Private methods

- (void)reportAppOpenToAdMob {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; // we're in a new thread here, so we need our own autorelease pool
    // Have we already reported an app open?
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                        NSUserDomainMask, YES) objectAtIndex:0];
    NSString *appOpenPath = [documentsDirectory stringByAppendingPathComponent:@"admob_app_open"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:appOpenPath]) {
        // Not yet reported -- report now
        NSString *appOpenEndpoint = [NSString stringWithFormat:@"http://a.admob.com/f0?isu=%@&md5=1&site_id=%@",
                                     [self hashedISU], self.admobAPIKey];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:appOpenEndpoint]];
        NSURLResponse *response;
        NSError *error = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if((!error) && ([(NSHTTPURLResponse *)response statusCode] == 200) && ([responseData length] > 0)) {
            [fileManager createFileAtPath:appOpenPath contents:nil attributes:nil]; // successful report, mark it as such
            NSLog(@"App download successfully reported.");
        } else {
            NSLog(@"WARNING: App download not successfully reported. %@", [NSString stringWithUTF8String:[responseData bytes]]);
        }
    }
    [pool release];
}


- (NSString *)hashedISU {
    NSString *result = @"";
    NSString *isu = nil;
    
    if ( [ASIdentifierManager respondsToSelector:@selector(sharedManager)] ) {
        ASIdentifierManager *identifierManager = [ASIdentifierManager sharedManager];
        isu = [[identifierManager advertisingIdentifier] UUIDString];
    }
    
    if(isu) {
        unsigned char digest[16];
        NSData *data = [isu dataUsingEncoding:NSASCIIStringEncoding];
        CC_MD5([data bytes], [data length], digest);
        
        result = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                  digest[0], digest[1], 
                  digest[2], digest[3],
                  digest[4], digest[5],
                  digest[6], digest[7],
                  digest[8], digest[9],
                  digest[10], digest[11],
                  digest[12], digest[13],
                  digest[14], digest[15]];
        result = [result uppercaseString];
    }
    return result;
}



@end