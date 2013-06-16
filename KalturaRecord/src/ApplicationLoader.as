package
{

import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.events.Event;
import flash.utils.getDefinitionByName;


public class ApplicationLoader extends MovieClip
{
	public var application:Object;

	public function ApplicationLoader()
	{
		stop();
		addEventListener(Event.ADDED_TO_STAGE, addedToStage);
	}

	private function addedToStage(event:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

		parent.addEventListener( Event.RESIZE, onResize );

		Global.PRELOADER = new PreloaderSkin();

		addChild(Global.PRELOADER);
		addEventListener(Event.ENTER_FRAME, onEnterFrame);

		onResize(null);
	}

	private function onEnterFrame(evt:Event):void
	{
		if (framesLoaded == totalFrames){
			onLoadComplete();
		}
	}

	private function onResize (evt:Event):void
	{
		if (parent == stage) {
			Global.PRELOADER.x = int(stage.stageWidth / 2);
			Global.PRELOADER.y = int(stage.stageHeight / 2);
		}
		else {
			Global.PRELOADER.x = int(parent.width / 2);
			Global.PRELOADER.y = int(parent.height / 2);
		}
	}

	private function onLoadComplete():void
	{
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		parent.removeEventListener(Event.RESIZE, onResize);
		nextFrame();

		var MainApp:Class = Class(getDefinitionByName(currentLabels[1].name));
		application = new MainApp();
		
		// recevice the parameters from outside
		application.pushParameters = stage.loaderInfo.parameters;
		addChildAt(application as DisplayObject, 0);
	}
}
}