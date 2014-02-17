/* WizAnalyticsPlugin for cordova
 *
 * @author Ally Ogilvie  
 * @copyright Wizcorp Inc. [ Incorporated Wizards ] 2014
 * @file - WizAnalyticsPlugin.js
 * @about - Access WizAnalytics SDKs through JavaScript
 *
 *
*/

	var wizAnalytics = {
	
	    event : {
	        log : function (eventName, options) {
	            cordova.exec(null, null, "WizAnalyticsPlugin", "logEvent", [eventName, options]);
	        }
	    },
	    
	    screen  : {
	        log : function (screenName, options) {
	            cordova.exec(null, null, "WizAnalyticsPlugin", "logScreen", [screenName, options]);
	        }
	    },
	
	    handleOpenURL : function(url) {
	            cordova.exec(null, null, "WizAnalyticsPlugin", "handleOpenURL", [url]);
	    }
	
	};
    module.exports = wizAnalytics;
