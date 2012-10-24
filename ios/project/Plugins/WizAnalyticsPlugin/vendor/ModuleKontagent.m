/* wizAnalytics - Smaato Module
 *
 * @author Ally Ogilvie
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file ModuleKontagent.m for iOS
 *
 *
 */

#import "ModuleKontagent.h"
#import <Kontagent/Kontagent.h>
#import "WizDebugLog.h"

@interface ModuleKontagent ()
@property (nonatomic, retain) NSString *kontagentAPIKey;
@property (nonatomic, retain) NSMutableDictionary *lastLog;
@end

@implementation ModuleKontagent

- (void)dealloc
{
    self.kontagentAPIKey = nil;
    self.lastLog = nil;
    [super dealloc];
}

#pragma mark - Required WizAnalyticsVendorModule protocol methods

- (id)initWithOptions:(NSDictionary *)options
{
    if ((self = [super init])) {
        self.kontagentAPIKey = [options objectForKey:@"KontagentKey"];
    }
    return self;
}

- (void)startSession
{
    WizLog(@"KONTAGENT START TRACKING %@", _kontagentAPIKey);
    
    [Kontagent startSession:_kontagentAPIKey mode:kKontagentSDKMode_PRODUCTION];

    [Kontagent messageSent:@"NEW_SESSION" trackingId:[Kontagent generateUniqueTrackingTag] optionalParams:nil];
    
    // This is also filled in automatically by the library
    [Kontagent sendDeviceInformation:nil];
    
    // Get the main bundle for the app.
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    
    // Get version string
    NSString* ver = [infoDict objectForKey:@"CFBundleVersion"];
    
    // Versioning info for your application
    KTParamMap *paramMap = [[KTParamMap alloc] init];
    [paramMap put:@"v_maj" value:ver];
    [Kontagent sendDeviceInformation:paramMap];
    
    [paramMap release];
}

#pragma mark - Optional WizAnalyticsVendorModule protocol methods

- (void)pauseSession
{
    /*
    WizLog(@"ON BACKGROUND - last log %@", self.lastLog);
    
    // send last event of last log
    for (NSString *key in self.lastLog) {
        
        
        NSDictionary *lastlogParams = [[NSDictionary alloc] initWithObjectsAndKeys:@"str1", @"lastlog", nil];

        KTParamMap *paramMap = [self buildKTParamMap:lastlogParams];
        
        NSDictionary *lastlogData = [[NSDictionary alloc] initWithDictionary:[self.lastLog objectForKey:key]];
        
        NSString *
        
        [Kontagent customEvent:[NSString stringWithFormat:@"LastLog_%@", key] optionalParams:paramMap];
        WizLog(@"KONTAGENT LAST LOG EVENT %@ DATA %@ PARAM MAP %@", [NSString stringWithFormat:@"LastLog_%@", key], [self.lastLog objectForKey:key], paramMap);
        
    }
    */
}

- (void)stopSession
{
    WizLog(@"KONTAGENT STOP SESSION");

    [Kontagent stopSession];
}

- (void)logEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata
{
    WizLog(@"KONTAGENT LOG EVENT %@ DATA %@", eventName, extraMetadata);
        
    NSDictionary *kontagentDict = [extraMetadata objectForKey:@"kontagent"];
    if ( kontagentDict ) {
        
        KTParamMap *paramMap = [self buildKTParamMap:extraMetadata];

        if ( [eventName isEqualToString:@"Purchase"] ) {
            if ( [[kontagentDict objectForKey:@"st1"] isEqualToString:@"Default"] ||
                [[kontagentDict objectForKey:@"st2"] isEqualToString:@"Default"] ||
                [[kontagentDict objectForKey:@"st3"] isEqualToString:@"Default"] ) {
                NSInteger value = [[kontagentDict objectForKey:@"v"] intValue];
                [Kontagent revenueTracking:value optionalParams:paramMap];
            }
        }
        
        [Kontagent customEvent:eventName optionalParams:paramMap];
        
        if (self.lastLog.count > 0) {
            [self.lastLog removeAllObjects];
        }
        self.lastLog = nil;
        NSDictionary *data = [[NSDictionary alloc] initWithDictionary:extraMetadata];
        self.lastLog = [[NSMutableDictionary alloc] initWithObjectsAndKeys:data, eventName, nil];
        
        [data release];
        [paramMap release];
    }
}

#pragma mark - Private methods

- (KTParamMap*)buildKTParamMap:(NSDictionary*)extraMetadata {
    
    KTParamMap *paramMap = [[KTParamMap alloc] init];
    WizLog(@"building param map %@", extraMetadata);
    NSDictionary *kontagentDict = [NSDictionary dictionaryWithDictionary:[extraMetadata objectForKey:@"kontagent"]];
    
    if ([kontagentDict valueForKey:@"st1"]) {
        [paramMap put:@"st1" value:[kontagentDict valueForKey:@"st1"]];
        
        if ([kontagentDict valueForKey:@"st2"]) {
            [paramMap put:@"st2" value:[kontagentDict valueForKey:@"st2"]];
            
            if ([kontagentDict valueForKey:@"st3"]) {
                [paramMap put:@"st3" value:[kontagentDict valueForKey:@"st3"]];
            }
        }
    }
    
    if ([kontagentDict valueForKey:@"l"]) {
        [paramMap put:@"l" value:[[kontagentDict valueForKey:@"l"] stringValue]];
    }
    if ([kontagentDict valueForKey:@"v"]) {
        [paramMap put:@"v" value:[[kontagentDict valueForKey:@"v"] stringValue]];
    }
    
    return paramMap;
}

@end