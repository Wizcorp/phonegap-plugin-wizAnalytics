//
//  JumpTapAppReport.m
//  TestApp
//
//  Created by James Maki on 8/27/09.
//  Copyright 2009 JumpTap Inc. All rights reserved.
//

#include <sys/socket.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CommonCrypto/CommonDigest.h>
#import <ifaddrs.h> 
#import <arpa/inet.h>
#import <sys/sysctl.h>
#import <AdSupport/AdSupport.h>

#import "JumpTapAppReport.h"

@implementation JumpTapAppReport

#ifdef CCI
NSString * const  JTConversionBaseUrl    = @"http://a.adjust-sp.jp/a";
#else
NSString * const  JTConversionBaseUrl    = @"http://a.jumptap.com/a";
#endif

static NSString * reportingUrl           = nil;
static BOOL       reportApplicationUsage = NO;
static BOOL       loggingEnabled         = NO;

+ (void) setReportingUrl:(NSString*)toSet {
	toSet = toSet != nil ? toSet : JTConversionBaseUrl;
	
	[reportingUrl release];
	reportingUrl = nil;
	reportingUrl = [[toSet stringByAppendingString:@"/conversion?"] retain];
}

+ (NSString*) reportingUrl {
	if (reportingUrl == nil) {
		[self setReportingUrl:JTConversionBaseUrl];
	}
	return reportingUrl;
}

+ (void) loggingEnabled: (BOOL) enabled {
	loggingEnabled = enabled;
}

+ (void) reportApplicationUsage: (BOOL) submitApplicationUsage {
	reportApplicationUsage = submitApplicationUsage;
}

+ (void) forRequest:(NSMutableDictionary*)dictionary addParameter:(NSString*)param forKey:(NSString*)key {
	if (param != nil && key != nil) {
		[dictionary setObject:param forKey:key];
	}
}

+ (void) appendDictionary: (NSDictionary*) parameters toRequest: (NSMutableString*) request {
	if (parameters != nil) {
		id name; 
		NSEnumerator * enumerator = [parameters keyEnumerator];
		while (name = [enumerator nextObject]) {
			[request appendString:name];
			[request appendString:@"="];
			[request appendString:[[parameters objectForKey:name] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
			[request appendString:@"&"];
		}
	}
}

+ (void) handleApplicationLaunchUrl: (NSURL *) url {
	
	NSRange range = [[url absoluteString] rangeOfString:@"jtsuccess=true"];
	if (range.location != NSNotFound) {
		if (loggingEnabled) {
			NSLog(@"JumpTapAppReport: \"jtsuccess=true\" found in application launch URL");
		}
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:JT_INSTALL_FLAG_KEY];		
	}
}

+ (void) submitReportWithExtraInfo: (NSDictionary*) info {
	
	NSString * scheme = nil;
	NSArray * urlTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"];
	if ([urlTypes count] > 0) {
		NSArray * schemes = [[urlTypes objectAtIndex: 0] objectForKey: @"CFBundleURLSchemes"];
		if ([schemes count] > 0) {
			scheme = [[NSString stringWithFormat:@"%@%@",[schemes objectAtIndex: 0], @"://autodetected"] retain];
			if (loggingEnabled) {
				NSLog(@"JumpTapAppReport: Generated URL using custom scheme: %@", scheme);
			}
		}
	}
	
	[self submitReportWithExtraInfo: info withAppUrl: scheme];
	[scheme autorelease];
}
#ifndef CCI
+ (NSString *) constructIDFAForConversion {
    if([ASIdentifierManager respondsToSelector:@selector(sharedManager)]) { //in iOS 6, we can use the idfa
        ASIdentifierManager * identifierManager = [ASIdentifierManager sharedManager];
        NSUUID * idfaBlob = [identifierManager advertisingIdentifier];
        return [idfaBlob UUIDString];
    }
    return @""; //empty string. Easier than having to worry about nil's all over the place.
}
#endif

+ (NSString*)sha1DigestToString:(unsigned char*)messageDigest {
    CFMutableStringRef string = CFStringCreateMutable(NULL, 40);
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        CFStringAppendFormat(string, NULL, (CFStringRef)@"%02X", messageDigest[i]);
    }
    CFStringLowercase(string, CFLocaleGetSystem());
    return (NSString*)string;
}
#ifndef CCI
+ (NSString *) checkTrackingEnabledForConversion {
    if([ASIdentifierManager respondsToSelector:@selector(sharedManager)]) {
        ASIdentifierManager * identifierManager = [ASIdentifierManager sharedManager];
        if([identifierManager isAdvertisingTrackingEnabled]){
            return @"Y";
        }else{
            return @"N";
        }
    }
    return @"";
}
#endif

