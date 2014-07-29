package core.geometry.vertex
{
	import core.math.Point4d;
	import core.math.Vector4d;
	
	import flash.geom.Point;

	public class Vertex extends Point4d
	{
		
		public var normal:Vector4d;
		public var texture_pos:Point;
		
		public function Vertex(x:Number = 0,y:Number = 0,z:Number = 0,w:Number = 1)
		{
			super(x,y,z,w);
			normal = new Vector4d();
			texture_pos = new Point();
		}
	}
}