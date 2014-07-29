package core.render
{
	import core.Constants;
	import core.geometry.matrix.GowMatrix;
	import core.geometry.object.Object4d;
	import core.geometry.plane.Plane3d;
	import core.geometry.poly.Poly4df;
	import core.math.Point3d;
	import core.math.Point4d;
	import core.math.Vector3d;
	import core.math.Vector4d;
	import core.util.Util;

	public class Camera
	{
		
		public static const CAMERA_TYPE_EULER:int = 0;
		public static const CAMERA_TYPE_UVN:int = 1;
		
		public var state:int;
		public var attr:int;
		public var pos:Point4d;
		public var dir:Vector4d;
		public var u:Vector4d;
		public var v:Vector4d;
		public var n:Vector4d;
		public var target:Point4d;
		//焦点视距
		public var view_dist:Number = 1;
		//视野
		public var fov:Number;
		//裁剪面
		public var near_clip_z:Number;
		public var far_clip_z:Number;
		public var rt_clip_z:Plane3d;
		public var lt_clip_z:Plane3d;
		public var tp_clip_z:Plane3d;
		public var bt_clip_z:Plane3d;
		//视平面宽高
		public var viewplane_width:Number;
		public var viewplane_height:Number;
		
		//视口属性
		public var viewport_width:Number;
		public var viewport_height:Number;
		public var viewport_centerX:Number;
		public var viewport_centerY:Number;
		
		//宽高比
		public var aspect_radio:Number;
		//相机从世界坐标到相机坐标变换矩阵
		public var mcam:GowMatrix;
		//相机从相机坐标到透视坐标变换矩阵
		public var mper:GowMatrix;
		//相机从透视坐标到屏幕坐标变换矩阵
		public var mscr:GowMatrix;
		public function Camera()
		{
		}
		
		public function initCamera(attr:int,cam_pos:Point4d,cam_dir:Vector4d,cam_target:Point4d,
								   nearZ:Number,farZ:Number,fov:Number,viewW:Number,viewH:Number):void{
			this.attr = attr;
			this.pos = cam_pos;
			this.dir = cam_dir;
			
			this.near_clip_z = nearZ;
			this.far_clip_z = farZ;
			this.fov = fov;
			this.viewport_width = viewW;
			this.viewport_height = viewH;
			this.u = new Vector4d(1,0,0,1);
			this.v = new Vector4d(0,1,0,1);
			this.n = new Vector4d(0,0,1,1);
			if(cam_target){
				this.target = cam_target;
			}else{
				this.target = new Point4d(0,0,0,0);
			}
			this.viewport_centerX = viewW/2;
			this.viewport_centerY = viewH/2;
			
			mcam = new GowMatrix(44);mcam.identity();
			mper = new GowMatrix(44);mper.identity();
			mscr = new GowMatrix(44);mscr.identity();
				
			aspect_radio = viewW/viewH;
			viewplane_width = 2;
			viewplane_height = 2/aspect_radio;
			var tan_fov:Number = Math.tan(Util.deg_to_rad(fov/2));
			view_dist = 0.5*viewplane_width/tan_fov;
			//右手坐标系
			var p:Point3d = new Point3d(0,0,0);
			var vn:Vector3d;
			if(fov == 90){
				vn = new Vector3d(1,0,-1);
				rt_clip_z = new Plane3d();
				rt_clip_z.init(p,vn);
				vn.init(-1,0,-1);
				lt_clip_z = new Plane3d();
				lt_clip_z.init(p,vn);
				vn.init(0,1,-1);
				tp_clip_z = new Plane3d();
				tp_clip_z.init(p,vn);
				vn.init(0,-1,-1);
				bt_clip_z = new Plane3d();
				bt_clip_z.init(p,vn);
			}else{
				vn = new Vector3d(view_dist,0,viewplane_width/(-2));
				rt_clip_z = new Plane3d();
				rt_clip_z.init(p,vn);
				vn.init(-view_dist,0,viewplane_width/(-2));
				lt_clip_z = new Plane3d();
				lt_clip_z.init(p,vn);
				vn.init(0,view_dist,viewplane_width/(-2));
				tp_clip_z = new Plane3d();
				tp_clip_z.init(p,vn);
				vn.init(0,-view_dist,viewplane_width/(-2));
				bt_clip_z = new Plane3d();
				bt_clip_z.init(p,vn);
			}
			
		}
				
		public function buildWorldToCameraMatrix_Euler():void{
			var mt_inv:GowMatrix = new GowMatrix(44);
			var mx_inv:GowMatrix = new GowMatrix(44);
			var my_inv:GowMatrix = new GowMatrix(44);
			var mz_inv:GowMatrix = new GowMatrix(44);
			mt_inv.init([1,0,0,0,
						0,1,0,0,
						0,0,1,0,
						-pos.x,-pos.y,-pos.z,1]);
			var t_x:Number = dir.x;
			var t_y:Number = dir.y;
			var t_z:Number = dir.z;
			var cos_t:Number = Math.cos(t_x);
			var sin_t:Number = -Math.sin(t_x);
			mx_inv.init([1,0,0,0,
						0,cos_t,sin_t,0,
						0,-sin_t,cos_t,0,
						0,0,0,1]);
			cos_t = Math.cos(t_y);
			sin_t = -Math.sin(t_y);
			my_inv.init([cos_t,0,-sin_t,0,
						0,1,0,0,
						sin_t,0,cos_t,0,
						0,0,0,1]);
			cos_t = Math.cos(t_z);
			sin_t = -Math.sin(t_z);
			mz_inv.init([cos_t,sin_t,0,0,
						-sin_t,cos_t,0,0,
						0,0,1,0,
						0,0,0,1]);
			var temp:GowMatrix = my_inv.multiply(mz_inv) as GowMatrix;
			temp = temp.multiply(mx_inv);
			mcam = mt_inv.multiply(temp);
		}
		
		public function buildWorldToCameraMatrix_unv(mode:int):void{
			var temp:GowMatrix = new GowMatrix(44);
			temp.init([1,0,0,0,
						0,1,0,0,
						0,0,1,0,
						-pos.x,-pos.y,-pos.z,1]);
			if(mode == Constants.UNV_MODE_SPHERICAL){
				var phi:Number = dir.y;
				var theta:Number = dir.z;
				var cos_phi:Number = Math.cos(phi);
				var sin_phi:Number = Math.sin(phi);
				var cos_theta:Number = Math.cos(theta);
				var sin_theta:Number = Math.sin(theta);
				var r:Number = sin_phi;
				target.x = r*cos_theta;
				target.y = r*sin_theta;
				target.z = cos_phi;
			}
			
			n.build(pos,target);
			v.setProperty(0,1,0,1);
			
			v.cross(n,u);
			n.cross(u,v);
			u.normalize();n.normalize();v.normalize();
			var temp_uvn:GowMatrix = new GowMatrix(44);
			temp_uvn.init([u.x,v.x,n.x,0,
						u.y,v.y,n.y,0,
						u.z,v.z,n.z,0,
						0,0,0,1]);
			mcam = temp.multiply(temp_uvn);
			
		}
		
		
		//消除物体背面
		public function removeBackfaces_obj(obj:Object4d):void{
			var viewVector:Vector4d = new Vector4d();
			for (var i:int = 0; i < obj.numPolys; i++) 
			{
				if(obj.poly_vec[i].attr&Constants.POLY4D_ATTR_2SIDES)continue;
				viewVector.x = pos.x - obj.poly_vec[i].tvlist[0].x;
				viewVector.y = pos.y - obj.poly_vec[i].tvlist[0].y;
				viewVector.z = pos.z - obj.poly_vec[i].tvlist[0].z;
				obj.poly_vec[i].calculateNormalVector();
				var pointMu:Number = viewVector.x*obj.poly_vec[i].normalVector.x+viewVector.y*obj.poly_vec[i].normalVector.y +viewVector.z*obj.poly_vec[i].normalVector.z;
				if(pointMu<0){
					obj.poly_vec[i].state = Constants.POLY4D_STATE_BACKFACE;
				}else{
					obj.poly_vec[i].state = Constants.POLY4D_STATE_ACTIVE;
				}
			}
		}
		
		
		public function cameraToPerspective_renderlist(list:RenderList4d):void{
			var temp:Poly4df;
			for (var i:int = 0; i < list.num_polys; i++) 
			{
				temp = list.poly_vec[i];
				if(temp==null||
					!(temp.state&Constants.POLY4D_STATE_ACTIVE)||
					temp.state&Constants.POLY4D_STATE_CLIPPED||
					temp.state&Constants.POLY4D_STATE_BACKFACE)
					continue;
				for (var j:int = 0; j < 3; j++) 
				{
					var z:Number = temp.tvlist[j].z;
					temp.tvlist[j].x = view_dist*temp.tvlist[j].x/z;
					temp.tvlist[j].y = view_dist*temp.tvlist[j].y*aspect_radio/z;
				}
				
			}		
		}
		
		public function cameraToPerspective_object(obj:Object4d):void{
			var vertice:Point4d;
			for (var i:int = 0; i < obj.numVertices; i++) 
			{
				vertice = obj.vlist_trans[i];
				if(vertice==null)
					continue;
				var z:Number = vertice.z;
				
				vertice.x = view_dist*vertice.x/z;
				vertice.y = view_dist*vertice.y*aspect_radio/z;			
				if(z<0){
					trace(z +"  "+vertice.x+"    "+vertice.y);
				}
			}		
		}
		
		public function cullObject(obj:Object4d,cullType:int):void{
			obj.state = Constants.POLY4D_STATE_ACTIVE;
			var temp:Point4d = new Point4d().copyFromMatrix(mcam.multiply(obj.worldPosition));
			if(cullType&Constants.CULL_Z){
				if((temp.z - obj.maxRadius)>far_clip_z||(temp.z + obj.maxRadius)<near_clip_z){
					obj.state = Constants.OBJECT_STATE_CLIPPED;
				}
			}
			if(cullType&Constants.CULL_X){
				var ztest:Number = 0.5*viewplane_width*temp.z/view_dist;
				if((temp.x - obj.maxRadius)>ztest||(temp.x + obj.maxRadius)<-ztest){
					obj.state = Constants.OBJECT_STATE_CLIPPED;
				}
			}
			if(cullType&Constants.CULL_Y){
				var ztest:Number = 0.5*viewport_height*temp.z/view_dist;
				if((temp.y - obj.maxRadius)>ztest||(temp.y + obj.maxRadius)<-ztest){
					obj.state = Constants.OBJECT_STATE_CLIPPED;
				}
			}
		}
		
		//没啥用
		public function cameraToPerspective_object_polys(obj:Object4d):void{
			var temp:Poly4df;
			for (var i:int = 0; i < obj.numPolys; i++) 
			{
				temp = obj.poly_vec[i];
				if(temp==null||
					!(temp.state&Constants.POLY4D_STATE_ACTIVE)||
					temp.state&Constants.POLY4D_STATE_CLIPPED||
					temp.state&Constants.POLY4D_STATE_BACKFACE)
					continue;
				for (var j:int = 0; j < 3; j++) 
				{
					var z:Number = temp.tvlist[j].z;
					temp.tvlist[j].x = view_dist*temp.tvlist[j].x/z;
					temp.tvlist[j].y = view_dist*temp.tvlist[j].y*aspect_radio/z;
				}
				
			}		
		}
		
		public function perspectiveToScreen_renderlist(list:RenderList4d):void{
			var temp:Poly4df;
			for (var i:int = 0; i < list.num_polys; i++) 
			{
				temp = list.poly_vec[i];
				if(temp==null||
					!(temp.state&Constants.POLY4D_STATE_ACTIVE)||
					temp.state&Constants.POLY4D_STATE_CLIPPED||
					temp.state&Constants.POLY4D_STATE_BACKFACE)
					continue;
				var a:Number = 0.5*viewport_width-0.5;
				var b:Number = 0.5*viewport_height-0.5;
				for (var j:int = 0; j < 3; j++) 
				{
					temp.tvlist[j].x = a+a*temp.tvlist[j].x;
					temp.tvlist[j].y = b-b*temp.tvlist[j].y;
				}
				
			}		
		}
		//没啥用
		public function perspectiveToScreen_obj_poly(obj:Object4d):void{
			var temp:Poly4df;
			for (var i:int = 0; i < obj.numPolys; i++) 
			{
				temp = obj.poly_vec[i];
				if(temp==null||
					!(temp.state&Constants.POLY4D_STATE_ACTIVE)||
					temp.state&Constants.POLY4D_STATE_CLIPPED||
					temp.state&Constants.POLY4D_STATE_BACKFACE)
					continue;
				var a:Number = 0.5*viewport_width-0.5;
				var b:Number = 0.5*viewport_height-0.5;
				for (var j:int = 0; j < 3; j++) 
				{
					temp.tvlist[j].x = a+a*temp.tvlist[j].x;
					temp.tvlist[j].y = b-b*temp.tvlist[j].y;
				}
				
			}		
		}
		
		public function perspectiveToScreen_obj(obj:Object4d):void{
			var temp:Point4d;
			for (var i:int = 0; i < obj.numVertices; i++) 
			{
				temp = obj.vlist_trans[i];
				if(temp==null)
					continue;
				var a:Number = 0.5*viewport_width-0.5;
				var b:Number = 0.5*viewport_height-0.5;
				temp.x = a+a*temp.x;
				temp.y = b-b*temp.y;
				
			}		
		}
		
		public var rx:Number = 0;
		public var ry:Number = 0;
		public var rz:Number = 0;
		public function set rotationX(rx:Number):void{
			this.rx = rx;
		}
		
		public function set rotationY(ry:Number):void{
			this.ry = ry;
		}
		
		public function set rotationZ(rz:Number):void{
			this.rz = rz;
		}
		
		public function initCameraToPerspectiveMatrix(list:RenderList4d):void{
			mper.init([view_dist,0,0,0,
						0,]);			
		}
		
	}
}















