

#import <Foundation/Foundation.h>

/**
  Enumeration of all logging levels.
 */
typedef enum IMAdTrackerLogLevels {
    IMAdTrackerLogLevelMinimal = 1, /**< Minimal level */
    IMAdTrackerLogLevelDebug = 2, /**< Debugging purpose */
    IMAdTrackerLogLevelCritical = 3, /**< Critical debugging */
} IMAdTrackerLogLevel;
/**
  Utility class for InMobi Ad Tracker SDK.
 */
@interface IMAdTrackerUtil : NSObject
/**
  Sets the Logging level.
  @param loggingLevel Logging level to be set.
 */
+ (void)setLogLevel:(IMAdTrackerLogLevel)loggingLevel;
/**
  Gets the current Logging level.
  @returns current Logging level.
 */
+ (IMAdTrackerLogLevel)getLogLevel;
/**
  Gets the version of current InMobi Ad Tracker SDK
  e.g. format @"2.0.2",@"1.5.0" etc.
  @returns current version of SDK.
 */
+ (NSString *)getSDKVersion;
@end
