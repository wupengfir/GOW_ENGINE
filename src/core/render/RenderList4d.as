package core.render
{
	import core.Constants;
	import core.geometry.poly.Poly4df;

	public class RenderList4d
	{
		public var state:int;
		public var attr:int;
		public var num_polys:int;
		public var poly_vec:Vector.<Poly4df> = new Vector.<Poly4df>(Constants.RENDERLISTD_MAX_POLYS,true);
		
		public function RenderList4d()
		{
		}
	}
}