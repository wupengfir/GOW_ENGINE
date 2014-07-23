package core.render
{
	import core.Constants;
	import core.geometry.object.Object4d;
	import core.geometry.poly.Poly4df;
	import core.light.Light;
	import core.light.LightManager;
	import core.math.Point4d;
	import core.util.Util;
	
	import flash.display.Graphics;
	import flash.display.Sprite;

	public class World extends Sprite
	{
		public var renderListArray:Array = new Array();
		public var objectArray:Array = new Array();
		
		private var cam:Camera;
		private var rm:RenderManager = new RenderManager();
		public function World()
		{
		}
		
		public function set camera(cam:Camera):void{
			this.cam = cam;
		}
		
		public function add(o:Object):void{
			if(o is RenderList4d){
				renderListArray.push(o);
			}
			if(o is Object4d){
				objectArray.push(o);
			}
		}
		
		public function shaderObject(obj:Object4d):void{
			if(!(obj.attr&Constants.OBJECT_STATE_ACTIVE)||
					obj.attr&Constants.OBJECT_STATE_CLIPPED||
						!(obj.attr&Constants.OBJECT_STATE_VISIBLE))
				return;
			var r_sum:uint = 0;
			var g_sum:uint = 0;
			var b_sum:uint = 0;
			var r_base:uint = 0;
			var g_base:uint = 0;
			var b_base:uint = 0;
			var poly:Poly4df;
			for (var j:int = 0; j < obj.numPolys; j++) 
			{
				poly = obj.poly_vec[j];
				if(poly == null || !poly.avaliable())continue;
				r_base = poly.color>>16&0x000000ff;
				g_base = poly.color>>8&0x000000ff;
				b_base = poly.color&0x000000ff;
				for (var i:int = 0; i < LightManager.numLights; i++) 
				{
					var light:Light = LightManager.lightList[i];
					if(!light.state)continue;
					if(light.attr&Light.LIGHTV1_ATTR_AMBIENT){					
						r_sum += light.c_ambient*r_base/256;
						g_sum += light.c_ambient*g_base/256;
						b_sum += light.c_ambient*b_base/256;
					}
				}
				poly.color = Util.ARGB(0xff,r_sum,g_sum,b_sum);
			}			
		}
		
		public function render(back:Boolean = false,cull:Boolean = true):void{
			if(cam == null)return;			
			var g:Graphics = this.graphics;
			g.clear();
			var temp:Poly4df;
			for each(var renderList:RenderList4d in renderListArray){				
				cam.buildWorldToCameraMatrix_Euler();
				rm.transform_renderList(renderList,cam.mcam,Constants.TRANSFORM_TRANS_ONLY);
				cam.cameraToPerspective_renderlist(renderList);
				cam.perspectiveToScreen_renderlist(renderList);
				
				for (var i:int = 0; i < renderList.num_polys; i++) 
				{
					temp = renderList.poly_vec[i];
					if(temp==null||
						!(temp.state&Constants.POLY4D_STATE_ACTIVE)||
						temp.state&Constants.POLY4D_STATE_CLIPPED||
						temp.state&Constants.POLY4D_STATE_BACKFACE)
						continue;
					for (var j:int = 0; j < 3; j++) 
					{
						g.lineStyle(1,0,1);
						g.moveTo(temp.tvlist[j].x,temp.tvlist[j].y);
						var a:int = j == 2?0:j+1;
						g.lineTo(temp.tvlist[a].x,temp.tvlist[a].y);
					}
					
				}
			}
			for each(var object:Object4d in objectArray){	
				object.toWorldPosition(Constants.TRANSFORM_LOCAL_TO_TRANS);
				if(object.rotation_world){
					object.rotationY_world = object.ry_world;
				}
				if(cam.attr == Camera.CAMERA_TYPE_EULER){
					cam.buildWorldToCameraMatrix_Euler();
				}else{
					cam.buildWorldToCameraMatrix_unv(Constants.UNV_MODE_SIMPLE);
				}
				
				if(back){
					cam.removeBackfaces_obj(object);
				}
				if(cull){
					cam.cullObject(object,Constants.CULL_XYZ);
				}
				if(object.state == Constants.OBJECT_STATE_CLIPPED){
					continue;
				}
				shaderObject(object);
				rm.transform_object4d(object,cam.mcam,Constants.TRANSFORM_TRANS_ONLY,false);
				cam.cameraToPerspective_object(object);
				cam.perspectiveToScreen_obj(object);
				
				for (var i:int = 0; i < object.numPolys; i++) 
				{
					temp = object.poly_vec[i];
					if(temp==null||
						!(temp.state&Constants.POLY4D_STATE_ACTIVE)||
						temp.state&Constants.POLY4D_STATE_CLIPPED||
						temp.state&Constants.POLY4D_STATE_BACKFACE)
						continue;
					g.lineStyle(1,0,1);
					g.beginFill(temp.color, 1);
					g.moveTo(temp.tvlist[0].x,temp.tvlist[0].y);
					g.lineTo(temp.tvlist[1].x,temp.tvlist[1].y);
					g.lineTo(temp.tvlist[2].x,temp.tvlist[2].y);
					g.lineTo(temp.tvlist[0].x,temp.tvlist[0].y);
					g.endFill();
				}
				
			}
			
		}
		
	}
}