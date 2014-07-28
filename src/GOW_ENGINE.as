package
{
	import core.geometry.matrix.GowMatrix;
	import core.load.ModelLoader;
	import core.load.PLG_Loader;
	import core.math.Vector4d;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
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
		public function GOW_ENGINE()
		{
			//stage.frameRate = 60;
			addChild(new Test8_2);
			var monitor:MonitorKit = new MonitorKit(MonitorKit.MKMODE_T);
			addChild(monitor);
//			var s = new ModelLoader().preTreat("  sdf \r //werfff");
			
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