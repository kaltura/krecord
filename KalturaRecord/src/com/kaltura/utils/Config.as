/**
 * Config.
 * 
 * Notice: Value keys are case sensitive.
 * 
 * @author Dani X Bacon <( Oink )
 * @version 0.2
 */
package com.kaltura.utils {
	
	import flash.utils.Dictionary;
	
	public class Config  {
		
		private var _data:Dictionary;
		//private var isIgnoreCase:Boolean = true;	
		
		function Config(data:XML = null) {
		
			this._data = new Dictionary();
			if (data) load(data);
		
		}
		
		/**
		 * Loads from xml key/value pairs settings into config.
		 * 
		 * Expected xml schema:
		 * <config>
		 *   <setting>
		 *     <key>string</key>
		 *     <value>any value</value>
		 *   </setting>
		 *   <setting>
		 *     <key>string</key>
		 *     <value>any value</value>
		 *   </setting>
		 * </config>
		 * 
		 * Load ignores any tags other than <setting> which are directly under xml root.
		 */
		public function load(data:XML):void {
		
			var count:int = 0;
			
			for each (var setting:XML in data.setting) {
				
				count++;
				var key:String = setting.key;
				if (!key) trace ("XML Format error");
				setKey(key, setting.value);
				
			}
		
		}
		
		public function contains(key:String):Boolean {
		
			return (this._data[key] != undefined);
		
		}
		
		public function get( key:String ):* {
		
			if ( this.contains( key ) )
				return ( this._data[key] );
			else
				trace( "Undefined key:", key ); 
		
		}
		
		public function getBoolean(key:String):Boolean {
			
			var value:String = get( key );
			
			value.toLowerCase();
			if ( value == "true" || value == "yes" || value == "1" ) return true;
			if ( value == "false" || value == "no" || value == "0" ) return false;
			trace( "Value is not a Boolean", key );
			return false;
		}
		
		public function getNumber(key:String):Number {

			if (isNaN(get(key))) trace( "Value is not a Number", key ); 
			var value:Number = Number(get(key));
			return value;

		}
		
		public function getString(key:String):String {
		
			var value:String = String( get( key ) );
			return (value);
		
		}
		
		public function getConfig(key:String):Config {
		
			var value:Config = new Config(get(key));
			return value;
		
		}
		
		public function setKey(key:String, value:*):void {
			
			this._data[key] = value;
			
		}
		
		/*
		public function set ignoreCase(isIgnore:Boolean):void {}
		
		public function get ignoreCase():Boolean {
			
			return new Boolean();
			
		}
		*/
		
		public function toExtendedString():String {
			
			var str:String = new String();
			for (var key:String in this._data) {
			
				str += (key + " = " + this._data[key] + "\n");
			
			}
			return str;
			
		}
		
	}
	
}