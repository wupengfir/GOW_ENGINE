package
{
	import core.Constants;
	import core.geometry.matrix.GowMatrix;
	import core.load.ModelLoader;
	import core.load.PLG_Loader;
	import core.math.Vector4d;
	import core.render.BitmapdataRender;
	import core.util.Util;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import monitor.MonitorKit;
	
	import test.Test7_1;
	import test.Test7_2;
	import test.Test7_3;
	import test.Test7_4;
	import test.Test8_1;
	import test.Test8_2;
	
	[SWF( width = "950", height = "650", frameRate = "30", backgroundColor = "0x3366FF" )]
	public class GOW_ENGINE extends Sprite
	{
		private var i:Number = 5;
		private var dic:Array = new Array();
		private var iiii:int;
		private var screen:BitmapdataRender;// = new BitmapdataRender()
		public function GOW_ENGINE()
		{
			stage.frameRate = 60;
			addChild(new Test8_2);
			var monitor:MonitorKit = new MonitorKit(MonitorKit.MKMODE_T);
			stage.addChild(monitor);
			
//			screen = new BitmapdataRender(stage.fullScreenWidth,stage.fullScreenHeight);
//			addChild(screen);
//			screen.moveTo(10,20);
//			screen.lineTo_v2(50,220);
//			screen.lineTo_v2(180,260);
//			screen.screen.alpha = .5;
//			screen.graphics.lineStyle(0,1);
//			screen.graphics.moveTo(110,20);
//			screen.graphics.lineTo(150,220);
//			screen.graphics.lineTo(280,260);
//			addEventListener(Event.ENTER_FRAME,function(e:Event):void{
//				screen.line_color = (0xff<<24)|Math.random()*0xffffff;		
//				screen.moveTo(Math.random()*screen.canva.width,Math.random()*screen.canva.height);
//				screen.lineTo(Math.random()*screen.canva.width,Math.random()*screen.canva.height);
//			});
		}
		
		public function ii(arr:Array):Vector.<Number>{
			var index:int = 0;
			var result:Vector.<Number> = new Vector.<Number>(arr.length);
			for each(var i:Number in arr){
				result[index] = i;
				index++;
			}
			return result;
		}
		
	}
	

	
}