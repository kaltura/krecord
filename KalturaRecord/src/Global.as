package
{
	
import com.kaltura.KalturaClient;
import com.kaltura.recording.controller.IRecordControl;
import com.kaltura.recording.view.KRecordViewParams;
import com.kaltura.recording.view.Theme;
import com.kaltura.utils.Locale;


public class Global
{

	static public var PRELOADER:PreloaderSkin;
	static public var VIEW_PARAMS:KRecordViewParams;
	static public var THEME:Theme;
	static public var LOCALE:Locale;
	static public var RECORD_CONTROL:IRecordControl;
	static public var KALTURACLIENT:KalturaClient;
	static public var DISABLE_GLOBAL_CLICK:Boolean = false;
	static public var REMOVE_PLAYER:Boolean = false;
	
}
}