# PLUGIN: 
For Cordova v2.3
phonegap-plugin-wizAnalytics


# DESCRIPTION :

Cordova plugin for accessing the native ad and event logging SDKs. 
(iOS only, Droid users please be patient...)

Currently supports;
- Apsalar 5.0.0U
- Adfonic
- Admob 6.2.1
- ChartBoost v3.0.7
- Google Analytics 2.0 beta4
- InMobi i251 (Build 2.5.1)
- JumpTapAppReport
- LeadBolt
- Localytics v2.6
- Millenium Media 4.6.1
- MdotM
- Smaato 1.4.1
- Kontagent 1.3.3



# DOCS & SUPPORT :

Specify the analytics modules to use, then in JavaScript code log events.
See below for detailed instructions and check out exampleWizAnalytics/www/index.html for JS code.

# USAGE :

- Add plugins directory ios/project/Plugins/WizAnalyticsPlugin/ to your project
- Add the following frameworks:
	- AdSupport.framework - Set this framework to Optional to support device versions earlier than iOS 6.
	- CoreTelephony.framework
	- CoreData.framework
	- MessageUI.framework
	- Security.framework
	- StoreKit.framework
	- SystemConfiguration.framework
	- libsqlite3.dylib
	- libz.dylib

- Specify the analytics modules to use by setting the analytics keys to use.
  This is done by specifying the key-name to key-value mapping for each of the
  analytic modules to be used when the application is launched. (For a list of
  valid key names see below)

  The key-name to key-value mappings must be specified in the wizAnalytics.plist
  file included in your application bundle.

  Valid key names are the following:
	- "ApsalarKey"
	- "AdfonicKey"
	- "AdmobKey"
	- "ChartboostKey"
	- "GoogleKey"
	- "InMobiKey"
	- "JumpTapKey"
	- "KontagentKey"
	- "LeadboltKey"
	- "LocalyticsKey"
	- "MilleniumKey"
	- "MdotMKey"
	- "SmaatoKey"

- Any additional parameters required per-module must also be specified in the
  wizAnalytics.plist file included in your application bundle.

# ADDING NEW VENDOR MODULES :

To add a new vendor module to support a new analytics service, create a new
Objective-C class that conforms to the WizAnalyticsVendorModule protocol with
name "Module<XXX>".  For example:

		@interface ModuleAcmeAnalytics : NSObject <WizAnalyticsVendorModule>
		@end

Then, implement the "required" methods for the WizAnalyticsVendorModule protocol
and optional implement the "optional" methods.

Link the implementation of the new class into your application.

To dynamically load the new module, specify the module key in the key dictionary
when launching the plugin.  The key name for loading the new module is:
"<class-name>Key".  For the example class above, the corresponding key name
is "ModuleAcmeAnalyticsKey".  
