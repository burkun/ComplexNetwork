package helper
{
	
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	

	public class LayoutGenerater
	{
		//对point布局，对线布局
		public function LayoutGenerater()
		{
		}
		public static function genPointLayout(p:helper.Point,attrs:Object):void{
			applyAttr(p,attrs);
		}
		
		private static function applyAttr(comp:UIComponent,attrs:Object):void{
			for(var i:String in attrs){
				comp[i] = attrs[i];
			}
		}
		//将point和线连起来
		public static function bundingPointsLine(p1:helper.Point,p2:helper.Point,line:SuperLine):void{
			line.setTwoPoints(p1,p2);
			p1.lines.push(line);
			p2.lines.push(line);
		}
		public static function unBundingPointsLine(p1:helper.Point,p2:helper.Point,line:SuperLine):void{
			line.setTwoPoints(null,null);
			var index:int = p1.lines.indexOf(line);
			if(index!=-1){
				p1.lines.splice(index);
			}
			p1.lines.splice(index,1);
			index = p2.lines.indexOf(line);
			if(index!=-1){
				p2.lines.splice(index,1);
			}
		}
		
		private static function calcPointSize(dataSet:DataSet):Array{
			var len:uint = dataSet.itemNumber,i:uint=0;
			var res:Array = new Array();
			for(i=0;i<len;i++){
				var ndegree:Number = dataSet.normallizedDegree[i];
				res[i] = Global.POINTSIZE_BASE*(1+ndegree*50);
			}
			return res;
		}
		//获取各个子图的周长
		private static function calcPerimeter(dataSet:DataSet,pointsSize:Array):Array{
			var subG:Array = dataSet.subGraph;
			var periArr:Array = new Array(subG.length);
			var len:uint = subG.length,i:uint=0,j:uint=0;
			for(i=0;i<len;i++){
				var sum:Number = 0;
				var len1:uint = subG[i].length;
				for(j=0;j<len1;j++){
					var k:uint = dataSet.inverseHeader[subG[i][j]];
					sum+=pointsSize[k];
				}
				sum += len1*Global.POINT_GAP; //加上间隙
				periArr[i] = sum;
			}
			return periArr;//获取周长
		}
		//获取半径
		private static function getCircleCenter(x:Number,y:Number,p:Number):flash.geom.Point{
			var r:Number = getRadius(p);
			return new flash.geom.Point(x+r,y+r);
		}
		//计算半径,输入的是周长
		private static function getRadius(p:Number):Number{
			return p/(2*Math.PI);
		}
		//计算弧度对应的角度值
		private static function getAngle(l:Number,r:Number):Number{
			return l/r;
		}
		private static function getPointByIndex(index:uint,points:Array):helper.Point{
			for(var i:uint=0;i<points.length;i++){
				var p:helper.Point = points[i] as helper.Point;
				if(p!=null&&p.dataIndex==index){
					return p;
				}
			}
			return null;
		}
		//对所有点进行度排序
		private static function sortNodeByDegree(nodes:Array,dataSet:DataSet):void{
			var i:uint = 0,j:uint,ki:uint,kj:uint;
			var degree:Array = new Array();
			for(i=0;i<nodes.length;i++){
				ki = dataSet.inverseHeader[nodes[i]];
				degree[i] = dataSet.degree[ki];
			}
			for(i=0;i<nodes.length-1;i++){
				for(j=i+1;j<nodes.length;j++){
					if(degree[i]<degree[j]){
						var temp1:Number = degree[i];
						degree[i] = degree[j];
						degree[j] = temp1;
						temp1 = nodes[i];
						nodes[i] = nodes[j];
						nodes[j] = temp1;
					}
				}
			}
		}
		private static function getColor(index:uint,totalNum:uint=50,beginColor:uint=Global.BEGINCOLOR,endColor:uint=Global.ENDCOLOR):uint{
			var rs:uint = beginColor>>16;
			var gs:uint = beginColor>>8&0xff;
			var bs:uint = beginColor&0xff;
			var re:uint = endColor>>16;
			var ge:uint = endColor>>8&0xff;
			var be:uint = endColor&0xff;
			var rn:uint = 0,gn:uint= 0,bn:uint = 0;
			rn = rs +(re-rs)*index/totalNum;
			gn = gs +(ge-gs)*index/totalNum;
			bn = bs +(be-bs)*index/totalNum;
			var color:uint = (rn<<16|gn<<8|bn);
			return color;
		}
		//偏移量x,y
		public static function layoutPoints(x:Number,y:Number,arryPoints:Array,dataSet:DataSet):void{
			var subG:Array = dataSet.subGraph;
			var len:uint = subG.length,i:uint=0,j:uint=0;
			var ox:uint = x,oy:uint = y;
			var pSize:Array = calcPointSize(dataSet);
			var perimeter:Array = calcPerimeter(dataSet,pSize);
			var preL:Number = 0;
			for(i=0;i<len;i++){
				var sum:Number = 0;
				var len1:uint = subG[i].length;
				var radius:Number = getRadius(perimeter[i]);//得到半径
				radius = radius<20?80:radius;//不能过小
				var centerX:Number = radius + ox;
				var centerY:Number = radius + oy;
				sortNodeByDegree(subG[i],dataSet);//从大到小画圈
				for(j=0;j<len1;j++){
					var k:uint = dataSet.inverseHeader[subG[i][j]];
					preL += pSize[k]/2;
					//对于每个点	，算弧长
					var p:helper.Point = getPointByIndex(k,arryPoints);
					var angle:Number = getAngle(preL,radius);
					var xxx:Number = centerX + Math.cos(angle)*radius;
					var yyy:Number = centerY + Math.sin(angle)*radius;
					p.realX = xxx;
					p.realY = yyy;
					p.pointSize = pSize[k];
					p.fillColor = getColor(j,len1);
					p.alginMentIndex = j;
					preL +=  (Global.POINT_GAP+pSize[k]/2);
				}
				ox+=centerX+radius+Global.SUBGRAPH_GAP;//oy 不变
			}	
		}
	}
}