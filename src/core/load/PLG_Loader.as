package core.load
{
	import core.Constants;
	import core.geometry.poly.Poly4df;
	import core.math.Point4d;
	import core.math.Vector3d;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class PLG_Loader extends EventDispatcher
	{
		private var loader:URLLoader = new URLLoader;
		private var scale:Vector3d;
		private var pos:Point4d;
		public static const LOAD_COMPLETE:String = "complete";
		public static const TYPE_OBJECT:int = 0;
		public static const TYPE_RENDERLIST:int = 1;
		public var polyData:Array = new Array();
		public var objectVerticesData:Array = new Array();
		private var type:int;
		public function PLG_Loader(type:int)
		{
			this.type = type;	
		}
		
		public function load(path:String,scale:Vector3d,worldPos:Point4d):void{
			this.scale = scale;
			this.pos = worldPos;
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.load(new URLRequest(path));
			loader.addEventListener(Event.COMPLETE,onComplete);
		}
		
		private function splitString(s:String):Array{
			var result:Array = new Array();
			var temp:String = "";
			for (var i:int = 0; i < s.length; i++) 
			{
				if(s.charAt(i)!=" "){
					temp+=s.charAt(i);
					if(i == s.length - 1){
						result.push(temp);
					}
				}else{
					if(temp == "")continue;
					var info:String = temp;
					result.push(info);
					temp = "";
				}
			}
			return result;
		}
		
		private function onComplete(e:Event):void{
			var data:ByteArray = e.target.data as ByteArray;
			var s:String = new String(data);
			var sa:Array = s.split("\r\n");
			var verF:Boolean = false;
			var verLF:Boolean = false;
			var vertexList:Array = new Array();
			var inited:Boolean = false;
			var numv:int;
			var nump:int;
			var values:Array;
			if(type == TYPE_RENDERLIST){
				for each(var info:String in sa){
					if(info.indexOf("#")!=-1||info==""){
						continue;
					}
					if(!inited){
						values = splitString(info);
						numv = int(values[1]);
						nump = int(values[2]);
						inited = true;
						continue;
					}				
					if(numv!=0){
						values = splitString(info);
						vertexList.push(new Point4d(Number(values[0])*scale.x+pos.x,Number(values[1])*scale.y+pos.y,-Number(values[2])*scale.z+pos.z,1));
						numv--;
						if(numv == 0)continue;
					}
					if(nump!=0&&numv==0){
						values = splitString(info);
						var poly:Poly4df = new Poly4df();
						poly.state = Constants.POLY4D_STATE_ACTIVE;
						poly.attr = 0;
						poly.vlist[0] = new Point4d().copyFromPoint4d(vertexList[values[2]] as Point4d);
						poly.vlist[1] = new Point4d().copyFromPoint4d(vertexList[values[3]] as Point4d);
						poly.vlist[2] = new Point4d().copyFromPoint4d(vertexList[values[4]] as Point4d);
						polyData.push(poly);
						nump--;
					}
				}
			}else{
				for each(var info:String in sa){
					if(info.indexOf("#")!=-1||splitString(info).length==0){
						continue;
					}
					if(!inited){
						values = splitString(info);
						numv = int(values[1]);
						nump = int(values[2]);
						inited = true;
						continue;
					}				
					if(numv!=0){
						values = splitString(info);
						vertexList.push(new Point4d(Number(values[0])*scale.x+pos.x,Number(values[1])*scale.y+pos.y,-Number(values[2])*scale.z+pos.z,1));
						numv--;
						if(numv == 0)continue;
					}
					if(nump!=0&&numv==0){
						values = splitString(info);
//						var poly:Poly4df = new Poly4df();
//						poly.state = Constants.POLY4D_STATE_ACTIVE;
//						poly.attr = 0;
//						poly.vlist[0] = new Point4d().copyFromPoint4d(vertexList[values[2]] as Point4d);
//						poly.vlist[1] = new Point4d().copyFromPoint4d(vertexList[values[3]] as Point4d);
//						poly.vlist[2] = new Point4d().copyFromPoint4d(vertexList[values[4]] as Point4d);
//						polyData.push(poly);
						objectVerticesData.push(new Point4d().copyFromPoint4d(vertexList[values[2]] as Point4d));
						objectVerticesData.push(new Point4d().copyFromPoint4d(vertexList[values[3]] as Point4d));
						objectVerticesData.push(new Point4d().copyFromPoint4d(vertexList[values[4]] as Point4d));
						nump--;
					}
				}
			}
			dispatchEvent(new Event(LOAD_COMPLETE));
		}
		
	}
}