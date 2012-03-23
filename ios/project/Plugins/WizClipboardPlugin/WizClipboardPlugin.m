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
#import <PhoneGap/PluginResult.h>
#else
#import "PGPlugin.h"
#import "PluginResult.h"
#endif
#import "WizClipboardPlugin.h"

@implementation WizClipboardPlugin


-(PGPlugin*) initWithWebView:(UIWebView*)theWebView
{

    self = (WizClipboardPlugin*)[super initWithWebView:theWebView];

    // prepare clipboard
    pasteboard = [UIPasteboard generalPasteboard];
    
    return self;
}


-(void)setText:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
	
    // get callback 
    NSString* callbackId = [arguments objectAtIndex:0];
    NSString* text       = [arguments objectAtIndex:1];
    
    // store the text
	[pasteboard setValue:text forPasteboardType:@"public.utf8-plain-text"];
    
    // keep open the callback
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK messageAsString:text];
    [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
    
}

-(void)getText:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options {
    
    NSString* callbackId       = [arguments objectAtIndex:0];

    // get the text from pasteboard
	NSString* text = [pasteboard valueForPasteboardType:@"public.utf8-plain-text"];
    
    PluginResult* pluginResult = [PluginResult resultWithStatus:PGCommandStatus_OK messageAsString:text];
    [self writeJavascript: [pluginResult toSuccessCallbackString:callbackId]];
    
}

@end
