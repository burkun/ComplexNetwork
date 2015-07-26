package helper
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	import spark.components.Button;
	
	public class OpenFileBunding
	{
		private var _btn:Button;
		private var _fun:Function;
		private var _fr:FileReference;
		private var _ff:FileFilter;
		private var _hasBtnEvent:Boolean = false;
		public function OpenFileBunding(btn:Button,ff:FileFilter,readOverFun:Function)
		{
			_btn = btn;
			_fun = readOverFun;
			_ff = ff;
			_btn.addEventListener(MouseEvent.CLICK,onBtnClick);
			_hasBtnEvent = true;
		}
		
		public function removeBtnEvent():void{
			if(_hasBtnEvent){
				_btn.removeEventListener(MouseEvent.CLICK,onBtnClick);
				_hasBtnEvent = false;
			}
		}
		protected function onBtnClick(event:Event):void{
			var btn:Button = event.target as Button;
			btn.label = "Computing, please wait...."
			btn.enabled = false;
			_fr = new FileReference();
			_fr.addEventListener(Event.SELECT,onFileSelect);
			_fr.addEventListener(Event.CANCEL,onCancel);
			_fr.browse([_ff]);	
		}
		protected function onCancel(event:Event):void{
			_fr.removeEventListener(Event.SELECT,onFileSelect);
			_fr.removeEventListener(Event.CANCEL,onCancel);
			trace("File read canceled!");
			_fr = null;
		}
		protected function onLoadComplete(event:Event):void{
			_fr.removeEventListener(Event.SELECT,onFileSelect);
			_fr.removeEventListener(Event.CANCEL,onCancel);
			_fr.removeEventListener(Event.COMPLETE, onLoadComplete);
			_fr.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			trace("file read over!");
			if(_fun!=null){
				_fun(_fr.data);
			}
			_fr = null;
		}
		
		protected function onLoadError(event:Event):void{
			_fr.removeEventListener(Event.SELECT,onFileSelect);
			_fr.removeEventListener(Event.CANCEL,onCancel);
			_fr.removeEventListener(Event.COMPLETE, onLoadComplete);
			_fr.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			_fr = null;
			trace("IO出错");
		}
		protected function onFileSelect(event:Event):void{
			//listen for when the file has loaded
			_fr.addEventListener(Event.COMPLETE, onLoadComplete);
			//listen for any errors reading the file
			_fr.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			//load the content of the file
			_fr.load();
		}
	}
}