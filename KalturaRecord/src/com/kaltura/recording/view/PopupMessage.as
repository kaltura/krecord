package com.kaltura.recording.view
{

import flash.display.MovieClip;
import flash.text.TextField;
	

public class PopupMessage extends UIComponent
{

	protected var _message:TextField;


	public function PopupMessage( skin:MovieClip )
	{
		super( skin );
	}

	override protected function redraw():void
	{
		super.redraw();

		_message = _skin["message"]		
	}
	
	public function set text( value:String ):void
	{
		if( _message )
		{
			_message.text = value;
		}
	}
	
	override protected function validateSkin( skin:MovieClip ):Boolean
	{
		if( skin["message"] )
			return( true );
		else
			return( false );
	}
}
}