#ifndef NO_UDID
+ (NSString *) constructHashedDeviceIdForConversion {
    NSString * version = [[UIDevice currentDevice] systemVersion];
#ifndef CCI
    if([[version substringToIndex:1] intValue] > 5) { //in iOS 6, don't send UDID
        return @"";
    }
#endif
    NSString * deviceId = [[UIDevice currentDevice] uniqueIdentifier];
    NSData * stringBytes = [deviceId dataUsingEncoding:NSASCIIStringEncoding];
    unsigned char messageDigest[CC_SHA1_DIGEST_LENGTH];
    if(CC_SHA1([stringBytes bytes], [stringBytes length], messageDigest)){
        return [self sha1DigestToString:messageDigest];
    }
    return @""; //empty string. Easier than having to worry about nil's all over the place.
}
#endif

+ (void) submitReportWithExtraInfo: (NSDictionary*) info withAppUrl: (NSString*) appUrl {
    

	if (loggingEnabled) {
		if (appUrl == nil) {
			NSLog(@"JumpTapAppReport: No URL has been specified (or could be generated) to relaunch the application. "
				  @"This could greatly impact reporting on some types of events.");
		}
	}
	
	NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
	BOOL hasReportedInstall = [userDefaults boolForKey:JT_INSTALL_FLAG_KEY];
	
	if (!hasReportedInstall || reportApplicationUsage) {
#ifndef NO_UDID
        NSString * hashedHardwareId = [self constructHashedDeviceIdForConversion];
#endif
#ifndef CCI        
        NSString * hardwareIDFA = [self constructIDFAForConversion];
        NSString * trackingEnabled = [self checkTrackingEnabledForConversion];
#endif
		NSString * event = hasReportedInstall ? @"run" : @"download";
		
		NSString * app = [[NSBundle mainBundle] bundleIdentifier];
		NSString * appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
				
		NSString * installDate = nil;
		if (!hasReportedInstall) {
			// only send our install date for install events
			installDate = [[userDefaults stringForKey:JT_INSTALL_DATE_KEY] retain];
			if (installDate == nil) {
				NSDateFormatter * formatter =[[NSDateFormatter alloc]init];
				[formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
				[formatter setDateFormat:@"YYYYMMddHHmmss"];
				installDate = [formatter stringFromDate:[NSDate date]];
				[userDefaults setObject:installDate forKey:JT_INSTALL_DATE_KEY];
				[formatter release];
			}
		}
		
		NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
#ifndef NO_UDID
        if(hashedHardwareId != @""){
            [self forRequest:parameters addParameter:hashedHardwareId forKey:@"hid_sha1"];
        }
#endif
#ifndef CCI
        if(trackingEnabled != @""){
            [self forRequest:parameters addParameter:trackingEnabled  forKey:@"idflag"  ];
        }
        if(hardwareIDFA != @""){
            [self forRequest:parameters addParameter:hardwareIDFA     forKey:@"idfa"    ];
        }
#endif
		[self forRequest:parameters addParameter:app			  forKey:@"app"	    ];
		[self forRequest:parameters addParameter:appVersion		  forKey:@"appVer"  ];
		[self forRequest:parameters addParameter:event			  forKey:@"event"	];
		[self forRequest:parameters addParameter:installDate	  forKey:@"date"	];
		[self forRequest:parameters addParameter: @"false"	      forKey:@"bounce"  ];				

        NSMutableString * reportUrl = [[NSMutableString alloc] initWithString:@""];
        bool foundUrl = NO;
		
        if (info != nil) {
            // extract an override reporting url if there is one.
            NSString * reportUrlParameter = (NSString *)[parameters objectForKey:@"reportUrl"];
            if (reportUrlParameter != nil) {
                [reportUrl appendString:reportUrlParameter];
                foundUrl = YES;
            }
            [parameters removeObjectForKey:@"reportUrl"];
			[parameters addEntriesFromDictionary:info];
		}
		
        if (!foundUrl) {
            [reportUrl appendString:[self reportingUrl]];
        }
        
		[self appendDictionary: parameters toRequest: reportUrl];

		[parameters release];
		
		NSMutableDictionary *runbook = [[NSMutableDictionary alloc] init];
		[runbook setObject:[reportUrl autorelease] forKey:@"reportUrl"];
		if (appUrl != nil) {
			[runbook setObject:appUrl forKey:@"appUrl"];	
		}
		[self performSelectorInBackground:@selector(submitReportApplication:) withObject: [runbook autorelease]];
	}
}


+ (void) submitReportApplication: (NSDictionary*) runbook {
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	NSString* report = [runbook valueForKey:@"reportUrl"];
	NSString* appUrl = [runbook valueForKey:@"appUrl"];
	
	if (loggingEnabled) {
		NSLog(@"JumpTapAppReport: Submiting JTAppReport: %@", report);
	}

	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:report]];
	NSHTTPURLResponse * httpResponse = nil; NSError * error = nil;
	[NSURLConnection sendSynchronousRequest:request returningResponse:(NSURLResponse**)&httpResponse error:&error];
	int statusCode = [httpResponse statusCode];
	NSString * errorMessage = [[httpResponse allHeaderFields] objectForKey:@"Jt-Error"];
	
	if (loggingEnabled) {
		NSLog(@"JumpTapAppReport: Status Code: %d", statusCode);
		if (errorMessage != nil) {
			NSLog(@"JumpTapAppReport: Error Message: %@", errorMessage);			
		}
		if (error != nil) {
			NSLog(@"JumpTapAppReport: HTTP Request Error: %@", error);
		}
	}
	
	if(error == nil) {
		switch (statusCode) {
			case 200: {
				if (errorMessage == nil) {
					[[NSUserDefaults standardUserDefaults] setBool:YES forKey:JT_INSTALL_FLAG_KEY];					
				}
				break;
			}
				
			case 300: {
				if (appUrl != nil) {
					NSMutableString * mutable = [[NSMutableString alloc] init];
					[mutable appendString: report];
					[mutable appendString: @"appurl="];
					NSString * encodedUrl = (NSString*)CFURLCreateStringByAddingPercentEscapes(
																							   kCFAllocatorDefault, 
																							   (CFStringRef)appUrl, 
																							   NULL, 
																							   (CFStringRef)@":/?#[]@!$&’()*+,;=", 
																							   kCFStringEncodingUTF8
																							   );
					
					[mutable appendString: encodedUrl];
					
					
					// add fragment delimiter if it's not already there
					[mutable appendString: [appUrl rangeOfString:@"#"].location == NSNotFound ? @"%23"/*#*/ : @"%26" /*&*/];					
					[mutable appendString: @"jtsuccess%3Dtrue"];
					[encodedUrl autorelease];
					
					if (loggingEnabled) {
						NSLog(@"JumpTapAppReport: Reporting via Safari: %@", mutable);
					}
					[[UIApplication sharedApplication] openURL: [NSURL URLWithString: mutable]];
					[mutable release];
					
				}
				break;
			}
		}
	}

	[pool release];
}



@end
