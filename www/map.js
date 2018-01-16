var exec = require('cordova/exec');
var map = {
	jumpAddress:function(callback) {
		exec(callback, callback, "map", "jumpAddress", []);
	},
	selectAddress:function(callback) {
		exec(callback, callback, "map", "selectAddress", []);
	}
};
module.exports = map;