<?php
/*
This file is part of the Kaltura Collaborative Media Suite which allows users
to do with audio, video, and animation what Wiki platfroms allow them to do with
text.

Copyright (C) 2006-2008 Kaltura Inc.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

require_once("kaltura_client_base.php");

class KalturaEntry
{
	public $name;
	public $tags;
	public $type;
	public $mediaType;
	public $source;
	public $sourceId;
	public $sourceLink;
	public $licenseType;
	public $credit;
	public $groupId;
	public $partnerData;
	public $conversionQuality;
	public $permissions;
	public $dataContent;
	public $desiredVersion;
	public $url;
	public $thumbUrl;
	public $filename;
	public $realFilename;
	public $indexedCustomData1;
	public $thumbOffset;
}

class KalturaKShow
{
	public $name;
	public $description;
	public $tags;
	public $indexedCustomData3;
	public $groupId;
	public $permissions;
	public $partnerData;
	public $allowQuickEdit;
}

class KalturaModeration
{
	public $comments;
	public $objectType;
	public $objectId;
}

class KalturaUser
{
	public $screenName;
	public $fullName;
	public $email;
	public $dateOfBirth;
	public $aboutMe;
	public $tags;
	public $gender;
	public $country;
	public $state;
	public $city;
	public $zip;
	public $urlList;
	public $networkHighschool;
	public $networkCollege;
	public $partnerData;
}

class KalturaWidget
{
	public $kshowId;
	public $entryId;
	public $sourceWidgetId;
	public $uiConfId;
	public $customData;
	public $partnerData;
	public $securityType;
}

class KalturaPuserKuser
{
}

class KalturaUiConf
{
	public $name;
}

class KalturaEntryFilter
{
	const ORDER_BY_CREATED_AT_ASC = "+created_at";
	const ORDER_BY_CREATED_AT_DESC = "-created_at";
	const ORDER_BY_VIEWS_ASC = "+views";
	const ORDER_BY_VIEWS_DESC = "-views";
	const ORDER_BY_ID_ASC = "+id";
	const ORDER_BY_ID_DESC = "-id";

	public $equalUserId;
	public $equalKshowId;
	public $equalType;
	public $inType;
	public $equalMediaType;
	public $inMediaType;
	public $equalIndexedCustomData;
	public $inIndexedCustomData;
	public $likeName;
	public $equalGroupId;
	public $greaterThanOrEqualViews;
	public $greaterThanOrEqualCreatedAt;
	public $lessThanOrEqualCreatedAt;
	public $inPartnerId;
	public $equalPartnerId;
	public $orderBy;
}

class KalturaKShowFilter
{
	const ORDER_BY_CREATED_AT_ASC = "+created_at";
	const ORDER_BY_CREATED_AT_DESC = "-created_at";
	const ORDER_BY_VIEWS_ASC = "+views";
	const ORDER_BY_VIEWS_DESC = "-views";
	const ORDER_BY_ID_ASC = "+id";
	const ORDER_BY_ID_DESC = "-id";

	public $greaterThanOrEqualViews;
	public $equalType;
	public $equalProducerId;
	public $greaterThanOrEqualCreatedAt;
	public $lessThanOrEqualCreatedAt;
	public $orderBy;
}

class KalturaModerationFilter
{
	const ORDER_BY_ID_ASC = "+id";
	const ORDER_BY_ID_DESC = "-id";

	public $equalId;
	public $equalPuserId;
	public $equalStatus;
	public $likeComments;
	public $equalObjectId;
	public $equalObjectType;
	public $equalGroupId;
	public $orderBy;
}

class KalturaNotificationFilter
{
	const ORDER_BY_ID_ASC = "+id";
	const ORDER_BY_ID_DESC = "-id";

	public $equalId;
	public $greaterThanOrEqualId;
	public $equalStatus;
	public $equalType;
	public $orderBy;
}

class KalturaNotification
{
	public $id;
	public $status;
	public $notificationResult;
}

class KalturaPartner
{
	public $name;
	public $url1;
	public $url2;
	public $appearInSearch;
	public $adminName;
	public $adminEmail;
	public $description;
	public $commercialUse;
}

class KalturaClient extends KalturaClientBase
{
	public function __constructor()
	{
		parent::__constructor();
	}

	public function addDvdEntry(KalturaSessionUser $kalturaSessionUser, KalturaEntry $dvdEntry)
	{
		$params = array();
		$this->addOptionalParam($params, "dvdEntry_name", $dvdEntry->name);
		$this->addOptionalParam($params, "dvdEntry_tags", $dvdEntry->tags);
		$this->addOptionalParam($params, "dvdEntry_type", $dvdEntry->type);
		$this->addOptionalParam($params, "dvdEntry_mediaType", $dvdEntry->mediaType);
		$this->addOptionalParam($params, "dvdEntry_source", $dvdEntry->source);
		$this->addOptionalParam($params, "dvdEntry_sourceId", $dvdEntry->sourceId);
		$this->addOptionalParam($params, "dvdEntry_sourceLink", $dvdEntry->sourceLink);
		$this->addOptionalParam($params, "dvdEntry_licenseType", $dvdEntry->licenseType);
		$this->addOptionalParam($params, "dvdEntry_credit", $dvdEntry->credit);
		$this->addOptionalParam($params, "dvdEntry_groupId", $dvdEntry->groupId);
		$this->addOptionalParam($params, "dvdEntry_partnerData", $dvdEntry->partnerData);
		$this->addOptionalParam($params, "dvdEntry_conversionQuality", $dvdEntry->conversionQuality);
		$this->addOptionalParam($params, "dvdEntry_permissions", $dvdEntry->permissions);
		$this->addOptionalParam($params, "dvdEntry_dataContent", $dvdEntry->dataContent);
		$this->addOptionalParam($params, "dvdEntry_desiredVersion", $dvdEntry->desiredVersion);
		$this->addOptionalParam($params, "dvdEntry_url", $dvdEntry->url);
		$this->addOptionalParam($params, "dvdEntry_thumbUrl", $dvdEntry->thumbUrl);
		$this->addOptionalParam($params, "dvdEntry_filename", $dvdEntry->filename);
		$this->addOptionalParam($params, "dvdEntry_realFilename", $dvdEntry->realFilename);
		$this->addOptionalParam($params, "dvdEntry_indexedCustomData1", $dvdEntry->indexedCustomData1);
		$this->addOptionalParam($params, "dvdEntry_thumbOffset", $dvdEntry->thumbOffset);

		$result = $this->hit("adddvdentry", $kalturaSessionUser, $params);
		return $result;
	}

	public function addEntry(KalturaSessionUser $kalturaSessionUser, $kshowId, KalturaEntry $entry, $uid = null)
	{
		$params = array();
		$params["kshow_id"] = $kshowId;
		$this->addOptionalParam($params, "entry_name", $entry->name);
		$this->addOptionalParam($params, "entry_tags", $entry->tags);
		$this->addOptionalParam($params, "entry_type", $entry->type);
		$this->addOptionalParam($params, "entry_mediaType", $entry->mediaType);
		$this->addOptionalParam($params, "entry_source", $entry->source);
		$this->addOptionalParam($params, "entry_sourceId", $entry->sourceId);
		$this->addOptionalParam($params, "entry_sourceLink", $entry->sourceLink);
		$this->addOptionalParam($params, "entry_licenseType", $entry->licenseType);
		$this->addOptionalParam($params, "entry_credit", $entry->credit);
		$this->addOptionalParam($params, "entry_groupId", $entry->groupId);
		$this->addOptionalParam($params, "entry_partnerData", $entry->partnerData);
		$this->addOptionalParam($params, "entry_conversionQuality", $entry->conversionQuality);
		$this->addOptionalParam($params, "entry_permissions", $entry->permissions);
		$this->addOptionalParam($params, "entry_dataContent", $entry->dataContent);
		$this->addOptionalParam($params, "entry_desiredVersion", $entry->desiredVersion);
		$this->addOptionalParam($params, "entry_url", $entry->url);
		$this->addOptionalParam($params, "entry_thumbUrl", $entry->thumbUrl);
		$this->addOptionalParam($params, "entry_filename", $entry->filename);
		$this->addOptionalParam($params, "entry_realFilename", $entry->realFilename);
		$this->addOptionalParam($params, "entry_indexedCustomData1", $entry->indexedCustomData1);
		$this->addOptionalParam($params, "entry_thumbOffset", $entry->thumbOffset);
		$this->addOptionalParam($params, "uid", $uid);

		$result = $this->hit("addentry", $kalturaSessionUser, $params);
		return $result;
	}

	public function addKShow(KalturaSessionUser $kalturaSessionUser, KalturaKShow $kshow, $detailed = null, $allowDuplicateNames = null)
	{
		$params = array();
		$this->addOptionalParam($params, "kshow_name", $kshow->name);
		$this->addOptionalParam($params, "kshow_description", $kshow->description);
		$this->addOptionalParam($params, "kshow_tags", $kshow->tags);
		$this->addOptionalParam($params, "kshow_indexedCustomData3", $kshow->indexedCustomData3);
		$this->addOptionalParam($params, "kshow_groupId", $kshow->groupId);
		$this->addOptionalParam($params, "kshow_permissions", $kshow->permissions);
		$this->addOptionalParam($params, "kshow_partnerData", $kshow->partnerData);
		$this->addOptionalParam($params, "kshow_allowQuickEdit", $kshow->allowQuickEdit);
		$this->addOptionalParam($params, "detailed", $detailed);
		$this->addOptionalParam($params, "allow_duplicate_names", $allowDuplicateNames);

		$result = $this->hit("addkshow", $kalturaSessionUser, $params);
		return $result;
	}

	public function addModeration(KalturaSessionUser $kalturaSessionUser, KalturaModeration $moderation)
	{
		$params = array();
		$this->addOptionalParam($params, "moderation_comments", $moderation->comments);
		$this->addOptionalParam($params, "moderation_objectType", $moderation->objectType);
		$this->addOptionalParam($params, "moderation_objectId", $moderation->objectId);

		$result = $this->hit("addmoderation", $kalturaSessionUser, $params);
		return $result;
	}

	public function addPartnerEntry(KalturaSessionUser $kalturaSessionUser, $kshowId, KalturaEntry $entry, $uid = null)
	{
		$params = array();
		$params["kshow_id"] = $kshowId;
		$this->addOptionalParam($params, "entry_name", $entry->name);
		$this->addOptionalParam($params, "entry_tags", $entry->tags);
		$this->addOptionalParam($params, "entry_type", $entry->type);
		$this->addOptionalParam($params, "entry_mediaType", $entry->mediaType);
		$this->addOptionalParam($params, "entry_source", $entry->source);
		$this->addOptionalParam($params, "entry_sourceId", $entry->sourceId);
		$this->addOptionalParam($params, "entry_sourceLink", $entry->sourceLink);
		$this->addOptionalParam($params, "entry_licenseType", $entry->licenseType);
		$this->addOptionalParam($params, "entry_credit", $entry->credit);
		$this->addOptionalParam($params, "entry_groupId", $entry->groupId);
		$this->addOptionalParam($params, "entry_partnerData", $entry->partnerData);
		$this->addOptionalParam($params, "entry_conversionQuality", $entry->conversionQuality);
		$this->addOptionalParam($params, "entry_permissions", $entry->permissions);
		$this->addOptionalParam($params, "entry_dataContent", $entry->dataContent);
		$this->addOptionalParam($params, "entry_desiredVersion", $entry->desiredVersion);
		$this->addOptionalParam($params, "entry_url", $entry->url);
		$this->addOptionalParam($params, "entry_thumbUrl", $entry->thumbUrl);
		$this->addOptionalParam($params, "entry_filename", $entry->filename);
		$this->addOptionalParam($params, "entry_realFilename", $entry->realFilename);
		$this->addOptionalParam($params, "entry_indexedCustomData1", $entry->indexedCustomData1);
		$this->addOptionalParam($params, "entry_thumbOffset", $entry->thumbOffset);
		$this->addOptionalParam($params, "uid", $uid);

		$result = $this->hit("addpartnerentry", $kalturaSessionUser, $params);
		return $result;
	}

	public function addUser(KalturaSessionUser $kalturaSessionUser, $userId, KalturaUser $user)
	{
		$params = array();
		$params["user_id"] = $userId;
		$this->addOptionalParam($params, "user_screenName", $user->screenName);
		$this->addOptionalParam($params, "user_fullName", $user->fullName);
		$this->addOptionalParam($params, "user_email", $user->email);
		$this->addOptionalParam($params, "user_dateOfBirth", $user->dateOfBirth);
		$this->addOptionalParam($params, "user_aboutMe", $user->aboutMe);
		$this->addOptionalParam($params, "user_tags", $user->tags);
		$this->addOptionalParam($params, "user_gender", $user->gender);
		$this->addOptionalParam($params, "user_country", $user->country);
		$this->addOptionalParam($params, "user_state", $user->state);
		$this->addOptionalParam($params, "user_city", $user->city);
		$this->addOptionalParam($params, "user_zip", $user->zip);
		$this->addOptionalParam($params, "user_urlList", $user->urlList);
		$this->addOptionalParam($params, "user_networkHighschool", $user->networkHighschool);
		$this->addOptionalParam($params, "user_networkCollege", $user->networkCollege);
		$this->addOptionalParam($params, "user_partnerData", $user->partnerData);

		$result = $this->hit("adduser", $kalturaSessionUser, $params);
		return $result;
	}

	public function addWidget(KalturaSessionUser $kalturaSessionUser, KalturaWidget $widget)
	{
		$params = array();
		$this->addOptionalParam($params, "widget_kshowId", $widget->kshowId);
		$this->addOptionalParam($params, "widget_entryId", $widget->entryId);
		$this->addOptionalParam($params, "widget_sourceWidgetId", $widget->sourceWidgetId);
		$this->addOptionalParam($params, "widget_uiConfId", $widget->uiConfId);
		$this->addOptionalParam($params, "widget_customData", $widget->customData);
		$this->addOptionalParam($params, "widget_partnerData", $widget->partnerData);
		$this->addOptionalParam($params, "widget_securityType", $widget->securityType);

		$result = $this->hit("addwidget", $kalturaSessionUser, $params);
		return $result;
	}

	public function checkNotifications(KalturaSessionUser $kalturaSessionUser, $notificationIds, $separator = ",", $detailed = null)
	{
		$params = array();
		$params["notification_ids"] = $notificationIds;
		$this->addOptionalParam($params, "separator", $separator);
		$this->addOptionalParam($params, "detailed", $detailed);

		$result = $this->hit("checknotifications", $kalturaSessionUser, $params);
		return $result;
	}

	public function cloneKShow(KalturaSessionUser $kalturaSessionUser, $kshowId, $detailed = null)
	{
		$params = array();
		$params["kshow_id"] = $kshowId;
		$this->addOptionalParam($params, "detailed", $detailed);

		$result = $this->hit("clonekshow", $kalturaSessionUser, $params);
		return $result;
	}

	public function collectStats(KalturaSessionUser $kalturaSessionUser, $objType, $objId, $command, $value, $extraInfo, $kshowId = null)
	{
		$params = array();
		$params["obj_type"] = $objType;
		$params["obj_id"] = $objId;
		$params["command"] = $command;
		$params["value"] = $value;
		$params["extra_info"] = $extraInfo;
		$this->addOptionalParam($params, "kshow_id", $kshowId);

		$result = $this->hit("collectstats", $kalturaSessionUser, $params);
		return $result;
	}

	public function deleteEntry(KalturaSessionUser $kalturaSessionUser, $entryId, $kshowId = null)
	{
		$params = array();
		$params["entry_id"] = $entryId;
		$this->addOptionalParam($params, "kshow_id", $kshowId);

		$result = $this->hit("deleteentry", $kalturaSessionUser, $params);
		return $result;
	}

	public function deleteKShow(KalturaSessionUser $kalturaSessionUser, $kshowId)
	{
		$params = array();
		$params["kshow_id"] = $kshowId;

		$result = $this->hit("deletekshow", $kalturaSessionUser, $params);
		return $result;
	}

	public function deleteUser(KalturaSessionUser $kalturaSessionUser, $userId)
	{
		$params = array();
		$params["user_id"] = $userId;

		$result = $this->hit("deleteuser", $kalturaSessionUser, $params);
		return $result;
	}

	public function getAllEntries(KalturaSessionUser $kalturaSessionUser, $entryId, $kshowId, $listType = null, $version = null)
	{
		$params = array();
		$params["entry_id"] = $entryId;
		$params["kshow_id"] = $kshowId;
		$this->addOptionalParam($params, "list_type", $listType);
		$this->addOptionalParam($params, "version", $version);

		$result = $this->hit("getallentries", $kalturaSessionUser, $params);
		return $result;
	}

	public function getDvdEntry(KalturaSessionUser $kalturaSessionUser, $dvdEntryId, $detailed = null)
	{
		$params = array();
		$params["dvdEntry_id"] = $dvdEntryId;
		$this->addOptionalParam($params, "detailed", $detailed);

		$result = $this->hit("getdvdentry", $kalturaSessionUser, $params);
		return $result;
	}

	public function getEntries(KalturaSessionUser $kalturaSessionUser, $entryIds, $separator = ",", $detailed = null)
	{
		$params = array();
		$params["entry_ids"] = $entryIds;
		$this->addOptionalParam($params, "separator", $separator);
		$this->addOptionalParam($params, "detailed", $detailed);

		$result = $this->hit("getentries", $kalturaSessionUser, $params);
		return $result;
	}

	public function getEntry(KalturaSessionUser $kalturaSessionUser, $entryId, $detailed = null, $version = null)
	{
		$params = array();
		$params["entry_id"] = $entryId;
		$this->addOptionalParam($params, "detailed", $detailed);
		$this->addOptionalParam($params, "version", $version);

		$result = $this->hit("getentry", $kalturaSessionUser, $params);
		return $result;
	}

	public function getKShow(KalturaSessionUser $kalturaSessionUser, $kshowId, $detailed = null)
	{
		$params = array();
		$params["kshow_id"] = $kshowId;
		$this->addOptionalParam($params, "detailed", $detailed);

		$result = $this->hit("getkshow", $kalturaSessionUser, $params);
		return $result;
	}

	public function getLastVersionsInfo(KalturaSessionUser $kalturaSessionUser, $kshowId)
	{
		$params = array();
		$params["kshow_id"] = $kshowId;

		$result = $this->hit("getlastversionsinfo", $kalturaSessionUser, $params);
		return $result;
	}

	public function getMetaDataAction(KalturaSessionUser $kalturaSessionUser, $entryId, $kshowId, $version)
	{
		$params = array();
		$params["entry_id"] = $entryId;
		$params["kshow_id"] = $kshowId;
		$params["version"] = $version;

		$result = $this->hit("getmetadata", $kalturaSessionUser, $params);
		return $result;
	}

	public function getPartner(KalturaSessionUser $kalturaSessionUser, $partnerAdminEmail, $cmsPassword, $partnerId)
	{
		$params = array();
		$params["partner_adminEmail"] = $partnerAdminEmail;
		$params["cms_password"] = $cmsPassword;
		$params["partner_id"] = $partnerId;

		$result = $this->hit("getpartner", $kalturaSessionUser, $params);
		return $result;
	}

	public function getThumbnail(KalturaSessionUser $kalturaSessionUser, $filename)
	{
		$params = array();
		$params["filename"] = $filename;

		$result = $this->hit("getthumbnail", $kalturaSessionUser, $params);
		return $result;
	}

	public function getUIConf(KalturaSessionUser $kalturaSessionUser, $uiConfId, $detailed = null)
	{
		$params = array();
		$params["ui_conf_id"] = $uiConfId;
		$this->addOptionalParam($params, "detailed", $detailed);

		$result = $this->hit("getuiconf", $kalturaSessionUser, $params);
		return $result;
	}

	public function getUser(KalturaSessionUser $kalturaSessionUser, $userId, $detailed = null)
	{
		$params = array();
		$params["user_id"] = $userId;
		$this->addOptionalParam($params, "detailed", $detailed);

		$result = $this->hit("getuser", $kalturaSessionUser, $params);
		return $result;
	}

	public function getWidget(KalturaSessionUser $kalturaSessionUser, $widgetId, $detailed = null)
	{
		$params = array();
		$params["widget_id"] = $widgetId;
		$this->addOptionalParam($params, "detailed", $detailed);

		$result = $this->hit("getwidget", $kalturaSessionUser, $params);
		return $result;
	}

	public function handleModeration(KalturaSessionUser $kalturaSessionUser, $moderationId, $moderationStatus)
	{
		$params = array();
		$params["moderation_id"] = $moderationId;
		$params["moderation_status"] = $moderationStatus;

		$result = $this->hit("handlemoderation", $kalturaSessionUser, $params);
		return $result;
	}

	public function listDvdEntries(KalturaSessionUser $kalturaSessionUser, KalturaEntryFilter $filter, $detailed = null, $pageSize = 10, $page = 1, $useFilterPuserId = null)
	{
		$params = array();
		$this->addOptionalParam($params, "filter__eq_user_id", $filter->equalUserId);
		$this->addOptionalParam($params, "filter__eq_kshow_id", $filter->equalKshowId);
		$this->addOptionalParam($params, "filter__eq_type", $filter->equalType);
		$this->addOptionalParam($params, "filter__in_type", $filter->inType);
		$this->addOptionalParam($params, "filter__eq_media_type", $filter->equalMediaType);
		$this->addOptionalParam($params, "filter__in_media_type", $filter->inMediaType);
		$this->addOptionalParam($params, "filter__eq_indexed_custom_data_1", $filter->equalIndexedCustomData);
		$this->addOptionalParam($params, "filter__in_indexed_custom_data_1", $filter->inIndexedCustomData);
		$this->addOptionalParam($params, "filter__like_name", $filter->likeName);
		$this->addOptionalParam($params, "filter__eq_group_id", $filter->equalGroupId);
		$this->addOptionalParam($params, "filter__gte_views", $filter->greaterThanOrEqualViews);
		$this->addOptionalParam($params, "filter__gte_created_at", $filter->greaterThanOrEqualCreatedAt);
		$this->addOptionalParam($params, "filter__lte_created_at", $filter->lessThanOrEqualCreatedAt);
		$this->addOptionalParam($params, "filter__in_partner_id", $filter->inPartnerId);
		$this->addOptionalParam($params, "filter__eq_partner_id", $filter->equalPartnerId);
		$this->addOptionalParam($params, "filter__order_by", $filter->orderBy);
		$this->addOptionalParam($params, "detailed", $detailed);
		$this->addOptionalParam($params, "page_size", $pageSize);
		$this->addOptionalParam($params, "page", $page);
		$this->addOptionalParam($params, "use_filter_puser_id", $useFilterPuserId);

		$result = $this->hit("listdvdentries", $kalturaSessionUser, $params);
		return $result;
	}

	public function listEntries(KalturaSessionUser $kalturaSessionUser, KalturaEntryFilter $filter, $detailed = null, $pageSize = 10, $page = 1, $useFilterPuserId = null)
	{
		$params = array();
		$this->addOptionalParam($params, "filter__eq_user_id", $filter->equalUserId);
		$this->addOptionalParam($params, "filter__eq_kshow_id", $filter->equalKshowId);
		$this->addOptionalParam($params, "filter__eq_type", $filter->equalType);
		$this->addOptionalParam($params, "filter__in_type", $filter->inType);
		$this->addOptionalParam($params, "filter__eq_media_type", $filter->equalMediaType);
		$this->addOptionalParam($params, "filter__in_media_type", $filter->inMediaType);
		$this->addOptionalParam($params, "filter__eq_indexed_custom_data_1", $filter->equalIndexedCustomData);
		$this->addOptionalParam($params, "filter__in_indexed_custom_data_1", $filter->inIndexedCustomData);
		$this->addOptionalParam($params, "filter__like_name", $filter->likeName);
		$this->addOptionalParam($params, "filter__eq_group_id", $filter->equalGroupId);
		$this->addOptionalParam($params, "filter__gte_views", $filter->greaterThanOrEqualViews);
		$this->addOptionalParam($params, "filter__gte_created_at", $filter->greaterThanOrEqualCreatedAt);
		$this->addOptionalParam($params, "filter__lte_created_at", $filter->lessThanOrEqualCreatedAt);
		$this->addOptionalParam($params, "filter__in_partner_id", $filter->inPartnerId);
		$this->addOptionalParam($params, "filter__eq_partner_id", $filter->equalPartnerId);
		$this->addOptionalParam($params, "filter__order_by", $filter->orderBy);
		$this->addOptionalParam($params, "detailed", $detailed);
		$this->addOptionalParam($params, "page_size", $pageSize);
		$this->addOptionalParam($params, "page", $page);
		$this->addOptionalParam($params, "use_filter_puser_id", $useFilterPuserId);

		$result = $this->hit("listentries", $kalturaSessionUser, $params);
		return $result;
	}

	public function listKShows(KalturaSessionUser $kalturaSessionUser, KalturaKShowFilter $filter, $detailed = null, $pageSize = 10, $page = 1, $useFilterPuserId = null)
	{
		$params = array();
		$this->addOptionalParam($params, "filter__gte_views", $filter->greaterThanOrEqualViews);
		$this->addOptionalParam($params, "filter__eq_type", $filter->equalType);
		$this->addOptionalParam($params, "filter__eq_producer_id", $filter->equalProducerId);
		$this->addOptionalParam($params, "filter__gte_created_at", $filter->greaterThanOrEqualCreatedAt);
		$this->addOptionalParam($params, "filter__lte_created_at", $filter->lessThanOrEqualCreatedAt);
		$this->addOptionalParam($params, "filter__order_by", $filter->orderBy);
		$this->addOptionalParam($params, "detailed", $detailed);
		$this->addOptionalParam($params, "page_size", $pageSize);
		$this->addOptionalParam($params, "page", $page);
		$this->addOptionalParam($params, "use_filter_puser_id", $useFilterPuserId);

		$result = $this->hit("listkshows", $kalturaSessionUser, $params);
		return $result;
	}

	public function listModerations(KalturaSessionUser $kalturaSessionUser, KalturaModerationFilter $filter, $detailed = null, $pageSize = 10, $page = 1)
	{
		$params = array();
		$this->addOptionalParam($params, "filter__eq_id", $filter->equalId);
		$this->addOptionalParam($params, "filter__eq_puser_id", $filter->equalPuserId);
		$this->addOptionalParam($params, "filter__eq_status", $filter->equalStatus);
		$this->addOptionalParam($params, "filter__like_comments", $filter->likeComments);
		$this->addOptionalParam($params, "filter__eq_object_id", $filter->equalObjectId);
		$this->addOptionalParam($params, "filter__eq_object_type", $filter->equalObjectType);
		$this->addOptionalParam($params, "filter__eq_group_id", $filter->equalGroupId);
		$this->addOptionalParam($params, "filter__order_by", $filter->orderBy);
		$this->addOptionalParam($params, "detailed", $detailed);
		$this->addOptionalParam($params, "page_size", $pageSize);
		$this->addOptionalParam($params, "page", $page);

		$result = $this->hit("listmoderations", $kalturaSessionUser, $params);
		return $result;
	}

	public function listMyDvdEntries(KalturaSessionUser $kalturaSessionUser, KalturaEntryFilter $filter, $detailed = null, $pageSize = 10, $page = 1, $useFilterPuserId = null)
	{
		$params = array();
		$this->addOptionalParam($params, "filter__eq_user_id", $filter->equalUserId);
		$this->addOptionalParam($params, "filter__eq_kshow_id", $filter->equalKshowId);
		$this->addOptionalParam($params, "filter__eq_type", $filter->equalType);
		$this->addOptionalParam($params, "filter__in_type", $filter->inType);
		$this->addOptionalParam($params, "filter__eq_media_type", $filter->equalMediaType);
		$this->addOptionalParam($params, "filter__in_media_type", $filter->inMediaType);
		$this->addOptionalParam($params, "filter__eq_indexed_custom_data_1", $filter->equalIndexedCustomData);
		$this->addOptionalParam($params, "filter__in_indexed_custom_data_1", $filter->inIndexedCustomData);
		$this->addOptionalParam($params, "filter__like_name", $filter->likeName);
		$this->addOptionalParam($params, "filter__eq_group_id", $filter->equalGroupId);
		$this->addOptionalParam($params, "filter__gte_views", $filter->greaterThanOrEqualViews);
		$this->addOptionalParam($params, "filter__gte_created_at", $filter->greaterThanOrEqualCreatedAt);
		$this->addOptionalParam($params, "filter__lte_created_at", $filter->lessThanOrEqualCreatedAt);
		$this->addOptionalParam($params, "filter__in_partner_id", $filter->inPartnerId);
		$this->addOptionalParam($params, "filter__eq_partner_id", $filter->equalPartnerId);
		$this->addOptionalParam($params, "filter__order_by", $filter->orderBy);
		$this->addOptionalParam($params, "detailed", $detailed);
		$this->addOptionalParam($params, "page_size", $pageSize);
		$this->addOptionalParam($params, "page", $page);
		$this->addOptionalParam($params, "use_filter_puser_id", $useFilterPuserId);

		$result = $this->hit("listmydvdentries", $kalturaSessionUser, $params);
		return $result;
	}

	public function listMyEntries(KalturaSessionUser $kalturaSessionUser, KalturaEntryFilter $filter, $detailed = null, $pageSize = 10, $page = 1, $useFilterPuserId = null)
	{
		$params = array();
		$this->addOptionalParam($params, "filter__eq_user_id", $filter->equalUserId);
		$this->addOptionalParam($params, "filter__eq_kshow_id", $filter->equalKshowId);
		$this->addOptionalParam($params, "filter__eq_type", $filter->equalType);
		$this->addOptionalParam($params, "filter__in_type", $filter->inType);
		$this->addOptionalParam($params, "filter__eq_media_type", $filter->equalMediaType);
		$this->addOptionalParam($params, "filter__in_media_type", $filter->inMediaType);
		$this->addOptionalParam($params, "filter__eq_indexed_custom_data_1", $filter->equalIndexedCustomData);
		$this->addOptionalParam($params, "filter__in_indexed_custom_data_1", $filter->inIndexedCustomData);
		$this->addOptionalParam($params, "filter__like_name", $filter->likeName);
		$this->addOptionalParam($params, "filter__eq_group_id", $filter->equalGroupId);
		$this->addOptionalParam($params, "filter__gte_views", $filter->greaterThanOrEqualViews);
		$this->addOptionalParam($params, "filter__gte_created_at", $filter->greaterThanOrEqualCreatedAt);
		$this->addOptionalParam($params, "filter__lte_created_at", $filter->lessThanOrEqualCreatedAt);
		$this->addOptionalParam($params, "filter__in_partner_id", $filter->inPartnerId);
		$this->addOptionalParam($params, "filter__eq_partner_id", $filter->equalPartnerId);
		$this->addOptionalParam($params, "filter__order_by", $filter->orderBy);
		$this->addOptionalParam($params, "detailed", $detailed);
		$this->addOptionalParam($params, "page_size", $pageSize);
		$this->addOptionalParam($params, "page", $page);
		$this->addOptionalParam($params, "use_filter_puser_id", $useFilterPuserId);

		$result = $this->hit("listmyentries", $kalturaSessionUser, $params);
		return $result;
	}

	public function listMyKShows(KalturaSessionUser $kalturaSessionUser, KalturaKShowFilter $filter, $detailed = null, $pageSize = 10, $page = 1, $useFilterPuserId = null)
	{
		$params = array();
		$this->addOptionalParam($params, "filter__gte_views", $filter->greaterThanOrEqualViews);
		$this->addOptionalParam($params, "filter__eq_type", $filter->equalType);
		$this->addOptionalParam($params, "filter__eq_producer_id", $filter->equalProducerId);
		$this->addOptionalParam($params, "filter__gte_created_at", $filter->greaterThanOrEqualCreatedAt);
		$this->addOptionalParam($params, "filter__lte_created_at", $filter->lessThanOrEqualCreatedAt);
		$this->addOptionalParam($params, "filter__order_by", $filter->orderBy);
		$this->addOptionalParam($params, "detailed", $detailed);
		$this->addOptionalParam($params, "page_size", $pageSize);
		$this->addOptionalParam($params, "page", $page);
		$this->addOptionalParam($params, "use_filter_puser_id", $useFilterPuserId);

		$result = $this->hit("listmykshows", $kalturaSessionUser, $params);
		return $result;
	}

	public function listNotifications(KalturaSessionUser $kalturaSessionUser, KalturaNotificationFilter $filter, $pageSize = 10, $page = 1)
	{
		$params = array();
		$this->addOptionalParam($params, "filter__eq_id", $filter->equalId);
		$this->addOptionalParam($params, "filter__gte_id", $filter->greaterThanOrEqualId);
		$this->addOptionalParam($params, "filter__eq_status", $filter->equalStatus);
		$this->addOptionalParam($params, "filter__eq_type", $filter->equalType);
		$this->addOptionalParam($params, "filter__order_by", $filter->orderBy);
		$this->addOptionalParam($params, "page_size", $pageSize);
		$this->addOptionalParam($params, "page", $page);

		$result = $this->hit("listnotifications", $kalturaSessionUser, $params);
		return $result;
	}

	public function listPartnerEntries(KalturaSessionUser $kalturaSessionUser, KalturaEntryFilter $filter, $detailed = null, $pageSize = 10, $page = 1, $useFilterPuserId = null)
	{
		$params = array();
		$this->addOptionalParam($params, "filter__eq_user_id", $filter->equalUserId);
		$this->addOptionalParam($params, "filter__eq_kshow_id", $filter->equalKshowId);
		$this->addOptionalParam($params, "filter__eq_type", $filter->equalType);
		$this->addOptionalParam($params, "filter__in_type", $filter->inType);
		$this->addOptionalParam($params, "filter__eq_media_type", $filter->equalMediaType);
		$this->addOptionalParam($params, "filter__in_media_type", $filter->inMediaType);
		$this->addOptionalParam($params, "filter__eq_indexed_custom_data_1", $filter->equalIndexedCustomData);
		$this->addOptionalParam($params, "filter__in_indexed_custom_data_1", $filter->inIndexedCustomData);
		$this->addOptionalParam($params, "filter__like_name", $filter->likeName);
		$this->addOptionalParam($params, "filter__eq_group_id", $filter->equalGroupId);
		$this->addOptionalParam($params, "filter__gte_views", $filter->greaterThanOrEqualViews);
		$this->addOptionalParam($params, "filter__gte_created_at", $filter->greaterThanOrEqualCreatedAt);
		$this->addOptionalParam($params, "filter__lte_created_at", $filter->lessThanOrEqualCreatedAt);
		$this->addOptionalParam($params, "filter__in_partner_id", $filter->inPartnerId);
		$this->addOptionalParam($params, "filter__eq_partner_id", $filter->equalPartnerId);
		$this->addOptionalParam($params, "filter__order_by", $filter->orderBy);
		$this->addOptionalParam($params, "detailed", $detailed);
		$this->addOptionalParam($params, "page_size", $pageSize);
		$this->addOptionalParam($params, "page", $page);
		$this->addOptionalParam($params, "use_filter_puser_id", $useFilterPuserId);

		$result = $this->hit("listpartnerentries", $kalturaSessionUser, $params);
		return $result;
	}

	public function rankKShow(KalturaSessionUser $kalturaSessionUser, $kshowId, $rank, $pageSize = 10, $page = 1)
	{
		$params = array();
		$params["kshow_id"] = $kshowId;
		$params["rank"] = $rank;
		$this->addOptionalParam($params, "page_size", $pageSize);
		$this->addOptionalParam($params, "page", $page);

		$result = $this->hit("rankkshow", $kalturaSessionUser, $params);
		return $result;
	}

	public function registerPartner(KalturaSessionUser $kalturaSessionUser, KalturaPartner $partner, $cmsPassword = null)
	{
		$params = array();
		$this->addOptionalParam($params, "partner_name", $partner->name);
		$this->addOptionalParam($params, "partner_url1", $partner->url1);
		$this->addOptionalParam($params, "partner_url2", $partner->url2);
		$this->addOptionalParam($params, "partner_appearInSearch", $partner->appearInSearch);
		$this->addOptionalParam($params, "partner_adminName", $partner->adminName);
		$this->addOptionalParam($params, "partner_adminEmail", $partner->adminEmail);
		$this->addOptionalParam($params, "partner_description", $partner->description);
		$this->addOptionalParam($params, "partner_commercialUse", $partner->commercialUse);
		$this->addOptionalParam($params, "cms_password", $cmsPassword);

		$result = $this->hit("registerpartner", $kalturaSessionUser, $params);
		return $result;
	}

	public function reportEntry(KalturaSessionUser $kalturaSessionUser, KalturaModeration $moderation)
	{
		$params = array();
		$this->addOptionalParam($params, "moderation_comments", $moderation->comments);
		$this->addOptionalParam($params, "moderation_objectType", $moderation->objectType);
		$this->addOptionalParam($params, "moderation_objectId", $moderation->objectId);

		$result = $this->hit("reportentry", $kalturaSessionUser, $params);
		return $result;
	}

	public function reportKShow(KalturaSessionUser $kalturaSessionUser, KalturaModeration $moderation)
	{
		$params = array();
		$this->addOptionalParam($params, "moderation_comments", $moderation->comments);
		$this->addOptionalParam($params, "moderation_objectType", $moderation->objectType);
		$this->addOptionalParam($params, "moderation_objectId", $moderation->objectId);

		$result = $this->hit("reportkshow", $kalturaSessionUser, $params);
		return $result;
	}

	public function rollbackKShow(KalturaSessionUser $kalturaSessionUser, $kshowId, $kshowVersion)
	{
		$params = array();
		$params["kshow_id"] = $kshowId;
		$params["kshow_version"] = $kshowVersion;

		$result = $this->hit("rollbackkshow", $kalturaSessionUser, $params);
		return $result;
	}

	public function search(KalturaSessionUser $kalturaSessionUser, $mediaType, $mediaSource, $search, $authData, $page = 1, $pageSize = 10)
	{
		$params = array();
		$params["media_type"] = $mediaType;
		$params["media_source"] = $mediaSource;
		$params["search"] = $search;
		$params["auth_data"] = $authData;
		$this->addOptionalParam($params, "page", $page);
		$this->addOptionalParam($params, "page_size", $pageSize);

		$result = $this->hit("search", $kalturaSessionUser, $params);
		return $result;
	}

	public function searchAuthData(KalturaSessionUser $kalturaSessionUser, $mediaSource, $username, $password)
	{
		$params = array();
		$params["media_source"] = $mediaSource;
		$params["username"] = $username;
		$params["password"] = $password;

		$result = $this->hit("searchauthdata", $kalturaSessionUser, $params);
		return $result;
	}

	public function searchFromUrl(KalturaSessionUser $kalturaSessionUser, $url, $mediaType)
	{
		$params = array();
		$params["url"] = $url;
		$params["media_type"] = $mediaType;

		$result = $this->hit("searchfromurl", $kalturaSessionUser, $params);
		return $result;
	}

	public function searchMediaInfo(KalturaSessionUser $kalturaSessionUser)
	{
		$params = array();

		$result = $this->hit("searchmediainfo", $kalturaSessionUser, $params);
		return $result;
	}

	public function searchmediaproviders(KalturaSessionUser $kalturaSessionUser)
	{
		$params = array();

		$result = $this->hit("searchmediaproviders", $kalturaSessionUser, $params);
		return $result;
	}

	public function setMetaData(KalturaSessionUser $kalturaSessionUser, $entryId, $kshowId, $hasRoughCut, $xml)
	{
		$params = array();
		$params["entry_id"] = $entryId;
		$params["kshow_id"] = $kshowId;
		$params["HasRoughCut"] = $hasRoughCut;
		$params["xml"] = $xml;

		$result = $this->hit("setmetadata", $kalturaSessionUser, $params);
		return $result;
	}

	public function startSession(KalturaSessionUser $kalturaSessionUser, $secret, $admin = null, $privileges = null, $expiry = 86400)
	{
		$params = array();
		$params["secret"] = $secret;
		$this->addOptionalParam($params, "admin", $admin);
		$this->addOptionalParam($params, "privileges", $privileges);
		$this->addOptionalParam($params, "expiry", $expiry);

		$result = $this->hit("startsession", $kalturaSessionUser, $params);
		return $result;
	}

	public function startWidgetSession(KalturaSessionUser $kalturaSessionUser, $widgetId, $expiry = 86400)
	{
		$params = array();
		$params["widget_id"] = $widgetId;
		$this->addOptionalParam($params, "expiry", $expiry);

		$result = $this->hit("startwidgetsession", $kalturaSessionUser, $params);
		return $result;
	}

	public function updateDvdEntry(KalturaSessionUser $kalturaSessionUser, $entryId, KalturaEntry $entry)
	{
		$params = array();
		$params["entry_id"] = $entryId;
		$this->addOptionalParam($params, "entry_name", $entry->name);
		$this->addOptionalParam($params, "entry_tags", $entry->tags);
		$this->addOptionalParam($params, "entry_type", $entry->type);
		$this->addOptionalParam($params, "entry_mediaType", $entry->mediaType);
		$this->addOptionalParam($params, "entry_source", $entry->source);
		$this->addOptionalParam($params, "entry_sourceId", $entry->sourceId);
		$this->addOptionalParam($params, "entry_sourceLink", $entry->sourceLink);
		$this->addOptionalParam($params, "entry_licenseType", $entry->licenseType);
		$this->addOptionalParam($params, "entry_credit", $entry->credit);
		$this->addOptionalParam($params, "entry_groupId", $entry->groupId);
		$this->addOptionalParam($params, "entry_partnerData", $entry->partnerData);
		$this->addOptionalParam($params, "entry_conversionQuality", $entry->conversionQuality);
		$this->addOptionalParam($params, "entry_permissions", $entry->permissions);
		$this->addOptionalParam($params, "entry_dataContent", $entry->dataContent);
		$this->addOptionalParam($params, "entry_desiredVersion", $entry->desiredVersion);
		$this->addOptionalParam($params, "entry_url", $entry->url);
		$this->addOptionalParam($params, "entry_thumbUrl", $entry->thumbUrl);
		$this->addOptionalParam($params, "entry_filename", $entry->filename);
		$this->addOptionalParam($params, "entry_realFilename", $entry->realFilename);
		$this->addOptionalParam($params, "entry_indexedCustomData1", $entry->indexedCustomData1);
		$this->addOptionalParam($params, "entry_thumbOffset", $entry->thumbOffset);

		$result = $this->hit("updatedvdentry", $kalturaSessionUser, $params);
		return $result;
	}

	public function updateEntriesThumbnails(KalturaSessionUser $kalturaSessionUser, $entryIds, $timeOffset)
	{
		$params = array();
		$params["entry_ids"] = $entryIds;
		$params["time_offset"] = $timeOffset;

		$result = $this->hit("updateentriesthumbnails", $kalturaSessionUser, $params);
		return $result;
	}

	public function updateEntry(KalturaSessionUser $kalturaSessionUser, $entryId, KalturaEntry $entry)
	{
		$params = array();
		$params["entry_id"] = $entryId;
		$this->addOptionalParam($params, "entry_name", $entry->name);
		$this->addOptionalParam($params, "entry_tags", $entry->tags);
		$this->addOptionalParam($params, "entry_type", $entry->type);
		$this->addOptionalParam($params, "entry_mediaType", $entry->mediaType);
		$this->addOptionalParam($params, "entry_source", $entry->source);
		$this->addOptionalParam($params, "entry_sourceId", $entry->sourceId);
		$this->addOptionalParam($params, "entry_sourceLink", $entry->sourceLink);
		$this->addOptionalParam($params, "entry_licenseType", $entry->licenseType);
		$this->addOptionalParam($params, "entry_credit", $entry->credit);
		$this->addOptionalParam($params, "entry_groupId", $entry->groupId);
		$this->addOptionalParam($params, "entry_partnerData", $entry->partnerData);
		$this->addOptionalParam($params, "entry_conversionQuality", $entry->conversionQuality);
		$this->addOptionalParam($params, "entry_permissions", $entry->permissions);
		$this->addOptionalParam($params, "entry_dataContent", $entry->dataContent);
		$this->addOptionalParam($params, "entry_desiredVersion", $entry->desiredVersion);
		$this->addOptionalParam($params, "entry_url", $entry->url);
		$this->addOptionalParam($params, "entry_thumbUrl", $entry->thumbUrl);
		$this->addOptionalParam($params, "entry_filename", $entry->filename);
		$this->addOptionalParam($params, "entry_realFilename", $entry->realFilename);
		$this->addOptionalParam($params, "entry_indexedCustomData1", $entry->indexedCustomData1);
		$this->addOptionalParam($params, "entry_thumbOffset", $entry->thumbOffset);

		$result = $this->hit("updateentry", $kalturaSessionUser, $params);
		return $result;
	}

	public function updateEntryThumbnail(KalturaSessionUser $kalturaSessionUser, $entryId, $sourceEntryId = null, $timeOffset = null)
	{
		$params = array();
		$params["entry_id"] = $entryId;
		$this->addOptionalParam($params, "source_entry_id", $sourceEntryId);
		$this->addOptionalParam($params, "time_offset", $timeOffset);

		$result = $this->hit("updateentrythumbnail", $kalturaSessionUser, $params);
		return $result;
	}

	public function updateEntryThumbnailJpeg(KalturaSessionUser $kalturaSessionUser, $entryId)
	{
		$params = array();
		$params["entry_id"] = $entryId;

		$result = $this->hit("updateentrythumbnailjpeg", $kalturaSessionUser, $params);
		return $result;
	}

	public function updateKShow(KalturaSessionUser $kalturaSessionUser, $kshowId, KalturaKShow $kshow, $detailed = null, $allowDuplicateNames = null)
	{
		$params = array();
		$params["kshow_id"] = $kshowId;
		$this->addOptionalParam($params, "kshow_name", $kshow->name);
		$this->addOptionalParam($params, "kshow_description", $kshow->description);
		$this->addOptionalParam($params, "kshow_tags", $kshow->tags);
		$this->addOptionalParam($params, "kshow_indexedCustomData3", $kshow->indexedCustomData3);
		$this->addOptionalParam($params, "kshow_groupId", $kshow->groupId);
		$this->addOptionalParam($params, "kshow_permissions", $kshow->permissions);
		$this->addOptionalParam($params, "kshow_partnerData", $kshow->partnerData);
		$this->addOptionalParam($params, "kshow_allowQuickEdit", $kshow->allowQuickEdit);
		$this->addOptionalParam($params, "detailed", $detailed);
		$this->addOptionalParam($params, "allow_duplicate_names", $allowDuplicateNames);

		$result = $this->hit("updatekshow", $kalturaSessionUser, $params);
		return $result;
	}

	public function updateKshowOwner(KalturaSessionUser $kalturaSessionUser, $kshowId, $detailed = null)
	{
		$params = array();
		$params["kshow_id"] = $kshowId;
		$this->addOptionalParam($params, "detailed", $detailed);

		$result = $this->hit("updatekshowowner", $kalturaSessionUser, $params);
		return $result;
	}

	public function updateNotification(KalturaSessionUser $kalturaSessionUser, KalturaNotification $notification)
	{
		$params = array();
		$this->addOptionalParam($params, "notification_id", $notification->id);
		$this->addOptionalParam($params, "notification_status", $notification->status);
		$this->addOptionalParam($params, "notification_notificationResult", $notification->notificationResult);

		$result = $this->hit("updatenotification", $kalturaSessionUser, $params);
		return $result;
	}

	public function updateUser(KalturaSessionUser $kalturaSessionUser, $userId, KalturaUser $user)
	{
		$params = array();
		$params["user_id"] = $userId;
		$this->addOptionalParam($params, "user_screenName", $user->screenName);
		$this->addOptionalParam($params, "user_fullName", $user->fullName);
		$this->addOptionalParam($params, "user_email", $user->email);
		$this->addOptionalParam($params, "user_dateOfBirth", $user->dateOfBirth);
		$this->addOptionalParam($params, "user_aboutMe", $user->aboutMe);
		$this->addOptionalParam($params, "user_tags", $user->tags);
		$this->addOptionalParam($params, "user_gender", $user->gender);
		$this->addOptionalParam($params, "user_country", $user->country);
		$this->addOptionalParam($params, "user_state", $user->state);
		$this->addOptionalParam($params, "user_city", $user->city);
		$this->addOptionalParam($params, "user_zip", $user->zip);
		$this->addOptionalParam($params, "user_urlList", $user->urlList);
		$this->addOptionalParam($params, "user_networkHighschool", $user->networkHighschool);
		$this->addOptionalParam($params, "user_networkCollege", $user->networkCollege);
		$this->addOptionalParam($params, "user_partnerData", $user->partnerData);

		$result = $this->hit("updateuser", $kalturaSessionUser, $params);
		return $result;
	}

	public function updateUserId(KalturaSessionUser $kalturaSessionUser, $userId, $newUserId)
	{
		$params = array();
		$params["user_id"] = $userId;
		$params["new_user_id"] = $newUserId;

		$result = $this->hit("updateuserid", $kalturaSessionUser, $params);
		return $result;
	}

	public function upload(KalturaSessionUser $kalturaSessionUser, $filename)
	{
		$params = array();
		$params["filename"] = $filename;

		$result = $this->hit("upload", $kalturaSessionUser, $params);
		return $result;
	}

	public function uploadJpeg(KalturaSessionUser $kalturaSessionUser, $filename, $hash)
	{
		$params = array();
		$params["filename"] = $filename;
		$params["hash"] = $hash;

		$result = $this->hit("uploadjpeg", $kalturaSessionUser, $params);
		return $result;
	}

	public function viewWidget(KalturaSessionUser $kalturaSessionUser, $entryId = null, $kshowId = null, $widgetId = null, $host = null)
	{
		$params = array();
		$this->addOptionalParam($params, "entry_id", $entryId);
		$this->addOptionalParam($params, "kshow_id", $kshowId);
		$this->addOptionalParam($params, "widget_id", $widgetId);
		$this->addOptionalParam($params, "host", $host);

		$result = $this->hit("viewwidget", $kalturaSessionUser, $params);
		return $result;
	}

}
?>
