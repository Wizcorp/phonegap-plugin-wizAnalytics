# PLUGIN: 
For Cordova v1.9
phonegap-plugin-wizAnalytics


# DESCRIPTION :

Cordova plugin for accessing the native ad and event logging SDKs. 
(iOS only, Droid users please be patient...)

Currently supports;
- Adfonic
- Admob
- ChartBoost
- Flurry
- InMobi
- JumpTapAppReport
- LeadBolt
- Localytics
- Millenium Media
- MdotM
- Smaato
- Kontagent



# DOCS & SUPPORT :

Load the plugin in JS (or in native code by allocating an instance of the plugin
class) then launch the analytics with analytics keys.

See below for detailed instructions and check out exampleWizAnalytics/www/index.html for JS code.

# USAGE

- Add plugins directory ios/project/Plugins/WizAnalyticsPlugin/ to your project
- Add the following frameworks:
	- CoreTelephony.framework
	- CoreData.framework
	- libsqlite3.dylib
	- libz.dylib

- Specify the analytics modules to use by setting the analytics keys to use.
  This is done by specifying the key-name to key-value mapping for each of the
  analytic modules to be used when the application is launched. (For a list of
  valid key names see below)

  This can be done in two different ways (in JavaScript *OR* native code, but
  not both).

  Method 1 -- In Javascript
	In your Javascript code, call:

		wizAnalytics.launch(keyDict)

	where 'keyDict' is your dictionary of key-name to key-value mappings.

  Method 2 -- In Native Code (iOS)
	In your app delegate, application: didFinishLaunchingWithOptions: method,
	allocate an instance of WizAnalyticsPlugin and send a message to the plugin
	specifying the launch options:

		WizAnalyticsPlugin *analytics = [WizAnalyticsPlugin alloc] init];
		[analytics launch:nil withDict:analyticsKeyDict];

	where 'keyDict' is your dictionary of key-name to key-value mappings.

  IMPORTANT NOTE:

	The specified keys that are provided on the first invocation of the launch
	method will be used for the lifetime of the application.  So even if the
	launch method is called a second time with different options, the original
	options will be used and retained.  The launch method is intended to be
	called once for the lifetime of the application and so subsequent
	invocations are effectively ignored.  For this reason it is advised to only
	call the launch method from native code OR JavaScript but not both.

  Valid key names are the following:
            "AdfonicKey"
            "AdmobKey"
            "ChartboostKey"
            "FlurryKey"
            "InMobiKey"
            "JumpTapKey"
            "KontagentKey"
            "LeadboltKey"
            "LocalyticsKey"
            "MilleniumKey"
            "MdotMKey"
            "SmaatoKey"

