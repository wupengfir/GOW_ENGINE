package core.mat
{
	public class MaterialManager
	{
		public static const MATV1_MAX_MATERIALS:int = 256;
		public static var materialList:Vector.<Material> = new Vector.<Material>(MATV1_MAX_MATERIALS);
		public static var numMaterials:int;
		public function MaterialManager()
		{
		}
		
		public static function addMaterial(m:Material):void{
			materialList[numMaterials] = m;
			numMaterials++;
		}
		
		public static function resetMaterials():void{
			numMaterials = 0;
		}
		
	}
}