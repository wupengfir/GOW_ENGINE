package
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
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
	
	public class Test7_3 extends Sprite
	{
		public var cam_pos:Point4d = new Point4d(100,0,-100,1);
		public var cam_dir:Vector4d = new Vector4d(0,0,100,1);
		public var target:Point4d = new Point4d(0,0,400,1);
		public var cam:Camera;
		public var renderList:RenderList4d = new RenderList4d();
		public var obj:Object4d = new Object4d();
		public var poly:Poly4df;
		public var poly_pos:Point4d = new Point4d(0,0,100,1);
		public var mrot:GowMatrix = new GowMatrix(44);
		public var ang_y:Number = 0;
		public var rm:RenderManager = new RenderManager();
		
		private var world:World = new World();
		private var cameraDistance:Number = 0;
		public function Test7_3()
		{
			var l:PLG_Loader = new PLG_Loader(PLG_Loader.TYPE_OBJECT);
			l.load("tank1.plg",new Vector3d(1,1,1),new Point4d(0,0,0,1));
			cam = new Camera();
			cam.initCamera(Camera.CAMERA_TYPE_UVN,cam_pos,cam_dir,target,400,5000,90,950,650);			
			l.addEventListener(PLG_Loader.LOAD_COMPLETE,onComplete);
			addEventListener(Event.ADDED_TO_STAGE,function(e:Event):void{
				addEventListener(Event.ENTER_FRAME,onEnter);
				stage.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
				stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
				stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
				stage.addEventListener(KeyboardEvent.KEY_UP,keyup);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,keydown);
			});
			world.camera = cam;
			
			obj.worldPosition = poly_pos;			
			//world.objectArray.push(obj);
			addChild(world);
			cameraDistance = 500;
		}
		
		private var moveback:Boolean = false;
		private var moveright:Boolean = false;
		private var moveleft:Boolean = false;
		private var movefront:Boolean = false;
		private var moveup:Boolean = false;
		private var movedown:Boolean = false;
		public function keyup(event:KeyboardEvent):void{
			if (event.keyCode==83) {
				moveback=false;
			} else if (event.keyCode==68) {
				moveright=false;
			} else if (event.keyCode==65) {
				moveleft=false;
			} else if (event.keyCode==87) {
				movefront=false;
			}else if (event.keyCode==32) {
				moveup=false;
			}else if (event.keyCode==82) {
				movedown=false;
			}
			
		}
		
		public function keydown(event:KeyboardEvent):void {
			if (event.keyCode==83) {
				moveback=true;
			} else if (event.keyCode==68) {
				moveright=true;
			} else if (event.keyCode==65) {
				moveleft=true;
			} else if (event.keyCode==87) {
				movefront=true;
			}else if (event.keyCode==32) {
				moveup=true;
			}else if (event.keyCode==82) {
				movedown=true;
			}
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
			for (var i:int = 0; i < 20; i++) 
			{
				var o:Object4d = new Object4d().copyFromObject4d(obj);
				o.worldPosition = new Point4d((i%5)*200,0,(int(i/5))*200+100,1);
				world.add(o);
			}
			var ooo:Object4d = new Object4d().copyFromObject4d(obj);
			ooo.scale(new Vector3d(.1,.1,.1));
			ooo.worldPosition = new Point4d(0,0,400,1);
			world.add(ooo);
		}
		
		private var view_ang:Number = 0;
		public function onEnter(e:Event):void{
//			if(moveright){
//				cam.pos.x +=10*Math.cos(-cam.dir.y); 
//				cam.pos.z +=10*Math.sin(-cam.dir.y); 
//			}
//			if(moveleft){
//				cam.pos.x -=10*Math.cos(-cam.dir.y); 
//				cam.pos.z -=10*Math.sin(-cam.dir.y);
//			}
			if(moveright){
				cam.pos.x +=10;
			}
			if(moveleft){
				cam.pos.x -=10;
			}
			if(movefront){
				cam.pos.z +=10;
			}
			if(moveback){
				cam.pos.z -=10;
			}
			if(moveup){
				cam.pos.y +=10;
			}
			if(movedown){
				cam.pos.y -=10;
			} 
			//++ang_y;
			for each(var o:Object4d in world.objectArray){
				o.rotationZ = ang_y;
			}
			if(++view_ang>360){
				view_ang = 0;
			}
//			cam.pos.x = cameraDistance*Math.cos(Util.deg_to_rad(view_ang));
//			cam.pos.y = cameraDistance*Math.sin(Util.deg_to_rad(view_ang));
//			cam.pos.z = 2*cameraDistance*Math.sin(Util.deg_to_rad(view_ang));
			//cam.pos.z = -cameraDistance*Math.cos(Util.deg_to_rad(view_ang))+400;
			world.render();
		}
		
	}
}













