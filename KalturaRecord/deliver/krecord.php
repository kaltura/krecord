<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<?php
require_once("kaltura_client.php");

// Design params:
$recorder_width = 400;
$recorder_height = 300;
$backgroundColor = '#ccc';

// Partner configuration:
$uid = "your_user_id(whatever)";
$uname = "your_user_name(whatever)";
$pid = "your_partner_id";
$spid = "your_sub_partner_id";
$secret = "secret_key_given_kaltura_on_partner_registration";
$host = "www.kaltura.com";
$cdnHost = "cdn.kaltura.com";
$uiconfId = "krecord_uiconf_id";

$config = new KalturaConfiguration($pid, $spid);

$config->serviceUrl = $host;
$client = new KalturaClient($config);

$user = new KalturaSessionUser();
$user->userId = $uid;
$user->screenName = $uname;

$result = $client->startSession($user, $secret, false, "edit:*");
$ks = @$result["result"]["ks"];

?>
	<title>KRecord - Kaltura Chromeless Recorder - JS Example</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/swfobject/2.1/swfobject.js"></script>
	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
</head>

<body>
	
	<div id="krecorder">This is where the KRecord will be embedded.</div>
	<div>
		<form>
			<fieldset style="display: block; width: 300px; margin: 10px; padding: 1em; font: 80%/1 sans-serif;">
				<legend>Camera Quality</legend>
				<label style="float: left; width: 45%; margin-right: 0.5em; padding-top: 0.2em; text-align: left; font-weight: bold;"
					for="quality" title="An integer that specifies the required level of picture quality, as determined by the amount of compression being applied to each video frame. Acceptable values range from 1 (lowest quality, maximum compression) to 100 (highest quality, no compression)." />
				Quality: </label> <INPUT type="text" id="quality" value="85" />
				<label style="float: left; width: 45%; margin-right: 0.5em; padding-top: 0.2em; text-align: left; font-weight: bold;"
					for="bandwidth" title="Specifies the maximum amount of bandwidth that the current outgoing video feed can use, in bytes per second. To specify that Flash Player video can use as much bandwidth as needed to maintain the value of quality, pass 0 for bandwidth. The default value is 0." />
				BandWidth: </label> <INPUT type="text" id="bandwidth" value="0" />
				<label style="float: left; width: 45%; margin-right: 0.5em; padding-top: 0.2em; text-align: left; font-weight: bold;"
					for="videoWidth" /> Video Width: </label> <INPUT type="text" id="videoWidth" value="320" /> 
				<label style="float: left; width: 45%; margin-right: 0.5em; padding-top: 0.2em; text-align: left; font-weight: bold;"
					for="videoHeight" /> Video Height: </label> <INPUT type="text" id="videoHeight" value="240" /> 
				<label style="float: left; width: 45%; margin-right: 0.5em; padding-top: 0.2em; text-align: left; font-weight: bold;"
					for="videoFPS" /> Video FPS: </label> <INPUT type="text" id="videoFPS" value="25" /> 
				<INPUT type="button" value="Set Camera Quality" onclick="setCameraQuality();return false;" />
			</fieldset>
		</form>
	</div>
	
	<div id="status">
		<h2>Current Status</h2>
		<h4 id="currentStatus" style="margin-left: 10px;"></h4>
		<h2>Status Log</h2>
		<div id="statusLog" style="margin-left: 10px; border: 1px solid; width: 600px;"></div>
	</div>
	
	<script type="text/javascript">
		var myDelegate = {
				addEntryComplete : function (addedEntry)
				{
					var entryId = addedEntry[0].id;
					var thumbnailUrl = 'http://<?php echo $cdnHost ?>/p/<?php echo $pid ?>/sp/<?php echo $spid ?>/thumbnail/entry_id/' + entryId + '/width/120/height/90';
					writeToLog ('your newly created entry id is: ' + entryId + 
							'<br />You can access the new entry at:' + 
							'<input type="text" style="width:300px;" value="' +
							'http://<?php echo $host ?>/api_v3/index.php/clientTag/krecord+sample+page/service/baseEntry/action/get/ks/<?php echo $ks ?>/entryId/' + entryId + '" />' + 
							'<br />new entry thumbnail: <img src="' + thumbnailUrl + '" />', false);
				},
				
				addEntryFail : function (err)
				{
					writeToLog ('failed to add entry:\n' + err[0], true);
				},
				
				previewEnd : function ()
				{
					writeToLog ('preview finished', false);
				},
				
				previewStarted : function ()
				{
					writeToLog ('preview started', false);
				},
			
				recordStart : function ()
				{
					writeToLog ('started sending recorded camera stream to server.', false);
				},
				
				recordComplete : function ()
				{
					writeToLog ('finished sending recorded camera stream to server.', false);
				},
				
				connected : function ()
				{
					writeToLog ('connected to server.', false);
				},
				
				deviceDetected : function ()
				{
					writeToLog ('found recording devices on user computer.', false);
				},
				
				errorCamera : function ()
				{
					writeToLog ('failed to find active camera on user computer.', false);
				},
				
				errorMicrophone : function ()
				{
					writeToLog ('failed to find active microphone on user computer.', false);
				},
				
		}
	</script>
	
	<script type="text/javascript">
	    if (swfobject.hasFlashPlayerVersion("9.0.0")) {
	    	var movieUrl = "http://<?php echo($host); ?>/krecord/ui_conf_id/<?php echo($uiconfId); ?>";
	      	var fn = function() {
		        var id = "krecorder";
		        var att = { name:"krecorder",
							data:movieUrl, 
							width:"<?php echo($recorder_width); ?>", 
							height:"<?php echo($recorder_height); ?>",
							wmode:"opaque"
						};
		        var par = { flashvars:
								"pid=<?php echo($pid); ?>" +
								"&ks=<?php echo($ks); ?>" +
								"&autoPreview=false" +
								"&delegate=myDelegate" +
			        			"&host=<?php echo($host); ?>",
			        			// add here any othe flashvars
							allowScriptAccess:"always",
							allowfullscreen:"true",
							bgcolor:"<?php echo($backgroundColor); ?>",
							wmode:"opaque"
						};
		        var myObject = swfobject.createSWF(att, par, id);
	      	};
	      swfobject.addDomLoadEvent(fn);
	    }
    </script>
	<script type="text/javascript">
		var apptime = 0;
		var d = new Date();
		apptime = d.getTime();

		function writeToLog (msg, isError) 
		{
			$('#currentStatus').html(msg);
			if (isError == true)
				$('#currentStatus').css("color","red");
			else
				$('#currentStatus').css("color","blue");
			var d = new Date();
			var t = d.getTime() - apptime;
			$('#statusLog').append(t + ' :: ' + msg + '<br />');
		}
		
		function setCameraQuality ()
		{
			var vidQ = $('#quality').val();
			var vidBW = $('#bandwidth').val();
			var vidW = $('#videoWidth').val();
			var vidH = $('#videoHeight').val();
			var vidFPS = $('#videoFPS').val();
			$('#krecorder').get(0).setQuality (vidQ, vidBW, vidW, vidH, vidFPS);
		}

	</script>
</body>
</html>
