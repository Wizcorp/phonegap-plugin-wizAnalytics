/* WizAnalyticsPlugin for cordova
*
 * @author Ally Ogilvie  
 * @copyright WizCorp Inc. [ Incorporated Wizards ] 2012
 * @file - WizAnalyticsPlugin.js
 * @about - Access WizAnalytics SDKs through JavaScript
 *
 *
*/

var wizAnalytics = {

    launch: function() {
        return cordova.exec(null, null, "WizAnalyticsPlugin", "launch", []);
    },
    
    session : {
        start : function (options) {
            cordova.exec(null, null, "WizAnalyticsPlugin", "startSession", [options]);
            
        },
        
        end : function (options) {
            cordova.exec(null, null, "WizAnalyticsPlugin", "endSession", [options]);
            
        },
        
        restart : function (options) {
            cordova.exec(null, null, "WizAnalyticsPlugin", "restartSession", [options]);
            
        }
        
    },
    
    event : {
        log : function (eventName, options) {
            if(typeof(options) == "undefined") {
		 		cordova.exec(null, null, "WizAnalyticsPlugin", "logEvent", [eventName, options]);
			} else {
				cordova.exec(null, null, "WizAnalyticsPlugin", "logEvent", [eventName, options]);
			}
            
            
        }
    },
    
    screen  : {
        log : function (screenName, options) {
            if(typeof(options) == "undefined") {
		 		cordova.exec(null, null, "WizAnalyticsPlugin", "logScreen", [screenName, options]);
			} else {
				cordova.exec(null, null, "WizAnalyticsPlugin", "logScreen", [screenName, options]);
			}
            
            
        }
    }

};