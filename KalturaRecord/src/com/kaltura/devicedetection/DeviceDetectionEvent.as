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
package com.kaltura.devicedetection
{
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Microphone;

	public class DeviceDetectionEvent extends Event
	{
		static public var DETECTED_CAMERA:String = "detectedCamera";
		static public var ERROR_CAMERA:String = "errorCamera";
		static public var CAMERA_DENIED:String = "cameraDenied";

		static public var DETECTED_MICROPHONE:String = "detectedMicrophone";
		static public var ERROR_MICROPHONE:String = "errorMicrophone";
		static public var MIC_DENIED:String = "microphoneDenied";
		static public var MIC_ALLOWED:String = "microphoneAllowed";
		static public var DEBUG:String = "micCamDebug";
		

		public var detectedDevice:Object;

		public function DeviceDetectionEvent(type:String, device:Object):void
		{
			super(type, true, false);
			detectedDevice = device;
		}

		override public function clone():Event
		{
			return new DeviceDetectionEvent (this.type, detectedDevice);
		}
	}
}