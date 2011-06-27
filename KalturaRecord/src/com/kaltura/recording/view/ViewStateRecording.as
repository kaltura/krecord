package com.kaltura.recording.view
{

import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.utils.getTimer;

import gs.TweenLite;
	

public class ViewStateRecording extends ViewState
{

	public var buttonStop:Button = new Button( Global.THEME.getSkinById( "buttonStopRecord" ));
	public var progressBar:ProgressBarRecording = new ProgressBarRecording( Global.THEME.getSkinById( "recordingProgressBar" ));

	private var _hideTimer:Timer = new Timer( 500, 1 );
	private var _recordingTimer:Timer;
	private var _recordingStartTime:int;

	public function ViewStateRecording()
	{
		_bg.visible = true;
		_bg.buttonMode = true;

		buttonStop.mouseEnabled = false;
		buttonStop.label = Global.LOCALE.getString( "Button.StopRecord" );

		addChild( buttonStop );
		addChild( progressBar );
		
		_hideTimer = new Timer( 2000, 1 );
		_hideTimer.addEventListener( TimerEvent.TIMER, onHideTimer, false, 0, true );
		
		_recordingTimer = new Timer( 1000 );
		_recordingTimer.addEventListener( TimerEvent.TIMER, onRecordingTimer, false, 0, true );
		
	}

	override protected function onResize():void
	{
		buttonStop.x = Math.round( this.width/2 );
		buttonStop.y = Math.round( this.height/2 );
		
		progressBar.x = Math.round( 7 + progressBar.width/2 );
		progressBar.y = Math.round( 7 + progressBar.height/2 );
	}

	override protected function onAddedToStage( evt:Event=null ):void
	{
		_bg.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true );
		_bg.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true );
		// click on video to stop recording
		if(!Global.DISABLE_GLOBAL_CLICK)
			this.addEventListener( MouseEvent.CLICK, onMouseClick, false, 0, true );
		//stage.addEventListener( Event.MOUSE_LEAVE, onMouseOut, false, 0, true );
		root.addEventListener( Event.MOUSE_LEAVE, onMouseOut, false, 0, true );
	}
	
	override public function open():void
	{
		super.open();
		_hideTimer.start();
		
		progressBar.time = 0;
		_recordingStartTime = getTimer();
		_recordingTimer.start();
	}

	override public function close():void
	{
		super.close();
		_hideTimer.reset();
		_recordingTimer.reset();
	}
	
	private function onMouseOut( evt:Event ):void
	{
		buttonStop.setState( "up" );	
	}

	private function onMouseOver( evt:MouseEvent ):void
	{
		buttonStop.setState( "over" );
	}

	private function onMouseClick( evt:Event ):void
	{
		evt.stopImmediatePropagation();
		evt = new ViewEvent( ViewEvent.RECORD_STOP, true );
		dispatchEvent( evt );
	}
	
	private function onMouseMove( evt:MouseEvent ):void
	{
		showButton();
		_hideTimer.reset();
		_hideTimer.start();
	}
	
	private function onHideTimer( evt:TimerEvent ):void
	{
		hideButton();
	}
	
	private function onRecordingTimer (evt:TimerEvent):void
	{
		progressBar.time = getTimer() - _recordingStartTime;
	}
	
	private function showButton():void
	{
		TweenLite.to( buttonStop, 0.5, {alpha:1} );	
	}
	
	private function hideButton():void
	{
		TweenLite.to( buttonStop, 0.5, {alpha:0} );
	}
	
}
}