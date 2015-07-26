package helper
{

	public class ElementGenerater
	{
		public function ElementGenerater()
		{
		}
		//index 表示global[i]存储的一堆线和点
		public static function generNode(index:uint,dataSet:DataSet):void{
			var psarr:Array = new Array();
			var len:uint = dataSet.itemNumber;
			var eventGen:EventGenerater = new EventGenerater();
			for(var i:uint=0;i<len;i++){
				var p:helper.Point = new helper.Point();
				p.dataSet = dataSet;
				p.dataIndex = i;
				p.label = dataSet.header[i].toString();
				p.dataSheetIndex = index;
				eventGen.addNodeEvents(p);
				psarr[i] = p;
			}
			LayoutGenerater.layoutPoints(0,0,psarr,dataSet);
			Global.pointsArrs[index] = psarr;
			var j:uint,lineArr:Array = new Array();
			for(i=0;i<dataSet.itemNumber;i++){
				for(j=i+1;j<dataSet.itemNumber;j++){
					if(dataSet.data[i][j]==1){
						var pi:helper.Point = Util.getPointByDataIndex(i,psarr);
						var pj:helper.Point = Util.getPointByDataIndex(j,psarr);
						var line:SuperLine = new SuperLine();
						lineArr.push(line);
						//Global.linesArrs[0][.push(line);
						LayoutGenerater.bundingPointsLine(pi,pj,line);
					}
				}
			}
			Global.linesArrs[index] = lineArr;
		} 
		
	}
}