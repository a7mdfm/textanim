var params, attributes, flashvars, playerVersion;

playerVersion = "10.0.0";

params = {};
params.menu = "false";
params.scale = "noscale";
params.allowScriptAccess = "always";
//params.bgcolor = "#000000";

attributes = {};
attributes.align = "top";

flashvars = {};

var paramPairs = window.location.search.substring(1).split("&");
for(var i = 0; i < paramPairs.length; i++){
	var pair = paramPairs[i].split("=");
	flashvars[pair[0]] = pair[1];
}

swfobject.embedSWF("ta_showclip.swf", "content", "640", "360", playerVersion, "expressInstall.swf", flashvars, params, attributes);