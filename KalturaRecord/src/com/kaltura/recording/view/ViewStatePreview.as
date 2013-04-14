package com.kaltura.recording.view {

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;


	/**
	 * co-ordinates the different preview components 
	 */
	public class ViewStatePreview extends ViewState {

		static private const MARGIN_BOTTOM:Number = 11;

		/**
		 * the preview player's controls
		 */
		public var player:PreviewPlayer = new PreviewPlayer(Global.THEME.getSkinById("previewPlayer"));

		/**
		 * messages dialog component
		 */
		public var popupDialog:PopupDialog = new PopupDialog(Global.THEME.getSkinById("popupDialog"));

		/**
		 * timer that shows preview progress
		 */
		public var previewTimer:PreviewTimer;


		public function ViewStatePreview() {
			addChild(player);
			addChild(popupDialog);

			// only add preview timer if required
			if (Global.SHOW_PREVIEW_TIMER && Global.THEME.getSkinById("playerTimer")) {
				previewTimer = new PreviewTimer(Global.THEME.getSkinById("playerTimer"));
				addChild(previewTimer);
				previewTimer.visible = false;
				player.addEventListener(PreviewPlayer.PREVIEW_UPDATE_PLAYHEAD, onUpdatePlayhead);
			}
			player.addEventListener(PreviewPlayer.PREVIEW_DONE, hideTimer);
			player.addEventListener(PreviewPlayer.PREVIEW_STOPPED, hideTimer);
		}


		protected function hideTimer(evt:Event = null):void {
			if (previewTimer)
				previewTimer.visible = false;
		}


		/**
		 * show new value on preview timer 
		 * @param evt
		 */
		protected function onUpdatePlayhead(evt:Event = null):void {
			if (!previewTimer.visible) {
				previewTimer.visible = true;
			}
			previewTimer.timer.text = player.playheadTime;
		}


		override protected function onAddedToStage(evt:Event = null):void {
			popupDialog.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
			popupDialog.message = Global.LOCALE.getString("Dialog.Overwrite");
			popupDialog.visible = false;

			player.addEventListener(MouseEvent.CLICK, onMouseClick, false, 0, true);
			player.buttonSave.label = Global.LOCALE.getString("Button.Save");
		}


		override public function open():void {
			if (previewTimer)
				previewTimer.visible = false;
			super.open();
		}


		private function onMouseClick(evt:MouseEvent):void {
			if (evt.target == player.buttonReRecord) {
				player.stop();
				player.mouseChildren = false;
				player.mouseEnabled = false;
				popupDialog.visible = true;
			}
			else if (evt.target == popupDialog.buttonYes) {
				dispatchEvent(new ViewEvent(ViewEvent.PREVIEW_RERECORD, true));
			}
			else if (evt.target == player.buttonSave) {
				player.stop();
				dispatchEvent(new ViewEvent(ViewEvent.PREVIEW_SAVE, true));
			}

			if (evt.target == popupDialog.buttonYes || evt.target == popupDialog.buttonNo) {
				player.mouseChildren = true;
				player.mouseEnabled = true;
				popupDialog.visible = false;
			}
		}


		override protected function onResize():void {
			player.x = Math.round(this.width / 2);
			player.y = Math.round(this.height - player.height / 2 - MARGIN_BOTTOM);

			popupDialog.x = Math.round(this.width / 2);
			popupDialog.y = Math.round(this.height / 2);
		}


	}
}
