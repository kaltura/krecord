package com.kaltura.recording.view {

	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFormat;


	public class View extends Sprite {
		public var viewWidth:Number = 320;
		public var viewHeight:Number = 240;

		private var _bg:Sprite = new Sprite;

		private var _states:Object = new Object;
		private var _currentState:ViewState;

		private var _message:TextField;

		private var _themeLoader:Loader = new Loader;
		private var _localeLoader:URLLoader = new URLLoader;


		function View() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
		}


		private function onAddedToStage(evt:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			loadTheme();
		}


		private function loadTheme():void {
			if (Global.DEBUG_MODE) 
				trace('loading theme:', Global.VIEW_PARAMS.themeUrl)
			_themeLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadThemeComplete);
			_themeLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_themeLoader.load(new URLRequest(Global.VIEW_PARAMS.themeUrl + "?r=1"), new LoaderContext(true, ApplicationDomain.currentDomain));
		}


		private function loadLocale():void {
			// First create defaults:
			Global.LOCALE = new KRecordLocaleDefault();

			if (Global.DEBUG_MODE) 
				trace('loading locale:', Global.VIEW_PARAMS.localeUrl);
			
			_localeLoader.addEventListener(Event.COMPLETE, onLoadLocaleComplete);
			_localeLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_localeLoader.load(new URLRequest(Global.VIEW_PARAMS.localeUrl));
		}


		private function ready():void {
			addState("start", new ViewStateStart);
			addState("recording", new ViewStateRecording);
			addState("preview", new ViewStatePreview);
			addState("message", new ViewStateMessage);
			addState("error", new ViewStateError);

			parent.addEventListener(Event.RESIZE, onResize, false, 0, true);
			onResize();

			dispatchEvent(new ViewEvent(ViewEvent.VIEW_READY));
		}


		private function onResize(evt:Event = null):void {
			for each (var state:ViewState in _states) {
				state.width = viewWidth;
				state.height = viewHeight;
			}
		}


		private function addState(name:String, state:ViewState):void {
			_states[name] = state;
			state.visible = false;
			addChild(state);
		}


		public function setState(name:String):void {
			if (_currentState)
				_currentState.close();

			_currentState = _states[name];
			_currentState.open();
		}


		public function getState():ViewState {
			return _currentState;
		}


		public function showPopupMessage(message:String):void {
			ViewStateMessage(_states["message"]).message = message;
			setState("message");
		}


		public function showPopupError(message:String):void {
			ViewStateError(_states["error"]).message = message;
			setState("error");
		}


		private function onLoadThemeComplete(evt:Event):void {
			if (Global.DEBUG_MODE) 
				trace('Theme file loaded');
			Global.THEME = new Theme(_themeLoader.content as DisplayObjectContainer);

			loadLocale();
		}


		private function onLoadLocaleComplete(evt:Event):void {
			if (Global.DEBUG_MODE) 
				trace('Locale file loaded');

			try {
				Global.LOCALE.load(new XML(_localeLoader.data));
			}
			catch (e:Error) {
				trace('Error parsing Locale file. Using defaults');
			}

			ready();
		}


		private function onIOError(evt:IOErrorEvent):void {
			trace(evt.text);
			if (evt.target == _localeLoader) {
				trace("Locale file didn't load. Using defaults");
				ready();
			}
		}


		/////////////////
		public function setError(value:String):void {
			_message = new TextField()
			_message.width = this.width;
			_message.height = this.height;
			var tf:TextFormat = new TextFormat();
			tf.color = 0xFFFF00;
			_message.text = value;
			_message.setTextFormat(tf);
			addChild(_message);
		}




	}
}