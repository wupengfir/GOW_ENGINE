package core.load
{
	import core.Constants;
	import core.geometry.poly.Poly4df;
	import core.math.Point4d;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class PLG_Loader extends EventDispatcher
	{
		private var loader:URLLoader = new URLLoader;
		private var scale;
		private var pos:Point4d;
		public static const LOAD_COMPLETE:String = "complete";
		
		public var polyData:Array = new Array();
		public function PLG_Loader()
		{
			
		}
		
		public function load(path:String,scale:Number,worldPos:Point4d):void{
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
//				if(info.indexOf("vertex list")!=-1){
//					verF = true;
//					continue;
//				}
//				if(info.indexOf("polygon list")!=-1){
//					verLF = true;
//					verF = false;
//					continue;
//				}
//				
//				if(info.length==0){
//					continue;
//				}
				
				if(numv!=0){
					values = splitString(info);
					vertexList.push(new Point4d(Number(values[0])*scale+pos.x,Number(values[1])*scale+pos.y,-Number(values[2])*scale+pos.z,1));
					numv--;
					if(numv == 0)continue;
				}
				if(nump!=0&&numv==0){
					values = info.split(" ");
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
			dispatchEvent(new Event(LOAD_COMPLETE));
		}
		
	}
}