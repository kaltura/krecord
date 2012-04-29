package com.kaltura.utils
{
	
import flash.display.MovieClip;
	

public class KMovieClipUtil
{

	static public function hasLabel( mc:MovieClip, label:String ):Boolean
	{
		for( var i:Number=0; i<mc.currentLabels.length; i++)
		{
			if( mc.currentLabels[i].name == label ) return( true );
		}
		return( false );
	}

}
}