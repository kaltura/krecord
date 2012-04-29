package com.kaltura.recording.view
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class Theme
	{
		private var _container:DisplayObjectContainer;
		
		public function Theme(container:DisplayObjectContainer)
		{
			_container = container;
		}
		
		public function getSkinById(id:String):MovieClip
		{
			var mc:MovieClip = _container.getChildByName(id) as MovieClip;
			
			if ( mc )
			{
				mc.x = 0;
				mc.y = 0;
			}
			
			return mc;
		}

	}
}