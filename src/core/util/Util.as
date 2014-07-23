package core.util
{
	public class Util
	{
		
		public static function deg_to_rad(a:Number):Number{
			return a*Math.PI/180;
		}
		
		public static function ARGB(a:int,r:int,g:Number,b:Number):uint{
			a = a<0?0:a;a = a>255?255:a;
			r = r<0?0:r;r = r>255?255:r;
			g = g<0?0:g;g = g>255?255:g;
			b = b<0?0:b;b = b>255?255:b;
			return a<<24|r<<16|g<<8|b;
		}
		
		public function Util()
		{
		}
	}
}