package test
{
	import core.Constants;
	import core.geometry.matrix.GowMatrix;
	import core.geometry.poly.Poly4d;
	import core.geometry.poly.Poly4df;
	import core.load.PLG_Loader;
	import core.math.Point4d;
	import core.math.Vector3d;
	import core.math.Vector4d;
	import core.render.Camera;
	import core.render.RenderList4d;
	import core.render.RenderManager;
	import core.render.World;
	import core.util.Util;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Test7_1 extends Sprite
	{
		
		public var cam_pos:Point4d = new Point4d(0,0,-100,1);
		public var cam_dir:Vector4d = new Vector4d(0,0,0,1);
		public var cam:Camera;
		public var renderList:RenderList4d = new RenderList4d();
		public var poly:Poly4df;
		public var poly_pos:Point4d = new Point4d(0,0,100,1);
		public var mrot:GowMatrix = new GowMatrix(44);
		public var ang_y:Number = 0;
		public var rm:RenderManager = new RenderManager();
		
		private var world:World = new World();
		public function Test7_1()
		{
			var l:PLG_Loader = new PLG_Loader(PLG_Loader.TYPE_RENDERLIST);
			l.load("cube2.plg",new Vector3d(10,10,10),new Point4d(0,0,0,1));
			cam = new Camera();
			cam.initCamera(0,cam_pos,cam_dir,null,50,500,90,950,650);			
			l.addEventListener(PLG_Loader.LOAD_COMPLETE,onComplete);
			addEventListener(Event.ADDED_TO_STAGE,function(e:Event):void{
				addEventListener(Event.ENTER_FRAME,onEnter);
				stage.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
				stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
				stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			});
			//renderList.toWorldPosition(poly_pos,Constants.TRANSFORM_TRANS_ONLY);
			world.camera = cam;
			world.renderListArray.push(renderList);
			addChild(world);
		}
		private var flag:Boolean = false;
		private var cx:Number;
		private var cy:Number;
		private var dirx:Number;
		private var diry:Number;
		private function onDown(e:MouseEvent):void{
			flag = true;
			cx = e.stageX;
			cy = e.stageY;
			dirx = cam.dir.x;
			diry = cam.dir.y;
		}
		
		public function onMove(e:MouseEvent):void{
			if(!flag)
			return;
			var cx_dis:Number = e.stageX - cx;
			var cy_dis:Number = e.stageY - cy;
			cam.dir.x = dirx - cy_dis/1000;
			cam.dir.y = diry - cx_dis/1000;
			trace(cam.dir.x +"    "+cam.dir.y);
		}
		
		private function onUp(e:MouseEvent):void{
			flag = false;
		}
		
		private function onComplete(e:Event):void{
			renderList.addPoly(e.target.polyData);
		}
		
		public function onEnter(e:Event):void{
			var cos:Number = Math.cos(Util.deg_to_rad(ang_y));
			var sin:Number = Math.sin(Util.deg_to_rad(ang_y));
			if(++ang_y>=360)ang_y = 0;
			mrot.init([cos,0,-sin,0,
						0,1,0,0,
						sin,0,cos,0,
						0,0,0,1]);
			rm.transform_renderList(renderList,mrot,Constants.TRANSFORM_LOCAL_TO_TRANS);
			renderList.toWorldPosition(new Point4d(0,0,200,0),Constants.TRANSFORM_TRANS_ONLY);
//			cam.initWorldToCameraMatrix_Euler();
//			rm.transform_renderList(renderList,cam.mcam,Constants.TRANSFORM_TRANS_ONLY);
//			cam.cameraToPerspective_renderlist(renderList);
//			cam.perspectiveToScreen_renderlist(renderList);
			world.render();
		}
		
		public function render():void{
			
			var g:Graphics = this.graphics;
			g.clear();
			var temp:Poly4df;
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
		
	}
}
















