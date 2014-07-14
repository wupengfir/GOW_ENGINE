package core.math
{
	import core.geometry.matrix.GowMatrix;

	public class Point4d
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var w:Number;
		public function Point4d(x:Number,y:Number,z:Number,w:Number)
		{
			this.x = x;
			this.y = y;
			this.z = z;
			this.w = w;
		}
		
		public function copyFromPoint4d(p:Point4d):void{
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
		
		public function add(p:Point4d,store:Point4d):void{
			store.x = this.x + p.x;		
			store.y = this.y + p.y;
			store.z = this.z + p.z;
		}
		
	}
}