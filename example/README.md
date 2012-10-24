# SETUP FOR BUILDING

To build this example, PhoneGap requires that the plugin be installed in the
correct location relative to this example's www directory.  So we must copy or
link the plugin javascript code to the www directory.

Copy Method:
	mkdir -p ./www/phonegap
	cp -r ../www/phonegap ./www

Link Method:
	mkdir -p ./www/phonegap/plugin/wizAnalyticsPlugin
	ln -f ../www/phonegap/plugin/wizAnalyticsPlugin/wizAnalyticsPlugin.js ./www/phonegap/plugin/wizAnalyticsPlugin/wizAnalyticsPlugin.js

