package helper
{

	import spark.filters.ColorMatrixFilter;
	public  class Global
	{
		public function Global()
		{
		}
		
		
		//data type
		public static const  VALUE_YES="y";
		public static const VALUE_NO = "n";
		public static const VALUE_SELF="m";
		
		public static const INFO_BUSY:String = "BUSY.....";
		public static const INFO_READY:String ="Ready!";
		public static const INFO_ERROR:String = "Error!";
		//装数据表
		private static var _sheets:Array = new Array();
		//全局函数，表示程序是否繁忙
		private static var _isBusy:Boolean = false;
		//global info for a hit
		private static var _gInfo:String = "Ready";
		//组件的引用
		private static var _pointsArrs:Array = new Array();
		private static var _linesArrs:Array = new Array();
		//layout
		public static const POINTSIZE_BASE:Number = 16;//px 
		public static const POINT_GAP:Number = POINTSIZE_BASE*0.4;//px
		public static const SUBGRAPH_GAP:Number = 0;
		public static const BEGINCOLOR:uint = 0xff007f;
		public static const ENDCOLOR:uint = 0x7fff00;
		public static function get pointsArrs():Array{
			return _pointsArrs;
		}
			
		public static function get sheets():Array{
			return _sheets;
		}
		public static function set sheets(value:Array):void{
			_sheets = value;
			_pointsArrs.splice(0,_pointsArrs.length);
			_linesArrs.slice(0,_linesArrs.length);
			var i:uint,len:uint = _sheets.length;
			for(i=0;i<len;i++){//初始化数组
				_pointsArrs[i] = new Array();
				_linesArrs[i] = new Array();
			}
		}

		public static function get linesArrs():Array{
			return _linesArrs;
		}
		public static function get isBusy():Boolean{
			return _isBusy;
		}
		public static function set isBusy(busy:Boolean):void{
			_isBusy = isBusy;
			if(_isBusy){
				_gInfo = INFO_BUSY;
			}else{
				if(_gInfo==INFO_BUSY){
					_gInfo = INFO_READY;
				}
			}
		}
		
		public static function set globalInfo(i:String):void{
			_gInfo = i;
		}
		public static function get globalInfo():String{
			return _gInfo;
		}
	}
}