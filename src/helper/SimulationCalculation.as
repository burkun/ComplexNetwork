package helper
{
	public class SimulationCalculation extends Calculation
	{
		public function SimulationCalculation(dataset:DataSet)
		{
			super(dataset);
		}
		
		public function set isCalcDegree(value:Boolean):void{
			 _isCalcDegree = value;
		}
		public function set isCalcCoreness(value:Boolean):void{
			_isCalcCoreness = value;
		}
		public function set isCalcCoeffi(value:Boolean):void{
			_isCalcCoeffi= value;
		}
		public function set isCalcSPL(value:Boolean):void{
			_isCalcSPL= value;
		}
		public function set isCalcSubGraph(value:Boolean):void{
			_isCalcSubGraph= value;
		}
		public function set isCalcNomallizedDegree(value:Boolean):void{
			_isCalcNormallizedDegree= value;
		}
	}
}