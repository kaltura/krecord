package {
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class KRecordContainerFlash extends Sprite
	{
		private var _kRecorderLoader:Loader = new Loader();

		private var button:Sprite = new Sprite();

		public function KRecordContainerFlash()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			addEventListener(Event.ADDED_TO_STAGE, startApplication);
		}

		private function startApplication (event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, startApplication);
			button.graphics.beginFill(0xff, 1);
			button.graphics.drawCircle(0, 0, 50);
			button.graphics.endFill();
			button.buttonMode = true;
			button.useHandCursor = true;
			button.addEventListener(MouseEvent.CLICK, buttonClickHandler);
			addChild(button);

			_kRecorderLoader.x = 100;
			_kRecorderLoader.y = 100;
			_kRecorderLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, finishedLoading);
			_kRecorderLoader.load(new URLRequest("KRecord.swf"), new LoaderContext(true, ApplicationDomain.currentDomain));
		}

		private function finishedLoading(event:Event):void
		{
			//wait for the krecord view to load -
			_kRecorderLoader.addEventListener("viewReady", krecordReady);
			//when loading inside another flash application, to pass initialization parameters to the krecord application, use the parameters object
			//if loaded through HTML directly, the initialization will be directed through the embed object flashVars.
			_kRecorderLoader.content['parameters'] = {themeUrl:"skin.swf",
														localeUrl:"locale.xml",
														autoPreview:"1",
														pid:"1",
														subpid:"100",
														ks:"some generated ks here..." };
			//_kRecorderLoader.content['parameters'] = root.loaderInfo.parameters;
			addChild(_kRecorderLoader);
		}

		private function krecordReady (event:Event):void
		{
			//when krecord view is ready, it can be resized
			_kRecorderLoader.width = 100 + Math.random() * 200;
			_kRecorderLoader.height = _kRecorderLoader.width * 0.75;

			//when krecord application is ready, it can be accessed for APIs
			//to access krecord application, use the application property:
			trace("Available microphones: " + _kRecorderLoader.content["application"].getMicrophones());
			(_kRecorderLoader.content["application"] as EventDispatcher).addEventListener("addEntryFault", addEntryFaultHandler);
		}

		private function addEntryFaultHandler (event:Event):void {
			trace ("can't save without KS...");
		}

		private function buttonClickHandler (event:MouseEvent):void
		{
			_kRecorderLoader.width = 100 + Math.random() * 600;
			_kRecorderLoader.height = _kRecorderLoader.width * 0.75;
		}
	}
}
