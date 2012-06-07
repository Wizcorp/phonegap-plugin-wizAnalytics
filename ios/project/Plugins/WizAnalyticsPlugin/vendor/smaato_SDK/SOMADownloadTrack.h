//
//  SOMADownloadTrack.h
//  SomaLib
//
//  
//  Copyright ©2011 Smaato, Inc.  All Rights Reserved.  Use of this software is subject to the Smaato Terms of Service. 
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SOMADownloadTrack : NSObject {
    NSString * mWifiMacMd5;
    NSString * mWifiMacSha1;
}
/* send Ping to Server for Download Tracking*/
-(void)sendPingToSOMAServer;
@end
