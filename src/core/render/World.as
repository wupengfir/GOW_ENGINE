package core.render
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import core.Constants;
	import core.geometry.object.Object4d;
	import core.geometry.poly.Poly4df;
	import core.math.Point4d;

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
				//(o as RenderList4d).toWorldPosition(Constants.TRANSFORM_LOCAL_TO_TRANS);
			}
			if(o is Object4d){
				objectArray.push(o);
				//(o as Object4d).toWorldPosition(Constants.TRANSFORM_LOCAL_TO_TRANS);
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
				if(object.state == Constants.POLY4D_STATE_CLIPPED){
					continue;
				}
				rm.transform_object4d(object,cam.mcam,Constants.TRANSFORM_TRANS_ONLY,false);
				cam.cameraToPerspective_object(object);
				cam.perspectiveToScreen_obj(object);
//				var vertice:Point4d;
//				g.lineStyle(1,0,1);
//				var tempI:int = 0;
//				for (var i:int = 0; i < object.numVertices; i+=3) 
//				{
//					for (var k:int = i; k < i+3; k++) 
//					{
//						vertice = object.vlist_trans[k];		
//						if(vertice==null)
//							continue;
//						g.moveTo(vertice.x,vertice.y);
//						var a:int = k == i+2?i:k+1;
//						g.lineTo(object.vlist_trans[a].x,object.vlist_trans[a].y);
//					}					
//				}
				
				for (var i:int = 0; i < object.numPolys; i++) 
				{
					temp = object.poly_vec[i];
					if(temp==null||
						!(temp.state&Constants.POLY4D_STATE_ACTIVE)||
						temp.state&Constants.POLY4D_STATE_CLIPPED||
						temp.state&Constants.POLY4D_STATE_BACKFACE)
						continue;
					g.lineStyle(1,0,1);
//					for (var j:int = 0; j < 3; j++) 
//					{
//						
//						g.moveTo(temp.tvlist[j].x,temp.tvlist[j].y);
//						var a:int = j == 2?0:j+1;
//						g.lineTo(temp.tvlist[a].x,temp.tvlist[a].y);
//					}
					g.beginFill(0x666666, 1);
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