package com.kaltura.recording.controller
{
public interface IRecordControl
{

	function get playheadTime():Number;
	function get recordedTime():uint;
	function get blackRecordTime():uint;
	
	function previewRecording():void;
	function pausePreviewRecording():void;
	function resume():void;
	function stopPreviewRecording ():void;
	function seek( offset:Number):void;
	
	
	function clearVideoAndSetCamera():void; //Boaz addition
	
	
	function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void;
	function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void;
 
	
}
}