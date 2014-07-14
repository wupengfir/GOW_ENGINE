package core.math
{
	public class Vector3d
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public function Vector3d(x:Number,y:Number,z:Number)
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		public function init(x:Number,y:Number,z:Number):void{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
	}
}