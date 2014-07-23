package
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import core.geometry.matrix.GowMatrix;
	import core.load.PLG_Loader;
	import core.math.Vector4d;
	
	import monitor.MonitorKit;
	
	import test.Test7_1;
	import test.Test7_2;
	import test.Test7_3;
	import test.Test7_4;
	import test.Test8_1;
	
	[SWF( width = "950", height = "650", frameRate = "30", backgroundColor = "0x3366FF" )]
	public class GOW_ENGINE extends Sprite
	{
		private var i:Number = 5;
		private var dic:Array = new Array();
		private var iiii:int;
		public function GOW_ENGINE()
		{
			//stage.frameRate = 60;
			addChild(new Test8_1);
			var monitor:MonitorKit = new MonitorKit(MonitorKit.MKMODE_T);
			addChild(monitor);
			
//			var i:BitmapData = new BitmapData(100,100);
//			i.dispose();
//			trace(i.width);
			
//			var v:Vector4d = new Vector4d(0,1,0);
//			var v1:Vector4d = new Vector4d(0,-1,1);
//			var v2:Vector4d = new Vector4d(0,-1,-1);
//			var temp:Vector4d = new Vector4d();
//			v.cross(v1,temp);
//			trace(temp.x +"  "+ temp.y +"   "+ temp.z);
//			v.cross(v2,temp);
//			trace(temp.x +"  "+ temp.y +"   "+ temp.z);
			
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