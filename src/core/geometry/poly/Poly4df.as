package core.geometry.poly
{
	import core.math.Point4d;

	public class Poly4df
	{
		public var state:int;
		public var attr:int;
		public var color:uint;
		public var vlist:Vector.<Point4d> = new Vector.<Point4d>(3);
		public var tvlist:Vector.<Point4d> = new Vector.<Point4d>(3);
		public var next:Poly4df;
		public var prec:Poly4df;
		public function Poly4df()
		{
			for (var i:int = 0; i < 3; i++) 
			{
				tvlist[i] = new Point4d();
			}
			
		}
	}
}