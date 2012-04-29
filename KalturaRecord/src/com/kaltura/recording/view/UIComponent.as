package com.kaltura.recording.view
{

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;


public class UIComponent extends Sprite
{

	protected var _skin:MovieClip;
	protected var _state:String = "up";
	public static var visibleSkin:Boolean=true
   
	public function UIComponent( s:MovieClip=null )
	{
		this.skin = s;
		s.visible=visibleSkin
		this.addEventListener( Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true );
	}
	
	protected function onAddedToStage( evt:Event=null ):void
	{
		this.removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
	}

	public function set skin( value:MovieClip ):void
	{
		if( validateSkin( value ))
			_skin = value;
		else
			throw new ViewEvent( ViewEvent.INVALID_SKIN, true );

		redraw();			
	}
	
	protected function validateSkin( skin:MovieClip ):Boolean
	{
		return( true );
	}

	public function setState( state:String ):void {}
	
	protected function redraw():void
	{
		while( numChildren != 0 )
			removeChildAt( 0 );
		
		addChild( _skin );		
	} 
	
}
}