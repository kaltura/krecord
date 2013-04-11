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
package com.kaltura.devicedetection {
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.system.Security;
	import flash.system.SecurityPanel;
	import flash.utils.Timer;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	/**
	 *  dispatched to notify an active microphone device was detetceted.
	 *  @eventType com.kaltura.devicedetection.DeviceDetectionEvent.DETECTED_MICROPHONE
	 */
	[Event(name = "detectedMicrophone", type = "com.kaltura.devicedetection.DeviceDetectionEvent")]
	
	/**
	 *  dispatched to notify an error of detecting an active microphone.
	 *  @eventType com.kaltura.devicedetection.DeviceDetectionEvent.ERROR_MICROPHONE
	 */
	[Event(name = "errorMicrophone", type = "com.kaltura.devicedetection.DeviceDetectionEvent")]
	
	/**
	 *  dispatched to notify an active camera device was detected.
	 *  @eventType com.kaltura.devicedetection.DeviceDetectionEvent.DETECTED_CAMERA
	 */
	[Event(name = "detectedCamera", type = "com.kaltura.devicedetection.DeviceDetectionEvent")]
	
	/**
	 *  dispatched to notify an error of detecting an active camera.
	 *  @eventType com.kaltura.devicedetection.DeviceDetectionEvent.ERROR_CAMERA
	 */
	[Event(name = "errorCamera", type = "com.kaltura.devicedetection.DeviceDetectionEvent")]
	
	/**
	 *  dispatched to notify access to cameras is denied by user.
	 *  @eventType com.kaltura.devicedetection.DeviceDetectionEvent.CAMERA_DENIED
	 */
	[Event(name = "cameraDenied", type = "com.kaltura.devicedetection.DeviceDetectionEvent")]

	public class DeviceDetector extends EventDispatcher {
		
		private var _micDetector:MicrophoneDetector;
		
		
		/**
		 * the allowed camera, once found 
		 */
		public var webCam:Camera = null;
		
		/**
		 * total number of cameras on the user's system 
		 */
		private var _camerasNumber:int = Camera.names.length;
		
		/**
		 * test index 
		 */
		private var _testedCameraIndex:int = -1;
		
		/**
		 * currently tested camera 
		 */
		private var _testedCamera:Camera;
		
		/**
		 * video for testing camera input 
		 */
		private var _testedVideo:Video = new Video(50, 50);
		
		/**
		 * rectangle for testing camera input 
		 */
		private var _testRect:Rectangle = new Rectangle(0, 0, 50, 50);
		private var _testedBitmapData:BitmapData = new BitmapData(50, 50, false, 0x0);
		private var _blackBitmapData:BitmapData = new BitmapData(50, 50, false, 0x0);
		private var _delayDetectCameraIndex:uint = 0;
		
		/**
		 * number of cameras that weren't available
		 */
		private var _cameraFails:uint = 0;
		
		public var maxCameraFails:uint = 3;

		

		/**
		 * image test delay 
		 */
		private var _delayTime:uint;
		private var _delayAfterFail:uint;
		
		

		//////
		//		CCCCCCCCC		AAAAAAAAAAA			MMMMMM		   MMMMMM
		//		CCCCCCCCC		AAAAAAAAAAA			MMMMMMMMMM MMMMMMMMMM
		//		CCC				AAA		AAA			MMMM    MMMMM	 MMMM
		//		CCC				AAAAAAAAAAA			MMM		 MMM	  MMM
		//		CCCCCCCCC		AAA		AAA			MMM		  M		  MMM
		//		CCCCCCCCC		AAA		AAA			MMM				  MMM
		//////

		public function detectCamera(delay:uint = 500):void {
			_delayTime = delay;
			_delayAfterFail = delay * 2;
			_testedCameraIndex = -1;
			if (_delayDetectCameraIndex != 0)
				clearTimeout(_delayDetectCameraIndex);
			_testedBitmapData = new BitmapData(_testRect.width, _testRect.height, false, 0x0);
			_blackBitmapData = new BitmapData(_testRect.width, _testRect.height, false, 0x0);
			_blackBitmapData.fillRect(_testRect, 0x0);
			detectNextCamera();
		}


		private function detectNextCamera():void {
			_cameraFails = 0;

			if (webCam) {
				dispatchCameraSuccess();
				return;
			}

			if (_testedCameraIndex > 0 && _testedCamera != null)
				_testedCamera.removeEventListener(StatusEvent.STATUS, statusCameraHandler);

			if ((++_testedCameraIndex) >= _camerasNumber) {
				//we didn't find any camera on the system..
				dispatchCameraError(DeviceDetectionEvent.ERROR_CAMERA);
				return;
			}

			_testedCamera = Camera.getCamera(_testedCameraIndex.toString());

			if (_testedCamera == null) {
				if (_camerasNumber > 0) {
					//there are devices on the system but we don't get access directly to them...
					//let the user set the access to the default camera:
					// NOTE: this should never happen here, because we use the specific access to the camera object
					// rather than using the default getCamera ();
//					Security.showSettings(SecurityPanel.CAMERA);
					dispatchCameraError(DeviceDetectionEvent.CAMERA_DENIED);
				}
				else {
					//we don't have any camera device!
					dispatchCameraError(DeviceDetectionEvent.ERROR_CAMERA);
				}
				return;
			}

			_testedBitmapData.fillRect(_testRect, 0x0);
			_testedVideo.attachCamera(null);
			_testedVideo.clear();
			_testedCamera.addEventListener(StatusEvent.STATUS, statusCameraHandler);
			_testedVideo.attachCamera(_testedCamera);

			if (!_testedCamera.muted) {
				trace("User selected Accept already.");
				delay_testCameraImage();
			}
		/*else {
			//the user selected not to allow access to the devices.
//		    	Security.showSettings(SecurityPanel.PRIVACY);
//	            dispatchCameraError (DeviceDetectionEvent.CAMERA_DENIED);
		}*/
		}


		private function statusCameraHandler(event:StatusEvent):void {
			switch (event.code) {
				case "Camera.Muted":
					trace("Camera: User clicked Deny.");
					dispatchCameraError(DeviceDetectionEvent.CAMERA_DENIED);
					break;

				case "Camera.Unmuted":
					trace("Camera: User clicked Accept.");
					delay_testCameraImage();
					break;
			}
		}


		/**
		 * delays the image test.
		 * <p>the system takes abit of time to initialize the connection to the physical camera and return image
		 * so we give the camera 1.5 seconds to actually be attached and return an image
		 * unfortunatly we don't have any event from the flash player that notify a physical initialization and that image was given.
		 * we additionaly give more time for slower machines (or cameras) if we fail.
		 * you can set the maximum fail tryouts by setting the maxFails variable.</p>
		 */
		private function delay_testCameraImage():void {
			_delayDetectCameraIndex = setTimeout(testCameraImage, (_cameraFails > 0) ? _delayAfterFail : _delayTime);
		}


		private function testCameraImage():void {
			_testedBitmapData.draw(_testedVideo);
			var testResult:Object = _testedBitmapData.compare(_blackBitmapData);
			trace("camera test: " + _testedCameraIndex);

			// Added currentFPS check to make sure if the camera is active.
			if (testResult is BitmapData || _testedCamera.currentFPS != 0) {
				//it's different, we have an image!
				dispatchCameraSuccess();
			}
			else {
				//camera is not available for some reson, we don't get any image.
				// move to check the next camera
				if ((++_cameraFails) < maxCameraFails) {
					delay_testCameraImage();
				}
				else {
					detectNextCamera();
				}
			}
		}


		private function dispatchCameraSuccess():void {
			disposeCamera();
			webCam = Camera.getCamera(_testedCameraIndex.toString());
			dispatchEvent(new DeviceDetectionEvent(DeviceDetectionEvent.DETECTED_CAMERA, webCam));
		}


		private function dispatchCameraError(errorEventType:String):void {
			disposeCamera();
			webCam = null;
			dispatchEvent(new DeviceDetectionEvent(errorEventType, webCam));
			ExternalInterface.call("noCamerasFound")
		}


		private function disposeCamera():void {
			if (_testedCamera)
				_testedCamera.removeEventListener(StatusEvent.STATUS, statusCameraHandler);
			_testedCamera = null;
			_testedVideo.attachCamera(null);
			_testedVideo.clear();
			if (_blackBitmapData)
				_blackBitmapData.dispose();
			if (_testedBitmapData)
				_testedBitmapData.dispose();
		}


		//////
		//		MMMMMM		   MMMMMM			IIIIIIIIIII			CCCCCCCCC
		//		MMMMMMMMMM MMMMMMMMMM			IIIIIIIIIII			CCCCCCCCC
		//		MMMM    MMMMM	 MMMM				III				CCC
		//		MMM		 MMM	  MMM				III				CCC
		//		MMM		  M		  MMM			IIIIIIIIIII			CCCCCCCCC
		//		MMM				  MMM			IIIIIIIIIII			CCCCCCCCC
		//////

		/**
		 * 
		 * @param timePerMic	delay before trying the next microphone (ms)
		 * @param timePerCheck	delay between activity checks for current microphone (ms)
		 * 
		 */
		public function detectMicrophone(timePerMic:int = 20000, timePerCheck:int = 1000):void {
			if (!_micDetector) {
				ExternalInterface.addCallback("openSettings", openSettings); 
				_micDetector = new MicrophoneDetector();
				_micDetector.addEventListener(DeviceDetectionEvent.DETECTED_MICROPHONE, handleMicDetectionEvents);
				_micDetector.addEventListener(DeviceDetectionEvent.ERROR_MICROPHONE, handleMicDetectionEvents);
				_micDetector.addEventListener(DeviceDetectionEvent.MIC_DENIED, handleMicDetectionEvents);
				_micDetector.addEventListener(DeviceDetectionEvent.MIC_ALLOWED, handleMicDetectionEvents);
			}
			_micDetector.detectMicrophone(timePerMic, timePerCheck);
		}
		
		private function handleMicDetectionEvents(event:DeviceDetectionEvent):void {
			switch (event.type) {
				case DeviceDetectionEvent.DETECTED_MICROPHONE:
					ExternalInterface.addCallback("getMicophoneActivityLevel", getMicrophoneActivity);
					try {
						ExternalInterface.call("workingMicFound");
					}
					catch (errObject:Error) {
						trace(errObject.message);
					}
					break;
				case DeviceDetectionEvent.ERROR_MICROPHONE:
					try {
						openSettings();
						ExternalInterface.call("noMicsFound");
					}
					catch (errObject:Error) {
						trace(errObject.message);
					}
					break;
				case DeviceDetectionEvent.MIC_DENIED:
					try {
						ExternalInterface.call("micDenied");
					}
					catch (errObject:Error) {
						trace(errObject.message);
					}
					break;
				case DeviceDetectionEvent.MIC_ALLOWED:
					try {
						ExternalInterface.call("micAllowed");
					}
					catch (errObject:Error) {
						trace(errObject.message);
					}
					break;
			}
			dispatchEvent(event.clone());
			
		}
		
		
		public function openSettings():void {
			Security.showSettings(SecurityPanel.PRIVACY);
		}
		
		private function getMicrophoneActivity():int {
			return _micDetector.getActivityNow();
		}
		
		public function get microphone():Microphone {
			return _micDetector.microphone;
		}

		/////// ============= singletone
		/**
		 *Constructor + getInstance.
		 */
		static private var _instance:DeviceDetector;


		public function DeviceDetector():void {
			if (_instance)
				throw(new Error("you can't instantiate singletone more than once, use getInstance instead."));

			_testedVideo.smoothing = false;
			_testedVideo.deblocking = 1;
		}


		static public function getInstance():DeviceDetector {
			if (!_instance)
				_instance = new DeviceDetector();
			return _instance;
		}


	}
}
