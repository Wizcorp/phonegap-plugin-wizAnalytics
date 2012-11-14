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

    session : {
        pause : function () {
            cordova.exec(null, null, "WizAnalyticsPlugin", "pauseSession", []);
        },

        restart : function () {
            cordova.exec(null, null, "WizAnalyticsPlugin", "restartSession", []);
        }
    },
    
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
