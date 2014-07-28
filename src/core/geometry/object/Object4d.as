package core.geometry.object
{
	import core.Constants;
	import core.geometry.matrix.GowMatrix;
	import core.geometry.poly.Poly4df;
	import core.math.Point4d;
	import core.math.Vector3d;
	import core.math.Vector4d;
	import core.render.RenderManager;
	import core.util.Util;

	public class Object4d
	{
		public var id:int;
		public var name:String = "";
		public var state:int;
		public var attr:int;
		public var avgRadius:Number = 0;
		public var maxRadius:Number = 0;
		public var worldPosition:Point4d;
		//物体方向向量
		public var dir:Vector4d;
		//物体局部坐标轴
		public var ux:Vector4d;
		public var uy:Vector4d;
		public var uz:Vector4d;
		//顶点数
		public var numVertices:int;
		//poly颜色数组
		public var colorList:Array;
		//顶点局部坐标
		public var vlist_local:Vector.<Point4d> = new Vector.<Point4d>(Constants.OBJECT4D_MAX_VERTICES,true);
		//变换后的顶点坐标
		public var vlist_trans:Vector.<Point4d> = new Vector.<Point4d>(Constants.OBJECT4D_MAX_VERTICES,true);
		
		public var poly_point_match_data:Array = new Array();
		
		private var rm:RenderManager = new RenderManager();
		public var numPolys:int;
		public var poly_vec:Vector.<Poly4df> = new Vector.<Poly4df>(Constants.RENDERLISTD_MAX_POLYS,true);
		
		public var toWorlded:Boolean = false;
		public function Object4d()
		{
			this.attr = Constants.OBJECT_STATE_ACTIVE|Constants.OBJECT_STATE_VISIBLE;
		}
		
		public function scale(v:Vector3d):void{
			for (var i:int = 0; i < numVertices; i++) 
			{
				vlist_local[i].x *= v.x;
				vlist_local[i].y *= v.y;
				vlist_local[i].z *= v.z;
				vlist_trans[i].x *= v.x;
				vlist_trans[i].y *= v.y;
				vlist_trans[i].z *= v.z;
			}
			
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
			for (var i:int = 0; i < numVertices; i++) 
			{
				var tRadius = Math.sqrt(vlist_local[i].x*vlist_local[i].x+vlist_local[i].y*vlist_local[i].y+vlist_local[i].z*vlist_local[i].z);
				if(tRadius>maxRadius){
					maxRadius = tRadius;
				}
			}
			
		}
		
		public function fillPolyVec(colors:Array = null):void{
			var vertice:Point4d;
			var index:int = 0;
			this.colorList = colors;
			for (var i:int = 0; i < numVertices; i+=3) 
			{
				var tempPoly:Poly4df = new Poly4df();
				if(colors){
					tempPoly.color = colors[Math.floor(i/3)];
					tempPoly.color_trans = colors[Math.floor(i/3)];
				}
				
				tempPoly.addPoint(vlist_trans[i],vlist_trans[i+1],vlist_trans[i+2]);
				poly_vec[index] = tempPoly;
				index++;
				numPolys++;
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
		
//		public function cloneObject4d(source:Object4d):Object4d{
//			for (var i:int = 0; i < source.numVertices; i++) 
//			{
//				vlist_local[i] = new Point4d().copyFromPoint4d(source.vlist_local[i]);
//				vlist_trans[i] = new Point4d().copyFromPoint4d(source.vlist_trans[i]);
//				numVertices++;
//			}
//			this.avgRadius = source.maxRadius;
//			this.maxRadius = source.maxRadius;
//			fillPolyVec(source.colorList);
//			return this;
//		}
		
		public function copyFromObject4d(source:Object4d):Object4d{
			for (var i:int = 0; i < source.numVertices; i++) 
			{
				vlist_local[i] = new Point4d().copyFromPoint4d(source.vlist_local[i]);
				vlist_trans[i] = new Point4d().copyFromPoint4d(source.vlist_trans[i]);
				numVertices++;
			}
			this.avgRadius = source.avgRadius;
			this.maxRadius = source.maxRadius;
			fillPolyVec(source.colorList);
			return this;
		}
		public var rx:Number = 0;
		public var ry:Number = 0;
		public var rz:Number = 0;
		public var rx_world:Number = 0;
		public var ry_world:Number = 0;
		public var rz_world:Number = 0;
		public var oldx:Number = 0;
		public var oldy:Number = 0;
		public var oldz:Number = 0;
		public var oldx_world:Number = 0;
		public var oldy_world:Number = 0;
		public var oldz_world:Number = 0;
		public function set rotationX(rx:Number):void{
			if(numVertices == 0)return;
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
			if(numVertices == 0)return;
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
			oldy = ry;
		}
		
		public var rotation_world:Boolean = false;
		
		public function set rotationY_world(ry_world:Number):void{
			if(numVertices == 0)return;
			this.ry_world = ry_world;
			var cos:Number = Math.cos(Util.deg_to_rad(ry_world));
			var sin:Number = Math.sin(Util.deg_to_rad(ry_world));
			if(ry_world>=360){
				ry_world = ry_world%360;
			}			
			var mrot:GowMatrix = new GowMatrix(44);
			mrot.init([cos,0,-sin,0,
				0,1,0,0,
				sin,0,cos,0,
				0,0,0,1]);
			rm.transform_object4d(this,mrot,Constants.TRANSFORM_TRANS_ONLY,false);
			oldy_world = ry_world;
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


















