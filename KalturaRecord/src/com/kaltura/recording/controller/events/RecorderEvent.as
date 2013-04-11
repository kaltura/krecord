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
package com.kaltura.recording.controller.events
{
	import flash.events.Event;

	public class RecorderEvent extends Event
	{
//		public static const CONNECTION_ESTABLISHED:String = "connectionEstablished";
//		public static const DEVICE_DETECTED:String = "deviceDetected";
//		public static const CONNECTION_ERROR:String = "connectionError";
//		public static const DEVICE_ERROR:String = "deviceError";

//		public static const RECORDER_PUBLISH:String = "recorderPublish";
//		public static const RECORDER_BUTTON_CLICK:String = "recorderButtonClick";
//		public static const RECORDER_FLUSH:String = "recorderFlush";
//		public static const RECORDER_PLAY:String = "recorderPlay";
//		public static const RECORDER_STOP:String = "recorderStop";
//		public static const RECORDER_APPROVE:String = "recorderApprove";
//		public static const RECORDER_CANCEL:String = "recorderCancel";
		
		/**
		 * dispatched when the recording stream's buffer is empty after recording has stopped
		 */
		public static const RECORD_COMPLETE : String = "recordComplete";
		
		/**
		 * dispatched whenever KRecordControl.connecting is set to true
		 */
		public static const CONNECTING : String = "connecting";
		
		/**
		 * dispatched whenever KRecordControl.connecting is set to false
		 */
		public static const CONNECTING_FINISH : String = "connectingFinish";
		
		/**
		 * dispatched whenever KRecordControl.streamUid is changed
		 * event.data is the new value
		 */
		public static const STREAM_ID_CHANGE : String = "streamIdChange";
		
		/**
		 * dispatched whenever KRecordControl.recordedTime is changed 
		 * event.data is the new value
		 */
		public static const UPDATE_RECORDED_TIME : String = "updateRecordedTime";
		
		

		public var data:Object;

		public function RecorderEvent (type:String, event_data:Object = null)
		{
			super(type, true, false);
			data = event_data;
		}

		override public function clone():Event
		{
			return new RecorderEvent (type, data);
		}
	}
}