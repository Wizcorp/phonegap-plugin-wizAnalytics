/* wizAnalytics - Adfonic Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleAdfonic.m for iOS
 *
 *
 */

#import "ModuleAdfonic.h"
#import "WizDebugLog.h"

@interface ModuleAdfonic ()
@property (nonatomic, retain) NSString *adfonicAPIKey;
@property (nonatomic, retain) NSString *appId;
@end

@implementation ModuleAdfonic

- (void)dealloc
{
    self.adfonicAPIKey = nil;
    [super dealloc];
}

#pragma mark - Required WizAnalyticsVendorModule protocol methods

- (id)initWithOptions:(NSDictionary *)options
{
    if ((self = [super init])) {
        WizLog(@"BOOT Adfonic");
        self.adfonicAPIKey = [options objectForKey:@"AdfonicKey"];
        self.appId = [options objectForKey:@"appId"];
    }
    return self;
}


- (void)startSession
{
    NSLog(@"ADFONIC START TRACKING %@", self.adfonicAPIKey);
    [self performSelectorInBackground:@selector(adfonicInstallTracking) withObject:nil];

}

#pragma mark - Private methods

-(void)adfonicInstallTracking {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *key = [NSString stringWithFormat:@"%@_AdfonicInstall", 
                     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
	if ([defaults boolForKey:key] == NO) {
		NSString* url = [NSString stringWithFormat:@"http://tracker.adfonic.net/is/%@/%@",
						 _appId, [[UIDevice currentDevice] uniqueIdentifier]];
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
		NSURLResponse *urlResponse;
		NSError *error;
		[NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
		int code = (urlResponse ? [(NSHTTPURLResponse *)urlResponse statusCode] : -1);
		if (!error && (code == 200)) {
			[defaults setBool:YES forKey:key];	
		}
	}	
	[pool release];
}

@end