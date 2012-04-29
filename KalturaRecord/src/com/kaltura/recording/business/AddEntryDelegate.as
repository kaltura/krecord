/*
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
// Copyright (C) 2006-2008  Kaltura Inc.
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
*/
package com.kaltura.recording.business
{
	import com.kaltura.base.vo.KalturaEntry;
	import com.kaltura.net.TemplateURLVariables;
	import com.kaltura.recording.business.interfaces.IResponder;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;

	public class AddEntryDelegate
	{
		private var responder:IResponder;
		private var _loader:URLLoader = new URLLoader;

		public function AddEntryDelegate(_responder:IResponder)
		{
			responder = _responder;
			_loader.addEventListener(Event.COMPLETE, 					loaderCompleteHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, 			ioErrorHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}

		/**
		 * adds a new entry to the Kaltura Network.
		 * @param baseParams				the recorder base parameters (containing partner and session info).
		 * @param mediaType					the media type of the newly created entry (video, audio, image etc).
		 * @param entryName					the name for the new added entry.
		 * @param fileName					the file name of the newly created entry as it exist on the server after upload/record.
		 * @param entryTags					user tags for the newly created entry.
		 * @param entryDescription			description of the newly created entry.
		 * @param fromTime					for streaming media - used to trim the new entry from the start, in milliseconds.
		 * @param toTime					for streaming media - used to trim the new entry from the end, in milliseconds.
		 * @param mediaSource				the Entry Media Source as specified by the EntryMediaSource enum, for webcam = 2;
		 * @param creditsScreenName			for anonymous user applications - the screen name of the user that contributed the entry.
		 * @param creditsSiteUrl			for anonymous user applications - the website url of the user that contributed the entry.
		 * @param thumbOffset				for streaming media - used to decide from what second to capture a thumbnail.
		 * @param adminTags					admin tags for the newly created entry.
		 * @param licenseType				the content license type to use (this is arbitrary to be set by the partner).
		 * @param credit					custom partner credit feild, will be used to attribute the contributing source.
		 * @param groupId					used to group multiple entries in a group.
		 * @param partnerData				special custom data for partners to store.
		 */
		public function addEntry (baseParams:BaseRecorderParams, mediaType:int, entryName:String, fileName:String,
								entryTags:String, entryDescription:String, fromTime:Number = -1, toTime:Number = -1,
								mediaSource:int = 2, creditsScreenName:String = '', creditsSiteUrl:String = '',
								thumbOffset:int = -1, adminTags:String = '', licenseType:String = '', credit:String = '',
								groupId:String = '', partnerData:String = ''):void
		{
			var params:TemplateURLVariables = new TemplateURLVariables(baseParams.baseRequestData);
			params["kshow_id"] = baseParams.kshowid;
			params["quick_edit"] = 0;
			if (creditsScreenName != '')
				params["credits_screen_name"] = creditsScreenName;
			if (creditsSiteUrl != '')
				params["credits_site_url"] = creditsSiteUrl;
			params["entry1_filename"] = fileName;
			params["entry1_description"] = entryDescription;
			params["entry1_tags"] = entryTags;
			params["entry1_mediaType"] = mediaType;
			params["entry1_source"] = mediaSource;
			params["entry1_name"] = entryName;
			if (licenseType != '')
				params["entry1_licenseType"] = licenseType;
			if (credit != '')
				params["entry1_credit"] = credit;
			if (groupId != '')
				params["entry1_groupId"] = groupId;
			if (partnerData != '')
				params["entry1_partnerData"] = partnerData;
			if (thumbOffset > -1)
				params["entry1_thumbOffset"] = thumbOffset;
			if (adminTags != '')
				params["entry1_adminTags"] = adminTags;
			if (fromTime >= 0)
				params["entry1_from_time"] = fromTime;
			if (toTime >= 0)
				params["entry1_to_time"] = toTime;
			var request:URLRequest = new URLRequest (baseParams.addEntryUrl);
			request.method = URLRequestMethod.GET;
			request.data = params;
			_loader.load(request);
		}

		private function loaderCompleteHandler (event:Event):void
		{
			var resultXml:XML = new XML (event.target.data);
			// if the server returned an error:
			if (resultXml.error.children().length() > 0)
			{
				fault (resultXml.error.children());
				return;
			}
			var entries:Array = [];
			var allEntries:XMLList = resultXml.result.entries.children();
			var entry:XML;
			var entryInfo:KalturaEntry;
			for each ( entry in allEntries )
			{
				entryInfo = new KalturaEntry (entry);
				entries.push(entryInfo);
			}
			responder.result(entries);
		}

		private function fault (info:Object):void
		{
			responder.fault(info);
		}

		private function ioErrorHandler(event:IOErrorEvent):void
		{
			fault (event);
		}

		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			fault (event);
		}
	}
}