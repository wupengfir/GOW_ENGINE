package core.geometry.poly
{
	import core.Constants;
	import core.math.Point4d;
	import core.math.Vector4d;

	public class Poly4df
	{
		public var state:int;
		public var attr:int;
		public var color:uint = 0xffffff;
		public var color_trans:uint;
		public var avg_z:Number = 0;
		public var vlist:Vector.<Point4d> = new Vector.<Point4d>(3);
		public var tvlist:Vector.<Point4d> = new Vector.<Point4d>(3);
		public var normalVector:Vector4d = new Vector4d();
		public var next:Poly4df;
		public var prec:Poly4df;
		public function Poly4df()
		{
			for (var i:int = 0; i < 3; i++) 
			{
				tvlist[i] = new Point4d();
			}
			state = Constants.POLY4D_STATE_ACTIVE;
		}
		
		public function addPoint(p1:Point4d,p2:Point4d,p3:Point4d):void{
			vlist[0] = new Point4d().copyFromPoint4d(p1);
			tvlist[0] = p1;
			vlist[1] = new Point4d().copyFromPoint4d(p2);
			tvlist[1] = p2;
			vlist[2] = new Point4d().copyFromPoint4d(p3);
			tvlist[2] = p3;
		}
		
		public function calculateAvgZ():void{
			avg_z = (tvlist[0].z+tvlist[1].z+tvlist[2].z)/3;
		}
		
		public function avaliable():Boolean{
			if(!(this.state&Constants.POLY4D_STATE_ACTIVE)||
				this.state&Constants.POLY4D_STATE_CLIPPED||
				this.state&Constants.POLY4D_STATE_BACKFACE)
			return false;
			return true;
		}
		
		public function calculateNormalVector():void{
			var x1:Number = tvlist[1].x-tvlist[0].x;
			var y1:Number = tvlist[1].y-tvlist[0].y;
			var z1:Number = tvlist[1].z-tvlist[0].z;
			//var w1:Number = Math.sqrt(x1*x1+y1*y1+z1*z1);
			var u:Vector4d = new Vector4d(x1,y1,z1,1);
			var x2:Number = tvlist[2].x-tvlist[0].x;
			var y2:Number = tvlist[2].y-tvlist[0].y;
			var z2:Number = tvlist[2].z-tvlist[0].z;
			//var w2:Number = Math.sqrt(x2*x2+y2*y2+z2*z2);;
			var v:Vector4d = new Vector4d(x2,y2,z2,1);
			normalVector.x = u.y*v.z-v.y*u.z;
			normalVector.y = u.z*v.x-u.x*v.z;
			normalVector.z = u.x*v.y-v.x*u.y;
			normalVector.w = 1;
			normalVector.normalize();
			//normalVector.minus();
		}
		
	}
}














