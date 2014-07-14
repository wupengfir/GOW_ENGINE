package core.render
{
	import core.Constants;
	import core.geometry.matrix.GowMatrix;
	import core.geometry.object.Object4d;
	import core.geometry.poly.Poly4df;
	import core.math.Point4d;
	import core.math.Vector4d;

	public class RenderManager
	{
		public function RenderManager()
		{
		}
		
		public function transform_renderList(list:RenderList4d,matrix:GowMatrix,coord_select:int){
			var temp:Poly4df;
			switch(coord_select){
				case Constants.TRANSFORM_LOCAL_ONLY:
					
					for (var i:int = 0; i < list.num_polys; i++) 
					{
						temp = list.poly_vec[i];
						if(temp==null||
						!(temp.state&Constants.POLY4D_STATE_ACTIVE)||
						temp.state&Constants.POLY4D_STATE_CLIPPED||
						temp.state&Constants.POLY4D_STATE_BACKFACE)
							continue;
						for (var j:int = 0; j < 3; j++) 
						{
							var result:GowMatrix = matrix.multiply(temp.vlist[j]);
							temp.vlist[j].copyFromMatrix(result);
						}
						
					}
					
					break;
				case Constants.TRANSFORM_TRANS_ONLY:
					
					for (var i:int = 0; i < list.num_polys; i++) 
					{
						temp = list.poly_vec[i];
						if(temp==null||
							!(temp.state&Constants.POLY4D_STATE_ACTIVE)||
							temp.state&Constants.POLY4D_STATE_CLIPPED||
							temp.state&Constants.POLY4D_STATE_BACKFACE)
							continue;
						for (var j:int = 0; j < 3; j++) 
						{
							var result:GowMatrix = matrix.multiply(temp.tvlist[j]);
							temp.tvlist[j].copyFromMatrix(result);
						}
						
					}
					break;
				case Constants.TRANSFORM_LOCAL_TO_TRANS:
					for (var i:int = 0; i < list.num_polys; i++) 
					{
						temp = list.poly_vec[i];
						if(temp==null||
							!(temp.state&Constants.POLY4D_STATE_ACTIVE)||
							temp.state&Constants.POLY4D_STATE_CLIPPED||
							temp.state&Constants.POLY4D_STATE_BACKFACE)
							continue;
						for (var j:int = 0; j < 3; j++) 
						{
							var result:GowMatrix = matrix.multiply(temp.vlist[j]);
							temp.tvlist[j].copyFromMatrix(result);
						}
						
					}
					break;
			}
		}
		
		public function transform_object4d(obj:Object4d,matrix:GowMatrix,coord_select:int,transform_basis:Boolean):void{
			var temp:Point4d;
			var result:GowMatrix
			switch(coord_select){
				case Constants.TRANSFORM_LOCAL_ONLY:
					
					for (var i:int = 0; i < obj.numVertices; i++) 
					{
						temp = obj.vlist_local[i];
						var result:GowMatrix = matrix.multiply(temp);
						temp.copyFromMatrix(result);		
					}
					break;
				case Constants.TRANSFORM_TRANS_ONLY:
					
					for (var i:int = 0; i < obj.numVertices; i++) 
					{
						temp = obj.vlist_trans[i];
						result = matrix.multiply(temp);
						temp.copyFromMatrix(result);		
					}
					break;
				case Constants.TRANSFORM_LOCAL_TO_TRANS:
					
					for (var i:int = 0; i < obj.numVertices; i++) 
					{
						temp = obj.vlist_local[i];
						result = matrix.multiply(temp);
						obj.vlist_trans[i].copyFromMatrix(result);		
					}
					break;
			}
			if(transform_basis){
				var tempV:Vector4d = obj.ux;
				result = matrix.multiply(tempV);
				obj.ux.copyFromMatrix(result);
				
				tempV = obj.uy;
				result = matrix.multiply(tempV);
				obj.uy.copyFromMatrix(result);
				
				tempV = obj.uz;
				result = matrix.multiply(tempV);
				obj.uz.copyFromMatrix(result);
			}
		}
		
	}
}


















