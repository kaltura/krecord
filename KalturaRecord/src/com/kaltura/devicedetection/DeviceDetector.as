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
	[Event(name="detectedMicrophone", type="com.kaltura.devicedetection.DeviceDetectionEvent")]
	/**
	 *  dispatched to notify an active camera device was detected.
	 *  @eventType com.kaltura.devicedetection.DeviceDetectionEvent.DETECTED_CAMERA
	 */
	[Event(name="detectedCamera", type="com.kaltura.devicedetection.DeviceDetectionEvent")]
	/**
	 *  dispatched to notify an error of detecting an active microphone.
	 *  @eventType com.kaltura.devicedetection.DeviceDetectionEvent.ERROR_MICROPHONE
	 */
	[Event(name="errorMicrophone", type="com.kaltura.devicedetection.DeviceDetectionEvent")]
	/**
	 *  dispatched to notify an error of detecting an active camera.
	 *  @eventType com.kaltura.devicedetection.DeviceDetectionEvent.ERROR_CAMERA
	 */
	[Event(name="errorCamera", type="com.kaltura.devicedetection.DeviceDetectionEvent")]

	public class DeviceDetector extends EventDispatcher
	{
		public var webCam:Camera = null;
		private var camerasNumber:int = Camera.names.length;
		private var testedCameraIndex:int = -1;
		private var testedCamera:Camera;
		private var testedVideo:Video = new Video (50, 50);
		private var testRect:Rectangle = new Rectangle (0, 0, 50, 50);
		private var testedBitmapData:BitmapData = new BitmapData (50, 50, false, 0x0);
		private var blackBitmapData:BitmapData = new BitmapData (50, 50, false, 0x0);
		private var delayDetectCameraIndex:uint = 0;
		private var cameraFails:uint = 0;
		public var maxCameraFails:uint = 3;

		public var microphone:Microphone = null;
		private var microphonesNumber:int = Microphone.names.length;
		private var testedMicrophoneIndex:int = 0;
		private var testedMicrophone:Microphone;
		private var mostActiveMicrophoneIndex:int = -1;
		private var mostActiveMicrophoneActivity:int = 0;
		private var testNetConnection:NetConnection;
		private var testNetStream:NetStream;
		private var useSilenceMicrophoneDetection:Boolean = false;
		private var delayDetectMicrphoneIndex:uint = 0;
		private var microphoneFails:uint = 0;
		public var maxMicrophoneFails:uint = 3;

		private var delayTime:uint;
		private var delayAfterFail:uint;
        private var MicTimer:Timer;
        private var everySecTimer:Timer;
    
        
		//////
		//		CCCCCCCCC		AAAAAAAAAAA			MMMMMM		   MMMMMM
		//		CCCCCCCCC		AAAAAAAAAAA			MMMMMMMMMM MMMMMMMMMM
		//		CCC				AAA		AAA			MMMM    MMMMM	 MMMM
		//		CCC				AAAAAAAAAAA			MMM		 MMM	  MMM
		//		CCCCCCCCC		AAA		AAA			MMM		  M		  MMM
		//		CCCCCCCCC		AAA		AAA			MMM				  MMM
		//////

		public function detectCamera (delay:uint = 500):void
		{
			delayTime = delay;
			delayAfterFail = delay * 2;
			testedCameraIndex = -1;
			if (delayDetectCameraIndex != 0)
				clearTimeout(delayDetectCameraIndex);
			testedBitmapData = new BitmapData (testRect.width, testRect.height, false, 0x0);
			blackBitmapData = new BitmapData (testRect.width, testRect.height, false, 0x0);
			blackBitmapData.fillRect(testRect, 0x0);
			detectNextCamera ();
		}

		private function detectNextCamera ():void
		{
			cameraFails = 0;

			if (webCam)
			{
				dispatchCameraSuccess ();
				return;
			}

			if (testedCameraIndex > 0 && testedCamera != null)
				testedCamera.removeEventListener(StatusEvent.STATUS, statusCameraHandler);

			if ((++testedCameraIndex) >= camerasNumber)
			{
				//we didn't find any camera on the system..
				dispatchCameraError ();
				return;
			}

			testedCamera = Camera.getCamera(testedCameraIndex.toString());

			if (testedCamera == null)
			{
				if (camerasNumber > 0)
				{
					//there are devices on the system but we don't get access directly to them...
					//let the user set the access to the default camera:
					// NOTE: this should never happen here, because we use the specific access to the camera object
					// rather than using the default getCamera ();
					Security.showSettings(SecurityPanel.CAMERA);
				} else {
					//we don't have any camera device!
					dispatchCameraError ();
				}
				return;
			}

			testedBitmapData.fillRect(testRect, 0x0);
			testedVideo.attachCamera(null);
			testedVideo.clear();
			testedCamera.addEventListener(StatusEvent.STATUS, statusCameraHandler);
			testedVideo.attachCamera(testedCamera);

			if (!testedCamera.muted)
		    {
		        trace("User selected Accept already.");
				delay_testCameraImage ();
		    } else {
		    	//the user selected not to allow access to the devices.
		    	Security.showSettings(SecurityPanel.PRIVACY);
		    }
		}

		private function statusCameraHandler (event:StatusEvent):void
		{
			switch (event.code)
		    {
		        case "Camera.Muted":
		            trace("Camera: User clicked Deny.");
		            dispatchCameraError ();
		            break;

		        case "Camera.Unmuted":
		            trace("Camera: User clicked Accept.");
		          	delay_testCameraImage ();
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
		private function delay_testCameraImage ():void
		{
			delayDetectCameraIndex = setTimeout (testCameraImage, (cameraFails > 0) ? delayAfterFail : delayTime);
		}

		private function testCameraImage ():void
		{
			testedBitmapData.draw(testedVideo);
			var testResult:Object = testedBitmapData.compare(blackBitmapData);
			trace ("camera test: " + testedCameraIndex);
			
			// Added currentFPS check to make sure if the camera is active.
			if (testResult is BitmapData || testedCamera.currentFPS != 0)
			{
				//it's different, we have an image!
				dispatchCameraSuccess ();
			} else {
				//camera is not available for some reson, we don't get any image.
				// move to check the next camera
				if ((++cameraFails) < maxCameraFails)
				{
					delay_testCameraImage ();
				} else {
					detectNextCamera ();
				}
			}
		}

		private function dispatchCameraSuccess ():void
		{
			disposeCamera ();
			webCam = Camera.getCamera(testedCameraIndex.toString());
			dispatchEvent(new DeviceDetectionEvent (DeviceDetectionEvent.DETECTED_CAMERA, webCam));
		}

		private function dispatchCameraError ():void
		{
			disposeCamera ();
			webCam = null;
			dispatchEvent(new DeviceDetectionEvent (DeviceDetectionEvent.ERROR_CAMERA, webCam));
			ExternalInterface.call("noCamerasFound")
		}

		private function disposeCamera ():void
		{
			if (testedCamera)
				testedCamera.removeEventListener(StatusEvent.STATUS, statusCameraHandler);
			testedCamera = null;
			testedVideo.attachCamera(null);
			testedVideo.clear();
			if (blackBitmapData)
				blackBitmapData.dispose();
			if (testedBitmapData)
				testedBitmapData.dispose();
		}


		//////
		//		MMMMMM		   MMMMMM			IIIIIIIIIII			CCCCCCCCC
		//		MMMMMMMMMM MMMMMMMMMM			IIIIIIIIIII			CCCCCCCCC
		//		MMMM    MMMMM	 MMMM				III				CCC
		//		MMM		 MMM	  MMM				III				CCC
		//		MMM		  M		  MMM			IIIIIIIIIII			CCCCCCCCC
		//		MMM				  MMM			IIIIIIIIIII			CCCCCCCCC
		//////

		public function detectMicrophone ():void
		{
			testedMicrophone=Microphone.getMicrophone(testedMicrophoneIndex);
			if(!testedMicrophone)
			{
				dispatchEvent(new DeviceDetectionEvent (DeviceDetectionEvent.ERROR_MICROPHONE, null));
				return;
			}
			testedMicrophone.setUseEchoSuppression(true)
			testedMicrophone.setLoopBack(true);//this is for provoking some activity input when it's not streaming
			testedMicrophone.setSilenceLevel(5);
			testedMicrophone.gain=90
			var timeLapse:String= ""//Application.application.parameters.testLapse;
			var timeValue:Number
			ExternalInterface.addCallback("openSettings",openSettings);
			if (timeLapse != null){
			timeValue=Number(timeLapse)
			MicTimer=new Timer (20000,0);
			everySecTimer=new Timer(timeValue/1000);	
			}
			else
			{
			MicTimer=new Timer (20000,0);	
			everySecTimer=new Timer(1000,20);
			}
			MicTimer.addEventListener(TimerEvent.TIMER, checkMicActivity);
			everySecTimer.addEventListener(TimerEvent.TIMER, onEverySec);
			if (testedMicrophone.muted==false)
			{
			addTimers()
			}
			else
			{
			testedMicrophone.addEventListener(StatusEvent.STATUS, statusHandler);
			}
		}
        
        private function addTimers():void
        {	
            MicTimer.start()
        	everySecTimer.start()	
        }
        
        private function stopTimers():void
        {
        	MicTimer.stop()	
        	everySecTimer.stop()
        }
        
        private function statusHandler(event:StatusEvent):void 
        {
			trace(event.code)
        	if (event.code=="Microphone.Unmuted")
        	{
        		addTimers()
        		trace("The user allows open the mic...")
        	}
        	
            if(event.code=="Microphone.Muted")   
           {
           	trace("The user does not allows to use the mic...");
           	////HERE A JS alert: "Are you sure you don't allow the mic to be open? You won't be able to record with audio..
           try {
				//KRecord.delegator("micDenied");
			   dispatchEvent(new DeviceDetectionEvent (DeviceDetectionEvent.MIC_DENIED, null));
                ExternalInterface.call("micDenied");
                }
                catch(errObject:Error) {
                  trace(errObject.message);
                }
           }
           
        }
       
       public function openSettings():void
       {
       	Security.showSettings("2");
       }


        private function checkMicActivity(timerEvent:TimerEvent):void
        {
        	if (testedMicrophone.activityLevel<2)
        	{
        	 detectNextMicrophone()	
        	}
        	else
        	{
        	success()
        	}
        }
        
        private function onEverySec(timerEvent:TimerEvent):void
        {
         if (testedMicrophone.activityLevel>2)
         {
         	success()
         }	
        }
        
       private function success():void
       {
       	    stopTimers()
        	dispatchMicrophoneSuccess ()
        	try {
               ExternalInterface.call("workingMicFound");
                }
            catch(errObject:Error) {
              trace(errObject.message);
                }
        	trace("working Mic Found")
       }
        
		private function detectNextMicrophone ():void
		{
			testedMicrophoneIndex++
			if (testedMicrophoneIndex < microphonesNumber)
			{
				detectMicrophone ()
			}
			else
			{
				////HERE A JS alert: "Not Working mics were found on your computer" Please check the configuration
			    try {
			    	 openSettings()
                     ExternalInterface.call("noMicsFound");
                    }
                catch(errObject:Error) {
                     trace(errObject.message);
                    }
				dispatchEvent(new DeviceDetectionEvent (DeviceDetectionEvent.ERROR_MICROPHONE, null));
			}
			return;
		}


		private function dispatchMicrophoneSuccess ():void
		{
			disposeMicrophone()
			microphone = Microphone.getMicrophone(testedMicrophoneIndex);
 			microphone.setUseEchoSuppression(true);
			microphone.gain=90
			dispatchEvent(new DeviceDetectionEvent (DeviceDetectionEvent.DETECTED_MICROPHONE, microphone));
			ExternalInterface.addCallback("getMicophoneActivityLevel",getActivityNow)
			microphone.setSilenceLevel(0);
		}

        private function getActivityNow():int
        {
        	var activ:int=microphone.activityLevel;
        	return activ;
        }


        private function disposeMicrophone ():void
		{
			if (testedMicrophone)
			{
				testedMicrophone.setLoopBack(false);
				testedMicrophone.gain=0
			}
			testedMicrophone = null;
		}


		/////// ============= singletone
		/**
		 *Constructor + getInsance.
		 */
		static private var _instance:DeviceDetector;

		public function DeviceDetector():void
		{
			if (_instance)
				throw (new Error ("you can't instantiate singletone more than once, use getInstance instead."));

			testedVideo.smoothing = false;
			testedVideo.deblocking = 1;
		}

		static public function getInstance ():DeviceDetector
		{
			if (!_instance)
				_instance = new DeviceDetector ();
			return _instance;
		}
		
		
	}
}