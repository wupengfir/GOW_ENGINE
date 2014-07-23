package core
{
	public class Constants
	{
		public static const RENDERLISTD_MAX_POLYS:int = 1024;
		public static const OBJECT4D_MAX_VERTICES:int = 1024;
		
		public static const POLY4D_ATTR_2SIDES:int = 0x0001;
		public static const POLY4D_ATTR_TRANSPARENT:int = 0x0002;
		public static const POLY4D_ATTR_8BITCOLOR:int = 0x0004;
		public static const POLY4D_ATTR_RGB16:int = 0x0008;
		public static const POLY4D_ATTR_RGB24:int = 0x0010;		
		public static const POLY4D_ATTR_SHADE_MODE_PURE:int = 0x0020;
		public static const POLY4D_ATTR_SHADE_MODE_FLAT:int = 0x0040;
		public static const POLY4D_ATTR_SHADE_MODE_GOURAUD:int = 0x0080;
		public static const POLY4D_ATTR_SHADE_MODE_PHONG:int = 0x0100;
		
		public static const POLY4D_STATE_ACTIVE:int = 0x0001;
		public static const POLY4D_STATE_CLIPPED:int = 0x0002;
		public static const POLY4D_STATE_BACKFACE:int = 0x0004;
		
		public static const OBJECT_STATE_ACTIVE:int = 0x0001;
		public static const OBJECT_STATE_CLIPPED:int = 0x0002;
		public static const OBJECT_STATE_VISIBLE:int = 0x0004;
		
		public static const TRANSFORM_LOCAL_ONLY:int = 0;
		public static const TRANSFORM_TRANS_ONLY:int = 1;
		public static const TRANSFORM_LOCAL_TO_TRANS:int = 2;
		
		public static const CULL_X:int = 0x0001;
		public static const CULL_Y:int = 0x0002;
		public static const CULL_Z:int = 0x0004;
		public static const CULL_XYZ:int = 0x0007;
		
		public static const UNV_MODE_SIMPLE:int = 0;
		public static const UNV_MODE_SPHERICAL:int = 1;
		public function Constants()
		{
		}
	}
}