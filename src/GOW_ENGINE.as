package
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import core.geometry.matrix.GowMatrix;
	
	[SWF( width = "950", height = "650", frameRate = "30", backgroundColor = "0x3366FF" )]
	public class GOW_ENGINE extends Sprite
	{
		private var i:Number = 5;
		private var dic:Array = new Array();
		private var iiii:int;
		public function GOW_ENGINE()
		{
			var m1:GowMatrix = new GowMatrix(22,ii([1,1,2,0]));
			var m2:GowMatrix = new GowMatrix(23,ii([0,2,3,1,1,2]));
			trace(m1.multiply(m2).values);
			trace(0x0001+2)
			trace(iiii)
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