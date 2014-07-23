package core.mat
{
	import flash.display.BitmapData;

	public class Material
	{
		public static const MATV1_ATTR_2SIDED:int = 0x0001;		
		public static const MATV1_ATTR_TRANSPARENT:int = 0x0001;
		
		public static const MATV1_ATTR_SHADE_MODE_CONSTANT:int = 0x0020;
		public static const MATV1_ATTR_SHADE_MODE_FLAT:int = 0x0040;
		public static const MATV1_ATTR_SHADE_MODE_GOURAUD:int = 0x0080;
		public static const MATV1_ATTR_SHADE_MODE_FASTPHONG:int = 0x0100;
		public static const MATV1_ATTR_SHADE_MODE_TEXTURE:int = 0x0200;

		public static const MATV1_STATE_ACTIVE:int = 0x0001;
		
		
		public var state:int;
		public var id:int;
		public var name:String;
		public var attr:int;
		public var color:uint;
		public var ka:Number = 0;
		public var kd:Number = 0;
		public var ks:Number = 0;
		public var power:Number = 0;
		
		public var ra:uint;
		public var rd:uint;
		public var rs:uint;
		
		public var texturePath:String;
		public var bitmapdataAvailable:Boolean = false;
		public var _bitmapdata:BitmapData;
		public function Material()
		{
		}
		
		public function set bitmapdata(data:BitmapData):void{
			_bitmapdata = data;
			bitmapdataAvailable = true;
		}
		
		public function get bitmapdata():BitmapData{
			if(bitmapdataAvailable){
				return _bitmapdata;
			}else{
				return null;
			}
		}
		
		public function dispose():void{
			if(bitmapdataAvailable){
				_bitmapdata.dispose();
				bitmapdataAvailable = false;
			}
		}
		
	}
}












