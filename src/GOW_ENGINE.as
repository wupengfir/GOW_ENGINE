package
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import core.Constants;
	import core.geometry.matrix.GowMatrix;
	import core.load.ModelLoader;
	import core.load.PLG_Loader;
	import core.math.Vector4d;
	import core.util.Util;
	
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
		public function GOW_ENGINE()
		{
			//stage.frameRate = 60;
			addChild(new Test8_2);
			var monitor:MonitorKit = new MonitorKit(MonitorKit.MKMODE_T);
			addChild(monitor);
//			var s = new ModelLoader().preTreat("  sdf \r //werfff");
			var i:int = 0;
			var t:Number = new Date().getTime();
			//trace(new Date().getTime());
			while(i<1000000){
				Util.distance({x:38,y:22,z:65},{x:0,y:0,z:0});
				i++;
			}
			var t1:Number = new Date().getTime();
			trace(t1 - t);
			i=0;
			while(i<1000000){
				Util.fast_distance({x:38,y:22,z:65},{x:0,y:0,z:0});
				i++;
			}
			trace(new Date().getTime() - t1);
//			trace();
//			trace(Util.fast_distance({x:38,y:22,z:65},{x:0,y:0,z:0}));
			
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