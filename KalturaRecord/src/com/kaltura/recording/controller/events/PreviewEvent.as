package com.kaltura.recording.controller.events
{
	import flash.events.Event;
	
	public class PreviewEvent extends Event {
		
		public static const PREVIEW_STARTED:String = "previewStarted";
		public static const PREVIEW_PAUSED:String = "previewPaused";
		public static const PREVIEW_RESUMED:String = "previewResumed";
		public static const PREVIEW_STOPPED:String = "previewStopped";
		
		public function PreviewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}