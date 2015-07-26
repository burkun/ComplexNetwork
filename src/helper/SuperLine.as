package helper
{
	import mx.graphics.GradientEntry;
	import mx.graphics.LinearGradientStroke;
	import mx.graphics.SolidColorStroke;
	
	import spark.primitives.Line;
	
	public class SuperLine extends Line
	{
		
		private var _point1:helper.Point;
		private var _point2:helper.Point;
		
		
		public function SuperLine()
		{
			super();
			initLayout();
		}

		
		public function setTwoPoints(p1:Point,p2:Point):void{
			if(p1.alginMentIndex>p2.alginMentIndex){
				_point1 = p2;
				_point2 = p1;
			}else{
				_point1 = p1;
				_point2 = p2;
			}
			setLine();
		}
		public function get point1():helper.Point{
			return _point1;
		}
		public function get point2():helper.Point{
			return _point2;
		}
		public function  getAnotherPoint(p:helper.Point):helper.Point{
			if(p==_point1){
				return _point2;
			}
			if(p==_point2){
				return _point1;
			}
			return null;
		}
		
		private function setLine():void{
			if(_point1!=null&&_point2!=null){
				this.xFrom = _point1.realX;
				this.yFrom = _point1.realY;
				this.xTo = _point2.realX;
				this.yTo = _point2.realY;
				var stroke:LinearGradientStroke = new LinearGradientStroke(1);
				stroke.rotation = Util.getAngle(_point1,_point2);
				stroke.entries = [new GradientEntry(_point1.fillColor),new GradientEntry(_point2.fillColor)];
				this.stroke = stroke;
			}else{
				this.xFrom = 0;
				this.yFrom = 0;
				this.xTo = 0;
				this.yTo = 0;
			}
		}
		//初始化布局
		private function initLayout():void{
			this.stroke = new SolidColorStroke(0x000000,1);
			this.depth = 0;
		}
	}
}