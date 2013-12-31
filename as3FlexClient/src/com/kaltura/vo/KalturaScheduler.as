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
	public dynamic class KalturaScheduler extends BaseFlexVo
	{
		/**
		* The id of the Scheduler
		* 
		**/
		public var id : int = int.MIN_VALUE;

		/**
		* The id as configured in the batch config
		* 
		**/
		public var configuredId : int = int.MIN_VALUE;

		/**
		* The scheduler name
		* 
		**/
		public var name : String = null;

		/**
		* The host name
		* 
		**/
		public var host : String = null;

		/**
		* Array of the last statuses
		* 
		**/
		public var statuses : Array = null;

		/**
		* Array of the last configs
		* 
		**/
		public var configs : Array = null;

		/**
		* Array of the workers
		* 
		**/
		public var workers : Array = null;

		/**
		* creation time
		* 
		**/
		public var createdAt : int = int.MIN_VALUE;

		/**
		* last status time
		* 
		**/
		public var lastStatus : int = int.MIN_VALUE;

		/**
		* last status formated
		* 
		**/
		public var lastStatusStr : String = null;

		/** 
		* a list of attributes which may be updated on this object 
		**/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('configuredId');
			arr.push('name');
			arr.push('host');
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
				case 'statuses':
					result = 'KalturaSchedulerStatus';
					break;
				case 'configs':
					result = 'KalturaSchedulerConfig';
					break;
				case 'workers':
					result = 'KalturaSchedulerWorker';
					break;
			}
			return result;
		}
	}
}
