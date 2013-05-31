var WEBSITE:String;
var FORUM:String;
var VOTE:String;

function GoWebsite() {
	getURL(WEBSITE, _blank);
}
function GoForum() {
	getURL(FORUM, _blank);
}
function GoVote() {
	getURL(VOTE, _blank);
}
var GET_ADDONS:String = "modules/adhons/addons/rightmenu/settings.conf";
var Addons_CONF_CONTENT:String;
var Addons:Object;
var Adhons:XML = new XML();
Adhons.nodeType = 1;
Adhons.ignoreWhite = true;
function XMLLoader(XMLPath:String):Void {
	Adhons.load(XMLPath);
	Adhons.onLoad = function(success:Boolean) {
		if (success) {
			Addons_CONF_CONTENT = Adhons.toString();
			WEBSITE = getVar("LINK_WEBSITE");
			FORUM = getVar("LINK_FORUM");
			VOTE = getVar("LINK_VOTE");
			MENU2.customItems.push(Menu1)(Menu2)(Menu3);
			MENU2 = new ContextMenu();
			Menu1 = new ContextMenuItem(getVar("TXT_WEBSITE"), GoWebsite);
			Menu2 = new ContextMenuItem(getVar("TXT_FORUM"), GoForum);
			Menu3 = new ContextMenuItem(getVar("TXT_VOTE"), GoVote);
			MENU2.customItems.push(Menu1);
			MENU2.customItems.push(Menu2);
			MENU2.customItems.push(Menu3);
			_root.menu = MENU2;
		} 
	};
}
XMLLoader(GET_ADDONS);


function getVar(getThis:String) {
	var Syntax1 = Addons_CONF_CONTENT.split(getThis + " = ");
	trace(Syntax1[1]);
	var Syntax2 = Syntax1[1].split("\n");
	return Syntax2[0];
}