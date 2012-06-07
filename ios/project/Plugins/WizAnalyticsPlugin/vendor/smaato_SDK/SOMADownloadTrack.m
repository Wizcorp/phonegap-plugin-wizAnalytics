//
//  SOMADownloadTrack.m
//  SomaLib_official
//
//  Created by Jocelyn Harrington on 3/2/10.
//  Copyright ©2011 Smaato, Inc.  All Rights Reserved.  Use of this software is subject to the Smaato Terms of Service. 
//

#import "SOMADownloadTrack.h"
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <CommonCrypto/CommonDigest.h>
#import "OpenUDID.h"
#import "ODIN.h"

@implementation SOMADownloadTrack

static const char* jailbreak_apps[] =
{
	"/Applications/Cydia.app", 
	"/Applications/limera1n.app", 
	"/Applications/greenpois0n.app", 
	"/Applications/blackra1n.app",
	"/Applications/blacksn0w.app",
	"/Applications/redsn0w.app",
	NULL,
};

- (BOOL) isJailBroken
{
	BOOL isJailB= NO;
	for (int i = 0; jailbreak_apps[i] != NULL; ++i)
	{
		if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:jailbreak_apps[i]]])
		{
			isJailB = YES;
		}		
	}
	return isJailB;
}

- (NSString *) getMacaddress
{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}



-(NSString*) getMd5ForString:(NSString *)str
{
	const char *cStr = [str UTF8String];
	unsigned char result[CC_MD5_DIGEST_LENGTH];
	CC_MD5( cStr, strlen(cStr), result );
	return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
			];
}

-(NSString*) getSha1ForString:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}


#pragma mark --Ping to Server--
/* send Ping to Server, such as appID, UDID*/
-(void)sendPingToSOMAServer {
    NSString* openUDID = [OpenUDID value];
    NSString* odin1 = [ODIN1() lowercaseString];
    NSString *strWifiMac = [self getMacaddress]; // Get the WiFi Mac Address
    if (strWifiMac != NULL) {
        mWifiMacMd5 = [[self getMd5ForString:strWifiMac] retain];
        mWifiMacSha1 = [[self getSha1ForString:strWifiMac] retain];
        mWifiMacSha1 = [[self getSha1ForString:strWifiMac] retain];
    }
    
	NSString *appname = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
	NSMutableString* urlString = [NSMutableString stringWithString:@"http://soma.smaato.net/oapi/dl.jsp"];
	[urlString appendFormat:@"?app=%@",appname]; //change that to appIdentifier
//	[urlString appendFormat:@"&ownid=%@", [[UIDevice currentDevice] uniqueIdentifier]]; //change back UDID since 3.4.3
    if (mWifiMacMd5 != nil)
        [urlString appendFormat:@"&macmd5=%@", mWifiMacMd5];
    if (mWifiMacSha1 != nil)
        [urlString appendFormat:@"&ownid3=%@", mWifiMacSha1];    
    [urlString appendFormat:@"&openudid=%@", openUDID];  
    [urlString appendFormat:@"&odin=%@", odin1];  
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	BOOL downloadDefault = [defaults boolForKey:@"SOMAStartResult"];
	if (!downloadDefault) {
		[urlString appendFormat:@"&firststart=true"];
	} else {
		[urlString appendFormat:@"&firststart=false"];
	}
	BOOL isJB = [self isJailBroken];
	if (isJB) {
		[urlString appendFormat:@"&isjailbroken=true"];
	} else {
		[urlString appendFormat:@"&isjailbroken=false"];
	}
	NSString *realURLString =[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *aurl = [NSURL URLWithString:realURLString];
	NSURLRequest *request=[NSURLRequest requestWithURL:aurl];
	[NSURLConnection connectionWithRequest:request delegate:self];	
}

#pragma mark -- NSURLDOWNLOAD DELEGATE -- 

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
	int responseStatusCode = [httpResponse statusCode];
	if (responseStatusCode == 200) {
		//if the status is true, set the NSDefaults BOOL= YES. 
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setBool:YES forKey:@"SOMAStartResult"];
	}
}

@end
