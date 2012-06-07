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

@implementation ModuleKontagent

@synthesize kontagentAPIKey = _kontagentAPIKey;

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
    // [Kontagent startSession:_kontagentAPIKey mode:kKontagentSDKMode_TEST];
    
    
    [Kontagent messageSent:@"NEW_SESSION" trackingId:[Kontagent generateUniqueTrackingTag] optionalParams:nil];
    //[Kontagent pageRequest:@"adfads" optionalParams:nil];
    // [Kontagent pageRequest:<#(KTParamMap *)#>];
    
}

- (void)stopSession
{
    [Kontagent stopSession];
}


- (void)logEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata
{
    WizLog(@"KONTAGENT LOG EVENT %@ DATA %@", eventName, extraMetadata);
    [Kontagent customEvent:eventName optionalParams:extraMetadata];
    //[Kontagent pageRequest:<#(KTParamMap *)#>];
    //funnel
    
    //[Kontagent revenueTracking:<#(NSInteger)#> optionalParams:<#(KTParamMap *)#>];
    
    //[Kontagent 
}

- (void)dealloc 
{
    self.kontagentAPIKey = nil;
    [super dealloc];
}




@end