package helper
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	
	import spark.components.Button;

	public class SaveFileBunding
	{
		private static const DEFAULT_FILE_NAME:String = "ComPlex_data.csv";
		private var _fun:Function;
		private var _fr:FileReference;
		private var _hasBtnEvent:Boolean = false;
		private var _btn:Button;
		private var _data:*;
		public function SaveFileBunding(btn:Button,onOverFun:Function)
		{
			_btn = btn;
			_fun = onOverFun;
		}
		public function removeBtnEvent():void{
			if(_hasBtnEvent){
				_btn.removeEventListener(MouseEvent.CLICK,onBtnClick);
				_hasBtnEvent = false;
			}
		}
		/**
		 * 不设置data不绑定事件
		 * */
		public function set data(value:*):void{
			_data = value;
			if(!_hasBtnEvent){
				_btn.addEventListener(MouseEvent.CLICK,onBtnClick);
				_hasBtnEvent = true;
			}
		}
		protected function onBtnClick(event:Event):void{
			_fr = new FileReference();
			//listen for the file has been saved
			_fr.addEventListener(Event.COMPLETE, onFileSave);
			//listen for when then cancel out of the save dialog
			_fr.addEventListener(Event.CANCEL,onCancel);
			//listen for any errors that occur while writing the file
			_fr.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			//open a native save file dialog, using the default file name
			_fr.save(_data, DEFAULT_FILE_NAME);
		}
		
		private function onFileSave(e:Event):void
		{
			trace("File Saved");
			_fr = null;
			if(_fun!=null){
				_fun();
			}
		}
		
		//called if the user cancels out of the file save dialog
		private function onCancel(e:Event):void
		{
			trace("File save select canceled.");
			_fr = null;
		}
		
		//called if an error occurs while saving the file
		private function onSaveError(e:IOErrorEvent):void
		{
			trace("Error Saving File : " + e.text);
			_fr = null;
		}

	}
}