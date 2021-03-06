package core.math
{
	import core.geometry.matrix.GowMatrix;

	public class Point4d
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var w:Number;
		public function Point4d(x:Number = 0,y:Number = 0,z:Number = 0,w:Number = 1)
		{
			this.x = x;
			this.y = y;
			this.z = z;
			this.w = w;
		}
		
		public function copyFromPoint4d(p:Object):Point4d{
			this.x = p.x;
			this.y = p.y;
			this.z = p.z;
			this.w = p.w;
			return this;
		}
		
		public function copyFromMatrix(m:GowMatrix):Point4d{
			this.x = m.values[0];
			this.y = m.values[1];
			this.z = m.values[2];
			this.w = m.values[3];
			return this;
		}
		
		public function add(p:Point4d,store:Point4d):void{
			store.x = this.x + p.x;		
			store.y = this.y + p.y;
			store.z = this.z + p.z;
		}
		
	}
}