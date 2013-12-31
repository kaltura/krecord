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
	public dynamic class KalturaSchedulerConfig extends BaseFlexVo
	{
		/**
		* The id of the Category
		* 
		**/
		public var id : int = int.MIN_VALUE;

		/**
		* Creator name
		* 
		**/
		public var createdBy : String = null;

		/**
		* Updater name
		* 
		**/
		public var updatedBy : String = null;

		/**
		* Id of the control panel command that created this config item
		* 
		**/
		public var commandId : String = null;

		/**
		* The status of the control panel command
		* 
		**/
		public var commandStatus : String = null;

		/**
		* The id of the scheduler
		* 
		**/
		public var schedulerId : int = int.MIN_VALUE;

		/**
		* The configured id of the scheduler
		* 
		**/
		public var schedulerConfiguredId : int = int.MIN_VALUE;

		/**
		* The name of the scheduler
		* 
		**/
		public var schedulerName : String = null;

		/**
		* The id of the job worker
		* 
		**/
		public var workerId : int = int.MIN_VALUE;

		/**
		* The configured id of the job worker
		* 
		**/
		public var workerConfiguredId : int = int.MIN_VALUE;

		/**
		* The name of the job worker
		* 
		**/
		public var workerName : String = null;

		/**
		* The name of the variable
		* 
		**/
		public var variable : String = null;

		/**
		* The part of the variable
		* 
		**/
		public var variablePart : String = null;

		/**
		* The value of the variable
		* 
		**/
		public var value : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		**/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('createdBy');
			arr.push('updatedBy');
			arr.push('commandId');
			arr.push('commandStatus');
			arr.push('schedulerId');
			arr.push('schedulerConfiguredId');
			arr.push('schedulerName');
			arr.push('workerId');
			arr.push('workerConfiguredId');
			arr.push('workerName');
			arr.push('variable');
			arr.push('variablePart');
			arr.push('value');
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
