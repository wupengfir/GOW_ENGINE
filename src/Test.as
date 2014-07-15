package
{
	import core.Constants;
	import core.geometry.matrix.GowMatrix;
	import core.geometry.poly.Poly4d;
	import core.geometry.poly.Poly4df;
	import core.math.Point4d;
	import core.math.Vector4d;
	import core.render.Camera;
	import core.render.RenderList4d;
	import core.render.RenderManager;
	import core.util.Util;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Test extends Sprite
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
		public function Test()
		{
			poly = new Poly4df();
			poly.state = Constants.POLY4D_STATE_ACTIVE;
			poly.attr = 0;
			poly.vlist[0] = new Point4d(0,50,0,1);
			poly.vlist[1] = new Point4d(50,-50,0,1);
			poly.vlist[2] = new Point4d(-50,-50,0,1);
			cam = new Camera();
			cam.initCamera(0,cam_pos,cam_dir,null,50,500,90,950,650);			
			var index:int;
			renderList.addPoly(poly);
			addEventListener(Event.ENTER_FRAME,onEnter);
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
			//trace(mrot.values);
			renderList.toWorldPosition(poly_pos,Constants.TRANSFORM_TRANS_ONLY);
			cam.initWorldToCameraMatrix_Euler();
			rm.transform_renderList(renderList,cam.mcam,Constants.TRANSFORM_TRANS_ONLY);
			cam.cameraToPerspective(renderList);
			cam.perspectiveToScreen(renderList);
			render();
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
















