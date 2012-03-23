/* WizClipboardPlugin - Clipboard plugin for phonegap
 *
 * @author WizCorp Inc. [ Incorporated Wizards ] 
 * @copyright 2011
 * @file WizClipboardPlugin.h for PhoneGap
 *
 */ 

#import <Foundation/Foundation.h>
#ifdef PHONEGAP_FRAMEWORK
#import <PhoneGap/PGPlugin.h>
#else
#import "PGPlugin.h"
#endif

@interface WizClipboardPlugin : PGPlugin{ 
    
    UIPasteboard *pasteboard;

}


-(void)setText:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

-(void)getText:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@end
