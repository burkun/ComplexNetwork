
package helper
{
	import com.as3xls.xls.ExcelFile;
	import com.as3xls.xls.Sheet;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	public class  ExcelReader
	{
		private var doAfterFun:Function;
		public   function ExcelReader()
		{
			
		}
		public   function ReadByFilePath(path:String,fun:Function):void{
			var urlFilePath:URLRequest = new URLRequest(path);
			var loader:URLLoader = new URLLoader(urlFilePath);
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE,loadFileCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			this.doAfterFun = fun;
		}
		public function ReadByBinArray(data:*):void{
			var xls:ExcelFile = new ExcelFile();
			xls.loadFromByteArray(data);
			doDataSeting(xls);
			Global.isBusy = false;
		}
		private function doDataSeting(xls:ExcelFile):void{
			var i:int=0,j:int=0,k:int=0,r:int=0;
			for(i=0;i<xls.sheets.length;i++){
				var header:Array = new Array();
				var data:Array = new Array();
				var sht:Sheet = xls.sheets[i];
				if(sht.cols>0){//一般sheet有三个，等于0表示这个sheet无用
					for(r=1;r<sht.cols;r++){
						var s:String = sht.getCell(0,r).toString()
						if(s!=""){
							header[r-1] = parseInt(sht.getCell(0,r).toString());
						}
					}
					for(j=1;j<sht.rows;j++){
						for(k=j;k<sht.cols;k++){
							var str:String = sht.getCell(j,k).toString();
							if(str!=""){//这个excel 插件有问题，cols 会等于254，如果不做这样的判断的话，就完蛋了
								str = Util.strTrim(str);
								var v:int = 0;
								if(str==Global.VALUE_YES){
									v = 1;
								}
								if(!(data[j-1] is Array)){
									data[j-1] = new Array();
								}
								if(!(data[k-1] is Array)){
									data[k-1] =  new Array();
								}
								data[j-1][k-1] = v;
								data[k-1][j-1] = v;
							}else{
								break;
							}
						}
					}
					var dataset:DataSet = new DataSet(header,data,sht.name);
					Global.sheets[i] = dataset;
				}
			}
			
		}
		protected  function loadFileCompleteHandler(evt:Event):void{
			Global.isBusy = true;
			var loader:URLLoader = (URLLoader)(evt.target);
			var xls:ExcelFile = new ExcelFile();
			xls.loadFromByteArray(loader.data);
			doDataSeting(xls);
			Global.isBusy = false;
			if(doAfterFun!=null){
				doAfterFun();
			}
		}
		protected static function ioErrorHandler(evt:Event):void{
			trace("读取文件错误！");
			Global.globalInfo = Global.INFO_ERROR;
		}
		
	}
}