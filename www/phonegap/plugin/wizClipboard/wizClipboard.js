 /* WizClipboard plugin for PhoneGap
 *
 * @author WizCorp Inc. [ Incorporated Wizards ] 
 * @copyright 2011
 * @file - wizClipboard.js
 * @about - JavaScript API for PhoneGap
 *
 *
 */


var wizClipboard = { 

	setText: function(text, s, f) {
	    
		return PhoneGap.exec(s, f, "WizClipboardPlugin", "setText", [text]);
	
	},
	
	getText: function(s, f) {
	    
		return PhoneGap.exec(s, f, "WizClipboardPlugin", "getText", []);
	
	}
	
};