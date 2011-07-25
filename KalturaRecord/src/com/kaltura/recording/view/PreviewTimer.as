package com.kaltura.recording.view
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class PreviewTimer extends UIComponent
	{
		private var _time:TextField;
		
		public function PreviewTimer(s:MovieClip=null)
		{
			super(s);
			_time = _skin["time"];
		}
		public function get timer():TextField
		{
			return _time;
		}
	}
}