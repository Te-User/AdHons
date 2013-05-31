// Boolean.
var isBanner:Boolean = false;
var Commandz:String = _parent._parent._txtConsole.text;
	
	if(Commandz == undefined) {
		isBanner = false;
	} else {
		isBanner = true;
	}
	

var GET_ADDONS:String = "modules/adhons/addons/welcome/settings.conf";
var Addons_CONF_CONTENT:String;
var Addons:Object;
var Adhons:XML = new XML();
Adhons.nodeType = 1;
Adhons.ignoreWhite = true;
function XMLLoader(XMLPath:String):Void {
	Adhons.load(XMLPath);
	Adhons.onLoad = function(success:Boolean) {
		if (success) {
			var WHERE_IS:Boolean = _parent.isBanner;
			var WHERE_WANT_IS:Boolean;
			Addons_CONF_CONTENT = Adhons.toString();
			var TXT_INF:String = "ERROR_BOX";
			if (parseInt(getVar("TYPE_MSG")) == 0) {
				TXT_INF = "INFO_CHAT";
			} else {
				TXT_INF = "ERROR_BOX";
			}
			if (parseInt(getVar("WHERE_ACTIVE_ADDON")) == 0) {
				WHERE_WANT_IS = false;
			} else {
				WHERE_WANT_IS = true;
			}
			if (WHERE_WANT_IS == isBanner) {
				_parent._parent.api.kernel.showMessage(getVar("TITLE_BOX"), getVar("WELCOME_TEXT"), TXT_INF);
			}
			//_parent._parent.api.kernel.showMessage(undefined, WHERE_WANT_IS + "==" + isBanner, "ERROR_BOX");
		}
	};
}
XMLLoader(GET_ADDONS);