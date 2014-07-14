package core.geometry.object
{
	import core.Constants;
	import core.math.Point4d;
	import core.math.Vector4d;

	public class Object4d
	{
		public var id:int;
		public var name:String;
		public var state:int;
		public var attr:int;
		public var avgRadius:Number;
		public var maxRadius:Number;
		public var worldPosition:Point4d;
		//物体方向向量
		public var dir:Vector4d;
		//物体局部坐标轴
		public var ux:Vector4d;
		public var uy:Vector4d;
		public var uz:Vector4d;
		//顶点数
		public var numVertices:int;
		//顶点局部坐标
		public var vlist_local:Vector.<Point4d> = new Vector.<Point4d>(Constants.OBJECT4D_MAX_VERTICES,true);
		//变换后的顶点坐标
		public var tvlist_local:Vector.<Point4d> = new Vector.<Point4d>(Constants.OBJECT4D_MAX_VERTICES,true);
		public function Object4d()
		{
		}
	}
}