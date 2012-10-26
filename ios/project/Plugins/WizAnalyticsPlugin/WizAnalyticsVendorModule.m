/* WizAnalyticsVendorModule - Protocol and base class implementation for vendor modules
 *
 * @author Chris Wynn
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file WizAnalyticsVendorModule.h for iOS
 *
 *
 */

#import "WizAnalyticsVendorModule.h"

@implementation WizAnalyticsVendorModule

- (id)initWithOptions:(NSDictionary *)options
{
    NSAssert( NO, @"WizAnalyticsVendorModule must be subclassed with name \"Module<XXX>.\"" );
    return nil;
}

- (void)startSession
{
    NSAssert( NO, @"WizAnalyticsVendorModule must be subclassed with name \"Module<XXX>.\"" );
}

@end
