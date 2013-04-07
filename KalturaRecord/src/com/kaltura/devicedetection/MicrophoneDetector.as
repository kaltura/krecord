package com.kaltura.devicedetection
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.media.Microphone;
	import flash.system.Security;
	import flash.utils.Timer;

	
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
	 *  dispatched to notify microphone is denied by user.
	 *  @eventType com.kaltura.devicedetection.DeviceDetectionEvent.MIC_DENIED
	 */
	[Event(name = "micDenied", type = "com.kaltura.devicedetection.DeviceDetectionEvent")]

	
	/**
	 *  dispatched to notify microphone is allowed by user.
	 *  @eventType com.kaltura.devicedetection.DeviceDetectionEvent.MIC_ALLOWED
	 */
	[Event(name = "micAllowed", type = "com.kaltura.devicedetection.DeviceDetectionEvent")]
	
	public class MicrophoneDetector extends EventDispatcher
	{
		
		/**
		 * the allowed microphone, once found 
		 */
		public var microphone:Microphone = null;
		
		private var _totalMicrophones:int = Microphone.names.length;
		private var _testedMicrophoneIndex:int = 0;
		private var _testedMicrophone:Microphone;
		
		/**
		 * used to move to the next microphone if no activity is detected in current one
		 */
		private var _micTimer:Timer;
		
		/**
		 * used to test microphone activity levels every second for 20 seconds or until activity is met 
		 */
		private var _everySecTimer:Timer;

		
		/**
		 * C'tor. 
		 */
		public function MicrophoneDetector() {}
		
		
		/**
		 * start mic detection process
		 * @param timePerMic	delay before trying the next microphone (ms)
		 * @param timePerCheck	delay between activity checks for current microphone (ms)
		 */
		public function detectMicrophone(timePerMic:int = 20000, timePerCheck:int = 1000):void {
			if (Microphone.names.length == 0) {
				// no microphones installed
				dispatchEvent(new DeviceDetectionEvent(DeviceDetectionEvent.ERROR_MICROPHONE, null));
				return;
			}
			// add listener to default microphone
			Microphone.getMicrophone().addEventListener(StatusEvent.STATUS, statusHandler);
			// create check timers
			_micTimer = new Timer(timePerMic, 1);
			_micTimer.addEventListener(TimerEvent.TIMER, nextMicrophone); 
			_everySecTimer = new Timer(timePerCheck, 0);
			_everySecTimer.addEventListener(TimerEvent.TIMER, checkActivity);
			// start detection
			detectMicrophone2(timePerMic, timePerCheck);
		}
		
		
		/**
		 * 
		 * @param timePerMic	delay before trying the next microphone (ms)
		 * @param timePerCheck	delay between activity checks for current microphone (ms)
		 * 
		 */
		private function detectMicrophone2(timePerMic:int = 20000, timePerCheck:int = 1000):void {
			_testedMicrophone = Microphone.getMicrophone(_testedMicrophoneIndex);
			if (!_testedMicrophone) {
				dispatchEvent(new DeviceDetectionEvent(DeviceDetectionEvent.ERROR_MICROPHONE, null));
				// clear timer listenres before return
				_micTimer.removeEventListener(TimerEvent.TIMER, nextMicrophone);
				_everySecTimer.removeEventListener(TimerEvent.TIMER, checkActivity);
				return;
			}
			// got a mic, lets see if it works:
			_testedMicrophone.setUseEchoSuppression(true)
			_testedMicrophone.setLoopBack(true); //this is for provoking some activity input when it's not streaming
			_testedMicrophone.setSilenceLevel(5);
			_testedMicrophone.gain = 90;
			
			if (!_testedMicrophone.muted) {
				// if the microphone is not denied by user, start activity check to verify mic is working properly 
				startActivityTest();
			}
			else {
				// if user denied microphone, wait for mic status change.
				_testedMicrophone.addEventListener(StatusEvent.STATUS, statusHandler);
			}
		}
		
		
		private function startActivityTest():void {
			_micTimer.start();
			_everySecTimer.start();
		}
		
		
		private function stopActivityTest():void {
			_micTimer.reset();
			_everySecTimer.reset();
		}
		
		
		private function statusHandler(event:StatusEvent):void {
			if (microphone) {
				// microphone was found before, it is now muted / unmuted
				if (event.code == "Microphone.Unmuted") {
					dispatchEvent(new DeviceDetectionEvent(DeviceDetectionEvent.MIC_ALLOWED, microphone));
				}
				else if (event.code == "Microphone.Muted") {
					dispatchEvent(new DeviceDetectionEvent(DeviceDetectionEvent.MIC_DENIED, null));
				}
			}
			else {
				// still part of detection flow
//				if (_testedMicrophone != Microphone.getMicrophone()) {
//					_testedMicrophone.removeEventListener(StatusEvent.STATUS, statusHandler);
//				}
				if (event.code == "Microphone.Unmuted") {
					startActivityTest();
					trace("The user allows using the mic.");
				}
				else if (event.code == "Microphone.Muted") {
					trace("The user does not allow using the mic.");
					////HERE A JS alert: "Are you sure you don't allow the mic to be open? You won't be able to record with audio..
					dispatchEvent(new DeviceDetectionEvent(DeviceDetectionEvent.MIC_DENIED, null));
				}
			}
		}
		
		
		
		/**
		 * if no activity yet, move to next microphone 
		 * @param timerEvent
		 */
		private function nextMicrophone(timerEvent:TimerEvent):void {
			if (_testedMicrophone.activityLevel > 2) {
				workingMicFound();
			}
			else {
				stopActivityTest();
				detectNextMicrophone();
			}
		}
		
		
		/**
		 * look for microphone activity 
		 * @param timerEvent
		 */
		private function checkActivity(timerEvent:TimerEvent):void {
			if (_testedMicrophone.activityLevel > 2) {
				workingMicFound();
			}
		}
		
		
		private function workingMicFound():void {
			stopActivityTest();
			dispatchMicrophoneSuccess();
			
			trace("working Mic Found")
			// clear timer listeners before return
			_micTimer.removeEventListener(TimerEvent.TIMER, nextMicrophone);
			_everySecTimer.removeEventListener(TimerEvent.TIMER, checkActivity);
		}
		
		
		
		private function detectNextMicrophone():void {
			_testedMicrophoneIndex++;
			if (_testedMicrophoneIndex < _totalMicrophones) {
				// got more mics to check
				detectMicrophone2();
			}
			else {
				// "Not Working mics were found on your computer" Please check the configuration
				dispatchEvent(new DeviceDetectionEvent(DeviceDetectionEvent.ERROR_MICROPHONE, null));
			}
			return;
		}
		
		
		private function dispatchMicrophoneSuccess():void {
			disposeMicrophone();
			microphone = Microphone.getMicrophone(_testedMicrophoneIndex);
			microphone.setUseEchoSuppression(true);
			microphone.gain = 90
			dispatchEvent(new DeviceDetectionEvent(DeviceDetectionEvent.DETECTED_MICROPHONE, microphone));
			microphone.setSilenceLevel(0);
		}
		
		
		public function getActivityNow():int {
			var activ:int = microphone.activityLevel;
			return activ;
		}
		
		
		private function disposeMicrophone():void {
			if (_testedMicrophone) {
				_testedMicrophone.setLoopBack(false);
				_testedMicrophone.gain = 0
			}
			_testedMicrophone = null;
		}

	}
}