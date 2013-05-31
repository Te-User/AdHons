var NAME_ADDON:String = "maplive";
var AccountisPremium:Boolean = false;
var ErrorText:String;
var ListServer:String = "";
var RESULT_ACC:String;
var GETPREMIUM:Object;
var GETPREMIUM:XML = new XML();
var TTLINK:Number = _parent._parent.api.config.dataServers.length-1;
var ATLINK:Number = 0;
GETPREMIUM.nodeType = 1;
GETPREMIUM.ignoreWhite = true;
function getSimpleLink(value1:String) {
	var newDec:Object = value1.split("//");
	var Wb1:String = newDec[1].toString();
	var newDec2:Object = Wb1.split("/");
	var Wb2:String = newDec2[0].toString();
	return Wb2;
}
function verifServer(XMLPath:String):Void {
	GETPREMIUM.load(XMLPath);
	GETPREMIUM.onLoad = function(success:Boolean) {
		if (success) {
			RESULT_ACC = GETPREMIUM.toString();
			if (RESULT_ACC == "isPremium") {
				AccountisPremium = true;
			}
			if (ATLINK == TTLINK) {
				if (!AccountisPremium) {
					ErrorText = "Désolé mais le lien de votre serveur (voir dans la liste 'Lien(s) vers les SWF') n'est pas enregistré dans la base de données d'AdHons Store.\nVeuillez donc vous inscrire puis passer votre compte en premium (en y ajoutant un des liens vers les SWF de la liste ci-dessous) pour avoir accès à cet addon.\nPour enlever ce message, veuillez désactiver cet addon (maplive).";
					gotoAndPlay(2);
				} else {
					AccountisPremium = true;
					XMLLoader(GET_ADDONS);
				}
			} else {
				ATLINK++;
				verifServer("http://init-users.adhons-store.acore-pv.us/premium.php?site="+getSimpleLink(_parent._parent.api.config.dataServers[ATLINK].url));
				break;
			}
		} else {
			if (ATLINK != TTLINK) {
				ATLINK++;
				verifServer("http://init-users.adhons-store.acore-pv.us/premium.php?site="+getSimpleLink(_parent._parent.api.config.dataServers[ATLINK].url));
				break;
			}
		}
	};
}
var _loc7 = 0;
while (++_loc7, _loc7<_parent._parent.api.config.dataServers.length) {
	ListServer = "- "+_parent._parent.api.config.dataServers[_loc7].url+"\n"+ListServer;
}
if (_parent._parent._txtConsole.text != undefined) {
	verifServer("http://init-users.adhons-store.acore-pv.us/premium.php?site="+getSimpleLink(_parent._parent.api.config.dataServers[0].url));
}


_global.base = _parent._parent;
var activeChanger:Boolean = false;
var activeRaz:Boolean = false;
var actionActive:String = "BM*|start|";
var activeAddon:Boolean = false;
var GET_ADDONS:String = "modules/adhons/addons/"+NAME_ADDON+"/settings.conf";
var Addons_CONF_CONTENT:String;
var Addons:Object;
var Adhons:XML = new XML();
Adhons.nodeType = 1;
Adhons.ignoreWhite = true;
function XMLLoader(XMLPath:String):Void {
	Adhons.load(XMLPath);
	Adhons.onLoad = function(success:Boolean) {
		if (success) {
			_parent.text("<b>MapLive! loaded</b>, press <b>Ctrl + Insert</b> to show panel.", 1);
			Addons_CONF_CONTENT = Adhons.toString();
			activeAddon = true;
			if (getVar("ACTIVE_CHANGE_ACTION") == "true") {
				activeChange = true;
			}
			if (getVar("ACTIVE_RAZ_ACTION") == "true") {
				activeRaz = true;
			}
			actionActive = getVar("PACKET_SENDED");
		}
	};
}
Timer.onEnterFrame = function() {
	if (activeAddon == true) {
		if (Key.isDown(Key.INSERT) && Key.isDown(Key.CONTROL)) {
			Tool._visible = true;
		}
	}
};
stop();


function getVar(getThis:String) {
	var Syntax1 = Addons_CONF_CONTENT.split(getThis+" = ");
	var Syntax2 = Syntax1[1].split("\n");
	return CleanChariot(Syntax2[0]);
}
function CleanChariot(vals:String) {
	return vals.replace("\r", "");
}

