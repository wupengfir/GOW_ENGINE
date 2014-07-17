package core.geometry.object
{
	import core.Constants;
	import core.geometry.matrix.GowMatrix;
	import core.geometry.poly.Poly4df;
	import core.math.Point4d;
	import core.math.Vector4d;
	import core.render.RenderManager;
	import core.util.Util;

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
		
		private var rm:RenderManager = new RenderManager();
		public var numPolys:int;
		public var poly_vec:Vector.<Poly4df> = new Vector.<Poly4df>(Constants.RENDERLISTD_MAX_POLYS,true);
		
		public var toWorlded:Boolean = false;
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
		
		public function fillPolyVec(type:int = 1):void{
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
		
		public function toWorldPosition(coord_select:int = 2):void{

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
		
		public function copyFromObject4d(source:Object4d):Object4d{
			for (var i:int = 0; i < source.numVertices; i++) 
			{
				vlist_local[i] = new Point4d().copyFromPoint4d(source.vlist_local[i]);
				vlist_trans[i] = new Point4d().copyFromPoint4d(source.vlist_trans[i]);
				numVertices++;
			}
			fillPolyVec();
			return this;
		}
		public var rx:Number = 0;
		public var ry:Number = 0;
		public var rz:Number = 0;
		public var oldx:Number = 0;
		public var oldy:Number = 0;
		public var oldz:Number = 0;
		public function set rotationX(rx:Number):void{
			this.rx = rx;
			var cos:Number = Math.cos(Util.deg_to_rad(rx-oldx));
			var sin:Number = Math.sin(Util.deg_to_rad(rx-oldx));
			if(rx>=360)rx = rx%360;
			var mrot:GowMatrix = new GowMatrix(44);
			mrot.init([1,0,0,0,
				0,cos,sin,0,
				0,-sin,cos,0,
				0,0,0,1]);
			rm.transform_object4d(this,mrot,Constants.TRANSFORM_LOCAL_ONLY,false);
			oldx = rx;
		}
		
		public function set rotationY(ry:Number):void{
			this.ry = ry;
			var cos:Number = Math.cos(Util.deg_to_rad(ry-oldy));
			var sin:Number = Math.sin(Util.deg_to_rad(ry-oldy));
			if(ry>=360){
				ry = ry%360;
			}			
			var mrot:GowMatrix = new GowMatrix(44);
			mrot.init([cos,0,-sin,0,
				0,1,0,0,
				sin,0,cos,0,
				0,0,0,1]);
			rm.transform_object4d(this,mrot,Constants.TRANSFORM_LOCAL_ONLY,false);
			trace(ry+"   "+oldy);
			oldy = ry;
		}
		
		public function set rotationZ(rz:Number):void{
			this.rz = rz;
			var cos:Number = Math.cos(Util.deg_to_rad(rz-oldz));
			var sin:Number = Math.sin(Util.deg_to_rad(rz-oldz));
			if(rz>=360)rz = rz%360;
			var mrot:GowMatrix = new GowMatrix(44);
			mrot.init([cos,sin,0,0,
				-sin,cos,0,0,
				0,0,1,0,
				0,0,0,1]);
			rm.transform_object4d(this,mrot,Constants.TRANSFORM_LOCAL_ONLY,false);
			oldz = rz;
		}
		
	}
}


















