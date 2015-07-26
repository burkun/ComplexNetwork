package helper
{
	

	public class Util
	{
		public function Util()
		{
		}
		//替换空格
		public static function strTrim(myString:String):String{
			if(myString.indexOf(" ")==-1 && myString.indexOf("　")==-1){  //如果字符串内没有空格直接返回 
				return myString; 
			} 
			var omyString:String=myString; //把原始字符串保存下来 
			myString=replace(myString,"　"," "); //把全角空格替换成普通空格，方便处理 
			
			var lblanknum:Number=0;//开始位置的空格数量 
			var rblanknum:Number=0;//结束位置的空格数量 
			
			//计算开始位置的空格数量 
			var i:int;
			for(i=0;i<myString.length;i++){ 
				if(myString.charAt(i)!=" "){ 
					break; 
				}else{ 
					lblanknum++; 
				}
			}  
			//计算结束位置的空格数量 
			for(i=(myString.length-1);i>0;i--){ 
				if(myString.charAt(i)!=" "){ 
					break; 
				}else{ 
					rblanknum++; 
				} 
			}  
			return omyString.substring(lblanknum,(omyString.length-rblanknum)); 
		} 
		
		public static function replace(s:String,o:String,n:String):String{ //字符替换函数 把s中o替换成n 
			return s=s.split(o).join(n); 
		}
		
		//---clone array
		public static function lowerCloneArray1(source:Array):Array{
			return source.slice();
		}
		public static function lowerCloneArray2(source:Array):Array{
			var len:uint = source.length;
			var clone:Array = new Array();
			for(var i:uint=0;i<len;i++){
				clone[i] = lowerCloneArray1(source[i]);
			}
			return clone;
		}
		public static function depCloneArray(source:Array):Array{
			var clone:Array = new Array();
			for(var i:*=0;i<source.length;i++){
				if(source[i] is Array){
					//递归
					clone[i] = depCloneArray(clone[i]);
				}else{
					if(source[i] is Cloneable){
						clone[i] = (source[i] as Cloneable).clone();
					}
				}
			}
			return clone;
		}
		public static function getPointByDataIndex(index:uint,pointsArr:Array):Point{
			var len:uint = pointsArr.length;
			for(var i:uint=0;i<len;i++){
				var p:Point = pointsArr[i] as Point;
				if(p.dataIndex == index){
					return p;
				}
			}
			return null;
		}
		
		public static function getAngle(p1:helper.Point,p2:helper.Point):Number{
			var dx:Number = p1.realX-p2.realX;
			var dy:Number = p1.realY-p2.realY;
			if(Math.abs(dx)<0.0001){
				if(dy<0){
					return -90;
				}else{
					return 90;
				}
			}else{
				var angle:Number =(Math.atan(dy/dx)*180/Math.PI)+90;
				if(dy>0){
					return -angle;
				}else{
					return angle;
				}
			}
		}
	}
}