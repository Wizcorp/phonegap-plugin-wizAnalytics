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

    launch: function(s, f) {
        return cordova.exec(s, f, "WizAnalyticsPlugin", "launch", []);                      
    },
    
    session : {
        start : function (options, s, f) {
            cordova.exec(s, f, "WizAnalyticsPlugin", "startSession", [options]);
            
        },
        
        end : function (options, s, f) {
            cordova.exec(s, f, "WizAnalyticsPlugin", "endSession", [options]);
            
        },
        
        restart : function (options, s, f) {
            cordova.exec(s, f, "WizAnalyticsPlugin", "restartSession", [options]);
            
        }
        
    },
    
    event : {
        log : function (eventName, options, s, f) {
            if(typeof(options) == "undefined") {
		 		cordova.exec(s, f, "WizAnalyticsPlugin", "logEvent", [eventName, options]);	
			} else {
				cordova.exec(s, f, "WizAnalyticsPlugin", "logEvent", [eventName, options]);
			}
            
            
        }
    }

};