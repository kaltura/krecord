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
//o
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
package com.kaltura.recording.controller {
	import com.kaltura.KalturaClient;
	import com.kaltura.commands.media.MediaAddFromRecordedWebcam;
	import com.kaltura.devicedetection.DeviceDetectionEvent;
	import com.kaltura.devicedetection.DeviceDetector;
	import com.kaltura.events.KalturaEvent;
	import com.kaltura.net.streaming.ExNetConnection;
	import com.kaltura.net.streaming.RecordNetStream;
	import com.kaltura.net.streaming.events.ExNetConnectionEvent;
	import com.kaltura.net.streaming.events.FlushStreamEvent;
	import com.kaltura.net.streaming.events.RecordNetStreamEvent;
	import com.kaltura.net.streaming.parsers.StreamSourceVO;
	import com.kaltura.recording.business.AddEntryDelegate;
	import com.kaltura.recording.business.BaseRecorderParams;
	import com.kaltura.recording.business.interfaces.IResponder;
	import com.kaltura.recording.controller.events.AddEntryEvent;
	import com.kaltura.recording.controller.events.RecorderEvent;
	import com.kaltura.vo.KalturaMediaEntry;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.ObjectEncoding;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	import mx.utils.ObjectUtil;
	import mx.utils.UIDUtil;

	[Event(name = "detectedMicrophone", type = "com.kaltura.devicedetection.DeviceDetectionEvent")]
	[Event(name = "detectedCamera", type = "com.kaltura.devicedetection.DeviceDetectionEvent")]
	[Event(name = "errorMicrophone", type = "com.kaltura.devicedetection.DeviceDetectionEvent")]
	[Event(name = "errorCamera", type = "com.kaltura.devicedetection.DeviceDetectionEvent")]
	[Event(name = "netconnectionConnectClosed", type = "com.kaltura.net.streaming.events.ExNetConnectionEvent")]
	[Event(name = "netconnectionConnectFailed", type = "com.kaltura.net.streaming.events.ExNetConnectionEvent")]
	[Event(name = "netconnectionConnectSuccess", type = "com.kaltura.net.streaming.events.ExNetConnectionEvent")]
	[Event(name = "netconnectionConnectRejected", type = "com.kaltura.net.streaming.events.ExNetConnectionEvent")]
	[Event(name = "netconnectionConnectInvalidapp", type = "com.kaltura.net.streaming.events.ExNetConnectionEvent")]
	[Event(name = "netstreamRecordStart", type = "com.kaltura.net.streaming.events.RecordNetStreamEvent")]
	[Event(name = "netstreamPlayStop", type = "com.kaltura.net.streaming.events.RecordNetStreamEvent")]
	[Event(name = "flushStart", type = "com.kaltura.net.streaming.events.FlushStreamEvent")]
	[Event(name = "flushProgress", type = "com.kaltura.net.streaming.events.FlushStreamEvent")]
	[Event(name = "flushComplete", type = "com.kaltura.net.streaming.events.FlushStreamEvent")]
	[Event(name = "addEntryResult", type = "com.kaltura.recording.controller.events.AddEntryEvent")]
	[Event(name = "addEntryFault", type = "com.kaltura.recording.controller.events.AddEntryEvent")]
	
	/**
	 * dispatched when the buffer is empty after recording is stopped
	 * */
	[Event(name = "bufferEmpty", type = "flash.events.Event")]
	
	
	
	/**
	 * KRECORDER - Flash Video and Audio Recording and Contributing Application.
	 * <p>Goals:
	 *	1. Simplified Media Device Detection (Active Camera and Microphone).
	 *	2. Simplified Media Selection Interface (Functions for manually choosing devices from available devices array).
	 *	3. Server Connection and Error Handling.
	 *	4. Video and Audio Recording on Red5, Handling of internal NetStream Events and Errors.
	 *	5. Preview Mechanism - Live Preview using RTMP (Before addentry).
	 *	6. Simplified addentry function to Kaltura Network Servers.
	 *	7. Full JavaScript interaction layer.
	 *	8. Dispatching of Events by Single Object to simplify Development of Recording Applications.</p>
	 * KRecorder does NOT provide any visual elements beyond a native flash video component attached to the recording NetStream.
	 *
	 * @author Zohar Babin
	 */
	public class KRecordControl extends EventDispatcher implements IResponder, IRecordControl {

		private const EXPANDED_BUFFER_LENGTH:int = 15;
		private const START_BUFFER_LENGTH:int = 2;
		private const MAX_BUFFER_LENGTH:int = 40;

		/**
		 *partner and application settings.
		 */
		protected var _initRecorderParameters:BaseRecorderParams;

		/**
		 * when we need to wait for some operation to start we are connecting.
		 */
		private var _connecting:Boolean = false;

		private var _timeOutTimer:Timer = new Timer(1500, 1);


		public function get connecting():Boolean {
			return _connecting;
		}


		public function set connecting(value:Boolean):void {
			_connecting = value;

			if (_connecting)
				dispatchEvent(new Event(RecorderEvent.CONNECTING, true));
			else
				dispatchEvent(new Event(RecorderEvent.CONNECTING_FINISH, true));
		}

		private var _autoPreview:Boolean = true;


		public function get autoPreview():Boolean {
			return _autoPreview;
		}


		public function set autoPreview(value:Boolean):void {
			_autoPreview = value;
		}


		/**
		 * the initialization recorder partner and application parameters.
		 */
		public function get initRecorderParameters():BaseRecorderParams {
			return _initRecorderParameters;
		}


		public function set initRecorderParameters(recorder_parameters:BaseRecorderParams):void {
			_initRecorderParameters = recorder_parameters;
		}

		/**
		 *monitors the connection status to the RTMP recording server.
		 */
		public var isConnected:Boolean = false;

		/**
		 *microphone device.
		 */
		protected var microphone:Microphone;
		
		/**
		 *camera device.
		 */
		protected var camera:Camera;
		
		public var video:Video = new Video();


		/**
		 * sets the camera to use, and attaches it to the video component.
		 */
		protected function setCamera(_camera:Camera):void {
			camera = _camera;
			video.attachCamera(camera);
		}

		private var connection:NetConnection;
		private var _recordStream:NetStream;
		private var _previewStream:NetStream;

		protected var _streamUid:String = UIDUtil.createUID();


		/**
		 *the uid of the stream recorded.
		 */
		public function get streamUid():String {
			return _streamUid;
		}


		/**
		 * internal implicit setter to change the published stream uid.
		 * @param value		the new strea uid.
		 */
		private function setStreamUid(value:String):void {
			_streamUid = value;
			dispatchEvent(new RecorderEvent(RecorderEvent.STREAM_ID_CHANGE, _streamUid));
		}

		/**
		 * the timestamp of when the recording started.
		 */
		private var _recordStartTime:uint;

		private var _recordedTime:uint;

		private var _bufferTime:Number = 70;


		/**
		 * the duration of the recording in milliseconds.
		 */
		public function get recordedTime():uint {
			return _recordedTime;
		}

		private var _waitForBufferFlush:Boolean = false;
		private var _firstPreviewPause:Boolean = true;


		/**
		 *sets camera recording quality.
		 * @param quality		An integer that specifies the required level of picture quality,
		 * 						as determined by the amount of compression being applied to each video frame. Acceptable values range from 1
		 * 						(lowest quality, maximum compression) to 100 (highest quality, no compression).
		 * 						To specify that picture quality can vary as needed to avoid exceeding bandwidth, pass 0 for quality.
		 * @param bw			Specifies the maximum amount of bandwidth that the current outgoing video feed can use,
		 * 						in bytes per second. To specify that Flash Player video can use as much bandwidth as needed to
		 * 						maintain the value of quality, pass 0 for bandwidth. The default value is 16384.
		 * @param w				the width of the frame.
		 * @param h				the height of the frame.
		 * @param fps			frame per second to use.
		 * @param gop			Specifies which video frames are transmitted in full (called keyframes) instead of being interpolated by the video compression algorithm
		 */
		public function setQuality(quality:int, bw:int, w:int, h:int, fps:Number, gop:int = 15):void {
			camera.setKeyFrameInterval(gop)
			camera.setMode(w, h, fps);
			camera.setQuality(bw, quality);
		}


		/**
		 *resize the video display.
		 * @param w		the new width.
		 * @param h		the new height.
		 */
		public function resizeVideo(w:Number, h:Number):void {
			if (camera) {
				video = new Video(w, h);
				video.width = w;
				video.height = h;
				video.attachCamera(camera);
			}
		}


		/**
		 * an internal implicit setter to recordTime property.
		 * @param value		the new stream recorded length.
		 */
		protected function setRecordedTime(value:uint):void {
			_recordedTime = value;
			dispatchEvent(new RecorderEvent(RecorderEvent.UPDATE_RECORDED_TIME, _recordedTime));
		}

		private var _blackRecordTime:uint = 0;


		/**
		 * this is the blacked out recording time since the client sent request to record and the server sent approve.
		 * we later cut the stream accordingly.
		 */
		public function get blackRecordTime():uint {
			return _blackRecordTime;
		}


		/**
		 * an internal implicit setter to the blackRecordTime property.
		 * @param val	the new duration between record command and actual publish start.
		 */
		protected function setBlackRecordTime(val:uint):void {
			_blackRecordTime = val;
		}


		/**
		 * activity level measured on the microphone.
		 */
		public function get micophoneActivityLevel():Number {
			if (microphone)
				return microphone.activityLevel;
			else
				return 0;
		}


		/**
		 * Returns the gain of the microphone
		 * @return
		 *
		 */
		public function get microphoneGain():Number {
			if (microphone)
				return microphone.gain;
			else
				return 0;
		}


		public function set microphoneGain(val:Number):void {
			if (microphone) {
				microphone.gain = val;
			}

		}


		/**
		 * locate active input devices.
		 */
		public function deviceDetection():void {

			detectMicrophoneDevice();
		}


		/**
		 * detect the most active microphone device.
		 */
		protected function detectMicrophoneDevice():void {
			if (!microphone) {
				DeviceDetector.getInstance().addEventListener(DeviceDetectionEvent.DETECTED_MICROPHONE, microphoneDeviceDetected, false, 0, true);
				DeviceDetector.getInstance().addEventListener(DeviceDetectionEvent.ERROR_MICROPHONE, microphoneDetectionError, false, 0, true);
				DeviceDetector.getInstance().addEventListener(DeviceDetectionEvent.MIC_DENIED, microphoneDenyError, false, 0, true);
				DeviceDetector.getInstance().detectMicrophone();
			}
			else {
				detectCameraDevice();
			}
		}


		/**
		 * microphone detected.
		 */
		private function microphoneDeviceDetected(event:DeviceDetectionEvent):void {
			removeMicrophoneDetectionListeners();
			microphone = DeviceDetector.getInstance().microphone;
			dispatchEvent(event.clone());
			detectCameraDevice();
		}


		/**
		 * camera deny
		 */
		private function cameraDenyError(event:DeviceDetectionEvent):void {
			dispatchEvent(event.clone());
		}


		/**
		 * microphone deny
		 */
		private function microphoneDenyError(event:DeviceDetectionEvent):void {
			dispatchEvent(event.clone());
		}


		/**
		 * no microphone detected.
		 */
		private function microphoneDetectionError(event:DeviceDetectionEvent):void {
			removeMicrophoneDetectionListeners();
			dispatchEvent(event.clone());
			detectCameraDevice();
		}


		private function removeMicrophoneDetectionListeners():void {
			DeviceDetector.getInstance().removeEventListener(DeviceDetectionEvent.DETECTED_MICROPHONE, microphoneDeviceDetected);
			DeviceDetector.getInstance().removeEventListener(DeviceDetectionEvent.ERROR_MICROPHONE, microphoneDetectionError);
		}


		/**
		 * detect the most active camera device.
		 */
		protected function detectCameraDevice():void {
			DeviceDetector.getInstance().addEventListener(DeviceDetectionEvent.DETECTED_CAMERA, cameraDeviceDetected, false, 0, true);
			DeviceDetector.getInstance().addEventListener(DeviceDetectionEvent.CAMERA_DENIED, cameraDenyError, false, 0, true);
			DeviceDetector.getInstance().addEventListener(DeviceDetectionEvent.ERROR_CAMERA, cameraDetectionError, false, 0, true);
			if (Global.DETECTION_DELAY != 0) {
				DeviceDetector.getInstance().detectCamera(Global.DETECTION_DELAY);
			}
			else {
				DeviceDetector.getInstance().detectCamera();
			}
		}


		/**
		 * camera detected.
		 */
		private function cameraDeviceDetected(event:DeviceDetectionEvent):void {
			removeCameraDetectionListeners();
			setCamera(DeviceDetector.getInstance().webCam);
			dispatchEvent(event.clone());
		}


		/**
		 * no camera detected.
		 */
		private function cameraDetectionError(event:DeviceDetectionEvent):void {
			removeCameraDetectionListeners();
			dispatchEvent(event.clone());
		}


		private function removeCameraDetectionListeners():void {
			DeviceDetector.getInstance().removeEventListener(DeviceDetectionEvent.DETECTED_CAMERA, cameraDeviceDetected);
			DeviceDetector.getInstance().removeEventListener(DeviceDetectionEvent.ERROR_CAMERA, cameraDetectionError);
		}


		/**
		 * a list of available camera devices on the system.
		 */
		public function getCameras():Array {
			return Camera.names;
		}


		/**
		 * manually set the camera device to use.
		 */
		public function setActiveCamera(camera_name:String):void {
			removeCameraDetectionListeners();
			var i:int;
			var found:Boolean = false;
			for (i = 0; i < Camera.names.length; ++i) {
				if (camera_name == Camera.names[i]) {
					found = true;
					break;
				}
			}
			setCamera(Camera.getCamera(found == true ? i.toString() : null));
		}


		/**
		 * a list of available microphone devices on the system.
		 */
		public function getMicrophones():Array {
			return Microphone.names;
		}


		/**
		 * manually select the microphone device to use.
		 */
		public function setActiveMicrophone(microphone_name:String):void {
			removeMicrophoneDetectionListeners();
			var i:int;
			var found:Boolean = false;
			for (i = 0; i < Microphone.names.length; ++i) {
				if (microphone_name == Microphone.names[i]) {
					found = true;
					break;
				}
			}
			microphone = Microphone.getMicrophone(found == true ? i : null);
		}


		/**
		 * start a connection to the streaming server.
		 */
		public function connectToRecordingServie():void {
			isConnected = false;
//			netConnection = new ExNetConnection ();
			connection = new NetConnection();
			NetConnection.defaultObjectEncoding = ObjectEncoding.AMF0;
			connection.addEventListener(NetStatusEvent.NET_STATUS, onNetConnectionStatus);
//			netConnection.addEventListener(ExNetConnectionEvent.NETCONNECTION_CONNECT_SUCCESS, connectionSuccess, false, 0, true);
//			netConnection.addEventListener(ExNetConnectionEvent.NETCONNECTION_CONNECT_CLOSED, connectionFailed, false, 0, true);
//			netConnection.addEventListener(ExNetConnectionEvent.NETCONNECTION_CONNECT_FAILED, connectionFailed, false, 0, true);
//			netConnection.addEventListener(ExNetConnectionEvent.NETCONNECTION_CONNECT_INVALIDAPP, connectionFailed, false, 0, true);
//			netConnection.addEventListener(ExNetConnectionEvent.NETCONNECTION_CONNECT_REJECTED, connectionFailed, false, 0, true);
//			netConnection.addEventListener(NetStatusEvent.NET_STATUS,onNetConnectionStatus);
			connection.connect(_initRecorderParameters.rtmpHost);
		}


		/**
		 * connected to the streaming server successfully.
		 */
		private function connectionSuccess(event:NetStatusEvent):void {
			var exEvent:ExNetConnectionEvent = new ExNetConnectionEvent(ExNetConnectionEvent.NETCONNECTION_CONNECT_SUCCESS, null, event.info);
			createRecordStream(exEvent);
			createPreviewStream();
		}


		/**
		 * there was an error in connecting the streaming server.
		 */
		private function connectionFailed(event:NetStatusEvent):void {
			var exEventType:String;
			switch (event.info.code) {
				case "NetConnection.Connect.InvalidApp":
					exEventType = ExNetConnectionEvent.NETCONNECTION_CONNECT_INVALIDAPP;
					break;
				case "NetConnection.Connect.Closed":
					exEventType = ExNetConnectionEvent.NETCONNECTION_CONNECT_CLOSED;
					break;
				case "NetConnection.Connect.Rejected":
					exEventType = ExNetConnectionEvent.NETCONNECTION_CONNECT_REJECTED;
					break;
				case "NetConnection.Connect.Failed":
				default:
					exEventType = ExNetConnectionEvent.NETCONNECTION_CONNECT_FAILED;
					break;
			}
			var exEvent:ExNetConnectionEvent = new ExNetConnectionEvent(exEventType, null, event.info)
			isConnected = false;
			trace("can't connect to streaming server, " + ObjectUtil.toString(exEvent.connectionInfo));
//			dispatchEvent(event.clone());
			dispatchEvent(exEvent);
		}


		/**
		 * open a stream to publish on.
		 */
		protected function createRecordStream(event:ExNetConnectionEvent = null):void {
			if (_recordStream) {
				_recordStream.removeEventListener(NetStatusEvent.NET_STATUS, onRecordNetStatus);
//				netStream.removeEventListener(FlushStreamEvent.FLUSH_START, streamFlushBubble);
//				netStream.removeEventListener(FlushStreamEvent.FLUSH_COMPLETE, streamFlushBubble);
//				netStream.removeEventListener(FlushStreamEvent.FLUSH_PROGRESS, streamFlushBubble);
//				netStream.removeEventListener(RecordNetStreamEvent.NETSTREAM_RECORD_START, recordStarted);
//				netStream.removeEventListener(RecordNetStreamEvent.NETSTREAM_PLAY_COMPLETE, stoppedStream);
//				netStream.removeEventListener(NetStatusEvent.NET_STATUS , onNetStatus );
			}
//			netStream = new RecordNetStream (netConnection, UIDUtil.createUID(), true, true);
//			netStream.bufferTime = _bufferTime;
//			netStream.addEventListener(FlushStreamEvent.FLUSH_START, streamFlushBubble, false, 0, true);
//			netStream.addEventListener(FlushStreamEvent.FLUSH_COMPLETE, streamFlushBubble, false, 0, true);
//			netStream.addEventListener(FlushStreamEvent.FLUSH_PROGRESS, streamFlushBubble, false, 0, true);
//			netStream.addEventListener(RecordNetStreamEvent.NETSTREAM_RECORD_START, recordStarted, false, 0, true);
//			netStream.addEventListener(RecordNetStreamEvent.NETSTREAM_PLAY_COMPLETE, stoppedStream, false, 0, true);
//			netStream.addEventListener(NetStatusEvent.NET_STATUS , onNetStatus );
//			

			_recordStream = new NetStream(connection);
			_recordStream.client = new KRecordNetClient();
			_recordStream.addEventListener(NetStatusEvent.NET_STATUS, onRecordNetStatus);
			_recordStream.bufferTime = MAX_BUFFER_LENGTH;

			isConnected = true;
			if (event)
				dispatchEvent(event.clone());
		}


		private function createPreviewStream():void {
			if (_previewStream) {
//				_previewStream.removeEventListener(AsyncErrorEvent.ASYNC_ERROR,	AsyncErrorHandler);
//				_previewStream.removeEventListener(IOErrorEvent.IO_ERROR,		IOErrorHandler);
				_previewStream.removeEventListener(NetStatusEvent.NET_STATUS, onPreviewNetStatus);
			}

			//Create the playBack Stream
			_previewStream = new NetStream(connection);
			_previewStream.client = new KRecordNetClient();

//			in_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR,	AsyncErrorHandler);
//			in_stream.addEventListener(IOErrorEvent.IO_ERROR,		IOErrorHandler);
			_previewStream.addEventListener(NetStatusEvent.NET_STATUS, onPreviewNetStatus);

			KRecordNetClient(_previewStream.client).addEventListener(KRecordNetClient.ON_STREAM_END, playEndHandler);
		}


		private function playEndHandler(evt:Event):void {
			stopPreviewRecording();
		}


		private function onRecordNetStatus(evt:NetStatusEvent):void {
			trace("Record stream net status: " + evt.info.code);
			switch (evt.info.code) {
				case "NetStream.Buffer.Flush":
					var flushEvent:FlushStreamEvent = new FlushStreamEvent(FlushStreamEvent.FLUSH_COMPLETE, 0, 0);
					dispatchEvent(flushEvent);
					break;
				case "NetStream.Record.Start":
					var recordNetStreamEvt:RecordNetStreamEvent = new RecordNetStreamEvent(RecordNetStreamEvent.NETSTREAM_RECORD_START);
					recordStarted(recordNetStreamEvt)
					break;
			}
		}


		/**
		 * the net connection status report while working.
		 */
		protected function onNetConnectionStatus(event:NetStatusEvent):void {
			trace("NetConnectionStatus: " + event.info.code);
			switch (event.info.code) {
				case "NetConnection.Connect.Success":
					connectionSuccess(event);
					break;
				case "NetConnection.Connect.InvalidApp":
				case "NetConnection.Connect.Failed":
				case "NetConnection.Connect.Closed":
				case "NetConnection.Connect.Rejected":
					connectionFailed(event);
					break;
			}
			dispatchEvent(event);
		}


		/**
		 * the stream report on a net status event while working.
		 */
		private function onPreviewNetStatus(event:NetStatusEvent):void {
			trace("NetStatusEvent: " + event.info.code);

			switch (event.info.code) {
				case "NetStream.Play.InsufficientBW":
				case "NetStream.Buffer.Full":
					if ((event.target).bufferLength <= EXPANDED_BUFFER_LENGTH)
						(event.target).bufferTime = 2 * EXPANDED_BUFFER_LENGTH;
					else
						(event.target).bufferTime = EXPANDED_BUFFER_LENGTH;

					if (_timeOutTimer.running) {
						_timeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimeOut);
						_timeOutTimer.stop();
						_timeOutTimer.reset();
					}
					connecting = false;
					break;
				case "NetStream.Buffer.Empty":
					(event.target).bufferTime = START_BUFFER_LENGTH;
					_timeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeOut);
					_timeOutTimer.start();

					connecting = true;
					break;
				case "NetStream.Play.Stop":
				case "NetStream.Unpause.Notify":
					connecting = false;

					notifyFinish();
					break;
			}

			dispatchEvent(event);
		}


		private function notifyFinish():void {
			var evt:RecordNetStreamEvent = new RecordNetStreamEvent(RecordNetStreamEvent.NETSTREAM_PLAY_COMPLETE);
			dispatchEvent(evt);
		}


		private function onTimeOut(evt:TimerEvent):void {
			stopPreviewRecording();
			connecting = false;

			notifyFinish();
		}


		private function readyToPreview():void {
			_firstPreviewPause = false;
			resume();
		}



		/**
		 * the server confirmed start recording.
		 */
		protected function recordStarted(event:RecordNetStreamEvent):void {
			trace("recordStarted");
			connecting = false;
			dispatchEvent(event.clone());
			setBlackRecordTime(getTimer() - _recordStartTime);
		}


		/**
		 * the stream has endded play (after preview finished).
		 */
		protected function stoppedStream(event:RecordNetStreamEvent):void {
			trace("stoppedStream");
			_firstPreviewPause = true;
			delayedStoppedHandler(event);
		}


		private function delayedStoppedHandler(event:RecordNetStreamEvent):void {
			trace("delayedStoppedHandler");
			clearVideoAndSetCamera();
			dispatchEvent(event);
		}


		/**
		 * clear the preview and set camera back
		 */
		public function clearVideoAndSetCamera():void {
			trace("clearVideoAndSetCamera");
			video.attachNetStream(null);
			createRecordStream();
			setCamera(camera);
		}


		/**
		 * start publishing the audio.
		 */
		public function recordNewStream():void {
			if (_recordStream) {
				setCamera(camera);
				if (camera)
					_recordStream.attachCamera(camera);
				if (microphone)
					_recordStream.attachAudio(microphone);
				setStreamUid(UIDUtil.createUID());
				trace("publishing: " + _streamUid);
				connecting = true; //setting loader until the Record.Start is called
				_recordStream.publish(_streamUid, RecordNetStream.PUBLISH_METHOD_RECORD);
				_recordStartTime = getTimer();
//				inter = setInterval(track, 50);
			}
		}
		
		private var inter:int;
		
