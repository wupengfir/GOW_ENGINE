package core.geometry.poly
{
	import core.math.Point4d;
	
	import flash.display.BitmapData;

	public class Poly extends Poly4df
	{
		public var bitmapdata:BitmapData;
		public var mati_id:int = 0;
		
		public var lit_color:Vector.<uint> = new Vector.<uint>(3);
		
		public function Poly()
		{
		}
	}
}