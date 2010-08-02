package com.kaltura.recording.view
{
	

public class ViewStateError extends ViewState
{

	public var _popup:PopupMessage = new PopupMessage( Global.THEME.getSkinById( "popupMessageError" ));


	public function ViewStateError()
	{
		addChild( _popup );
	}
	
	override protected function onResize():void
	{
		_popup.x = Math.round( this.width/2 );
		_popup.y = Math.round( this.height/2 );
	}
	
	public function set message( value:String ):void
	{
		if( _popup )
		{
			_popup.text = value;
		}
	}
	
}
}