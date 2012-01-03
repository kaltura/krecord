package com.kaltura.recording.view
{

import flash.display.MovieClip;
import flash.text.TextField;
	

public class ProgressBarRecording extends UIComponent
{

	private var _time:TextField;


	public function ProgressBarRecording( skin:MovieClip )
	{
		super( skin );
	}

	override protected function redraw():void
	{
		super.redraw();

		_time = _skin["time"];
	}

	private function formatTime( ms:Number ):String
	{
		var formatted:String;
		var sec:Number = Math.floor( ms/1000 );
		var min:Number = Math.floor( sec/60 );
		var hour:Number = Math.floor( min/60 );
		
		sec = sec - (min*60);
		if(min>=60)
			min = min - (hour*60);
		
		var secString:String = String(sec);
		var hourString:String = String(hour);

		var minString:String = String(min);
		
		secString = (secString.length == 1) ? "0" + secString : secString;
		minString = (minString.length == 1) ? "0" + minString : minString;
		hourString = (hourString.length == 1) ? "0" + hourString : hourString;
		
		formatted = hourString+":"+minString + ":" + secString;		  
		
		return( formatted );
	}
	
	// value in ms
	public function set time( value:Number ):void
	{
		if( _time )
		{
			//TODO 
			_time.text = formatTime( value );
		}
	}
	
	override protected function validateSkin( skin:MovieClip ):Boolean
	{
//		if( skin["time"] && skin["soundLevel"] )
		if( skin["time"] )
			return( true );
		else
			return( false );
	}
}
}