//		private function track():void {
//			trace('bufferLength: ', _recordStream.bufferLength);
//		}
		
		
		/**
		 * if buffer empty, close stream and notify
		 * */
		private function checkBufferFlushed():void {
			trace("buffer: ", _recordStream.bufferLength);
			if (_recordStream.bufferLength <= 0) {
				clearInterval(inter);
				_recordStream.close();
				_recordHalted = false;
				dispatchEvent(new Event("bufferEmpty"));
			}
		}

		/**
		 * stop publishing to the server: attach null camera and mic so the stream 
		 * will keep publishing. when buffer is empty, we close it.
		 * @see checkBufferFlushed()
		 */
		public function stopRecording():void {
//			clearInterval(inter);
			setRecordedTime(getTimer() - _recordStartTime);
			if (_recordStream) {
				_recordHalted = true;
				_recordStream.attachAudio(null);
				_recordStream.attachCamera(null);
				inter = setInterval(checkBufferFlushed, 50);
			}
		}

		private var _recordHalted:Boolean;

		/**
		 * play the recorded stream.
		 */
		public function previewRecording():void {
			trace("previewRecording");
			if (_previewStream) {
				connecting = true;
				video.attachNetStream(_previewStream);
				trace("playing: " + _streamUid);
				_previewStream.play(_streamUid);
			}
		}


		/**
		 * stop the playing stream.
		 */
		public function stopPreviewRecording():void {
			trace("stopPreviewRecording");
			if (_previewStream) {
				_firstPreviewPause = true;
				_previewStream.close();
			}
		}


		/**
		  * pause the playing stream.
		  */
		public function pausePreviewRecording():void {
			trace("pausePreviewRecording");
			if (_previewStream) {
				_previewStream.pause();
			}
		}


		/**
		 * seek the playing stream.
		 */
		public function seek(offset:Number):void {
			trace("seek");
			if (_previewStream)
				_previewStream.seek(offset);
		}


		/**
		 * resume the playing stream.
		 */
		public function resume():void {
			trace("resume");
			if (_previewStream)
				_previewStream.resume();
		}


		/**
		 * The position of the playing stream playhead, in seconds.
		 */
		public function get playheadTime():Number {
			if (_previewStream) {
				return _previewStream.time;
			}

			return NaN;
		}


		/**
		 * set the recorder netStream bufferTime.
		 */
		public function set bufferTime(value:Number):void {
			_bufferTime = value;

			if (_recordStream)
				_recordStream.bufferTime = _bufferTime;
		}


		/**
		 * get the recorder netStream bufferLength.
		 */
		public function get bufferLength():Number {
			if (_recordStream)
				return _recordStream.bufferLength;

			return NaN;
		}



		/**
		 * add the last recording as a new Kaltura entry in the Kaltura Network.
		 * @param entry_name				the name for the new added entry.
		 * @param entry_tags				user tags for the newly created entry.
		 * @param entry_description			description of the newly created entry.
		 * @param credits_screen_name		for anonymous user applications - the screen name of the user that contributed the entry.
		 * @param credits_site_url			for anonymous user applications - the website url of the user that contributed the entry.
		 * @param categories				categories of entry
		 * @param admin_tags				admin tags for the newly created entry.
		 * @param license_type				the content license type to use (this is arbitrary to be set by the partner).
		 * @param credit					custom partner credit feild, will be used to attribute the contributing source.
		 * @param group_id					used to group multiple entries in a group.
		 * @param partner_data				special custom data for partners to store.
		 * @see com.kaltura.recording.business.AddEntryDelegate
		 */
		public function addEntry(entry_name:String, entry_tags:String, entry_description:String, credits_screen_name:String = '',
			credits_site_url:String = '', categories:String = "", admin_tags:String = '', license_type:String = '',
			credit:String = '', group_id:String = '', partner_data:String = ''):void {

			var kc:KalturaClient = Global.KALTURA_CLIENT;
			var entry:KalturaMediaEntry = new KalturaMediaEntry();
			entry.mediaType = 1;
			entry.name = entry_name;
			entry.tags = entry_tags;
			entry.description = entry_description;
			entry.creditUserName = credits_screen_name;
			if (categories && categories != "")
				entry.categories = categories;
			entry.creditUrl = credits_site_url;
			if (admin_tags && admin_tags != "")
				entry.adminTags = admin_tags;
			entry.licenseType = int(license_type);
			entry.groupId = int(group_id);
			entry.partnerData = partner_data;
			//
			var addEntry:MediaAddFromRecordedWebcam = new MediaAddFromRecordedWebcam(entry, streamUid);
			addEntry.useTimeout = false;
			addEntry.addEventListener(KalturaEvent.COMPLETE, result);
			addEntry.addEventListener(KalturaEvent.FAILED, fault);
			kc.post(addEntry);
		}


		public function result(data:Object):void {
			trace("result", ObjectUtil.toString(data));
			dispatchEvent(new AddEntryEvent(AddEntryEvent.ADD_ENTRY_RESULT, data.data));
		}


		public function fault(info:Object):void {
			trace("fault", ObjectUtil.toString(info));
			dispatchEvent(new AddEntryEvent(AddEntryEvent.ADD_ENTRY_FAULT, info));
		}
	}
}
