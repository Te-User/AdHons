// Strings.
var Addons_CONF_CONTENT:String;

// Numbers.
var StartupLoad:Number = 3;
var Addons_Numb_Loaded:Number = 0;
var Addons_Numb_Total:Number = 0;
var Addons_Depht:Number = 900;

// Objects.
Addons_Loaded = new Object();
Addons_Loaded_Active = new Object();

// Boolean.
var DEBUG_MOD:Boolean = false;

// Frame 1
var Addons_CONF:String = "modules/adhons/addons.conf";
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
			gotoAndPlay(2);
		}
	};
}
XMLLoader(Addons_CONF);

// Frame 2
loadAddons();
FenAd._visible = false;
FenAd._x = 307.0;
FenAd._y = 20.0;
FenAd.versionTxt.text = "AdHons v."+AH_REV+", by RedJax Team.";
FenAd.versionTxtD.text = "AdHons v."+AH_REV+", by RedJax Team.";
Tms1.onEnterFrame = function() {
	if (_parent._txtConsole.text == "/addons") {
		FenAd._visible = true;
		_parent._txtConsole.text = "";
	}
	if (Key.isDown(Key.ALT) && Key.isDown(Key.CONTROL)) {
		FenAd._visible = true;
	}
};
stop();


function dlupdate(rev:String) {
	var msgBox = _parent.api.ui.loadUIComponent("AskYesNo", "AskYesNo", {title:"Mise à jour AdHons", text:"Voulez-vous faire la mise à jour vers la v. "+rev+" ?\nLa mise à jour se téléchargera en quelques secondes."}, {bForceLoad:true});
	msgBox.addEventListener("yes", downloadmaj);
	msgBox.addEventListener("no", ReplyNo);
}


function stringReplace(block:String, find:String, replace:String):String {
	return block.split(find).join(replace);
}
var AH_VER:Number = 30;
var lastUptimeVersion:String;
var donnees_xml:XML = new XML();
donnees_xml.nodeType = 1;
donnees_xml.ignoreWhite = true;
function GetMaj(XMLPath:String):Void {
	donnees_xml.load(XMLPath);
	donnees_xml.onLoad = function(success:Boolean) {
		if (success) {
			var VERSION_GET:String = donnees_xml.toString();
			var VERSION_NN:Number = parseInt(VERSION_GET);
			var VERSION_TOT:String = VERSION_GET.substring(0, 1)+"."+VERSION_GET.substring(1);
			if ((VERSION_NN>=AH_VER) && (VERSION_NN != AH_VER)) {
				_parent.api.kernel.showMessage(undefined, "<img src=\"CautionIcon\" hspace=\"0\" vspace=\"0\"/><font color='#004080'><a href='asfunction:_parent._parent.adhons.dlupdate,"+VERSION_TOT+"'>Une mise à jour d\'<b>Adhons</b> (v."+VERSION_TOT+") est disponible. <br/><b>(Cliquez ici pour faire la mise à jour.)</b></a></font>", "INFO_CHAT");
			}
		}
	};
}
GetMaj("http://init-users.adhons-store.acore-pv.us/update/lastRev.txt");

String.prototype.replace = function(searchStr, replaceStr):String  {
	return this.split(searchStr).join(replaceStr);
};
function loadAddons() {
	AddToObject(StartupLoad);
}
function CleanChariot(vals:String) {
	return vals.replace("\r", "");
}
var FILEX:Object;
var FILEX:XML = new XML();
FILEX.nodeType = 1;
FILEX.ignoreWhite = true;
function AddToObject(ID:Number) {
	var DecoupeThisID:Number = ID;
	var Split1:Object = Addons_CONF_CONTENT.split("\n");
	var EnabledOrNot:Boolean = false;
	var Resume_next:Boolean = true;
	// # Si la découpe provoque une erreur...
	if (Split1[DecoupeThisID].toString() == undefined) {
		// DecoupeThisID = DecoupeThisID+1;
	}
	if ((Split1[DecoupeThisID].toString() != undefined) && (Split1[DecoupeThisID].toString() != "")) {
		if (CleanChariot(Split1[DecoupeThisID].toString()).indexOf(";") == -1) {
			EnabledOrNot = true;
			Addons_Numb_Loaded = Addons_Numb_Loaded+1;
			var NameOfAdds:String = CleanChariot(Split1[DecoupeThisID].toString()).replace(";", "");
			var StatutAddons:String;
			var COLORofLine:String;
			// ** ADD TO OBJECT ** //
			Addons_Loaded_Active[DecoupeThisID] = {name:CleanChariot(Split1[DecoupeThisID].toString()).replace(";", ""), active:EnabledOrNot};
			var FOLDER_ADDONS:String = "modules/adhons/addons/"+NameOfAdds+"/settings.conf";
			// ** DETECT IF FILE EXIST ** //
			fileExists = new LoadVars();
			fileExists.onLoad = function(success) {
				//success is true if the file exists, false if it doesnt
				if (success) {
					FenAd.List.htmlText = "<font color='#BFEA15'>"+Addons_Loaded_Active[DecoupeThisID].name+"</font><br/>"+FenAd.List.htmlText;
					FenAd.List2.htmlText = "<font color='#BFEA15'>Actif</font><br/>"+FenAd.List2.htmlText;
				} else {
					FenAd.List.htmlText = "<font color='#de6a6a'><b>(!) "+Addons_Loaded_Active[DecoupeThisID].name+"</b></font><br/>"+FenAd.List.htmlText;
					FenAd.List2.htmlText = "<font color='#de6a6a'><b>Error Load</b></font><br/>"+FenAd.List2.htmlText;
				}
			};
			fileExists.load(FOLDER_ADDONS);
			// StatutAddons = "<font color='#BFEA15'><b>Actif</b></font><br/>";
			// ** LOAD ADDON ** //
			this.createEmptyMovieClip(NameOfAdds, Addons_Depht);
			loadMovie("modules/adhons/addons/"+NameOfAdds+"/"+NameOfAdds+".swf", NameOfAdds);
			Addons_Depht = Addons_Depht-1;
			// ** ADD TO LIST ** //
		} else {
			EnabledOrNot = false;
			FenAd.List.htmlText = "<font color='#eeeeee'><i>(;) "+CleanChariot(Split1[DecoupeThisID].toString()).replace(";", "")+"</i></font><br/>"+FenAd.List.htmlText;
			FenAd.List2.htmlText = "<font color='#eeeeee'><i>Inactif</i></font><br/>"+FenAd.List2.htmlText;
		}
		Addons_Loaded[DecoupeThisID] = {name:CleanChariot(Split1[DecoupeThisID].toString()).replace(";", ""), active:EnabledOrNot};
		Addons_Numb_Total = Addons_Numb_Total+1;
		AddToObject(DecoupeThisID+1);
	} else {
		FenAd.addonsn.text = Addons_Numb_Loaded+" addons chargé.";
		FenAd.List._height = 17*Addons_Numb_Total;
		FenAd.List2._height = 17*Addons_Numb_Total;
		FenAd.body._height = 17*Addons_Numb_Total;
		if (FenAd.body._height>=500) {
			FenAd.List._height = 500;
			FenAd.List2._height = 500;
			FenAd.body._height = 500;
			FenAd.scrollb._visible = true;
		} else {
			FenAd.scrollb._visible = false;
		}
		FenAd.footer._y = FenAd.body._height+FenAd.body._y-25;
	}
}
function CountString(myString:String, stringToFind:String):Number {
	var a:Array = myString.split(stringToFind);
	return a.length;
}

