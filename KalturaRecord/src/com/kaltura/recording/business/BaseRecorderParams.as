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
	public class BaseRecorderParams
	{
		public var host:String;
		public var rtmpHost:String;
		public var addEntryUrl:String;
		public var baseRequestData:Object;
		public var kshowid:String;

		/**
		 * Constructor.
		 * @param _host						Kaltura api host.
		 * @param rtmp_host					Streaming service for the recording.
		 * @param _ks						Kaltura Session id.
		 * @param _partnerid				Kaltura Partner id.
		 * @param _subpid					Kaltura Sub Partner id.
		 * @param _uid						Partner User id.
		 * @param _kshowid					kshow to associate the recordings to.
		 * @param recording_application		the name of the recording application on the streaming server.
		 */
		public function BaseRecorderParams (_host:String, rtmp_host:String, _ks:String, _partnerid:String,
										_subpid:String, _uid:String, _kshowid:String, recording_application:String = "oflaDemo"):void
		{
			host = _host;
			var hasHttp:Boolean = host.indexOf("http://") > -1;
			if (rtmp_host == '')
				rtmpHost = hasHttp ? "rtmp://" + host.substr(7) + "/" + recording_application : "rtmp://" + host + "/" + recording_application;
			else
				rtmpHost = rtmp_host + "/" + recording_application;
			if (!hasHttp)
				host = "http://" + host;
			baseRequestData =
				{
					ks: 		_ks,
					partner_id: _partnerid,
					subp_id: 	_subpid,
					uid: 		_uid
				};
			kshowid = _kshowid;
			addEntryUrl = host + "/index.php/partnerservices2/addentry";
		}
	}
}