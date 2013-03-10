package com.kaltura.utils
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.NetStream;
	import flash.utils.Timer;
	
	/**
	 * verifies the buffer contents changes over time
	 * @author atar.shadmi
	 */
	public class ConnectionTester extends EventDispatcher {
		
		public static const SUCCESS:String = "success";
		public static const FAIL:String = "fail";
		
		/**
		 * timer for checking test timeout 
		 */
		private var _timeOut:Timer;
		
		/**
		 * timer for checking buffer contents 
		 */		
		private var _tester:Timer;
		
		/**
		 * queried stream  
		 */		
		private var _stream:NetStream;
		
		private var _bufferLength:Number;
		
		public function ConnectionTester(stream:NetStream, timeout:int)
		{
			_stream = stream;
			
			_tester = new Timer(50);
			_tester.addEventListener(TimerEvent.TIMER, onTester);
			
			_timeOut = new Timer(timeout, 1);
			_timeOut.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeOut);
		}
		
		/**
		 * this method invokes the test process.
		 * after calling this method you should listen to either success or failed events. 
		 */		
		public function test():void {
			_bufferLength = _stream.bufferLength;
			_timeOut.reset();
			_timeOut.start();
			_tester.reset();
			_tester.start();
		}
		
		// compare buffer values
		private function onTester(e:TimerEvent):void {
			if (_bufferLength >= _stream.bufferLength) {
				// buffer is the same or emptier
				_bufferLength = _stream.bufferLength;
			}
			else {
				// buffer is filling up
				stop();
				dispatchEvent(new Event(ConnectionTester.SUCCESS));
			}
			
		}
		
		// notify fail
		private function onTimeOut(e:TimerEvent):void {
			// timeout reached with no buffer filling
			stop();
			dispatchEvent(new Event(ConnectionTester.FAIL));
		}
		
		/**
		 * stop the test, stop timers. 
		 */
		public function stop():void {
			_timeOut.stop();
			_tester.stop();
		}
		
		public function get running():Boolean {
			return _timeOut.running;
		}
		
	}
}