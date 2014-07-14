package core
{
	public class Constants
	{
		public static const RENDERLISTD_MAX_POLYS:int = 1024;
		public static const OBJECT4D_MAX_VERTICES:int = 1024;
		
		public static const POLY4D_ATTR_2SIDES:int = 0x0001;
		public static const POLY4D_ATTR_TRANSPARENT:int = 0x0002;
		public static const POLY4D_ATTR_8BITCOLOR:int = 0x0008;
		public static const POLY4D_ATTR_RGB16:int = 0x0008;
		public static const POLY4D_ATTR_RGB24:int = 0x0010;
		
		public static const POLY4D_ATTR_SHADE_MODE_PURE:int = 0x0020;
		public static const POLY4D_ATTR_SHADE_MODE_FLAT:int = 0x0040;
		public static const POLY4D_ATTR_SHADE_MODE_GOURAUD:int = 0x0080;
		public static const POLY4D_ATTR_SHADE_MODE_PHONG:int = 0x0100;
		
		public static const POLY4D_STATE_ACTIVE:int = 0x0001;
		public static const POLY4D_STATE_CLIPPED:int = 0x0002;
		public static const POLY4D_STATE_BACKFACE:int = 0x0004;
		
		public function Constants()
		{
		}
	}
}