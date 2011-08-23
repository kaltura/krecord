/*
   // ===================================================================================================
   //                           _  __     _ _
   //                          | |/ /__ _| | |_ _  _ _ _ __ _
   //                          | ' </ _` | |  _| || | '_/ _` |
   //                          |_|\_\__,_|_|\__|\_,_|_| \__,_|
   //
   // This file is part of the Kaltura Collaborative Media Suite which allows users
   // to do with audio, video, and animation what Wiki platfroms allow them to do with
   // text.
   //
   // Copyright (C) 2006-2008  Kaltura Inc.
   //
   // This program is free software: you can redistribute it and/or modify
   // it under the terms of the GNU Affero General Public License as
   // published by the Free Software Foundation, either version 3 of the
   // License, or (at your option) any later version.
   //
   // This program is distributed in the hope that it will be useful,
   // but WITHOUT ANY WARRANTY; without even the implied warranty of
   // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   // GNU Affero General Public License for more details.
   //
   // You should have received a copy of the GNU Affero General Public License
   // along with this program.  If not, see <http://www.gnu.org/licenses/>.
   //
   // @ignore
   // ===================================================================================================
 */
package
{

	import com.kaltura.KalturaClient;
	import com.kaltura.base.vo.KalturaEntry;
	import com.kaltura.config.KalturaConfig;
	import com.kaltura.devicedetection.DeviceDetectionEvent;
	import com.kaltura.net.streaming.events.ExNetConnectionEvent;
	import com.kaltura.net.streaming.events.FlushStreamEvent;
	import com.kaltura.net.streaming.events.RecordNetStreamEvent;
	import com.kaltura.recording.business.BaseRecorderParams;
	import com.kaltura.recording.controller.KRecordControl;
	import com.kaltura.recording.controller.events.AddEntryEvent;
	import com.kaltura.recording.controller.events.RecorderEvent;
	import com.kaltura.recording.view.KRecordViewParams;
	import com.kaltura.recording.view.UIComponent;
	import com.kaltura.recording.view.View;
	import com.kaltura.recording.view.ViewEvent;
	import com.kaltura.recording.view.ViewState;
	import com.kaltura.recording.view.ViewStatePreview;
	import com.kaltura.utils.KConfigUtil;
	import com.kaltura.utils.KUtils;
	import com.kaltura.utils.ObjectHelpers;
	import com.kaltura.vo.KalturaMediaEntry;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.system.Security;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Timer;
	
	import mx.core.Application;
	import mx.utils.ObjectUtil;

	[SWF(width='320', height='240', frameRate='30', backgroundColor='#999999')]
	[Frame(factoryClass="ApplicationLoader")]

	public class KRecord extends Sprite
	{
		public var pushParameters:Object;

		private var recordControl:KRecordControl=new KRecordControl();
		public var autoPreview:Boolean=false;

		
		private var _message:TextField;
		
		private var _showErrorMessege:Boolean;
		
		private var _view:View=new View;
		private var _newViewState:String;
		/**
		 * limit in seconds to recording time. 0 means no limit 
		 */
		private var _limitRecord:Number = 0 ;
		/**
		 * The timer for the recording limitation  
		 */
		private var _limitRecordTimer:Timer;

		
		public static const VERSION:String = "v1.5.3"; 
		
		/**
		 *Constructor.
		 * @param init		if true will automatically call startApplication and initialize application.
		 *
		 */
		public function KRecord(init:Boolean=true):void
		{
			trace("version:",VERSION);
			Global.RECORD_CONTROL=recordControl;
//		if (init)
//			addEventListener(Event.ADDED_TO_STAGE, startApplication);
			addEventListener(Event.ADDED_TO_STAGE, build);
		}

		private function build(evt:Event=null):void
		{
			Security.allowDomain("*");
			
			var customContextMenu:ContextMenu=new ContextMenu();
			customContextMenu.hideBuiltInItems();
			var menuItem:ContextMenuItem=new ContextMenuItem(VERSION);
			customContextMenu.customItems.push(menuItem);

			stageResize(null);
			
			var initParams:KRecordViewParams;
			//read flashVars (uses these lines only when flashVars and ExternalInterface control is needed):
			var paramObj:Object = !pushParameters ? root.loaderInfo.parameters : pushParameters;
			var appparams:Object=ObjectHelpers.lowerNoUnderscore(paramObj);
			if(appparams.showui=="false"){
				UIComponent.visibleSkin=false
			}
			if(appparams.showerrormessege=="true" || appparams.showerrormessege=="1"){
				_showErrorMessege=true
			}
			// view params:
			var themeUrl:String=KConfigUtil.getDefaultValue(appparams.themeurl, "skin.swf");
			var localeUrl:String=KConfigUtil.getDefaultValue(appparams.localeurl, "locale.xml");
			var autoPreview:String=KConfigUtil.getDefaultValue(appparams.autopreview, "1");
			if(appparams.showpreviewtimer=="true" || appparams.showpreviewtimer =="0" )
				Global.SHOW_PREVIEW_TIMER = true;
			Global.REMOVE_PLAYER=(appparams.removeplayer=="1" || appparams.removeplayer=="true");
			initParams = new KRecordViewParams(themeUrl, localeUrl, autoPreview);

			var configuration : KalturaConfig = new KalturaConfig();
			configuration.partnerId = appparams.pid;
			configuration.ignoreNull = 1;
			configuration.domain = KUtils.hostFromCode(appparams.host); 
			configuration.srvUrl = "api_v3/index.php"
			configuration.ks = appparams.ks;
				
			if (!appparams.httpprotocol)
			{
				var url:String = root.loaderInfo.url;			
				configuration.protocol = isHttpURL(url) ? getProtocol(url) : "http";  			
			}else
			{
				configuration.protocol = appparams.httpprotocol;
			}
			configuration.protocol +="://";
			
			Global.KALTURA_CLIENT = new KalturaClient(configuration);
			
			Global.DISABLE_GLOBAL_CLICK = (appparams.disableglobalclick=="1" || appparams.disableglobalclick=="true"); 
			Global.VIEW_PARAMS=initParams;
			_view.addEventListener(ViewEvent.VIEW_READY, startApplication);
			addChild(_view);

		}

		public static function isHttpURL(url:String):Boolean
		{
			return url != null &&
				(url.indexOf("http://") == 0 ||
					url.indexOf("https://") == 0);
		}
		
		private function onStartRecord(evt:ViewEvent):void
		{
			startRecording();
			_newViewState="recording";
			if (!recordControl.connecting)
				_view.setState(_newViewState);
			limitRecording();
		}
		/**
		 * Stop recording automatically. 
		 * This function is here so we dont change the signature of  stopRecording function
		 * @param evt
		 * 
		 */		
		private function onRecordTimeComplete(evt:TimerEvent):void
		{
			trace("AUTO STOP AFTER ",_limitRecord," SECONDS")
			stopRecording();
			callInterfaceDelegate("autoStopRecord",_limitRecord);
		}
		
		

		private function onReRecord(evt:ViewEvent):void
		{
			startRecording();
			_newViewState="recording";
			if (!recordControl.connecting)
				_view.setState(_newViewState);
		}

		private function onStopRecord(evt:ViewEvent=null):void
		{
			stopRecording();
			_newViewState="preview";
			if (!recordControl.connecting)
				_view.setState(_newViewState);
		}


		public static function getProtocol(url:String):String
		{
			var slash:int = url.indexOf("/");
			var indx:int = url.indexOf(":/");
			if (indx > -1 && indx < slash)
			{
				return url.substring(0, indx);
			}
			else
			{
				indx = url.indexOf("::");
				if (indx > -1 && indx < slash)
					return url.substring(0, indx);
			}
			
			return "";
		}
		
		private function onSave(evt:ViewEvent):void
		{
			recordControl.stopPreviewRecording();
			// get entry flashvars:
			if (ExternalInterface.available)
			{
				try
				{
					var paramObj:Object = !pushParameters ? root.loaderInfo.parameters : pushParameters;
					var appparams:Object=ObjectHelpers.lowerNoUnderscore(paramObj);
					var entryName:String=KConfigUtil.getDefaultValue(appparams.entryname, "");
					var entryTags:String=KConfigUtil.getDefaultValue(appparams.entrytags, "");
					var entryDescription:String=KConfigUtil.getDefaultValue(appparams.entrydescription, "");
					var creditsScreenName:String=KConfigUtil.getDefaultValue(appparams.creditsscreenName, "");
					var creditsSiteUrl:String=KConfigUtil.getDefaultValue(appparams.creditssiteUrl, "");
					var categories:String=KConfigUtil.getDefaultValue(appparams.categories, "");
					var adminTags:String=KConfigUtil.getDefaultValue(appparams.admintags, "");
					var licenseType:String=KConfigUtil.getDefaultValue(appparams.licensetype, "");
					var credit:String=KConfigUtil.getDefaultValue(appparams.credit, "");
					var groupId:String=KConfigUtil.getDefaultValue(appparams.groupid, "");
					var partnerData:String=KConfigUtil.getDefaultValue(appparams.partnerdata, "");

					addEntry(entryName, entryTags, entryDescription, creditsScreenName, creditsSiteUrl,categories, adminTags, licenseType, credit, groupId, partnerData)
				}
				catch (err:Error)
				{
					trace('Error reading flashVars and initializing KRecord via html and JS');
				}
			}
			else
			{
				addEntry("", "", "", "", "", "", "", "", "", "", "");
			}

			trace("SAVE");
		}


		/**
		 * initializes the application.
		 */
		public function startApplication(event:Event=null):void
		{
			if (Global.PRELOADER && Global.PRELOADER.parent)
			{
				Global.PRELOADER.parent.removeChild(Global.PRELOADER);
				Global.PRELOADER=null;
			}

			_view.showPopupMessage(Global.LOCALE.getString("Dialog.Connecting"));
			_view.addEventListener(ViewEvent.RECORD_START, onStartRecord);
			_view.addEventListener(ViewEvent.RECORD_STOP, onStopRecord);
			_view.addEventListener(ViewEvent.PREVIEW_SAVE, onSave);
			_view.addEventListener(ViewEvent.PREVIEW_RERECORD, onReRecord);

			stage.align=StageAlign.TOP_LEFT;
			stage.scaleMode=StageScaleMode.NO_SCALE;
			var initParams:BaseRecorderParams;
			//read flashVars (uses these lines only when flashVars and ExternalInterface control is needed):
			if (ExternalInterface.available)
			{
				try
				{
					var paramObj:Object = !pushParameters ? root.loaderInfo.parameters : pushParameters;
					var appparams:Object=ObjectHelpers.lowerNoUnderscore(paramObj);
					autoPreview= !(appparams.autopreview=="0" || appparams.autopreview=="false");
					_limitRecord= KConfigUtil.getDefaultValue(appparams.limitrecord,0);
					var hostUrl:String=KConfigUtil.getDefaultValue(appparams.host, "http://www.kaltura.com");
					var rtmpHost:String=KConfigUtil.getDefaultValue(appparams.rtmphost, "rtmp://www.kaltura.com");
					var ks:String=KConfigUtil.getDefaultValue(appparams.ks, "");
					var pid:String=KConfigUtil.getDefaultValue(appparams.pid, "");
					var subpid:String=KConfigUtil.getDefaultValue(appparams.subpid, "");
					var uid:String=KConfigUtil.getDefaultValue(appparams.uid, "");
					var kshowId:String=KConfigUtil.getDefaultValue(appparams.kshowid, "-1");
					var fmsApp:String=KConfigUtil.getDefaultValue(appparams.fmsapp, "oflaDemo");
					//init KRecord parameters:
					initParams=new BaseRecorderParams(hostUrl, rtmpHost, ks, pid, subpid, uid, kshowId, fmsApp);
					// Register External call

					ExternalInterface.addCallback("stopRecording", stopRecording);
					ExternalInterface.addCallback("startRecording", startRecording);
					ExternalInterface.addCallback("previewRecording", previewRecording);
					ExternalInterface.addCallback("stopPreviewRecording", stopPreviewRecording);
					ExternalInterface.addCallback("addEntry", addEntry);
					ExternalInterface.addCallback("getRecordedTime", getRecordedTime);
					ExternalInterface.addCallback("setQuality", setQuality);
					ExternalInterface.addCallback("getMicrophones", getMicrophones);
					ExternalInterface.addCallback("getMicrophoneActivityLevel", getMicrophoneActivityLevel);
					ExternalInterface.addCallback("getMicrophoneGain", getMicrophoneGain);
					ExternalInterface.addCallback("setMicrophoneGain", setMicrophoneGain);
					ExternalInterface.addCallback("getCameras", getCameras);
					ExternalInterface.addCallback("setActiveCamera", setActiveCamera);
					ExternalInterface.addCallback("setActiveMicrophone", setActiveMicrophone);

					ExternalInterface.marshallExceptions=true;
					trace('flashVars caught and JS functions registered to wrapper.\n' + 'objectId - ' + ExternalInterface.objectID);

				}
				catch (err:Error)
				{
					trace('Error reading flashVars and initializing KRecord via html and JS');
				}
			}
			else
			{
				//init KRecord parameters, use this line in cases where you don't use flashVars and external JS control:
				initParams=new BaseRecorderParams('http://www.kaltura.com', 'rtmp://www.kaltura.com', '', '', '', '', '-1', 'oflaDemo');
			}

			recordControl.initRecorderParameters=initParams;
			recordControl.addEventListener(DeviceDetectionEvent.DETECTED_CAMERA, deviceDetected);
			recordControl.addEventListener(DeviceDetectionEvent.DETECTED_MICROPHONE, deviceDetected);
			recordControl.addEventListener(DeviceDetectionEvent.ERROR_CAMERA, deviceError);
			
			recordControl.addEventListener(DeviceDetectionEvent.MIC_DENIED, deviceError);
			recordControl.addEventListener(DeviceDetectionEvent.ERROR_MICROPHONE, deviceError);
			recordControl.addEventListener(ExNetConnectionEvent.NETCONNECTION_CONNECT_SUCCESS, connected);
			recordControl.addEventListener(ExNetConnectionEvent.NETCONNECTION_CONNECT_FAILED, connectionError);
			recordControl.addEventListener(ExNetConnectionEvent.NETCONNECTION_CONNECT_CLOSED, connectionError);
			recordControl.addEventListener(RecordNetStreamEvent.NETSTREAM_RECORD_START, recordStart);
			
			recordControl.addEventListener(FlushStreamEvent.FLUSH_START, flushHandler);
			recordControl.addEventListener(FlushStreamEvent.FLUSH_PROGRESS, flushHandler);
			recordControl.addEventListener(FlushStreamEvent.FLUSH_COMPLETE, flushHandler);
			
			recordControl.addEventListener(RecordNetStreamEvent.NETSTREAM_PLAY_COMPLETE, previewEndHandler);
			
			recordControl.addEventListener(AddEntryEvent.ADD_ENTRY_RESULT, addEntryComplete);
			recordControl.addEventListener(AddEntryEvent.ADD_ENTRY_FAULT, addEntryFailed);
			recordControl.addEventListener(RecorderEvent.CONNECTING, onConnecting);
			recordControl.addEventListener(RecorderEvent.CONNECTING_FINISH, onConnectingFinish);
			recordControl.addEventListener(RecorderEvent.STREAM_ID_CHANGE, streamIdChange);
			recordControl.addEventListener(RecorderEvent.UPDATE_RECORDED_TIME, updateRecordedTime);
			trace("call deviceDetection");
			recordControl.deviceDetection();

			if(this.stage == this.root.parent)
				stage.addEventListener(Event.RESIZE, stageResize);

			dispatchEvent(new ViewEvent(ViewEvent.VIEW_READY, true));
		}


		/**
		 *sets camera recording quality.
		 * @param quality		An integer that specifies the required level of picture quality,
		 * 						as determined by the amount of compression being applied to each video frame. Acceptable values range from 1
		 * 						(lowest quality, maximum compression) to 100 (highest quality, no compression).
		 * 						To specify that picture quality can vary as needed to avoid exceeding bandwidth, pass 0 for quality.
		 * @param bw			Specifies the maximum amount of bandwidth that the current outgoing video feed can use,
		 * 						in bytes per second. To specify that Flash Player video can use as much bandwidth as needed to
		 * 						maintain the value of quality, pass 0 for bandwidth. The default value is 16384.
		 * @param w				the width of the frame.
		 * @param h				the height of the frame.
		 * @param fps			frame per second to use.
		 * @param fps			frame per second to use.
		 * @param gop			The distance (in frames) between 2 keyframes 
		 * @bufferTime			This parameter compensates for lower connectivity or inconstant bandwidth 
		 * 						so no content will be lost. 
		 */
		public function setQuality(quality:int, bw:int, w:int, h:int, fps:Number, gop:int=25, bufferTime:Number=70):void
		{
			recordControl.bufferTime=bufferTime;
			recordControl.setQuality(quality, bw, w, h, fps, gop);
		}

		public function getMicrophones():String
		{
			return recordControl.getMicrophones().toString();
		}

		public function getCameras():String
		{
			return recordControl.getCameras().toString();
		}

		public function setActiveCamera(cameraName:String):void
		{
			recordControl.setActiveCamera(cameraName);
		}

		public function setActiveMicrophone(microphoneName:String):void
		{
			recordControl.setActiveMicrophone(microphoneName);
		}
		
		public function getMicrophoneActivityLevel():Number {
			return recordControl.micophoneActivityLevel;
		}
		/**
		 * returns the volume of the microphone 
		 * @return 
		 * 
		 */		
		public function getMicrophoneGain():Number {
			return recordControl.microphoneGain;
		}
		
		/**
		 * sets the gain of the microphone 
		 * @param val the given volume, between 0 to 100
		 * 
		 */		
		public function setMicrophoneGain(val:String):void {
			recordControl.microphoneGain = parseFloat(val);
		}

		/**
		 *the duration of the recording in milliseconds.
		 */
		public function getRecordedTime():uint
		{
			return recordControl.recordedTime;
		}
		
		public static function delegator(methodName:String, ... args):void
		{
			try
			{
				ExternalInterface.call("eval(window.delegator)", methodName , args);
			} 
			catch(error:Error) 
			{
				trace ("delegator: "+error.message);
			}
		}
		
		private function callInterfaceDelegate(methodName:String, ... args):void
		{
			delegator(methodName,args);
			try {
				var paramObj:Object = this.root.loaderInfo.parameters;
				var appparams:Object = ObjectHelpers.lowerNoUnderscore(paramObj);
				var delegate:String = KConfigUtil.getDefaultValue(paramObj.delegate, "window");
				ExternalInterface.call("eval(" + delegate + "." + methodName + ")", args);
			} catch (err:Error) {trace (err.message)}
			//print message on screen
			var message:String = "";
			switch (methodName)
			{
				case DeviceDetectionEvent.ERROR_CAMERA:
					message = "Error.CameraError";
					break;
				case DeviceDetectionEvent.ERROR_MICROPHONE:
					message = "Error.MichrophoneError";
					break;
				case ExNetConnectionEvent.NETCONNECTION_CONNECT_FAILED:
					message = "Error.ConnectionError";
					break;
				case ExNetConnectionEvent.NETCONNECTION_CONNECT_CLOSED:
					message = "Error.ConnectionClosed";
					break;
				case RecorderEvent.CONNECTING:
					//message = "Dialog.Connecting";
					break;
				case DeviceDetectionEvent.MIC_DENIED:
					message = "Error.micDenied";
					break;
				case DeviceDetectionEvent.CAMERA_DENIED:
					message = "Error.cameraDenied";
				break;
			}
			//handle only the MIC_DENIED & CAMERA_DENIED since the UI is not ready for them yet QND
			if(message && (methodName==DeviceDetectionEvent.MIC_DENIED || methodName==DeviceDetectionEvent.CAMERA_DENIED ))
			{
				if(!_message)
				{
					_message= new TextField();
					_message.width = this.width;
					_message.height = this.height;
					var tf:TextFormat = new TextFormat();
					tf.color = 0xFFFFFF;
				}
				
				_message.text = Global.LOCALE.getString(message);
				_message.setTextFormat(tf);
				if(_showErrorMessege) //show this message only if showErrorMessege is set to true 
					addChild(_message);
			}
		}

		private function stageResize(event:Event):void
		{
			//set the _view width and height because any view resize by it's parent
			_view.width = _view.viewWidth=stage.stageWidth;
			_view.height = _view.viewHeight=stage.stageHeight;

			graphics.clear();
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, _view.viewWidth, _view.viewHeight);
			graphics.endFill();

			if (recordControl && recordControl.video)
			{
				if (contains(recordControl.video))
					removeChild(recordControl.video);
				recordControl.resizeVideo(_view.viewWidth, _view.viewHeight);
				addChildAt(recordControl.video, 0);
			}
		}

		private function deviceError(event:DeviceDetectionEvent):void
		{
			try
			{
				this.callInterfaceDelegate(event.type);				
			}
			catch (err:Error)
			{
				trace(err.message)
			}

			if (event.type == DeviceDetectionEvent.ERROR_CAMERA)
			{
				_view.showPopupError(Global.LOCALE.getString("Error.CameraError"));
			}
			dispatchEvent(event.clone());
		}

		private function deviceDetected(event:DeviceDetectionEvent):void
		{
			
			//add the detected mic notification
			if(event.type == DeviceDetectionEvent.DETECTED_MICROPHONE)
			{
				try
				{
					this.callInterfaceDelegate(DeviceDetectionEvent.DETECTED_MICROPHONE);
				}
				catch (err:Error)
				{
					trace(err.message)
				}
			}

			
			
			
			if (event.type == DeviceDetectionEvent.DETECTED_CAMERA)
			{
				stageResize(null);
				setQuality(85, 0, 336, 252, 25);
				recordControl.connectToRecordingServie();
//			_view.setState( "start" );
				try
				{
					this.callInterfaceDelegate("deviceDetected");
				}
				catch (err:Error)
				{
					trace(err.message)
				}
			}
			dispatchEvent(event.clone());
		}

		private function connected(event:ExNetConnectionEvent):void
		{
			_view.setState("start");
			trace(event.type);
			try
			{
				this.callInterfaceDelegate("connected");
			}
			catch (err:Error)
			{
				trace(err.message)
			}
			dispatchEvent(event.clone());
		}

		private function connectionError(event:ExNetConnectionEvent):void
		{
			trace(event.type)
			try
			{
				this.callInterfaceDelegate(event.type);
			}
			catch (err:Error)
			{
				trace(err.message)
			}
			_view.showPopupError(Global.LOCALE.getString("Error.ConnectionError"));
			dispatchEvent(event.clone());
		}

		/**
		 * start publishing the audio.
		 */
		public function startRecording():void
		{
			_newViewState = "recording"
			_view.setState(_newViewState);
			trace("RECORD START");
			recordControl.recordNewStream();
			limitRecording();

		}

		/**
		 * Check if this instance needs to limit the time and start the timer if needed. 
		 */
		private function limitRecording():void
		{
			if(_limitRecord && !_limitRecordTimer)
			{
				_limitRecordTimer = new Timer(_limitRecord*1000,1);
				_limitRecordTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onRecordTimeComplete);
				_limitRecordTimer.start();
			}
		}
		private function recordStart(event:RecordNetStreamEvent):void
		{
			try
			{
				this.callInterfaceDelegate("recordStart");
			}
			catch (err:Error)
			{
				trace(err.message)
			}
			dispatchEvent(event.clone());
		}

		/**
		 * stop publishing to the server.
		 */
		public function stopRecording():void
		{
			if(_limitRecordTimer)
			{
				_limitRecordTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,onRecordTimeComplete);
				_limitRecordTimer.stop();
				_limitRecordTimer = null;
			}
			
			_newViewState = "preview"
			_view.setState(_newViewState);
			trace("KRecord==>stopRecording()");
			recordControl.stopRecording();
		}

		private function flushHandler(event:FlushStreamEvent):void
		{
			trace(event.type + "  :   " + event.bufferSize + " / " + event.totalBuffer);
			if (event.type == FlushStreamEvent.FLUSH_COMPLETE)
			{
				/*if (autoPreview)
				 previewRecording();*/
				try
				{
					this.callInterfaceDelegate("flushComplete");
				}
				catch (err:Error)
				{
					trace(err.message);
				}
				dispatchEvent(event.clone());
			
			}
		}

		/**
		 * show loader connecting when needed.
		 */
		private function onConnecting(event:Event):void
		{
			_view.showPopupMessage(Global.LOCALE.getString("Dialog.Connecting"));
			dispatchEvent(event.clone());
		}

		/**
		 * remove loader connecting when needed and get back to the current view state.
		 */
		private function onConnectingFinish(event:Event):void
		{
			//if(_newViewState != "message")
			trace("Return to State: " + _newViewState);
			_view.setState(_newViewState);
			dispatchEvent(event.clone());
		}

		/**
		 * play the recorded stream.
		 */
		public function previewRecording():void
		{
			trace("PREVIEW START");
			var currentState:Object = _view.getState();
			if(currentState is ViewStatePreview)
			{
				(currentState as ViewStatePreview).player.play(new MouseEvent("click"));
			}
			
		}
		/**
		 * stop playing the recorded stream.
		 */
		public function stopPreviewRecording():void
		{
			var currentState:Object = _view.getState();
			if(currentState is ViewStatePreview)
			{
				trace("PREVIEW STOP");
				(currentState as ViewStatePreview).player.stop();
			}
		}

		private function previewEndHandler(event:RecordNetStreamEvent):void
		{
			trace('preview: ' + event.type);

			try
			{
				this.callInterfaceDelegate("previewEnd");
			}
			catch (err:Error)
			{
				trace(err.message)
			}
			dispatchEvent(event.clone());
		}

		/**
		 * add the last recording as a new Kaltura entry in the Kaltura Network.
		 * @param entry_name				the name for the new added entry.
		 * @param entry_tags				user tags for the newly created entry.
		 * @param entry_description			description of the newly created entry.
		 * @param credits_screen_name		for anonymous user applications - the screen name of the user that contributed the entry.
		 * @param credits_site_url			for anonymous user applications - the website url of the user that contributed the entry.
		 * @param categories				Categories. comma seperated string
		 * @param admin_tags				admin tags for the newly created entry.
		 * @param license_type				the content license type to use (this is arbitrary to be set by the partner).
		 * @param credit					custom partner credit feild, will be used to attribute the contributing source.
		 * @param group_id					used to group multiple entries in a group.
		 * @param partner_data				special custom data for partners to store.
		 */
		public function addEntry(entry_name:String='', entry_tags:String='', entry_description:String='', credits_screen_name:String='', credits_site_url:String='', categories:String="", admin_tags:String='', license_type:String='', credit:String='', group_id:String='', partner_data:String=''):void
		{
			if (entry_name == '')
				entry_name='recorded_entry_pid_' + recordControl.initRecorderParameters.baseRequestData.partner_id + (Math.floor(Math.random() * 1000000)).toString();
			
			  this.callInterfaceDelegate("beforeAddEntry");
			recordControl.addEntry(entry_name, entry_tags, entry_description, credits_screen_name, credits_site_url, categories, admin_tags, license_type, credit, group_id, partner_data);
		}

		private function addEntryFailed(event:AddEntryEvent):void
		{
			dispatchEvent(event.clone());
			this.callInterfaceDelegate("addEntryFailed",{errorCode:event.info.error.errorCode , errorMsg:event.info.error.errorMsg});
		}

		private function addEntryComplete(event:AddEntryEvent):void
		{
			var entry:KalturaMediaEntry=event.info as KalturaMediaEntry;
			if (entry)
			{
				try
				{
					this.callInterfaceDelegate("addEntryComplete", event.info);
				}
				catch (err:Error)
				{
					trace(err.message)
				}
				trace("Your new entry is: " + entry.entryId + "\nthumb: " + entry.thumbnailUrl);
			}
			else
			{
				try
				{
					this.callInterfaceDelegate("addEntryFail", event.info);
				}
				catch (err:Error)
				{
					trace(err.message)
				}
				trace(ObjectUtil.toString(event.info));
			}
			dispatchEvent(event.clone());
		}

		private function streamIdChange(event:RecorderEvent):void
		{
			dispatchEvent(event.clone());
		}

		private function updateRecordedTime(event:RecorderEvent):void
		{
			dispatchEvent(event.clone());
		}
	}
}
