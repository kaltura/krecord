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
		
		/**
		 * stream is published to this url
		 */
		public var rtmpHost:String;
		
		/**
		 * is the published stream a live stream or a recorded stream?
		 */
		public var isLive:Boolean;
		
		/**
		 * preferred name for the published stream (live stream only) 
		 */
		public var streamName:String = '';

		/**
		 * Constructor.
		 * @param _host						Kaltura api host.
		 * @param rtmp_host					Streaming service for the recording.
		 * @param recording_application		the name of the recording application on the streaming server.
		 * @param is_live					if true, the outgoing stream will be treated as a live stream, not as a recorded stream.
		 * @param stream_name				for live streams, name of the published stream. if not passed, a random UID will be used.
		 */
		public function BaseRecorderParams (_host:String, rtmp_host:String, recording_application:String, 
											is_live:Boolean = false, stream_name:String = ''):void {
			host = _host;
			var hasHttp:Boolean = host.indexOf("http://") > -1;
			
			if (rtmp_host == '')
				rtmpHost = hasHttp ? "rtmp://" + host.substr(7) + "/" + recording_application : "rtmp://" + host + "/" + recording_application;
			else if (recording_application) {
				rtmpHost = rtmp_host + "/" + recording_application;
			}
			else {
				rtmpHost = rtmp_host;
			}
			
			if (!hasHttp) {
				host = "http://" + host;
			}
			
			isLive = is_live;
			streamName = stream_name;
				
		}
	}
}