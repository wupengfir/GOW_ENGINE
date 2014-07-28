package core.load
{
	import core.math.Point4d;
	import core.math.Vector3d;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	public class ModelLoader extends EventDispatcher
	{
		protected var loader:URLLoader = new URLLoader;
		protected var scale:Vector3d;
		protected var pos:Point4d;
		public  var color:Array = new Array;
		public static const LOAD_COMPLETE:String = "complete";
		public static const TYPE_OBJECT:int = 0;
		public static const TYPE_RENDERLIST:int = 1;
		public var polyData:Array = new Array();
		public var objectVerticesData:Array = new Array();
		
		public function load(path:String,scale:Vector3d,worldPos:Point4d):void{
			this.scale = scale;
			this.pos = worldPos;
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.load(new URLRequest(path));
			loader.addEventListener(Event.COMPLETE,onComplete);
		}
		
		protected function onComplete(e:Event):void{
			dispatchEvent(new Event(LOAD_COMPLETE));
		}
		
		public function preTreat(str:String):String{
			if(str == null)return "";
			str = removeNote(str);
			var _str:String="";    
			var flag:Boolean = false;
			var index:int = 0;
			while(str.charAt(index) == " "){
				index++;
			}
			_str = str.substr(index);
			index = _str.length - 1;
			while(_str.charAt(index) == " "||_str.charAt(index) == "\r"){
				index--;
			}
			if(index<_str.length - 1){
				_str = _str.substring(0,index+1);
			}
			return _str;
		}
		
		public function removeNote(str:String):String{
			return str.split("//")[0];
		}
		
		public function splitString(s:String):Array{
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
		
		public function ModelLoader()
		{
		}
	}
}