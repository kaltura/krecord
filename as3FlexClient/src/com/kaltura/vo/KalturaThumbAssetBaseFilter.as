package com.kaltura.vo
{
	import com.kaltura.vo.KalturaAssetFilter;

	[Bindable]
	public dynamic class KalturaThumbAssetBaseFilter extends KalturaAssetFilter
	{
		override public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = super.getUpdateableParamKeys();
			return arr;
		}

		override public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = super.getInsertableParamKeys();
			return arr;
		}

	}
}
