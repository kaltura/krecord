// TODO: support label

package com.kaltura.recording.view
{

import com.kaltura.utils.KMovieClipUtil;

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;


public class Button extends UIComponent
{

	private var _label:TextField;


	public function Button( skin:MovieClip=null )
	{
		super( skin );
				
		buttonMode = true;
		mouseChildren = false;
	}
	
	override protected function onAddedToStage(evt:Event=null):void
	{
		addEventListener( MouseEvent.MOUSE_OVER, onMouseOver, false, 0, true );
		addEventListener( MouseEvent.MOUSE_OUT, onMouseOut, false, 0, true );
		addEventListener( MouseEvent.CLICK, onMouseClick, false, 0, true );
	}
	
	override protected function redraw():void
	{
		super.redraw();
		
		_label = _skin["label"];
		if( _label ) _label.autoSize = TextFieldAutoSize.CENTER;
	}
	
	protected function onMouseClick( evt:Event ):void
	{
//		trace( "CLICK " + this );
	}
	
	protected function onMouseOver( evt:Event=null ):void
	{
		if( _state != "over" )
		{
			if( KMovieClipUtil.hasLabel( _skin, "over" ))
				_skin.gotoAndStop( "over" );
			_state = "over";
		}
	}
	
	protected function onMouseOut( evt:Event=null ):void
	{
		if( _state != "up" )
		{
			if( KMovieClipUtil.hasLabel( _skin, "up" ))
				_skin.gotoAndStop( "up" );
			_state = "up";
		}
	}

	public function set label( value:String ):void
	{
		if( _label ) _label.text = value;
	}

	override public function setState( state:String ):void
	{
		if( state == "up" ) onMouseOut();
		if( state == "over" ) onMouseOver();
	}
	
}
}