package core.geometry.plane
{
	import core.math.Point3d;
	import core.math.Vector3d;

	public class Plane3d
	{
		public var p:Point3d;
		public var v:Vector3d;
		public function Plane3d()
		{
		}
		
		public function init(p:Point3d,v:Vector3d):void{
			this.p = new Point3d(p.x,p.y,p.z);
			this.v = new Vector3d(v.x,v.y,v.z);
		}
		
	}
}