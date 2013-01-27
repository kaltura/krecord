/*
This file is part of the Kaltura Collaborative Media Suite which allows users 
to do with audio, video, and animation what Wiki platfroms allow them to do with 
text.

Copyright (C) 2006-2008  Kaltura Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

@ignore
*/
package com.kaltura.recording.controller
{
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.Event;
	
	/**
	 *  Dispatched when the Netstream client gets BufferSizes object on the metadata
	 *  @eventType com.net.NetClient.ON_METADATA_BUFFER_SIZES
	 */
	[Event(name="bufferSizes", type="flash.events.Event")]
	
	/**
	 *  Dispatched when the Netstream client gets to the end of the stream
	 *  @eventType com.net.NetClient.ON_STREAM_END
	 */
	[Event(name="StreamEnd", type="flash.events.Event")]
	
	/**
	 *  Dispatched when the Netstream client gets event that the stream has been switched on the server sequence (playlist mode)
	 *  @eventType com.net.NetClient.ON_STREAM_SWITCH
	 */
	[Event(name="StreamSwitch", type="flash.events.Event")]
	
	/**
	 *  Dispatched when the Netstream client gets to the last second before the stream ends
	 *  @eventType com.net.NetClient.ON_LAST_SECOND
	 */
	[Event(name="onLastSecond", type="flash.events.Event")]
	
	public class KRecordNetClient extends EventDispatcher
	{
		public static var ON_METADATA_BUFFER_SIZES:String = "OnMetaData.bufferSizes";
		public static var ON_STREAM_END:String = "Stream.End";
		public static var ON_STREAM_SWITCH:String = "Stream.Switch";
		public static var ON_LAST_SECOND:String = "onLastSecond";
		
		private var _ClientID:String = "";
		public var MetaData:Object;
		
		public function get ClientID():String{
			return _ClientID;
		}
		
		public function set ClientID(cID:String):void{
			_ClientID = cID;
		}
		
		public function NetClient(ClientID:String = ""):void{
			_ClientID = ClientID;
		}
		private var dispatchedMetaData:Boolean = false;
		public function onMetaData(info:Object, ...args):void {
			// trace("\nmetadata: \nduration=" + info.duration + "\nwidth=" + info.width + "\nheight=" + info.height + "\nframerate=" + info.framerate);
			MetaData = new Object(); 
			MetaData.duration = info.duration;
			MetaData.width = info.width;
			MetaData.height = info.height;
			MetaData.framerate = info.framerate;
			MetaData.keyframes = info.keyframes;
			
			try {
				MetaData.bufferSizes = info.bufferSizes;
				if (MetaData.bufferSizes.length > 0) {
					//trace("there is bufferSizes object injected:\n" + MetaData.bufferSizes);
					dispatchEvent(new Event(ON_METADATA_BUFFER_SIZES));
				}
				//trace("there is bufferSizes object injected");
			}	
			catch (Err:Error){
				//trace("MetaData Error, bufferSizes: " + Err.message);
			}
			try {
				MetaData.keyframes.times = info.keyframes.times;
				//trace("there is keyframes.times object injected");
			}	
			catch (Err:Error){
				//trace("MetaData Error, keyframes.times: " + Err.message);
			}
			try {
				MetaData.keyframes.filepositions = info.keyframes.filepositions;
				//trace("there is keyframes.filepositions object injected");
			}	
			catch (Err:Error){
				//trace("MetaData Error, keyframes.filepositions: " + Err.message);
			}
			if (!dispatchedMetaData)
			{
				dispatchEvent(new Event("ExtendedOnMetaData", true, false));
				dispatchedMetaData = true;
			}
		}
		
		public function onLastSecond(info:Object):void{
			//trace("Client dispatches ONLASTSECOND!!!!!!!");
			dispatchEvent(new Event(ON_LAST_SECOND, true, false));
		}
		
		public function onCuePoint(info:Object):void {
			//trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
		}
		
		public function onPlayStatus(info:Object):void {
			if (info.code == "NetStream.Play.Complete"){
				//trace("Play of the stream has completed!");
				dispatchEvent(new Event(ON_STREAM_END, true, false));
			}else if (info.code == "NetStream.Play.Switch"){
				//trace("switched streams!");
				dispatchEvent(new Event(ON_STREAM_SWITCH, true, false));
			}
		}
		
		public function onBWDone():void {
			//trace("onBWDone: ");
		}
		
		public function onBWCheck():void {
			//trace("onBWonBWCheck: ");
		}
		
		public function streamInfo(info:Object):void {
			//trace("This is Stream info:  " + info);
		}
		
		public function close():void {
			//trace("close: ");
			//trace("Closing Client");
		}
	}
}