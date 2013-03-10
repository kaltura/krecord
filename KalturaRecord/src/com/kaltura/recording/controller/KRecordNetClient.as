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
package com.kaltura.recording.controller {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;

	/**
	 *  Dispatched when the Netstream client gets BufferSizes object on the metadata
	 *  @eventType com.net.NetClient.ON_METADATA_BUFFER_SIZES
	 */
	[Event(name = "bufferSizes", type = "flash.events.Event")]

	/**
	 *  Dispatched when the Netstream client gets to the end of the stream
	 *  @eventType com.net.NetClient.ON_STREAM_END
	 */
	[Event(name = "StreamEnd", type = "flash.events.Event")]

	/**
	 *  Dispatched when the Netstream client gets event that the stream has been switched on the server sequence (playlist mode)
	 *  @eventType com.net.NetClient.ON_STREAM_SWITCH
	 */
	[Event(name = "StreamSwitch", type = "flash.events.Event")]

	/**
	 *  Dispatched when the Netstream client gets to the last second before the stream ends
	 *  @eventType com.net.NetClient.ON_LAST_SECOND
	 */
	[Event(name = "onLastSecond", type = "flash.events.Event")]

	public class KRecordNetClient extends EventDispatcher {
		public static var ON_METADATA_BUFFER_SIZES:String = "OnMetaData.bufferSizes";
		public static var ON_STREAM_END:String = "Stream.End";
		public static var ON_STREAM_SWITCH:String = "Stream.Switch";
		public static var ON_LAST_SECOND:String = "onLastSecond";
		
		public var debugTraces:Boolean = false;

		private var _ClientID:String = "";
		
		private var _metadata:Object;
		
		public function get metaData():Object {
			return _metadata;
		}


		public function get ClientID():String {
			return _ClientID;
		}

		public function set ClientID(cID:String):void {
			_ClientID = cID;
		}


		
		public function KRecordNetClient(ClientID:String = "") {
			_ClientID = ClientID;
		}
		
		private var _dispatchedMetaData:Boolean = false;


		public function onMetaData(info:Object, ... args):void {
			if (debugTraces) 
				trace("KRecordNetClient: \nmetadata: \nduration=" + info.duration + "\nwidth=" + info.width + "\nheight=" + info.height + "\nframerate=" + info.framerate);
			_metadata = new Object();
			_metadata.duration = info.duration;
			_metadata.width = info.width;
			_metadata.height = info.height;
			_metadata.framerate = info.framerate;
			_metadata.keyframes = info.keyframes;

			try {
				_metadata.bufferSizes = info.bufferSizes;
				if (_metadata.bufferSizes.length > 0) {
					if (debugTraces)
						trace("KRecordNetClient: there is bufferSizes object injected:\n" + _metadata.bufferSizes);
					dispatchEvent(new Event(ON_METADATA_BUFFER_SIZES));
				}
			}
			catch (Err:Error) {
				if (debugTraces)
					trace("KRecordNetClient: MetaData Error, bufferSizes: " + Err.message);
			}
			try {
				_metadata.keyframes.times = info.keyframes.times;
				if (debugTraces)
					trace("KRecordNetClient: there is keyframes.times object injected");
			}
			catch (Err:Error) {
				if (debugTraces)
					trace("KRecordNetClient: MetaData Error, keyframes.times: " + Err.message);
			}
			try {
				_metadata.keyframes.filepositions = info.keyframes.filepositions;
				if (debugTraces)
					trace("KRecordNetClient: there is keyframes.filepositions object injected");
			}
			catch (Err:Error) {
				if (debugTraces)
					trace("KRecordNetClient: MetaData Error, keyframes.filepositions: " + Err.message);
			}
			if (!_dispatchedMetaData) {
				dispatchEvent(new Event("ExtendedOnMetaData", true, false));
				_dispatchedMetaData = true;
			}
		}


		public function onLastSecond(info:Object):void {
			if (debugTraces)
				trace("KRecordNetClient: Client dispatches ONLASTSECOND");
			dispatchEvent(new Event(ON_LAST_SECOND, true, false));
		}


		public function onCuePoint(info:Object):void {
			if (debugTraces)
				trace("KRecordNetClient: cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
		}


		public function onPlayStatus(info:Object):void {
			if (info.code == "NetStream.Play.Complete") {
				if (debugTraces)
					trace("KRecordNetClient: Play of the stream has completed!");
				dispatchEvent(new Event(ON_STREAM_END, true, false));
			}
			else if (info.code == "NetStream.Play.Switch") {
				if (debugTraces)
					trace("KRecordNetClient: switched streams!");
				dispatchEvent(new Event(ON_STREAM_SWITCH, true, false));
			}
		}


		public function onBWDone():void {
			if (debugTraces)
				trace("KRecordNetClient: onBWDone");
		}


		public function onBWCheck():void {
			if (debugTraces)
				trace("KRecordNetClient: onBWonBWCheck");
		}


		public function streamInfo(info:Object):void {
			if (debugTraces)
				trace("This is Stream info:  " + info);
		}


		public function close():void {
			if (debugTraces)
				trace("close: ");
			//trace("Closing Client");
		}
	}
}
