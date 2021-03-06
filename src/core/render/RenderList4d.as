package core.render
{
	import core.Constants;
	import core.geometry.poly.Poly4df;
	import core.math.Point4d;

	public class RenderList4d
	{
		public var state:int;
		public var attr:int;
		public var num_polys:int;
		public var poly_vec:Vector.<Poly4df> = new Vector.<Poly4df>(Constants.RENDERLISTD_MAX_POLYS,true);
//		public var world_pos:Point4d;
		public function RenderList4d()
		{
		}
		
		public function addPoly(poly:Object):void{
			if(poly is Poly4df){
				poly_vec[num_polys] = poly as Poly4df;
				num_polys++;
			}
			if(poly is Array){
				var arr:Array = poly as Array;
				for each(var p:Poly4df in arr){
					poly_vec[num_polys] = p;
					num_polys++;
				}
			}
		}
		
		public function reSet():void{
			num_polys = 0;
		}
		
		public function toWorldPosition(world_pos:Point4d,coord_select:int = 2):void{
			var temp:Poly4df;
			if(coord_select == Constants.TRANSFORM_LOCAL_TO_TRANS){				
				for (var i:int = 0; i < num_polys; i++) 
				{
					temp = poly_vec[i]
					for (var j:int = 0; j < 3; j++) 
					{
						temp.vlist[j].add(world_pos,temp.tvlist[j]);
					}					
				}				
			}
			else if(coord_select == Constants.TRANSFORM_TRANS_ONLY){
				for (var i:int = 0; i < num_polys; i++) 
				{
					temp = poly_vec[i]
					for (var j:int = 0; j < 3; j++) 
					{
						temp.tvlist[j].add(world_pos,temp.tvlist[j]);
					}					
				}
			}
		}
		
	}
}