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
			lightList[numLights] = m;
			numLights++;
		}
		
		public static function resetMaterials():void{
			for (var i:int = 0; i < numLights; i++) 
			{
				lightList[i].dispose();
			}
			numLights = 0;
		}
		
	}
}