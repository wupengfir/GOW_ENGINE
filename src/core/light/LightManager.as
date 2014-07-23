package core.light
{
	public class LightManager
	{
		public static const LIGHTV1_MAX_LIGHTS:int = 16;
		
		public static var lightList:Vector.<Light> = new Vector.<Light>(LIGHTV1_MAX_LIGHTS);
		public static var numLights:int;
		public function LightManager()
		{
		}
		
		public static function addLight(m:Light):void{
			m.id = numLights;
			lightList[numLights] = m;
			numLights++;
		}
		
		public static function resetLights():void{
			numLights = 0;
		}
		
	}
}