package com.kaltura.recording.view
{
	

public class ViewStateSaving extends ViewState
{

	public var _popup:PopupMessage = new PopupMessage( Global.THEME.getSkinById( "popupProgress" ));


	public function ViewStateSaving()
	{
		addChild( _popup );
		message = "Saving...";
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