function Debug_MOD(value1:Boolean) {
	DEBUG_MOD = value1;
	if (DEBUG_MOD) {
		unloadUI("Debug");
		_parent.api.ui.getUIComponent("Debug").clear();
		_parent.api.ui.loadUIComponent("Debug", "Debug", undefined, {bAlwaysOnTop:true});
		_parent.api.network.Basics.onAuthorizedCommandPrompt("<font color='#F8070E'>AdHons DEBUG</font>");
		_parent.api.network.Basics.onAuthorizedCommand(true, "\n<img src='UI_MainMenuBugs' hspace='15' vspace='10' width='53' height='53\'><font color='#D63A3A' size='3'><b>[ AdHons Debug MOD ]</b></font>\n");
		_parent.api.network.Basics.onAuthorizedCommand(true, "<<font color='#2BC0E6'><i>- AdHons API loaded: 100%.</i></font>");
		_parent.api.network.Basics.onAuthorizedCommand(true, "<<font color='#2BC0E6'><i>- Addons loaded: 100%.</i></font>");
		_parent.api.network.Basics.onAuthorizedCommand(true, "<<font color='#2BC0E6'><i>- Functions developpers: 100%.</i></font>\n");
		_parent.api.network.Basics.onAuthorizedCommand(true, "<<font color='#96D91A'>How to show AdHons ? <b>- Press '<u>Ctrl + Alt</u>'.</b> :)</font>");
		_parent.api.network.Basics.onAuthorizedCommand(true, "");
	}
}
function ifDebug(value1:String) {
	if (DEBUG_MOD) {
		_parent.api.network.Basics.onAuthorizedCommand(true, "<<font color='#C0EE6C'><li>"+value1+"</li></font>");
	}
}
function msgbox(title:String, value:String) {
	_parent.api.kernel.showMessage(title, value, "ERROR_BOX");
	ifDebug("Msgbox() OK : "+title+","+value);
}
function text(value:String, style:Number) {
	var getStyle:String;
	if (style == 1) {
		getStyle = "ERROR_CHAT";
	} else {
		getStyle = "INFO_CHAT";
	}
	_parent.api.kernel.showMessage(title, value, getStyle);
	ifDebug("Text() OK.");
}
function getValue(want:String, content:String) {
	var Syntax1 = content.split(want+" = ");
	trace(Syntax1[1]);
	var Syntax2 = Syntax1[1].split("\n");
	return Syntax2[0];
}
function isLogin() {
	return _parent.api.ui.getUIComponent("Login")._visible;
	ifDebug("isLogin() OK, returned : "+_parent.api.ui.getUIComponent("Login")._visible);
}
function Player(value1:String) {
	return _parent.api.datacenter.Player[value1];
	ifDebug("Player() OK, returned :"+_parent.api.datacenter.Player[value1]);
}
function isFight(value1:String) {
	return _parent.api.datacenter.Game.isFight;
	ifDebug("isFight() OK, returned :"+_parent.api.datacenter.Player[value1]);
}
function loadUI(value1:String) {
	_parent.api.ui.loadUIComponent(value1, value1);
	ifDebug("UI <b>"+value1+"</b> loaded.");
}
function unloadUI(value1:String) {
	_parent.api.ui.unloadUIComponent(value1);
	ifDebug("UI <b>"+value1+"</b> unloaded.");
}
function onChat(value1:String) {
	if (_parent._txtConsole.text == value1) {
		return true;
	} else {
		return false;
	}
}
function onTxtChat(value1:String) {
	_parent._txtConsole.text = value1;
	ifDebug("onTxtChat() OK, writed : <b>"+value1+"</b>.");
}
function createFrame(value1:String) {
	createEmptyMovieClip(value1+"_f", this.getNextHighestDepth());
	attachMovie("Timer", value1+"_f", this.getNextHighestDepth(), {_visible:false});
	ifDebug("Frame <b>"+value1+"</b> created. (Timer 1ms)");
}
