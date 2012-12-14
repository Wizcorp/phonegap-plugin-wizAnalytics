//
//  MMAdvertiser
//
//  Copyright 2011 Millennial Media. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum LogLevel {
    MMLOG_LEVEL_OFF   = 0,
    MMLOG_LEVEL_INFO  = 1 << 0,
    MMLOG_LEVEL_DEBUG = 1 << 1,
    MMLOG_LEVEL_ERROR = 1 << 2,
    MMLOG_LEVEL_FATAL = 1 << 3
} MMLogLevel;

@interface MMAdvertiser : NSObject

+ (MMAdvertiser *)sharedSDK;
+ (void)setLogLevel:(MMLogLevel)level;

- (NSDictionary *) parseURL: (NSURL *) url;
- (void) trackConversionWithGoalId: (NSString *) goalid;


- (void) setValue:(id)value forKey:(NSString *)key;
- (id) valueForKey: (NSString *) key;
- (NSDictionary *) storedKeyValuePairs;

- (BOOL) isOverlayShowing;
- (void) closeOverlay;

@end
