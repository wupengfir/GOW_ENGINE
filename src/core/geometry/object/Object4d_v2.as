package core.geometry.object
{
	import core.Constants;
	import core.geometry.matrix.GowMatrix;
	import core.geometry.poly.Poly4df;
	import core.math.Point3d;
	import core.math.Point4d;
	import core.math.Vector3d;
	import core.math.Vector4d;
	import core.render.RenderManager;
	import core.util.Util;
	
	public class Object4d_v2 extends Object4d
	{
		
		public function Object4d_v2()
		{
		}
				
		override public function fillPolyVec(colors:Array = null):void{
			var vertice:Point4d;
			var index:int = 0;
			this.colorList = colors;				
			for each(var p:Point3d in poly_point_match_data){
				var tempPoly:Poly4df = new Poly4df();
				tempPoly.addPoint(vlist_trans[p.x],vlist_trans[p.y],vlist_trans[p.z]);
				if(colors){
					tempPoly.color = colors[Math.floor(index)];
					tempPoly.color_trans = colors[Math.floor(index)];
				}
				poly_vec[index] = tempPoly;
				index++;
				numPolys++;	
			}				
				
		}
		
		
		public function copyFromObject4d_v2(source:Object4d_v2):Object4d_v2{
			for (var i:int = 0; i < source.numVertices; i++) 
			{
				vlist_local[i] = new Point4d().copyFromPoint4d(source.vlist_local[i]);
				vlist_trans[i] = new Point4d().copyFromPoint4d(source.vlist_trans[i]);
				numVertices++;
			}
			for (var j:int = 0; j < source.poly_point_match_data.length; j++) 
			{
				poly_point_match_data[j] = new Point3d(source.poly_point_match_data[j].x,source.poly_point_match_data[j].y,source.poly_point_match_data[j].z);
			}
			
			this.avgRadius = source.avgRadius;
			this.maxRadius = source.maxRadius;
			fillPolyVec(source.colorList);
			return this;
		}				
	}
}


















