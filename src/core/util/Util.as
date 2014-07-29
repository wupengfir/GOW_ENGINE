package core.util
{
	import core.Constants;

	public class Util
	{
		
		public static function deg_to_rad(a:Number):Number{
			return a*Math.PI/180;
		}
		
		public static function ARGB(a:uint,r:uint,g:uint,b:uint):uint{
			a = a<0?0:a;a = a>254?254:a;
			r = r<0?0:r;r = r>254?254:r;
			g = g<0?0:g;g = g>254?254:g;
			b = b<0?0:b;b = b>254?254:b;
			return a<<24|r<<16|g<<8|b;
		}
		
		public static function distance(a:Object,b:Object):Number{
			return Math.sqrt((b.x-a.x)*(b.x-a.x)+(b.y-a.y)*(b.y-a.y)+(b.z-a.z)*(b.z-a.z));
		}
		
		private static var temp:Number = 0;
		private static var x:Number = 0;
		private static var y:Number = 0;
		private static var z:Number = 0;
		public static function fast_distance(a:Object,b:Object):Number{
			x = Math.abs(b.x - a.x)<<10;
			y = Math.abs(b.y - a.y)<<10;
			z = Math.abs(b.z - a.z)<<10;
			if(y < x){temp = y;y=x;x=temp;}
			if(z < y){temp = y;y=z;z=temp;}
			if(y < x){temp = y;y=x;x=temp;}
			return (z+11*(y>>5)+(x>>2))>>10;
		}
		
		public static function float_equal(a:Number,b:Number):Boolean{
			var x:Number = Math.abs(a-b);
			if(x<Constants.ALMOST_ZERO)
				return true;
			return false;
		}
		
		public function Util()
		{
		}
	}
}