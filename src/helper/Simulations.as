package helper
{
	
	import mx.collections.ArrayCollection;
	//import mx.collections.Sort;
	//import mx.collections.SortField;

	public class Simulations
	{
		private var _originalData:DataSet;
		private var _newData:DataSet;
		//private var _degreeDic:ArrayCollection = new ArrayCollection();
		private var _removeNodeFlags:Array = new Array();
		private var _randomAttackDic:ArrayCollection = new ArrayCollection();
		private var _intentionalAttackDic:ArrayCollection = new ArrayCollection();
		
		
		public function Simulations(data:DataSet)
		{
			_originalData = data;
			
		}

		private function init():void{
			_newData = _originalData.clone() as DataSet;
			_newData._setCalclator(new SimulationCalculation(_newData));//设置一个新的calculation
			var i:uint=0;
			for(i=0;i<_newData.itemNumber;i++){
				//_degreeDic.addItem({index:i,degree:_newData.degree[i],nodeName:_newData.header[i]});
				_removeNodeFlags[i] = false;
			}
			//sortCollection(_degreeDic);
		}
		
		/*private function sortCollection(coll:ArrayCollection){
			var sort:Sort = new Sort();
			sort.fields=[new SortField["degree"]];
			coll.sort = sort;
			coll.refresh();
		}*/
		
		private function removeNode(index:uint):void{
			if(!_removeNodeFlags[index]){
				for(var i:uint=0;i<_newData.itemNumber;i++){
					_newData.data[index][i] = 0;
					_newData.data[i][index] = 0;
				}
				_removeNodeFlags[index] = true;
			}
		}
		
		private function getMaxDegreeNodeIndex():int{
			var i:int =0;
			var maxIndex:int = -1;
			var maxNum:Number = -1;
			for(i=0;i<_newData.itemNumber;i++){
				if(_removeNodeFlags[i]==false&&_newData.degree[i]>maxNum){
					maxIndex = i;
					maxNum = _newData.degree[i];
				}
			}
			return maxIndex;
		}
		
		private function radomNumber(Total:uint,Current:uint):Array {
			var CurrentKuArray:Array = [];
			var shu:Array = [];
			for (var i:uint=0; i<Total; i++) {
				shu.push(i);	
			}
			for (i=0; i<Current; i++) {
				var k:uint = Math.floor(Math.random() * shu.length);//从数组shu中随机选一个元素（第k个）
				CurrentKuArray[i] = shu[k];//把数组shu中选出的元素的值赋给数组myArry第i个元素
				shu.splice(k, 1);
			}
			return CurrentKuArray;	
		}
		private function getMaxSubGraphNodeNum(subarr:Array):uint{
			var nodeNum:uint = 0;
			var i:uint = 0,len:uint = subarr.length;
			for(i=0;i<len;i++){
				var subsubArr:Array = subarr[i] as Array;
				if(subsubArr!=null){
					if(nodeNum<subsubArr.length){
						nodeNum = subsubArr.length;
					}
				}
			}
			return nodeNum;
		}
		
		public function ifIntentionalAttack():ArrayCollection{
			init();
			if(_intentionalAttackDic.length==0){
				var nodeNum:uint = _newData.itemNumber;
				while(nodeNum>0){
					var index:int = getMaxDegreeNodeIndex();
					removeNode((uint)(index));
					_newData.calculater.caluSubGraph();//更新
					var maxNum:uint = getMaxSubGraphNodeNum(_newData.subGraph);
					nodeNum=nodeNum-1;
					_intentionalAttackDic.addItem({"S":maxNum/Number(_newData.itemNumber),"f":1-(nodeNum/Number(_newData.itemNumber))})
					setAllFalse();
				}
			}
			return _intentionalAttackDic;
		}
		
		public function setAllFalse():void{
			(_newData.calculater as SimulationCalculation).isCalcSubGraph =false;
			(_newData.calculater as SimulationCalculation).isCalcDegree = false;
			(_newData.calculater as SimulationCalculation).isCalcCoeffi =false;
			(_newData.calculater as SimulationCalculation).isCalcNomallizedDegree = false;
			(_newData.calculater as SimulationCalculation).isCalcSPL =false;
		}
		
		public function ifRandomAttack():ArrayCollection{
			init();
			var randomArr:Array = radomNumber(_newData.itemNumber,_newData.itemNumber);
			if(_randomAttackDic.length==0){
				var nodeNum:uint = _newData.itemNumber;
				while(nodeNum>0){
					var index:int = randomArr[nodeNum-1];
					removeNode((uint)(index));
					_newData.calculater.caluSubGraph();//更新
					var maxNum:uint = getMaxSubGraphNodeNum(_newData.subGraph);
					nodeNum=nodeNum-1;
					_randomAttackDic.addItem({"S":maxNum/Number(_newData.itemNumber),"f":1-(nodeNum/Number(_newData.itemNumber))})
					setAllFalse();
				}
			}
			return _randomAttackDic;
		}
	}
}