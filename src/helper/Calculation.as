package helper
{
	
	public class Calculation
	{
		protected var _dataSet:DataSet;
		protected var _isCalcDegree:Boolean = false;
		protected var _isCalcCoreness:Boolean = false;
		protected var _isCalcCoeffi:Boolean = false;
		protected var _isCalcSPL:Boolean = false;
		protected var _isCalcSubGraph:Boolean = false;
		protected var _isCalcNormallizedDegree:Boolean = false;
		
		public function get isCalcDegree():Boolean{
			return _isCalcDegree;
		}
		public function get isCalcCoreness():Boolean{
			return _isCalcCoreness;
		}
		public function get isCalcCoeffi():Boolean{
			return _isCalcCoeffi;
		}
		public function get isCalcSPL():Boolean{
			return _isCalcSPL;
		}
		public function get isCalcSubGraph():Boolean{
			return _isCalcSubGraph;
		}
		public function get isCalcNomallizedDegree():Boolean{
			return _isCalcNormallizedDegree;
		}
		//构造函数
		public function Calculation(dataset:DataSet)
		{
			_dataSet = dataset;
		}
		
		
		//------------------------------------------------
		public function calcDegree():void{
			var i:uint=0,j:uint=0;
			var sum:int = 0;
			var min:uint=uint.MAX_VALUE;
			var max:uint = uint.MIN_VALUE;
			for(i=0;i<_dataSet.row;i++){
				sum=0;
				for(j=0;j<_dataSet.col;j++){
					sum+=_dataSet.data[i][j];
				}
				_dataSet._setDegree(i,sum);
				if(max<sum){
					max = sum;
				}
				if(min>sum){
					min = sum;
				}
			}
			_dataSet._setMaxMinDegree(max,min);
			_isCalcDegree = true;
		}
		public function calcNormallizedDegree():void{
			var i:uint=0;
			var sum:Number = 0;
			for(i=0;i<_dataSet.itemNumber;i++){
				sum += _dataSet.degree[i];
			}
			for(i=0;i<_dataSet.itemNumber;i++){
				_dataSet._setNormalliedDegree(i,_dataSet.degree[i]/sum);
			}
			_isCalcNormallizedDegree  = true;
		}
		//-----------------------------------------------
		////返回最小度节点的索引
		private function findMinDegree(d:Array,f:Array):int{
			var i:uint = 0;
			var index:int = -1;
			var minValue:int;
			for(i=0;i<f.length;i++){
				if(f[i]==false){
					minValue = d[i];
					index = i;
					break;
				}
			}//找到一个未标记的node
			for(;i<d.length;i++){
				if(minValue>d[i]&&f[i]==false){
					minValue = d[i];
					index = i;
				}
			}
			return index;
		}
		//判断是否是所有点都用了
		private function isAllNodeDegreeChoosed(f:Array):Boolean{
			for(var i:uint=0;i<f.length;i++){
				if(f[i]==false){
					return false;
				}
			}
			return true;
		}
		//返回是0的度的节点的索引,de表示小于等于当前coreness(de)
		private function findLessDegree(degree:Array,f:Array,coreness:int):Array{
			var lessArray:Array = new Array();
			for(var i:uint=0;i<degree.length;i++){
				if(degree[i]<=coreness&&f[i]==false){
					lessArray.push(i);
				}
			}
			return lessArray;
		}
		private function removeNode(data:Array,degrees:Array,index:uint):void{
			var dataiLen:uint = data.length;
			var datajLen:uint = data[0].length;
			var j:uint = 0;
			for(j=0;j<datajLen;j++){
				if(data[index][j]==1){
					data[index][j] = 0;
					//degrees[index]-=1; //也可以不减1，直接赋值为0
					data[j][index] = 0;
					degrees[j] -=1;
				}
			}
			degrees[index] = 0;
		}
		public function calcCoreness():void{
			var degree:Array = Util.lowerCloneArray1(_dataSet.degree);
			var data:Array = Util.lowerCloneArray2(_dataSet.data);
			var flags:Array = new Array(degree.length);
			var i:uint = 0;
			for(i=0;i<flags.length;i++){
				flags[i] = false;//init
			}
			var maxCoreness:Number = 0;
			var currentCoreness:int = 0;
			while(!isAllNodeDegreeChoosed(flags)){
				var minDegreeIndex:int = findMinDegree(degree,flags);
				if(minDegreeIndex!=-1){
					currentCoreness = degree[minDegreeIndex]; //找到当前coreness
					if(currentCoreness>maxCoreness){
						maxCoreness = currentCoreness;
					}
					removeNode(data,degree,minDegreeIndex);
					flags[minDegreeIndex] = true;//表示已经移除
					_dataSet._setCoreness(minDegreeIndex,currentCoreness);
					//寻找由这个行为而导致出现的新的或者老的小于等于coreness的节点
					var lessArray:Array;
					//如果degree中存在已知的，比coreness小或者等于的，那就继续找
					while((lessArray=findLessDegree(degree,flags,currentCoreness)).length>0){
						var lenLess:uint = lessArray.length;
						var k:uint = 0;
						for(;k<lenLess;k++){
							removeNode(data,degree,lessArray[k]);
							flags[lessArray[k]] = true;//表示已经移除
							_dataSet._setCoreness(lessArray[k],currentCoreness);
						}
					}
				}
			}
			_dataSet._setMaxCoreness(maxCoreness);
			_isCalcCoreness = true;
		}
		//-------------------------------------------------------------------
		//计算邻居们的连接的边数
		private function calcNeighborEdges(data:Array,neigh:Array):Number{
			var len:uint = neigh.length,i:uint,j:uint;
			var count:Number = 0.0;
			for(i=0;i<len;i++){
				for(j=i+1;j<len;j++){
					if(data[neigh[i]][neigh[j]]==1){
						count+=1;
					}
				}
			}
			return count;
		}
		
		public function calcClusCoeffi():void{
			var i:uint,j:uint,len:uint=_dataSet.itemNumber;
			var tneigh:Array;
			for(i=0;i<len;i++){
				tneigh = new Array();
				for(j=0;j<len;j++){
					if(_dataSet.data[i][j]==1){
						tneigh.push(j);
					}
				}
				var lower:Number = tneigh.length*(tneigh.length-1)/2;
				if(lower!=0){
					var uper:Number=calcNeighborEdges(_dataSet.data,tneigh);
					_dataSet._setClusCoeffi(i,uper/lower);
				}else{
					_dataSet._setClusCoeffi(i,0);
				}
			}
			_isCalcCoeffi = true;
		}//
		//------------------------------------------------
		//计算离群点，就是不连通的图
		private function getNextNode(f:Array):int{
			var i:uint =  0;
			for(i=0;i<f.length;i++){
				if(f[i]==false){
					return i;
					break;
				}
			}
			return -1;
		}
		private function getUnconntectedNode(flags:Array,suba:Array,nodeIndex:uint):void{
			var j:uint;
			if(flags[nodeIndex]==false){
				suba.push(_dataSet.header[nodeIndex]);
				flags[nodeIndex] = true;
			}
			for(j=0;j<_dataSet.itemNumber;j++){
				if(_dataSet.data[nodeIndex][j]==1&&flags[j]==false){
					suba.push(_dataSet.header[j]);
					flags[j] = true;
					getUnconntectedNode(flags,suba,j);
				}
			}
		}
		public function caluSubGraph():void{
			var flags:Array = new Array(),i:uint;
			for(i=0;i<_dataSet.itemNumber;i++){
				flags[i] = false;//init
			}
			var subArray:Array = new Array();
			var index:int = 0;
			while((index = getNextNode(flags))!=-1){
				var subsubArray:Array = new Array();
				getUnconntectedNode(flags,subsubArray,index);
				if(subsubArray.length!=0){
					subsubArray.sort(function(a:uint,b:uint):int{
						if(a<b){
							return 1;
						}else if(a>b){
							return -1;
						}else{
							return 0;
						}
					},16);
					subArray.push(subsubArray);
				}
			}
			_dataSet._setSubGraphs(subArray);
			_isCalcSubGraph = true;
		}
		//------------------------------------------------
		private function calcDisMatrix():Array{
			var dis:Array = new Array(),i:uint,j:uint,k:uint;
			for(i=0;i<_dataSet.itemNumber;i++){
				if(!(dis[i] is Array)){
					dis[i] = new Array();
				}
				for(j=0;j<_dataSet.itemNumber;j++){
					if(_dataSet.data[i][j]==1){
						dis[i][j] = 1;
					}else{
						dis[i][j] = int.MAX_VALUE;
					}
				}
			}
			for(k=0;k<_dataSet.itemNumber;k++){
				for(i=0;i<_dataSet.itemNumber;i++){
					for(j=0;j<_dataSet.itemNumber;j++){
						var tem:Number = dis[i][k]+dis[k][j];
						dis[i][j] = dis[i][j]>tem?tem:dis[i][j];
					}
				}
			}
			return dis;
		}
		public function calcAvgPathLen():void{
			//使用Floyd-Warshall算法
			var dis:Array = calcDisMatrix();
			var subG:Array = _dataSet.subGraph;
			var i:uint = 0,j:uint=0,k:uint=0;
			for(i=0;i<subG.length;i++){
				//对每个子图来计算
				var len:uint = (subG[i] as Array).length;
				var lower:Number = len*(len-1);
				var sum:Number = 0;
				for(j=0;j<len;j++){
					var sum1:Number = 0;
					var indexj:uint = _dataSet.inverseHeader[subG[i][j]];
					var indexk:uint;
					for(k=0;k<j;k++){
						indexk = _dataSet.inverseHeader[subG[i][k]];
						sum1+=dis[indexj][indexk];
					}
					for(k=j+1;k<len;k++){
						indexk = _dataSet.inverseHeader[subG[i][k]];
						sum1+=dis[indexj][indexk];
						sum+=dis[indexj][indexk];
					}
					_dataSet._setNodeSPL(indexj,sum1/(len-1));//每个点的平均最短路径
				}
				if(len<=1){
					_dataSet._setAvgSPL(i,0);
					
				}else{
					_dataSet._setAvgSPL(i,sum*2/lower);
				}
			}
			_isCalcSPL = true;
		}
	}
}