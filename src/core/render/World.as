package core.render
{
	import core.Constants;
	import core.geometry.object.Object4d;
	import core.geometry.poly.Poly4df;
	import core.light.Light;
	import core.light.LightManager;
	import core.math.Point4d;
	import core.math.Vector4d;
	import core.util.Util;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class World extends Sprite
	{
		public var renderListArray:Array = new Array();
		public var objectArray:Array = new Array();
		
		private var view:BitmapdataRender = new BitmapdataRender(1000,1000);
		private var renderList_all:RenderList4d = new RenderList4d();
		private var cam:Camera;
		private var rm:RenderManager = new RenderManager();
		public function World()
		{
			addChild(view);
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
			if(LightManager.numLights == 0)return;
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
			var r_a:uint = 0;
			var g_a:uint = 0;
			var b_a:uint = 0;
			var poly:Poly4df;
			for (var j:int = 0; j < obj.numPolys; j++) 
			{
				r_sum = 0;
				g_sum = 0;
				b_sum = 0;
				poly = obj.poly_vec[j];
				if(poly == null || !poly.avaliable())continue;
				r_base = poly.color>>16&0x000000ff;
				g_base = poly.color>>8&0x000000ff;
				b_base = poly.color&0x000000ff;
				
				for (var i:int = 0; i < LightManager.numLights; i++) 
				{
					var light:Light = LightManager.lightList[i];
					if(!light.state)continue;
					if(light.attr & Light.LIGHTV1_ATTR_AMBIENT){
						r_a = light.c_ambient>>16&0x000000ff;
						g_a = light.c_ambient>>8&0x000000ff;
						b_a = light.c_ambient&0x000000ff;										
						r_sum += r_a*r_base/256;
						g_sum += g_a*g_base/256;
						b_sum += b_a*b_base/256;
					}else if(light.attr & Light.LIGHTV1_ATTR_INFINITE){
						var dp:Number = light.dir.x*poly.normalVector.x+light.dir.y*poly.normalVector.y +light.dir.z*poly.normalVector.z;
						if(dp>0){
							r_a = light.c_diffuse>>16&0x000000ff;
							g_a = light.c_diffuse>>8&0x000000ff;
							b_a = light.c_diffuse&0x000000ff;
							r_sum += r_a*r_base*dp/256;
							g_sum += g_a*g_base*dp/256;
							b_sum += b_a*b_base*dp/256;
						}
					}else if(light.attr & Light.LIGHTV1_ATTR_POINT){
						var dist:Number = Util.distance(light.pos,poly.tvlist[0]);
						var vec:Vector4d = new Vector4d().build(poly.tvlist[0],light.pos);
						vec.normalize();
						var dp:Number = vec.x*poly.normalVector.x+vec.y*poly.normalVector.y +vec.z*poly.normalVector.z;
						var atten:Number = light.kc + light.kl*dist + light.kq*dist*dist;
						if(dp>0){
							r_a = light.c_specular>>16&0x000000ff;
							g_a = light.c_specular>>8&0x000000ff;
							b_a = light.c_specular&0x000000ff;
							r_sum += r_a*r_base*dp/(256*dist*atten);
							g_sum += g_a*g_base*dp/(256*dist*atten);
							b_sum += b_a*b_base*dp/(256*dist*atten);
						}
					}else if(light.attr & Light.LIGHTV1_ATTR_SPOTLIGHT_SIMPLE){
						var dist:Number = Util.distance(light.pos,poly.tvlist[0]);
						var vec:Vector4d = light.dir;
						vec.normalize();
						var dp:Number = vec.x*poly.normalVector.x+vec.y*poly.normalVector.y +vec.z*poly.normalVector.z;
						var atten:Number = light.kc + light.kl*dist + light.kq*dist*dist;
						if(dp>0){
							r_a = light.c_diffuse>>16&0x000000ff;
							g_a = light.c_diffuse>>8&0x000000ff;
							b_a = light.c_diffuse&0x000000ff;
							r_sum += r_a*r_base*dp/(256*dist*atten);
							g_sum += g_a*g_base*dp/(256*dist*atten);
							b_sum += b_a*b_base*dp/(256*dist*atten);
						}
					}else if(light.attr & Light.LIGHTV1_ATTR_SPOTLIGHT_COMPLICATE){
						var dist:Number = Util.distance(light.pos,poly.tvlist[0]);
						var vec:Vector4d = light.dir;
						vec.normalize();
						var dp:Number = vec.x*poly.normalVector.x+vec.y*poly.normalVector.y +vec.z*poly.normalVector.z;
						var atten:Number = light.kc + light.kl*dist + light.kq*dist*dist;
						if(dp>0){
							vec = new Vector4d().build(poly.tvlist[0],light.pos);
							vec.normalize();
							var dlps:Number = vec.x*poly.normalVector.x+vec.y*poly.normalVector.y +vec.z*poly.normalVector.z;
							if(dlps>0){
								r_a = light.c_diffuse>>16&0x000000ff;
								g_a = light.c_diffuse>>8&0x000000ff;
								b_a = light.c_diffuse&0x000000ff;
								r_sum += r_a*r_base*dp*dlps/(256*dist*atten);
								g_sum += g_a*g_base*dp*dlps/(256*dist*atten);
								b_sum += b_a*b_base*dp*dlps/(256*dist*atten);
							}
							
						}
					}
					
				}
				poly.color_trans = Util.ARGB(0xff,r_sum,g_sum,b_sum);
			}			
		}
		
		
		
		
		public function render(back:Boolean = false,cull:Boolean = true):void{
			if(cam == null)return;		
			renderList_all.reSet();
			var g:Graphics = this.graphics;
			g.clear();
			view.clear();
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
					temp.calculateAvgZ();
					renderList_all.addPoly(temp);
//					g.lineStyle(1,0,0);
//					g.beginFill(temp.color_trans, 1);
//					g.moveTo(temp.tvlist[0].x,temp.tvlist[0].y);
//					g.lineTo(temp.tvlist[1].x,temp.tvlist[1].y);
//					g.lineTo(temp.tvlist[2].x,temp.tvlist[2].y);
//					g.lineTo(temp.tvlist[0].x,temp.tvlist[0].y);
//					g.endFill();
				}
				
			}
			sort(0,renderList_all.num_polys-1);
			//sort_n();
			for (var i:int = 0; i < renderList_all.num_polys; i++) 
			{
				
				temp = renderList_all.poly_vec[i];
//				g.lineStyle(1,0,0);
//				g.beginFill(temp.color_trans, 1);
//				g.moveTo(temp.tvlist[0].x,temp.tvlist[0].y);
//				g.lineTo(temp.tvlist[1].x,temp.tvlist[1].y);
//				g.lineTo(temp.tvlist[2].x,temp.tvlist[2].y);
//				g.lineTo(temp.tvlist[0].x,temp.tvlist[0].y);
//				g.endFill();
				view.moveTo(temp.tvlist[0].x,temp.tvlist[0].y);
				view.lineTo_v2(temp.tvlist[1].x,temp.tvlist[1].y);
				view.lineTo_v2(temp.tvlist[2].x,temp.tvlist[2].y);
				view.lineTo_v2(temp.tvlist[0].x,temp.tvlist[0].y);
				
			}
		}
		
		public function sort_n():void{
			var temp:int;
			var tempP:Poly4df;
			for (var i:int = 0; i < renderList_all.num_polys; i++) 
			{
				temp = i;
				for (var j:int = i; j < renderList_all.num_polys; j++) 
				{
					if( renderList_all.poly_vec[temp].avg_z < renderList_all.poly_vec[j].avg_z){
						tempP = renderList_all.poly_vec[temp];
						renderList_all.poly_vec[temp] = renderList_all.poly_vec[j];
						renderList_all.poly_vec[j] = tempP;
					}
				}
				
			}
			
		}
		
		public function sort(l:int,r:int):void{
			if(l<r){
				var i:int = l;
				var j:int = r;
				var temp:Poly4df = renderList_all.poly_vec[l];
				while(i<j){
					while(i<j && renderList_all.poly_vec[j].avg_z <= temp.avg_z){
						j--;
					}
					if(i<j){
						renderList_all.poly_vec[i++] = renderList_all.poly_vec[j];
					}
					while(i<j && renderList_all.poly_vec[i].avg_z > temp.avg_z){
						i++;
					}
					if(i<j){
						renderList_all.poly_vec[j--] = renderList_all.poly_vec[i];
					}
				}
				renderList_all.poly_vec[i] = temp;
				sort(l,i-1);
				sort(i+1,r);
			}			
		}
		
	}
}