package core.render
{
	import flash.display.BitmapData;
	import flash.geom.Point;

	public class BitmapdataRender
	{
		
		public var canva:BitmapData;
		public var pen_pos:Point = new Point();
		
		public function BitmapdataRender(width:int,height:int)
		{
			canva = new BitmapData(width,height);
		}
		
		public function moveTo(x:Number,y:Number):void{
			pen_pos.x = x;
			pen_pos.y = y;
		}
		
		public function lineTo(x:Number,y:Number):void{
			
			moveTo(x,y);
		}
		
		public function drawTriangle():void{
			
		}
		
	}
}