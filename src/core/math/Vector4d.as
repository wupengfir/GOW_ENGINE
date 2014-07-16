package core.math
{
	import core.geometry.matrix.GowMatrix;

	public class Vector4d
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var w:Number;
		public function Vector4d(x:Number = 0,y:Number = 0,z:Number = 0,w:Number = 0)
		{
			this.x = x;
			this.y = y;
			this.z = z;
			this.w = w;
		}
		public function copyFromVector4d(p:Vector4d):void{
			this.x = p.x;
			this.y = p.y;
			this.z = p.z;
			this.w = p.w;
		}
		public function copyFromMatrix(m:GowMatrix):void{
			this.x = m.values[0];
			this.y = m.values[1];
			this.z = m.values[2];
			this.w = m.values[3];
		}
		
		public function minus():void{
			this.x = -x;
			this.y = -y;
			this.z = -z;
		}
		
	}
}