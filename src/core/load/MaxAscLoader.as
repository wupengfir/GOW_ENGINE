package core.load
{
	import core.geometry.object.Object4d_v2;
	import core.geometry.poly.Poly4df;
	import core.math.Point3d;
	import core.math.Point4d;
	
	import flash.events.Event;
	import flash.utils.ByteArray;

	public class MaxAscLoader extends ModelLoader
	{
		public var object:Object4d_v2 = new Object4d_v2();
		
		public var pointData:Array = new Array();
		public function MaxAscLoader()
		{
		}
		
		override protected function onComplete(e:Event):void{
			var data:String = new String(e.target.data as ByteArray);
			var infoList = data.split("\n");
			var attribute:Array;
			var info:String;
			for(var i:int = 0; i < infoList.length; i++){
				info = infoList[i] as String;
				info = preTreat(info);
				if(info.indexOf("#")!=-1||info == ""){
					continue;
				}
				if(info.indexOf("Vertex") == 0){
					attribute = splitString(info);
					if(attribute.length  > 2){
						var x:Number = Number(attribute[2].split(":")[1]*scale.x);
						var y:Number = Number(attribute[3].split(":")[1]*scale.y);
						var z:Number = Number(attribute[4].split(":")[1]*scale.z);
						objectVerticesData.push(new Point4d(x,y,z));
					}
				}
				if(info.indexOf("Face") == 0){
					attribute = splitString(info);
					if(attribute.length  > 2){
						//var poly:Poly4df = new Poly4df();
						var a:Number = Number(attribute[2].split(":")[1]);
						var b:Number = Number(attribute[3].split(":")[1]);
						var c:Number = Number(attribute[4].split(":")[1]);
						//poly.addPoint(objectVerticesData[a],objectVerticesData[b],objectVerticesData[c]);
						//polyData.push(poly);
						pointData.push(new Point3d(a,b,c));
					}
				}
			}
			object.addVertices(objectVerticesData);
			object.poly_point_match_data = pointData;
			object.fillPolyVec();
			super.onComplete(null);
		}
		
	}
}