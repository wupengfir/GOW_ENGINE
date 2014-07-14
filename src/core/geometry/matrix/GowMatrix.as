package core.geometry.matrix
{
	import core.math.Point4d;
	import core.math.Vector4d;

	public class GowMatrix
	{
		
		public var values:Vector.<Number>;
		public var type:int;
		public var rowNum:int;
		public var columnNum:int;
		public function GowMatrix(type:int,values:Vector.<Number>)
		{
			rowNum = type/10;
			columnNum = type%10;
			if(rowNum*columnNum!=values.length){
				throw(new Error("matrix type or values is wrong"));
			}
			this.type = type;
			this.values = values;

		}
		
		public function multiply(m:Object):Object{
			if(m is GowMatrix){
				if(columnNum != m.rowNum){
					throw new Error("matrix could not be muliplied");
				}
				var vec:Vector.<Number> = new Vector.<Number>(rowNum*m.columnNum);
				var temp:Number = 0;
				var a:int;
				var b:int;
				for (var i:int = 0; i < rowNum*m.columnNum; i++) 
				{
					a = i/m.columnNum;
					b = i%m.columnNum;
					for (var j:int = 0; j < columnNum; j++) 
					{
						
						temp += values[a*columnNum+j]*m.values[j*m.columnNum+b];
						
					}
					vec[i] = temp;
					temp = 0;
				}
				
				return new GowMatrix(rowNum*10+m.columnNum,vec);
			}
			if(m is Point4d){
				var vec:Vector.<Number> = new Vector.<Number>(4);
				vec.push((m as Point4d).x);
				vec.push((m as Point4d).y);
				vec.push((m as Point4d).z);
				vec.push((m as Point4d).w);
				var ma:GowMatrix = new GowMatrix(14,vec);				
				var result:GowMatrix =  ma.multiply(this);
				return result;
			}
			if(m is Vector4d){
				var vec:Vector.<Number> = new Vector.<Number>(4);
				vec.push((m as Vector4d).x);
				vec.push((m as Vector4d).y);
				vec.push((m as Vector4d).z);
				vec.push((m as Vector4d).w);
				var ma:GowMatrix = new GowMatrix(14,vec);				
				var result:GowMatrix =  ma.multiply(this);
				return result;
			}
			return null;
		}
		
		
		
	}
}

















