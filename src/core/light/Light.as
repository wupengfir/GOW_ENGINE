package core.light
{
	import core.math.Point4d;
	import core.math.Vector4d;

	public class Light
	{
		public static const LIGHTV1_ATTR_AMBIENT:int = 0x0001;
		public static const LIGHTV1_ATTR_INFINITE:int = 0x0002;
		public static const LIGHTV1_ATTR_POINT:int = 0x0004;
		public static const LIGHTV1_ATTR_SPOTLIGHT_SIMPLE:int = 0x0008;
		public static const LIGHTV1_ATTR_SPOTLIGHT_COMPLICATE:int = 0x0010;
		public static const LIGHTV1_STATE_ON:int = 1;
		public static const LIGHTV1_STATE_OFF:int = 0;
		
		public var state:int;
		public var id:int;
		public var name:String;
		public var attr:int;
		
		public var c_ambient:uint;
		public var c_diffuse:uint;
		public var c_specular:uint;
		public var pos:Point4d = new Point4d();
		public var dir:Vector4d = new Vector4d();
		public var kc:Number = 0;
		public var kl:Number = 0;
		public var kq:Number = 0;
		public var spot_inner:Number = 0;
		public var spot_outer:Number = 0;
		public var pf:Number = 0;
		
		public function Light()
		{
		}
		
		public function init(state:int,attr:int,
							 c_ambient:uint,c_diffuse:uint,c_specular:uint,
							kc:Number,kl:Number,kq:Number,pos:Point4d,dir:Vector4d,
							spot_inner:Number,spot_outer:Number,pf:Number):void{
//			if(index<0||index>LightManager.LIGHTV1_MAX_LIGHTS){
//				return;
//			}
			this.state = state;
			this.attr = attr;
			this.c_ambient = c_ambient;
			this.c_diffuse = c_diffuse;
			this.c_specular = c_specular;
			this.kc = kc;
			this.kl = kl;
			this.kq = kq;
			this.pos.copyFromPoint4d(pos);
			this.dir.copyFromVector4d(dir);
			this.spot_inner = spot_inner;
			this.spot_outer = spot_outer;
			this.pf = pf;
		}
		
	}
}





















