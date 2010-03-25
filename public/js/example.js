var params, attributes, flashvars, playerVersion;

playerVersion = "10.0.0";

params = {};
params.menu = "false";
params.scale = "noscale";
params.allowScriptAccess = "always";
params.bgcolor = "#FAFAFA";

attributes = {};
attributes.align = "top";

flashvars = {};

var paramPairs = window.location.search.substring(1).split("&");
for(var i = 0; i < paramPairs.length; i++){
	var pair = paramPairs[i].split("=");
	flashvars[pair[0]] = pair[1];
}

swfobject.embedSWF("textanim_maker.swf", "content", "100%", "100%", playerVersion, "expressInstall.swf", flashvars, params, attributes);