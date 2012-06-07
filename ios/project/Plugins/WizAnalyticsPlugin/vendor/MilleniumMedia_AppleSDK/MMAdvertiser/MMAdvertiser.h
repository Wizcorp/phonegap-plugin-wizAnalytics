//
//  MMAdvertiser
//
//  Copyright 2011 Millennial Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMAdvertiser : NSObject

+ (MMAdvertiser *)sharedSDK;


- (NSDictionary *) parseURL: (NSURL *) url;
- (void) trackConversionWithGoalId: (NSString *) goalid;


- (void) setValue:(id)value forKey:(NSString *)key;
- (id) valueForKey: (NSString *) key;
- (NSDictionary *) storedKeyValuePairs;

- (BOOL) isOverlayShowing;
- (void) closeOverlay;

@end
