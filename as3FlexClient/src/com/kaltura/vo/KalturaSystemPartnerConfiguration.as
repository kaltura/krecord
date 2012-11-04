package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;
	[Bindable]
	public dynamic class KalturaSystemPartnerConfiguration extends BaseFlexVo
	{
		/** 
		* 		* */ 
		public var partnerName : String;

		/** 
		* 		* */ 
		public var description : String;

		/** 
		* 		* */ 
		public var adminName : String;

		/** 
		* 		* */ 
		public var adminEmail : String;

		/** 
		* 		* */ 
		public var host : String;

		/** 
		* 		* */ 
		public var cdnHost : String;

		/** 
		* 		* */ 
		public var maxBulkSize : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var partnerPackage : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var monitorUsage : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var moderateContent : Boolean;

		/** 
		* 		* */ 
		public var rtmpUrl : String;

		/** 
		* 		* */ 
		public var storageDeleteFromKaltura : Boolean;

		/** 
		* 		* */ 
		public var storageServePriority : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var kmcVersion : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var defThumbOffset : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var adminLoginUsersQuota : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var userSessionRoleId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var adminSessionRoleId : int = int.MIN_VALUE;

		/** 
		* 		* */ 
		public var alwaysAllowedPermissionNames : String;

		/** 
		* 		* */ 
		public var importRemoteSourceForConvert : Boolean;

		/** 
		* 		* */ 
		public var permissions : Array = new Array();

		/** 
		* a list of attributes which may be updated on this object 
		* */ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('partnerName');
			arr.push('description');
			arr.push('adminName');
			arr.push('adminEmail');
			arr.push('host');
			arr.push('cdnHost');
			arr.push('maxBulkSize');
			arr.push('partnerPackage');
			arr.push('monitorUsage');
			arr.push('moderateContent');
			arr.push('rtmpUrl');
			arr.push('storageDeleteFromKaltura');
			arr.push('storageServePriority');
			arr.push('kmcVersion');
			arr.push('defThumbOffset');
			arr.push('adminLoginUsersQuota');
			arr.push('userSessionRoleId');
			arr.push('adminSessionRoleId');
			arr.push('alwaysAllowedPermissionNames');
			arr.push('importRemoteSourceForConvert');
			arr.push('permissions');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		* */ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

	}
}
