cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "phonegap/plugin/wizAnalyticsPlugin/wizAnalyticsPlugin.js",
        "id": "jp.wizcorp.phonegap.plugin.wizAnalytics.wizAnalyticsPlugin",
        "clobbers": [
            "window.wizAnalytics"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "jp.wizcorp.phonegap.plugin.wizAnalytics": "1.0.0"
}
// BOTTOM OF METADATA
});