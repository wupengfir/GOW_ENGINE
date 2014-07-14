package core.geometry.poly
{
	import core.math.Point4d;

	public class Poly4d
	{
		public var state:int;
		public var attr:int;
		public var color:uint;
		public var vlist:Vector.<Point4d> = new Vector.<Point4d>(3,true);
		public var vert:Vector.<int> = new Vector.<int>(3);
		public function Poly4d()
		{
		}
	}
}