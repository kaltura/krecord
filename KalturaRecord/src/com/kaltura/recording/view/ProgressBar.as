package com.kaltura.recording.view
{

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
	

public class ProgressBar extends UIComponent
{

	private var _progressBar:MovieClip;
	private var _hitArea:Sprite;
	
	private var _progress:Number = 0;
	private var _totalWidth:Number;
	

	public function ProgressBar( skin:MovieClip=null )
	{
		super( skin );
		
		buttonMode = true;
		mouseChildren = false;
	}

	override protected function redraw():void
	{
		super.redraw();
		
		_progressBar = _skin["bar"];
		_progressBar.mouseEnabled = false;
		_totalWidth = _progressBar.width;
		
		_hitArea = new Sprite;
		_hitArea.graphics.beginFill( 0xff0000, 0 );
		_hitArea.graphics.drawRect( 0,0,_progressBar.width, _progressBar.height );
		_hitArea.graphics.endFill();
		_hitArea.x = _progressBar.x;
		_hitArea.y = _progressBar.y;
		_hitArea.buttonMode = true;
		_skin.addChildAt( _hitArea, 0 );
		
		addEventListener( MouseEvent.CLICK, onMouseClick, false, 0, true );
	}

	private function onMouseClick( evt:MouseEvent ):void
	{
		var p:Number = _hitArea.mouseX/(_hitArea.width-_hitArea.x);
		setProgress( p );
	}

	// value = 0 -> 1
	public function setProgress( p:Number ):void
	{
		if( _progressBar && p >=0 && p <=1 )
		{
			_progressBar.width = _totalWidth*p;
			_progress = p;
		}
	}

	public function getProgress():Number
	{
		return( _progress );
	}

	override protected function validateSkin( skin:MovieClip ):Boolean
	{
		if( skin["bar"] )
			return( true );
		else
			return( false );
	}
	
}
}