package core.load
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class FileLoader3D
	{
		private var loader:URLLoader = new URLLoader;
		public function FileLoader3D()
		{
			
		}
		
		public function load(path:String):void{
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.load(new URLRequest(path));
			loader.addEventListener(Event.COMPLETE,onComplete);
		}
		
		private function onComplete(e:Event):void{
			var data:ByteArray = e.target.data as ByteArray;
		}
		
	}
}