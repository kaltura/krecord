package com.kaltura.recording.view
{

import flash.display.Sprite;
import flash.events.Event;

import gs.TweenLite;


public class ViewState extends Sprite
{
	
	protected var _bg:Sprite = new Sprite; 
	

	public function ViewState()
	{
		_bg.graphics.beginFill( 0x0000ff, 0 );
		_bg.graphics.drawRect( 0,0,1,1 );
		_bg.graphics.endFill();
		_bg.visible = false;
		addChild( _bg );
		
		addEventListener( Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true );
	}
	
	public function open():void
	{
		this.alpha = 0;
		this.visible = true;
		TweenLite.to( this, 0.5, {alpha:1} );
	}
	
	public function close():void
	{
		this.alpha = 1;
		this.visible = false;
		TweenLite.to( this, 0.5, {alpha:0} );
	}
	
	protected function onAddedToStage( evt:Event=null ):void {}
	
	override public function set width( value:Number ):void
	{
		_bg.width = value;
		onResize();
	}
	
	override public function get width():Number
	{
		return( _bg.width );
	}
	
	override public function set height( value:Number ):void
	{
		_bg.height = value;
		onResize();
	}
	
	override public function get height():Number
	{
		return( _bg.height );
	}
	
	protected function onResize():void {}
	
}
}