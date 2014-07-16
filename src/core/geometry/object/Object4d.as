package core.geometry.object
{
	import core.Constants;
	import core.geometry.poly.Poly4df;
	import core.math.Point4d;
	import core.math.Vector4d;

	public class Object4d
	{
		public var id:int;
		public var name:String = "";
		public var state:int;
		public var attr:int;
		public var avgRadius:Number;
		public var maxRadius:Number;
		public var worldPosition:Point4d;
		//物体方向向量
		public var dir:Vector4d;
		//物体局部坐标轴
		public var ux:Vector4d;
		public var uy:Vector4d;
		public var uz:Vector4d;
		//顶点数
		public var numVertices:int;
		//顶点局部坐标
		public var vlist_local:Vector.<Point4d> = new Vector.<Point4d>(Constants.OBJECT4D_MAX_VERTICES,true);
		//变换后的顶点坐标
		public var vlist_trans:Vector.<Point4d> = new Vector.<Point4d>(Constants.OBJECT4D_MAX_VERTICES,true);
		
		public var numPolys:int;
		public var poly_vec:Vector.<Poly4df> = new Vector.<Poly4df>(Constants.RENDERLISTD_MAX_POLYS,true);
		public function Object4d()
		{
			
		}
		
		public function addVertices(v:Object):void{
			if(v is Point4d){
				vlist_local[numVertices] = v as Point4d;
				if(vlist_trans[numVertices] == null)vlist_trans[numVertices] = new Point4d().copyFromPoint4d(vlist_local[numVertices]);
				numVertices++;
			}
			if(v is Array){
				var arr:Array = v as Array;
				for each(var p:Point4d in arr){
					vlist_local[numVertices] = p;
					if(vlist_trans[numVertices] == null)vlist_trans[numVertices] = new Point4d().copyFromPoint4d(vlist_local[numVertices]);
					numVertices++;
				}
			}
		}
		
		public function fillPolyVec(type:int = Constants.TRANSFORM_TRANS_ONLY):void{
			var vertice:Point4d;
			var index:int = 0;
			if(type == Constants.TRANSFORM_TRANS_ONLY){
				for (var i:int = 0; i < numVertices; i+=3) 
				{
					var tempPoly:Poly4df = new Poly4df();
					tempPoly.addPoint(vlist_trans[i],vlist_trans[i+1],vlist_trans[i+2]);
					poly_vec[index] = tempPoly;
					index++;
					numPolys++;
				}
			}else{
				for (var i:int = 0; i < numVertices; i+=3) 
				{
					var tempPoly:Poly4df = new Poly4df();
					tempPoly.addPoint(vlist_local[i],vlist_local[i+1],vlist_local[i+2]);
					poly_vec[index] = tempPoly;
					index++;
					numPolys++;
				}
			}
						
		}
		
		public function toWorldPosition(coord_select:int = Constants.TRANSFORM_LOCAL_TO_TRANS):void{
			var temp:Point4d;
			if(coord_select == Constants.TRANSFORM_LOCAL_TO_TRANS){				
				for (var i:int = 0; i < numVertices; i++) 
				{
					temp = vlist_local[i];
					temp.add(worldPosition,vlist_trans[i]);
				}				
			}
			else if(coord_select == Constants.TRANSFORM_TRANS_ONLY){
				for (var i:int = 0; i < numVertices; i++) 
				{
					temp = vlist_trans[i];
					temp.add(worldPosition,temp);
				}
			}
		}
	}
}


















