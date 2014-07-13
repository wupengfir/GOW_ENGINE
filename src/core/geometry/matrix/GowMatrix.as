package core.geometry.matrix
{
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
		
		public function multiply(m:GowMatrix):GowMatrix{
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
		
	}
}

















