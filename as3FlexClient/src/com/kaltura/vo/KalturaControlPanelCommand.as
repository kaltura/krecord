// ===================================================================================================
//                           _  __     _ _
//                          | |/ /__ _| | |_ _  _ _ _ __ _
//                          | ' </ _` | |  _| || | '_/ _` |
//                          |_|\_\__,_|_|\__|\_,_|_| \__,_|
//
// This file is part of the Kaltura Collaborative Media Suite which allows users
// to do with audio, video, and animation what Wiki platfroms allow them to do with
// text.
//
// Copyright (C) 2006-2011  Kaltura Inc.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
// @ignore
// ===================================================================================================
package com.kaltura.vo
{
	import com.kaltura.vo.BaseFlexVo;

	[Bindable]
	public dynamic class KalturaControlPanelCommand extends BaseFlexVo
	{
		/**
		* The id of the Category
		* 
		**/
		public var id : int = int.MIN_VALUE;

		/**
		* Creation date as Unix timestamp (In seconds)
		* 
		**/
		public var createdAt : int = int.MIN_VALUE;

		/**
		* Creator name
		* 
		**/
		public var createdBy : String = null;

		/**
		* Update date as Unix timestamp (In seconds)
		* 
		**/
		public var updatedAt : int = int.MIN_VALUE;

		/**
		* Updater name
		* 
		**/
		public var updatedBy : String = null;

		/**
		* Creator id
		* 
		**/
		public var createdById : int = int.MIN_VALUE;

		/**
		* The id of the scheduler that the command refers to
		* 
		**/
		public var schedulerId : int = int.MIN_VALUE;

		/**
		* The id of the scheduler worker that the command refers to
		* 
		**/
		public var workerId : int = int.MIN_VALUE;

		/**
		* The id of the scheduler worker as configured in the ini file
		* 
		**/
		public var workerConfiguredId : int = int.MIN_VALUE;

		/**
		* The name of the scheduler worker that the command refers to
		* 
		**/
		public var workerName : int = int.MIN_VALUE;

		/**
		* The index of the batch process that the command refers to
		* 
		**/
		public var batchIndex : int = int.MIN_VALUE;

		/**
		* The command type - stop / start / config
		* 
		* @see com.kaltura.types.KalturaControlPanelCommandType
		**/
		public var type : int = int.MIN_VALUE;

		/**
		* The command target type - data center / scheduler / job / job type
		* 
		* @see com.kaltura.types.KalturaControlPanelCommandTargetType
		**/
		public var targetType : int = int.MIN_VALUE;

		/**
		* The command status
		* 
		* @see com.kaltura.types.KalturaControlPanelCommandStatus
		**/
		public var status : int = int.MIN_VALUE;

		/**
		* The reason for the command
		* 
		**/
		public var cause : String = null;

		/**
		* Command description
		* 
		**/
		public var description : String = null;

		/**
		* Error description
		* 
		**/
		public var errorDescription : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		**/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('createdBy');
			arr.push('updatedBy');
			arr.push('createdById');
			arr.push('schedulerId');
			arr.push('workerId');
			arr.push('workerConfiguredId');
			arr.push('workerName');
			arr.push('batchIndex');
			arr.push('type');
			arr.push('targetType');
			arr.push('status');
			arr.push('cause');
			arr.push('description');
			arr.push('errorDescription');
			return arr;
		}

		/** 
		* a list of attributes which may only be inserted when initializing this object 
		**/ 
		public function getInsertableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			return arr;
		}

		/** 
		* get the expected type of array elements 
		* @param arrayName 	 name of an attribute of type array of the current object 
		* @return 	 un-qualified class name 
		**/ 
		public function getElementType(arrayName:String):String
		{
			var result:String = '';
			switch (arrayName) {
			}
			return result;
		}
	}
}
