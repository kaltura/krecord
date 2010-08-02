package com.kaltura.recording.view
{

import flash.events.Event;


public class ViewEvent extends Event
{
	
	static public const VIEW_READY:String 		= "viewReady";
	
	static public const INVALID_SKIN:String 	= "invalidSkin";
	
	static public const RECORD_START:String 	= "recordStart";
	static public const RECORD_STOP:String 		= "recordStop";
	
	static public const PREVIEW_SAVE:String 	= "previewSave";
	static public const PREVIEW_RERECORD:String = "previewReRecord";
	
	public var data:*;
	
	
	public function ViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
	{
		super(type, bubbles, cancelable);
	}
	
}
}