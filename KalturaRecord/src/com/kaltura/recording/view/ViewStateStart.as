package com.kaltura.recording.view
{

import flash.events.Event;
import flash.events.MouseEvent;
	

public class ViewStateStart extends ViewState
{

	public var buttonStart:Button = new Button( Global.THEME.getSkinById( "buttonStartRecord" ));


	public function ViewStateStart()
	{
		_bg.visible = true;
		if(!Global.DISABLE_GLOBAL_CLICK)
			_bg.buttonMode = true;
		buttonStart.mouseEnabled = false;
		buttonStart.label = Global.LOCALE.getString( "Button.StartRecord" );
		addChild( buttonStart );
	}
	
	override protected function onResize():void
	{
		buttonStart.x = Math.round( this.width/2 );
		buttonStart.y = Math.round( this.height/2 );
	}

	override protected function onAddedToStage( evt:Event=null ):void
	{
		_bg.addEventListener( MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true );
		// add click for start record to the video
		if(!Global.DISABLE_GLOBAL_CLICK)
			this.addEventListener( MouseEvent.CLICK, onMouseClick, false, 0, true );
		//stage.addEventListener( Event.MOUSE_LEAVE, onMouseOut, false, 0, true );
		root.addEventListener( Event.MOUSE_LEAVE, onMouseOut, false, 0, true );
	}
	
	private function onMouseOut( evt:Event ):void
	{
		buttonStart.setState( "up" );	
	}

	private function onMouseOver( evt:MouseEvent ):void
	{
		buttonStart.setState( "over" );
	}

	private function onMouseClick( evt:Event ):void
	{
		if(evt)
			evt.stopImmediatePropagation();
		evt = new ViewEvent( ViewEvent.RECORD_START, true );
		dispatchEvent( evt );
	}
	
	
}
}