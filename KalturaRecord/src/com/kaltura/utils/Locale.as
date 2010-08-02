package com.kaltura.utils
{


public class Locale extends Config
{
	
	function Locale( data:XML = null ):void
	{
		super( data );
	}

	// disable support for reading non string data types
	
	override public function getBoolean( key:String ):Boolean
	{
		trace("Locale supports only strings");
		return false;	
	}
	
	override public function getNumber(key:String):Number
	{
		trace("Locale supports only strings");
		return NaN;	
	}
	
	override public function getConfig(key:String):Config
	{
		trace("Locale supports only strings");
		return null;	
	}

}
}