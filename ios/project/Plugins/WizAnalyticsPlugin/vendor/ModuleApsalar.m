//
//  ModuleApsalar.m
//  exampleWizAnalytics
//
//  Created by Chris Wynn on 3/4/13.
//  Copyright (c) 2013 Wizcorp. All rights reserved.
//

#import "ModuleApsalar.h"
#import "Apsalar.h"
#import "WizDebugLog.h"

@interface ModuleApsalar ()
@property (nonatomic, retain) NSString *apsalarKey;
@property (nonatomic, retain) NSString *apsalarSecret;
@end

@implementation ModuleApsalar

- (void)dealloc
{
    self.apsalarKey = nil;
    self.apsalarSecret = nil;
    [super dealloc];
}

#pragma mark - Required WizAnalyticsVendorModule protocol methods

- (id)initWithOptions:(NSDictionary *)options
{
    if ((self = [super init])) {
        WizLog(@"BOOT Apsalar");
        self.apsalarKey = [options objectForKey:@"ApsalarKey"];
        self.apsalarSecret = [options objectForKey:@"ApsalarSecret"];
    }
    return self;
}

- (void)startSession
{
    WizLog(@"[Apsalar] ******* Starting Apsalar Session");
    [Apsalar startSession:self.apsalarKey withKey:self.apsalarSecret];
}

#pragma mark - Optional WizAnalyticsVendorModule protocol methods

- (void)stopSession
{
    WizLog(@"[Apsalar] ******* Ending Apsalar Session");
    [Apsalar endSession];
}

- (void)resumeSession
{
    WizLog(@"[Apsalar] ******* Re-Starting Apsalar Session");
    [Apsalar reStartSession:self.apsalarKey withKey:self.apsalarSecret];
}

- (void)logEvent:(NSString *)eventName withExtraMetadata:(NSDictionary *)extraMetadata
{
    if (extraMetadata != nil) {
        [Apsalar event:eventName];
        WizLog(@"[Apsalar] ******* [event] %@:", eventName);
	} else {
        [Apsalar event:eventName withArgs:extraMetadata];
        WizLog(@"[Apsalar] ******* [event] %@: %@:", eventName, extraMetadata);
    }
}

- (void)handleOpenURL:(NSURL *)url
{
    WizLog(@"[Apsalar] ******* Starting Apsalar Session with URL");
    [Apsalar startSession:self.apsalarKey withKey:self.apsalarSecret andURL:url];
}

@end