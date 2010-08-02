package com.kaltura.recording.view
{

import com.kaltura.net.streaming.events.RecordNetStreamEvent;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.NetStatusEvent;
import flash.text.TextField;
	

public class PreviewPlayer extends UIComponent
{

	public var buttonSave:Button;
	public var buttonReRecord:Button;
	public var buttonPlay:Button;
	public var buttonPause:Button;
	public var buttonStop:Button;
	public var progressBar:ProgressBar;
	public var textProgress:TextField;
	
	private var _totalTime:Number=0;
	private var _autoPreview : Boolean = true;
	
	public function PreviewPlayer( skin:MovieClip )
	{
		super( skin );
		Global.RECORD_CONTROL.addEventListener( NetStatusEvent.NET_STATUS , onNetStatus );
	}
	
	private function onNetStatus( event : NetStatusEvent ) : void
	{
		switch(event.info.code)
		{
			case "NetStream.Unpublish.Success": 
			if(Global.VIEW_PARAMS.autoPreview==true)
			 {
			 	stop();
				play(); 
				Global.RECORD_CONTROL.previewRecording(); //need to add it because play was called without mouse event
			 }
			else{
				Global.RECORD_CONTROL.stopPreviewRecording()
			}
			break;			
		}
	}
	
	override protected function redraw():void
	{
		super.redraw();
		
		buttonSave = new Button( _skin["buttonSave"] );
		buttonSave.name = "buttonSave";
		_skin.addChild( buttonSave );
		
		buttonReRecord = new Button( _skin["buttonReRecord"] );
		buttonReRecord.name = "buttonReRecord";
		_skin.addChild( buttonReRecord );

		buttonPlay = new Button( _skin["buttonPlay"] );
		buttonPlay.addEventListener( MouseEvent.CLICK, onMouseClick, false, 0, true );
		buttonPlay.name = "buttonPlay";
		buttonPlay.visible = true;
		_skin.addChild( buttonPlay );

		buttonPause = new Button( _skin["buttonPause"] );
//		buttonPause.addEventListener( MouseEvent.CLICK, onMouseClick, false, 0, true );
		buttonPause.name = "buttonPause";
		buttonPause.visible = false;
		_skin.addChild( buttonPause );

		buttonStop = new Button( _skin["buttonStop"] );
		buttonStop.addEventListener( MouseEvent.CLICK, onMouseClick, false, 0, true );
		buttonStop.name = "buttonStop";
		buttonStop.visible = false;
		_skin.addChild( buttonStop )
		
		progressBar = new ProgressBar( _skin["progressBar"] );
		progressBar.addEventListener( MouseEvent.CLICK, onMouseClick, false, 0, true );
		progressBar.name = "progressBar";
		_skin.addChild( progressBar );
		
		textProgress = _skin["textProgress"];
	}
	
	private function onMouseClick( evt:MouseEvent ):void
	{
		if( evt.target == buttonPlay )	play( evt );
		if( evt.target == buttonStop )	stop();
		if( evt.target == progressBar ) seek( getSeekSeconds() );
	}
	
	public function play( evt:MouseEvent = null ):void
	{
		if( !playing )
		{
			buttonPlay.visible = false;
			buttonStop.visible = true;
//			buttonPause.visible = true;
			
			if( _state == "pause" )
			{
				trace( "PREVIEW RESUME" );
				Global.RECORD_CONTROL.resume();
			}
			else
			{
				trace( "PREVIEW PLAY" );
				this.addEventListener( Event.ENTER_FRAME, onProgress, false, 0, true );
				Global.RECORD_CONTROL.addEventListener( RecordNetStreamEvent.NETSTREAM_PLAY_COMPLETE, onPreviewComplete, false, 0, true );
				
				if(evt) //if it is a click do preview (before this preview was called twice
					Global.RECORD_CONTROL.previewRecording();
			}
			
			_state = "play";
		}
	}
	
	// p = 0 -> 1
	private function getSeekSeconds():Number
	{
		var ms:Number = progressBar.getProgress()*Global.RECORD_CONTROL.recordedTime;
		var s:Number = Math.floor( ms/1000 );
		
		return( s );		
	}
	
	public function seek( offset:Number ):void
	{
		pause();
		Global.RECORD_CONTROL.seek( offset );
		play();
	}
	
	public function pause():void
	{
		if( !paused )
		{
			trace( "PREVIEW PAUSE" );
			buttonPlay.visible = true;
			buttonStop.visible = false;
//			buttonPause.visible = false;
			Global.RECORD_CONTROL.pausePreviewRecording();
	
			_state = "pause";
		}
	}
	
	public function stop():void
	{
		if( !stopped )
		{
			trace( "PREVIEW STOP" );
			buttonPlay.visible = true;
			buttonStop.visible = false;
//			buttonPause.visible = false;
			this.removeEventListener( Event.ENTER_FRAME, onProgress );
			Global.RECORD_CONTROL.removeEventListener( RecordNetStreamEvent.NETSTREAM_PLAY_COMPLETE, onPreviewComplete );
			
			//Boaz addition
			/////////////////////////////////////////////
			Global.RECORD_CONTROL.stopPreviewRecording();
			Global.RECORD_CONTROL.clearVideoAndSetCamera();
			/////////////////////////////////////////////
			
			updateProgress( 0 );
			_state = "stop";
		}
	}
	
	private function stopPreview() : void
	{ 
		Global.RECORD_CONTROL.stopPreviewRecording();
	}
	
	public function get playing():Boolean
	{
		return( _state == "play" );
	}
	
	public function get paused():Boolean
	{
		return( _state == "pause" );
	}
	
	public function get stopped():Boolean
	{
		return( _state == "stop" );
	}
	
	private function onProgress( evt:Event ):void
	{
		updateProgress();
	}
	
	private function updateProgress( p:Number=-1 ):void
	{
		var playheadTime:String = "00:00";
		
		if( p<0 )
		{
			p =Global.RECORD_CONTROL.playheadTime*1000/Global.RECORD_CONTROL.recordedTime;
			playheadTime = ( formatTime( Global.RECORD_CONTROL.playheadTime*1000 ));
		}
			
		var recordedTime:String = formatTime( Global.RECORD_CONTROL.recordedTime );
		
		//trace( "playheadTime: " + Global.RECORD_CONTROL.playheadTime );
		
		progressBar.setProgress( p );
		
		if( playheadTime <= recordedTime )
			textProgress.text = playheadTime + "/" + recordedTime;
		else
			trace("playheadTime: " + playheadTime);
	}
	
	private function onPreviewComplete( evt:Event ):void
	{
		stop();
	}

	private function formatTime( ms:Number ):String
	{
		var formatted:String;
		var sec:Number = Math.floor( ms/1000 );
		var min:Number = Math.floor( sec/60 );
		
		sec = sec - (min*60);
		
		var secString:String = String(sec);
		var minString:String = String(min);
		
		secString = (secString.length == 1) ? "0" + secString : secString;
		minString = (minString.length == 1) ? "0" + minString : minString;
		
		formatted = minString + ":" + secString;		  
		
		return( formatted );
	}
	
	override protected function validateSkin( skin:MovieClip ):Boolean
	{
		if( skin["buttonSave"] && skin["buttonReRecord"] && skin["buttonPlay"] && skin["textProgress"] && skin["progressBar"] )
//		if( skin["buttonSave"] && skin["buttonReRecord"] && skin["buttonPlay"] && skin["buttonStop"] )
			return( true );
		else
			return( false );
	}
}
}