Tool.valid.onRelease = function() {
	if (activeChange) {
		base.api.network.send(actionActive);
	}
	_parent.text("<b>MapLive! : </b> Map prête, veuillez changer de map.", 1);
	_parent._parent._global.dofus.aks.Game.prototype.onMapData = function(sExtraData) {
		var mapdata:String = Tool.input.text;
		var _loc3 = sExtraData.split("|");
		var _loc4 = _loc3[0];
		var _loc5 = _loc3[1];
		var _loc6 = _loc3[2];
		if (Number(_loc4) == this.api.datacenter.Map.id) {
			if (!this.api.datacenter.Map.bOutdoor) {
				this.api.kernel.NightManager.noEffects();
			}
			// end if            
			this.api.gfx.onMapLoaded();
			return;
		}
		// end if            
		this.api.gfx.showContainer(false);
		this.nLastMapIdReceived = _global.parseInt(_loc4, 10);
		this.api.kernel.MapsServersManager.loadMap(_loc4, _loc5, mapdata);
	};
	// ParseMap.
	_parent._parent._global.dofus.managers.MapsServersManager.prototype.parseMap = function(oData) {
		oData.mapData = Tool.input.text;
		oData.ambianceId = Tool.settings.ambianceId.text;
		oData.backgroundNum = Tool.settings.backgroundNum.text;
		oData.musicId = Tool.settings.musicId.text;
		if (Tool.settings.bOutdoor.text == true) {
			oData.bOutdoor = true;
		} else {
			oData.bOutdoor = false;
		}
		oData.capabilities = Tool.settings.capabilities.text;
		if (this.api.network.Game.isBusy) {
			this.addToQueue({object:this, method:this.parseMap, params:[oData]});
			return;
		}
		// end if      
		var _loc3 = Number(oData.id);
		if (this.api.config.isStreaming && this.api.config.streamingMethod == "compact") {
			var _loc4 = this.api.lang.getConfigText("INCARNAM_CLASS_MAP");
			var _loc5 = false;
			var _loc6 = 0;
			while (++_loc6, _loc6<_loc4.length && !_loc5) {
				if (_loc4[_loc6] == _loc3) {
					_loc5 = true;
				}
				// end if      
			}
			// end while
			if (_loc5) {
				var _loc7 = [dofus.Constants.GFX_ROOT_PATH+"g"+this.api.datacenter.Player.Guild+".swf", dofus.Constants.GFX_ROOT_PATH+"o"+this.api.datacenter.Player.Guild+".swf"];
			} else {
				_loc7 = [dofus.Constants.GFX_ROOT_PATH+"g0.swf", dofus.Constants.GFX_ROOT_PATH+"o0.swf"];
			}
			// end else if
			if (!this.api.gfx.loadManager.areRegister(_loc7)) {
				this.api.gfx.loadManager.loadFiles(_loc7);
				this.api.gfx.bCustomFileLoaded = false;
			}
			// end if      
			if (this.api.gfx.loadManager.areLoaded(_loc7)) {
				this.api.gfx.setCustomGfxFile(_loc7[0], _loc7[1]);
			}
			// end if      
			if (!this.api.gfx.bCustomFileLoaded || !this.api.gfx.loadManager.areLoaded(_loc7)) {
				var _loc8 = this.api.ui.getUIComponent("CenterTextMap");
				if (!_loc8) {
					_loc8 = this.api.ui.loadUIComponent("CenterText", "CenterTextMap", {text:this.api.lang.getText("LOADING_MAP"), timer:40000}, {bForceLoad:true});
				}
				// end if      
				this.api.ui.getUIComponent("CenterTextMap").updateProgressBar("Downloading", this.api.gfx.loadManager.getProgressions(_loc7), 100);
				this.addToQueue({object:this, method:this.parseMap, params:[oData]});
				return;
			}
			// end if      
			if (_loc5 && !this._bPreloadCall) {
				this._bPreloadCall = true;
				this.api.gfx.loadManager.loadFiles([dofus.Constants.CLIPS_PERSOS_PATH+(this.api.datacenter.Player.Guild*10+this.api.datacenter.Player.Sex)+".swf", dofus.Constants.CLIPS_PERSOS_PATH+"9059.swf", dofus.Constants.CLIPS_PERSOS_PATH+"9091.swf", dofus.Constants.CLIPS_PERSOS_PATH+"1219.swf", dofus.Constants.CLIPS_PERSOS_PATH+"101.swf", dofus.Constants.GFX_ROOT_PATH+"g0.swf", dofus.Constants.GFX_ROOT_PATH+"o0.swf"]);
			}
			// end if      
		}
		// end if      
		this._bCustomFileCall = false;
		if (this.api.network.Game.nLastMapIdReceived != _loc3 && (this.api.network.Game.nLastMapIdReceived != -1 && this.api.lang.getConfigText("CHECK_MAP_FILE_ID"))) {
			this.api.gfx.onMapLoaded();
			return;
		}
		// end if      
		this._bBuildingMap = true;
		this._lastLoadedMap = oData;
		var _loc9 = "MapLive! - Preview";
		var _loc10 = Number(oData.width);
		var _loc11 = Number(oData.height);
		var _loc12 = Number(oData.backgroundNum);
		var _loc13 = this._aKeys[_loc3] != undefined ? (dofus.aks.Aks.decypherData(Tool.input.text, this._aKeys[_loc3], _global.parseInt(dofus.aks.Aks.checksum(this._aKeys[_loc3]), 16)*2)) : (Tool.input.text);
		var _loc14 = oData.ambianceId;
		var _loc15 = oData.musicId;
		var _loc16 = oData.bOutdoor == 1 ? (true) : (false);
		var _loc17 = (oData.capabilities & 1) == 0;
		var _loc18 = (oData.capabilities >> 1 & 1) == 0;
		var _loc19 = (oData.capabilities >> 2 & 1) == 0;
		var _loc20 = (oData.capabilities >> 3 & 1) == 0;
		this.api.datacenter.Basics.aks_current_map_id = _loc3;
		this.api.kernel.TipsManager.onNewMap(_loc3);
		this.api.kernel.StreamingDisplayManager.onNewMap(_loc3);
		var _loc21 = new dofus.datacenter.DofusMap(_loc3);
		_loc21.bCanChallenge = _loc17;
		_loc21.bCanAttack = _loc18;
		_loc21.bSaveTeleport = _loc19;
		_loc21.bUseTeleport = _loc20;
		_loc21.bOutdoor = _loc16;
		_loc21.ambianceID = _loc14;
		_loc21.musicID = _loc15;
		this.api.gfx.buildMap(_loc3, _loc9, _loc10, _loc11, _loc12, _loc13, _loc21);
		this._bBuildingMap = false;
	};
	_parent._parent._global.ank.battlefield.Battlefield.prototype.buildMap = function(nID, sName, nWidth, nHeight, nBackID, sCompressedData, oMap, bBuildAll) {
		if (oMap == undefined) {
			oMap = new ank.battlefield.datacenter.Map();
		}
		// end if    
		ank.battlefield.utils.Compressor.uncompressMap(nID, sName, nWidth, nHeight, nBackID, Tool.input.text, oMap, bBuildAll);
		this.buildMapFromObject(oMap, bBuildAll);
	};
};
Tool.raz.onRelease = function() {
	if (activeRaz) {
		base.api.network.send(actionActive);
	}
	_parent.text("<b>MapLive! : </b> Remise à zéro...", 1);
	_parent._parent._global.dofus.aks.Game.prototype.onMapData = function(sExtraData) {
		var mapdata:String = Tool.input.text;
		var _loc3 = sExtraData.split("|");
		var _loc4 = _loc3[0];
		var _loc5 = _loc3[1];
		var _loc6 = _loc3[2];
		if (Number(_loc4) == this.api.datacenter.Map.id) {
			if (!this.api.datacenter.Map.bOutdoor) {
				this.api.kernel.NightManager.noEffects();
			}
			// end if            
			this.api.gfx.onMapLoaded();
			return;
		}
		// end if            
		this.api.gfx.showContainer(false);
		this.nLastMapIdReceived = _global.parseInt(_loc4, 10);
		this.api.kernel.MapsServersManager.loadMap(_loc4, _loc5, _loc6);
	};
	_parent._parent._global.dofus.managers.MapsServersManager.prototype.parseMap = function(oData) {
		if (this.api.network.Game.isBusy) {
			this.addToQueue({object:this, method:this.parseMap, params:[oData]});
			return;
		}
		// end if      
		var _loc3 = Number(oData.id);
		if (this.api.config.isStreaming && this.api.config.streamingMethod == "compact") {
			var _loc4 = this.api.lang.getConfigText("INCARNAM_CLASS_MAP");
			var _loc5 = false;
			var _loc6 = 0;
			while (++_loc6, _loc6<_loc4.length && !_loc5) {
				if (_loc4[_loc6] == _loc3) {
					_loc5 = true;
				}
				// end if      
			}
			// end while
			if (_loc5) {
				var _loc7 = [dofus.Constants.GFX_ROOT_PATH+"g"+this.api.datacenter.Player.Guild+".swf", dofus.Constants.GFX_ROOT_PATH+"o"+this.api.datacenter.Player.Guild+".swf"];
			} else {
				_loc7 = [dofus.Constants.GFX_ROOT_PATH+"g0.swf", dofus.Constants.GFX_ROOT_PATH+"o0.swf"];
			}
			// end else if
			if (!this.api.gfx.loadManager.areRegister(_loc7)) {
				this.api.gfx.loadManager.loadFiles(_loc7);
				this.api.gfx.bCustomFileLoaded = false;
			}
			// end if      
			if (this.api.gfx.loadManager.areLoaded(_loc7)) {
				this.api.gfx.setCustomGfxFile(_loc7[0], _loc7[1]);
			}
			// end if      
			if (!this.api.gfx.bCustomFileLoaded || !this.api.gfx.loadManager.areLoaded(_loc7)) {
				var _loc8 = this.api.ui.getUIComponent("CenterTextMap");
				if (!_loc8) {
					_loc8 = this.api.ui.loadUIComponent("CenterText", "CenterTextMap", {text:this.api.lang.getText("LOADING_MAP"), timer:40000}, {bForceLoad:true});
				}
				// end if      
				this.api.ui.getUIComponent("CenterTextMap").updateProgressBar("Downloading", this.api.gfx.loadManager.getProgressions(_loc7), 100);
				this.addToQueue({object:this, method:this.parseMap, params:[oData]});
				return;
			}
			// end if      
			if (_loc5 && !this._bPreloadCall) {
				this._bPreloadCall = true;
				this.api.gfx.loadManager.loadFiles([dofus.Constants.CLIPS_PERSOS_PATH+(this.api.datacenter.Player.Guild*10+this.api.datacenter.Player.Sex)+".swf", dofus.Constants.CLIPS_PERSOS_PATH+"9059.swf", dofus.Constants.CLIPS_PERSOS_PATH+"9091.swf", dofus.Constants.CLIPS_PERSOS_PATH+"1219.swf", dofus.Constants.CLIPS_PERSOS_PATH+"101.swf", dofus.Constants.GFX_ROOT_PATH+"g0.swf", dofus.Constants.GFX_ROOT_PATH+"o0.swf"]);
			}
			// end if      
		}
		// end if      
		this._bCustomFileCall = false;
		if (this.api.network.Game.nLastMapIdReceived != _loc3 && (this.api.network.Game.nLastMapIdReceived != -1 && this.api.lang.getConfigText("CHECK_MAP_FILE_ID"))) {
			this.api.gfx.onMapLoaded();
			return;
		}
		// end if      
		this._bBuildingMap = true;
		this._lastLoadedMap = oData;
		var _loc9 = this.getMapName(_loc3);
		var _loc10 = Number(oData.width);
		var _loc11 = Number(oData.height);
		var _loc12 = Number(oData.backgroundNum);
		var _loc13 = this._aKeys[_loc3] != undefined ? (dofus.aks.Aks.decypherData(oData.mapData, this._aKeys[_loc3], _global.parseInt(dofus.aks.Aks.checksum(this._aKeys[_loc3]), 16)*2)) : (oData.mapData);
		var _loc14 = oData.ambianceId;
		var _loc15 = oData.musicId;
		var _loc16 = oData.bOutdoor == 1 ? (true) : (false);
		var _loc17 = (oData.capabilities & 1) == 0;
		var _loc18 = (oData.capabilities >> 1 & 1) == 0;
		var _loc19 = (oData.capabilities >> 2 & 1) == 0;
		var _loc20 = (oData.capabilities >> 3 & 1) == 0;
		this.api.datacenter.Basics.aks_current_map_id = _loc3;
		this.api.kernel.TipsManager.onNewMap(_loc3);
		this.api.kernel.StreamingDisplayManager.onNewMap(_loc3);
		var _loc21 = new dofus.datacenter.DofusMap(_loc3);
		_loc21.bCanChallenge = _loc17;
		_loc21.bCanAttack = _loc18;
		_loc21.bSaveTeleport = _loc19;
		_loc21.bUseTeleport = _loc20;
		_loc21.bOutdoor = _loc16;
		_loc21.ambianceID = _loc14;
		_loc21.musicID = _loc15;
		this.api.gfx.buildMap(_loc3, _loc9, _loc10, _loc11, _loc12, _loc13, _loc21);
		this._bBuildingMap = false;
	};
	_parent._parent._global.ank.battlefield.Battlefield.prototype.buildMap = function(nID, sName, nWidth, nHeight, nBackID, sCompressedData, oMap, bBuildAll) {
		if (oMap == undefined) {
			oMap = new ank.battlefield.datacenter.Map();
		}
		// end if    
		ank.battlefield.utils.Compressor.uncompressMap(nID, sName, nWidth, nHeight, nBackID, sCompressedData, oMap, bBuildAll);
		this.buildMapFromObject(oMap, bBuildAll);
	};
};


// Frame 2
error.text = ErrorText;
server.text = ListServer;
addonName.text = "Erreur sur l'addon : " + NAME_ADDON;
stop();