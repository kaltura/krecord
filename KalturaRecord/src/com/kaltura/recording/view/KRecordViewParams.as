package com.kaltura.recording.view
{
	public class KRecordViewParams
	{
		public var themeUrl:String;
		public var localeUrl:String;
		public var autoPreview:Boolean;
		
		public function KRecordViewParams(themeUrl:String, localeUrl:String, autoPreview:String)
		{
			this.themeUrl = themeUrl;
			this.localeUrl = localeUrl;
			this.autoPreview = (autoPreview == '1') || autoPreview == "true";
		}

	}
}