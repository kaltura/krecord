package com.kaltura.recording.view
{

import flash.display.MovieClip;
import flash.text.TextField;
	

public class PopupDialog extends PopupMessage
{

	public var buttonYes:Button;
	public var buttonNo:Button;
//	private var _message:TextField;


	public function PopupDialog( skin:MovieClip )
	{
		super( skin );
	}

	override protected function redraw():void
	{
		super.redraw();
		
		buttonYes = new Button( _skin["buttonYes"] );
		buttonYes.name = "buttonYes";
		buttonYes.label = Global.LOCALE.getString( "Button.Yes" );
		_skin.addChild( buttonYes );
		
		buttonNo = new Button( _skin["buttonNo"] );
		buttonNo.name = "buttonNo";
		buttonNo.label = Global.LOCALE.getString( "Button.No" );
		_skin.addChild( buttonNo );
		
		_message = _skin["message"];
	}
	
	public function set message( value:String ):void
	{
		_message.text = value;
	}
	
	override protected function validateSkin( skin:MovieClip ):Boolean
	{
		if( skin["message"] && skin["buttonYes"] && skin["buttonNo"] )
			return( true );
		else
			return( false );
	}
}
}