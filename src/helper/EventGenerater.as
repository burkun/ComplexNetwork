package helper
{
	import flash.events.MouseEvent;
	
	

	public class EventGenerater
	{
		public function EventGenerater()
		{
		}
		
		public function addNodeEvents(point:Point):void{
			point.addEventListener(MouseEvent.DOUBLE_CLICK,onmouseClick);
		}
		
		private var _hideNodeArr:Array = new Array();
		private var _hideLineArr:Array = new Array();
		private var _isHide:Boolean = false;
		private var _lastNode:Point;
		private function hiddenOtherNodeAndLine(p:Point):void{
			_hideLineArr.splice(0);
			_hideNodeArr.splice(0);
			var i:uint=0;
			var index:uint=p.dataSheetIndex;
			var dataPindex:uint = p.dataIndex;
			for(i=0;i<Global.pointsArrs[index].length;i++){
				var tp:Point = Global.pointsArrs[index][i] as Point;
				var tpIndex:uint = tp.dataIndex;
				if(p.dataSet.data[dataPindex][tpIndex]!=1&&p!=tp){
					_hideNodeArr.push(tp);
					tp.alpha = 0;
					tp.mouseEnabled = false;
				}else{
					tp.alpha = 1;
					tp.mouseEnabled = true;
				}
			}
			for(i=0;i<Global.linesArrs[index].length;i++){
				var line:SuperLine = Global.linesArrs[index][i];
				if(line.point1!=p&&line.point2!=p){
					_hideLineArr.push(line);
					line.alpha = 0;	
				}else{
					line.alpha = 1;
				}
			}
		}
		
		private function showOtherNodeAndLine():void{
			while(_hideLineArr.length!=0){
				var line:SuperLine = _hideLineArr.shift();
				line.alpha=1;
			}
			while(_hideNodeArr.length!=0){
				var node:Point = _hideNodeArr.shift();
				node.alpha = 1;
				node.mouseEnabled = true;
			}
		}
		
		protected function onmouseClick(event:MouseEvent):void{
			if(_lastNode==null){
				_lastNode = event.target as Point;
				hiddenOtherNodeAndLine(_lastNode)
				_isHide = true;
			}else{
				var t:Point = event.target as Point;
				if(t==_lastNode){
					if(_isHide==false){
						hiddenOtherNodeAndLine(_lastNode);
						_isHide = true;
					}else{
						showOtherNodeAndLine();
						_isHide = false;
					}
				}else{
					_lastNode = t;
					_isHide = true;
					hiddenOtherNodeAndLine(_lastNode);
				}
			}
			//filterLineAndNodes(point,true);
		}
	}
}