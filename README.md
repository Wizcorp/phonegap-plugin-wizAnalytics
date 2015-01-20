# phonegap-plugin-wizAnalytics

Supports Cordova 3.3.*+

# Description

Cordova plugin for accessing the native ad and event logging SDKs. 
(iOS only)

Currently supports

- Google Analytics 3.03a
- Localytics 2.21.1
- MixPanel 2.3.1
- Flurry 4.3.2
- Apsalar 6.0.6 no-Ad-SDK

Specify the analytics modules to use, then in JavaScript code log events.
See below for detailed instructions and check out exampleWizAnalytics/www/index.html for JS code.

## Install (with Plugman) 

	cordova plugin add https://github.com/Wizcorp/phonegap-plugin-wizAnalytics
	cordova build
	
	< or >
	
	phonegap local plugin add https://github.com/Wizcorp/phonegap-plugin-wizAnalytics
	phonegap build

- Add `$(SRCROOT)` to Xcode Search Header Paths 
- Specify the analytics modules to use by setting the analytics keys to use.
  
  This is done by specifying the key-name to key-value mapping for each of the
  analytic modules to be used when the application is launched. (For a list of
  valid key names see below)

  The key-name to key-value mappings must be specified in the wizAnalytics.plist
  file included in your application bundle.

  Valid key names are as follows:
	- "ApsalarKey"
	- "AdmobKey"
	- "GoogleKey"
	- "LocalyticsKey"
	- "FlurryKey"

- Any additional parameters required per-module must also be specified in the
  wizAnalytics.plist file included in your application bundle.

# Adding Your Own Vendor Modules

To add a new vendor module to support a new analytics service, create a new
Objective-C class that conforms to the WizAnalyticsVendorModule protocol with
name "Module<XXX>".  For example:

		@interface ModuleAcmeAnalytics : NSObject <WizAnalyticsVendorModule>
		@end

Then, implement the **required** methods for the WizAnalyticsVendorModule protocol
and optionally implement the optional methods.

Link the implementation of the new class into your application.

To dynamically load the new module, specify the module key in the key dictionary
when launching the plugin.  The key name for loading the new module is:
`<class-name>Key`.  For the example class above, the corresponding key name
is `"ModuleAcmeAnalyticsKey"`.  
