package helper
{

	public class DataSet extends Object implements Cloneable
	{
		//下标从1开始
		public function DataSet(header:Array,data:Array,name:String)
		{
			super();
			_header = header;
			_data = data;
			_name = name;
			calcRowCol();
			_calculater = new Calculation(this);
		}
		private var _name:String = "";
		private var _header:Array = new Array();
		private var _data:Array = new Array();
		private var _col:int = 0;
		private var _row:int = 0;
		private var _degree:Array = new Array();
		private var _coreness:Array = new Array();
		private var _clusCoeffi:Array = new Array();
		private var _calculater:Calculation;
		private var _totalClusCoeffi:Number = 0;
		private var _avgShortPathLen:Array = new Array();
		private var _nodeShortPathLen:Array = new Array();
		private var _subGraph:Array = new Array();
		private var _inverseHeader:Array = new Array();//注意这个大小不能作为参考，只能用[]来取。
		private var _normallizedDegree:Array = new Array();
		private var _maxDegreeMinDegree:Array = new Array(2);
		private var _graphCoreness:uint;
		
		
		
		
		private function intiInverseHeader():void{
			for(var i:uint;i<itemNumber;i++){
				_inverseHeader[_header[i]]=i;
			}
		}
		
		private function calcRowCol():void{
			_row = _data.length;
			_col = _data[0].length;
		}
		
		public function get graphCoreness():uint{
			if(!_calculater.calcCoreness()){
				_calculater.calcCoreness();
			}
			return _graphCoreness
		}
		public function get name():String{
			return _name;
		}
		public function get maxminDegree():Array{
			if(!_calculater.isCalcDegree){
				_calculater.calcDegree();
			}
			return _maxDegreeMinDegree;
		}
		public function get calculater():Calculation{
			return _calculater;
		}
		
		//不能使用.length获取下标！
		public function get inverseHeader():Array{
			if(_inverseHeader.length==0){
				intiInverseHeader();
			}
			return _inverseHeader;
		}
		public function get coreness():Array{
			if(!_calculater.isCalcCoreness){
				//只计算一次
				_calculater.calcCoreness();
			}
			return _coreness;
		}
		public function get degree():Array{
			if(_calculater.isCalcDegree){
				return _degree;
			}else{
				_calculater.calcDegree();
				return _degree;
			}
		}
		//获取到子图
		public function get subGraph():Array{
			if(!_calculater.isCalcSubGraph){
				_calculater.caluSubGraph();
			}
			return _subGraph;
		}
		//获取最短平均
		public function get avgSPL():Array{
			if(!_calculater.isCalcSPL){
				_calculater.calcAvgPathLen();
			}
			return _avgShortPathLen;
		}
		public function get nodeAvgSPL():Array{
			if(!_calculater.isCalcSPL){
				_calculater.calcAvgPathLen();
			}
			return _nodeShortPathLen;
		}
		
		public function get normallizedDegree():Array{
			if(!_calculater.isCalcNomallizedDegree){
				_calculater.calcNormallizedDegree();
			}
			return _normallizedDegree;
		}
		public function get totalCoeffi():Number{
			if(!_calculater.isCalcCoeffi){
				var coeff:* = this.coeffi;
			}
			return _totalClusCoeffi;
		}
		
		public function get coeffi():Array{
			if(!_calculater.isCalcCoeffi){
				_calculater.calcClusCoeffi();
				var sum:Number = 0;
				for(var i:uint;i<itemNumber;i++){
					sum+=_clusCoeffi[i];
				}
				_totalClusCoeffi = sum/itemNumber;
			}
			return _clusCoeffi;
		}

		//一维，把所有子图全部保存
		public function _setCalclator(value:Calculation):void{
			_calculater = value;
		}
		
		public function _setNormalliedDegree(index:uint,value:Number):void{
			_normallizedDegree[index]=value;
		}
		public function _setMaxCoreness(value:uint):void{
			_graphCoreness = value;
		}
		public function _setMaxMinDegree(max:uint,min:uint):void{
			_maxDegreeMinDegree[0] = max;
			_maxDegreeMinDegree[1] = min;
		}
		public function _setNodeSPL(index:uint,value:Number):void{
			_nodeShortPathLen[index] =value;
		}
		public function _setAvgSPL(index:uint,value:Number):void{
			_avgShortPathLen[index] = value;
		}
		public function _setSubGraphs(value:Array):void{
			_subGraph = value;
		}
		public function _setCoreness(i:int,value:int):void{
			_coreness[i] = value;
		}
		public function _setDegree(i:int,value:int):void{
			_degree[i] = value;
		}
		public function _setClusCoeffi(i:int,value:Number):void{
			_clusCoeffi[i] = value
		}
		
		
		
		public function get itemNumber():int{
				return _data.length;
		}
		
		public function get data():Array{
			return _data;
		}
		
		public function get col():int{
			return _col;
		} 

		public function get row():int{
			return _row;
		} 
		
		public function get header():Array{
			return _header;
		}
		public function toString():String{
			var  i:int,j:int;
			var res:String = "";
			for(i=0;i<_col;i++){
				res+=(_header[i]+" ");
			}
			res+="\n";
			for(i=0;i<_row;i++){
				for(j=0;j<_col;j++){
					res+=(_data[i][j]+" ");
				}
				res+="\n";
			}
			return res;
		}
		
		public function clone():Cloneable
		{
			var _theader:Array =Util.lowerCloneArray1(_header);
			var _tdata:Array =Util.lowerCloneArray2(_data);
			return new DataSet(_theader,_tdata,name+"_clone");

		}
		
	}
}