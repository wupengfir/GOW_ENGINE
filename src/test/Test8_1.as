package test
{
	import core.Constants;
	import core.geometry.matrix.GowMatrix;
	import core.geometry.object.Object4d;
	import core.geometry.poly.Poly4d;
	import core.geometry.poly.Poly4df;
	import core.light.Light;
	import core.light.LightManager;
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
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	public class Test8_1 extends Sprite
	{
		public var cam_pos:Point4d = new Point4d(0,0,-100,1);
		public var cam_dir:Vector4d = new Vector4d(0,0,0,1);
		public var cam:Camera;
		public var renderList:RenderList4d = new RenderList4d();
		public var obj:Object4d = new Object4d();
		public var poly:Poly4df;
		public var poly_pos:Point4d = new Point4d(0,-100,300,1);
		public var copy:Point4d = new Point4d(0,-100,300,1);
		
		public var mrot:GowMatrix = new GowMatrix(44);
		public var ang_y:Number = 0;
		public var rm:RenderManager = new RenderManager();
		
		private var world:World = new World();
		public function Test8_1()
		{
			var l:PLG_Loader = new PLG_Loader(PLG_Loader.TYPE_OBJECT);
			l.load("tower1.plg",new Vector3d(1,1,1),new Point4d(0,0,0,1));
			cam = new Camera();
			cam.initCamera(Camera.CAMERA_TYPE_EULER,cam_pos,cam_dir,null,50,500,90,950,650);			
			l.addEventListener(PLG_Loader.LOAD_COMPLETE,onComplete);
			addEventListener(Event.ADDED_TO_STAGE,function(e:Event):void{
				addEventListener(Event.ENTER_FRAME,onEnter);
				stage.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
				stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
				stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
				stage.addEventListener(KeyboardEvent.KEY_UP,keyup);
				stage.addEventListener(KeyboardEvent.KEY_DOWN,keydown);
				stage.addEventListener(MouseEvent.CLICK,onClick);
			});
			world.camera = cam;
			
			obj.worldPosition = poly_pos;	
			
			addChild(world);
		}
		
		private var moveback:Boolean = false;
		private var moveright:Boolean = false;
		private var moveleft:Boolean = false;
		private var movefront:Boolean = false;
		private var moveup:Boolean = false;
		private var movedown:Boolean = false;
		private var turnright:Boolean = false;
		private var turnleft:Boolean = false;
		public function keyup(event:KeyboardEvent):void{
			if (event.keyCode==83) {
				moveback=false;
			} else if (event.keyCode==69) {
				moveright=false;
			} else if (event.keyCode==81) {
				moveleft=false;
			} else if (event.keyCode==87) {
				movefront=false;
			}else if (event.keyCode==32) {
				moveup=false;
			}else if (event.keyCode==82) {
				movedown=false;
			}else if (event.keyCode==65) {
				turnleft=false;
			}else if (event.keyCode==68) {
				turnright=false;
			}
			
			
		}
		
		public function keydown(event:KeyboardEvent):void {
			if (event.keyCode==83) {
				moveback=true;
			} else if (event.keyCode==69) {
				moveright=true;
			} else if (event.keyCode==81) {
				moveleft=true;
			} else if (event.keyCode==87) {
				movefront=true;
			}else if (event.keyCode==32) {
				moveup=true;
			}else if (event.keyCode==82) {
				movedown=true;
			}else if (event.keyCode==65) {
				turnleft=true;
			}else if (event.keyCode==68) {
				turnright=true;
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
		
		private var light:Light = new Light();
		private function onComplete(e:Event):void{
			obj.addVertices(e.target.objectVerticesData);
			obj.fillPolyVec(e.target.color);
			for (var i:int = 0; i < 10; i++) 
			{
				var o:Object4d = new Object4d().copyFromObject4d(obj);
				o.worldPosition = new Point4d((i%5)*200,0,(int(i/5))*200+100,1);
				world.add(o);
			}
			//			obj.rotationY = 180;
			world.add(obj);
			LightManager.addLight(light);
			light.init(Light.LIGHTV1_STATE_ON,Light.LIGHTV1_ATTR_AMBIENT,0x00ffffff,0,0,0,0,0,null,null,0,0,0);
			
		}
		
		private function onClick(e:MouseEvent):void{
			obj.rotationY = 180;
		}
		
		private var turning:int = 0;
		
		private var mv:Vector4d = new Vector4d();
		private var obj_tv:Vector4d = new Vector4d();
		private var my_obj:GowMatrix = new GowMatrix(44);
		private var mx1:GowMatrix = new GowMatrix(44);
		private var my:GowMatrix = new GowMatrix(44);
		private var mz:GowMatrix = new GowMatrix(44);
		public function onEnter(e:Event):void{
			mv.setProperty(0,0,0,1);
			obj_tv.setProperty(0,0,0,1);
			if(moveright){
				mv.x +=10; 
			}
			if(moveleft){
				mv.x -=10; 
			}
			if(movefront){
				mv.z +=10;
			}
			if(moveback){
				mv.z -=10;
			}
			if(moveup){
				mv.y +=10;
			}
			if(movedown){
				mv.y -=10;
			}
			if(turnleft){
				cam.dir.y -= .1;
				obj_tv.y -= .1;
				turning -= 2;
				if(turning<-16)turning = -16;
			}
			if(turnright){
				cam.dir.y += .1;
				obj_tv.y += .1;
				turning += 2;
				if(turning>16)turning = 16;
			} 
			var t_x:Number = cam.dir.x;
			var t_y:Number = cam.dir.y;
			var t_z:Number = cam.dir.z;
			var cos_t:Number = Math.cos(t_x);
			var sin_t:Number = Math.sin(t_x);
			mx1.init([1,0,0,0,
				0,cos_t,sin_t,0,
				0,-sin_t,cos_t,0,
				0,0,0,1]);
			cos_t = Math.cos(t_y);
			sin_t = Math.sin(t_y);
			my.init([cos_t,0,-sin_t,0,
				0,1,0,0,
				sin_t,0,cos_t,0,
				0,0,0,1]);
			cos_t = Math.cos(t_z);
			sin_t = Math.sin(t_z);
			mz.init([cos_t,sin_t,0,0,
				-sin_t,cos_t,0,0,
				0,0,1,0,
				0,0,0,1]);
			var temp:GowMatrix = my.multiply(mz) as GowMatrix;
			temp = temp.multiply(mx1);
			mv.copyFromMatrix(temp.multiply(mv));
			cam.pos.x += mv.x;
			cam.pos.y += mv.y;
			cam.pos.z += mv.z;
			
			
			poly_pos.copyFromPoint4d(copy);
			obj.worldPosition.copyFromMatrix(my.multiply(poly_pos));
			obj.worldPosition.x += cam.pos.x; 
			obj.worldPosition.y += cam.pos.y;
			obj.worldPosition.z += cam.pos.z;
			//			poly_pos.x = cam.pos.x + copy.x;
			//			poly_pos.y = cam.pos.y + copy.y;
			//			poly_pos.z = cam.pos.z + copy.z;
			//			obj.worldPosition.copyFromMatrix(my.multiply(poly_pos));
			if(!turnleft&&!turnright){
				if(turning<0)turning += 2;
				if(turning>0)turning -= 2;
			}
			obj.rotationY = cam.dir.y*180/Math.PI + 180 + turning;
			
			//			obj.worldPosition.x = cam.pos.x+300*Math.sin(cam.dir.y);
			//			obj.worldPosition.y = cam.pos.y-70;
			//			obj.worldPosition.z = cam.pos.z+300*Math.cos(cam.dir.y);
			//			obj.rotationY = cam.dir.y*180/Math.PI + 180;
			
			//			++ang_y;
			//			obj.rotationY = ang_y;
			
			//			obj.rotation_world = true;
			//			obj.ry_world = cam.dir.y*180/Math.PI;
			
			
			world.render(true);
		}
		
	}
}













