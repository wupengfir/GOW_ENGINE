package
{
	import core.Constants;
	import core.geometry.matrix.GowMatrix;
	import core.geometry.object.Object4d;
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
	
	public class TestObject extends Sprite
	{
		public var cam_pos:Point4d = new Point4d(0,0,-100,1);
		public var cam_dir:Vector4d = new Vector4d(0,0,0,1);
		public var cam:Camera;
		public var renderList:RenderList4d = new RenderList4d();
		public var obj:Object4d = new Object4d();
		public var poly:Poly4df;
		public var poly_pos:Point4d = new Point4d(0,0,100,1);
		public var mrot:GowMatrix = new GowMatrix(44);
		public var ang_y:Number = 0;
		public var rm:RenderManager = new RenderManager();
		
		private var world:World = new World();
		public function TestObject()
		{
			var l:PLG_Loader = new PLG_Loader(PLG_Loader.TYPE_OBJECT);
			l.load("tank1.plg",new Vector3d(1,1,1),new Point4d(0,0,0,1));
			cam = new Camera();
			cam.initCamera(0,cam_pos,cam_dir,null,50,500,90,950,650);			
			l.addEventListener(PLG_Loader.LOAD_COMPLETE,onComplete);
			addEventListener(Event.ADDED_TO_STAGE,function(e:Event):void{
				addEventListener(Event.ENTER_FRAME,onEnter);
				stage.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
				stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
				stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			});
			world.camera = cam;
			obj.worldPosition = poly_pos;
			world.objectArray.push(obj);
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
			obj.addVertices(e.target.objectVerticesData);
			obj.fillPolyVec();
		}
		
		public function onEnter(e:Event):void{
			var cos:Number = Math.cos(Util.deg_to_rad(ang_y));
			var sin:Number = Math.sin(Util.deg_to_rad(ang_y));
			if(++ang_y>=360)ang_y = 0;
			mrot.init([cos,0,-sin,0,
				0,1,0,0,
				sin,0,cos,0,
				0,0,0,1]);
//			mrot.init([1,0,0,0,
//				0,cos,sin,0,
//				0,-sin,cos,0,
//				0,0,0,1]);
			rm.transform_object4d(obj,mrot,Constants.TRANSFORM_LOCAL_TO_TRANS,false);			
			obj.toWorldPosition(Constants.TRANSFORM_TRANS_ONLY);
			
			cam.removeBackfaces_obj(obj);
			
			world.render();
		}
		
	}
}













