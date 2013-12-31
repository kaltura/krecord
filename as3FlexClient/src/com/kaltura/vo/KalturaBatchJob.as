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
	import com.kaltura.vo.KalturaJobData;

	import com.kaltura.vo.BaseFlexVo;

	[Bindable]
	public dynamic class KalturaBatchJob extends BaseFlexVo
	{
		/**
		**/
		public var id : int = int.MIN_VALUE;

		/**
		**/
		public var partnerId : int = int.MIN_VALUE;

		/**
		**/
		public var createdAt : int = int.MIN_VALUE;

		/**
		**/
		public var updatedAt : int = int.MIN_VALUE;

		/**
		**/
		public var deletedAt : int = int.MIN_VALUE;

		/**
		**/
		public var lockExpiration : int = int.MIN_VALUE;

		/**
		**/
		public var executionAttempts : int = int.MIN_VALUE;

		/**
		**/
		public var lockVersion : int = int.MIN_VALUE;

		/**
		**/
		public var entryId : String = null;

		/**
		**/
		public var entryName : String = null;

		/**
		* @see com.kaltura.types.KalturaBatchJobType
		**/
		public var jobType : String = null;

		/**
		**/
		public var jobSubType : int = int.MIN_VALUE;

		/**
		**/
		public var data : KalturaJobData;

		/**
		* @see com.kaltura.types.KalturaBatchJobStatus
		**/
		public var status : int = int.MIN_VALUE;

		/**
		**/
		public var abort : int = int.MIN_VALUE;

		/**
		**/
		public var checkAgainTimeout : int = int.MIN_VALUE;

		/**
		**/
		public var message : String = null;

		/**
		**/
		public var description : String = null;

		/**
		**/
		public var priority : int = int.MIN_VALUE;

		/**
		**/
		public var history : Array = null;

		/**
		* The id of the bulk upload job that initiated this job
		* 
		**/
		public var bulkJobId : int = int.MIN_VALUE;

		/**
		**/
		public var batchVersion : int = int.MIN_VALUE;

		/**
		* When one job creates another - the parent should set this parentJobId to be its own id.
		* 
		**/
		public var parentJobId : int = int.MIN_VALUE;

		/**
		* The id of the root parent job
		* 
		**/
		public var rootJobId : int = int.MIN_VALUE;

		/**
		* The time that the job was pulled from the queue
		* 
		**/
		public var queueTime : int = int.MIN_VALUE;

		/**
		* The time that the job was finished or closed as failed
		* 
		**/
		public var finishTime : int = int.MIN_VALUE;

		/**
		* @see com.kaltura.types.KalturaBatchJobErrorTypes
		**/
		public var errType : int = int.MIN_VALUE;

		/**
		**/
		public var errNumber : int = int.MIN_VALUE;

		/**
		**/
		public var estimatedEffort : int = int.MIN_VALUE;

		/**
		**/
		public var urgency : int = int.MIN_VALUE;

		/**
		**/
		public var schedulerId : int = int.MIN_VALUE;

		/**
		**/
		public var workerId : int = int.MIN_VALUE;

		/**
		**/
		public var batchIndex : int = int.MIN_VALUE;

		/**
		**/
		public var lastSchedulerId : int = int.MIN_VALUE;

		/**
		**/
		public var lastWorkerId : int = int.MIN_VALUE;

		/**
		**/
		public var dc : int = int.MIN_VALUE;

		/**
		**/
		public var jobObjectId : String = null;

		/**
		**/
		public var jobObjectType : int = int.MIN_VALUE;

		/** 
		* a list of attributes which may be updated on this object 
		**/ 
		public function getUpdateableParamKeys():Array
		{
			var arr : Array;
			arr = new Array();
			arr.push('entryId');
			arr.push('entryName');
			arr.push('jobSubType');
			arr.push('data');
			arr.push('status');
			arr.push('abort');
			arr.push('checkAgainTimeout');
			arr.push('message');
			arr.push('description');
			arr.push('priority');
			arr.push('history');
			arr.push('bulkJobId');
			arr.push('batchVersion');
			arr.push('parentJobId');
			arr.push('rootJobId');
			arr.push('queueTime');
			arr.push('finishTime');
			arr.push('errType');
			arr.push('errNumber');
			arr.push('estimatedEffort');
			arr.push('urgency');
			arr.push('schedulerId');
			arr.push('workerId');
			arr.push('batchIndex');
			arr.push('lastSchedulerId');
			arr.push('lastWorkerId');
			arr.push('dc');
			arr.push('jobObjectId');
			arr.push('jobObjectType');
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
				case 'data':
					result = '';
					break;
				case 'history':
					result = 'KalturaBatchHistoryData';
					break;
			}
			return result;
		}
	}
}
