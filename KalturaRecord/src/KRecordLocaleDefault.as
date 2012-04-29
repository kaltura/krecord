package
{
	import com.kaltura.utils.Locale;
	

	public class KRecordLocaleDefault extends Locale
	{
		private var _defaults:XML = 
		
		<config>
		
			<setting>
				<key>Button.StopRecord</key>
				<value>Click anywhere to stop recording</value>
			</setting>
		
			<setting>
				<key>Button.StartRecord</key>
				<value>Click anywhere to start recording</value>
			</setting>
		
			<setting>
				<key>Button.Save</key>
				<value>Save</value>
			</setting>

			<setting>
				<key>Button.Yes</key>
				<value>Yes</value>
			</setting>

			<setting>
				<key>Button.No</key>
				<value>No</value>
			</setting>
		
			<setting>
				<key>Dialog.Overwrite</key>
				<value>Record again without saving?</value>
			</setting>
		
			<setting>
				<key>Dialog.Connecting</key>
				<value>Connecting...</value>
			</setting>
		
			<setting>
				<key>Error.ConnectionError</key>
				<value>Connection error. Please try again later</value>
			</setting>
		
			<setting>
				<key>Error.CameraError</key>
				<value>No camera detected</value>
			</setting>
		
		</config>
		
		
		
		public function KRecordLocaleDefault()
		{
			super(_defaults);
		}
		
	}
}