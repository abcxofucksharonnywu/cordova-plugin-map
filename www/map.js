var exec = require('cordova/exec');
var map = {
	jumpAddress:function(address,callback) {
		exec(callback, callback, "map", "jumpAddress", [address]);
	},
	selectAddress:function(address,callback) {
		exec(callback, callback, "map", "selectAddress", [address]);
	}
};
module.exports = map;
