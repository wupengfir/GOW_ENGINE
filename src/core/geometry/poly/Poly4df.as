package core.geometry.poly
{
	import core.Constants;
	import core.geometry.object.Object4d;
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
		
		public function addPoint(obj:Object4d,p1:int,p2:int,p3:int):void{
			vlist[0] = obj.vlist_local[p1];
			tvlist[0] = obj.vlist_trans[p1];
			vlist[1] = obj.vlist_local[p2];
			tvlist[1] = obj.vlist_trans[p2];
			vlist[2] = obj.vlist_local[p3];
			tvlist[2] = obj.vlist_trans[p3];
		}
		
		public function reSetPoint():void{
			
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
		
		public function calculateOriginNormalVector():void{
			var x1:Number = tvlist[1].x-tvlist[0].x;
			var y1:Number = tvlist[1].y-tvlist[0].y;
			var z1:Number = tvlist[1].z-tvlist[0].z;
			var u:Vector4d = new Vector4d(x1,y1,z1,1);
			var x2:Number = tvlist[2].x-tvlist[0].x;
			var y2:Number = tvlist[2].y-tvlist[0].y;
			var z2:Number = tvlist[2].z-tvlist[0].z;
			var v:Vector4d = new Vector4d(x2,y2,z2,1);
			normalVector.x = u.y*v.z-v.y*u.z;
			normalVector.y = u.z*v.x-u.x*v.z;
			normalVector.z = u.x*v.y-v.x*u.y;
			normalVector.w = 1;
		}
		
		public function calculateNormalVector():void{
			var x1:Number = tvlist[1].x-tvlist[0].x;
			var y1:Number = tvlist[1].y-tvlist[0].y;
			var z1:Number = tvlist[1].z-tvlist[0].z;
			var u:Vector4d = new Vector4d(x1,y1,z1,1);
			var x2:Number = tvlist[2].x-tvlist[0].x;
			var y2:Number = tvlist[2].y-tvlist[0].y;
			var z2:Number = tvlist[2].z-tvlist[0].z;
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














