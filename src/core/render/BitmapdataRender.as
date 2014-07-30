package core.render
{
	import core.util.Util;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BitmapdataRender extends Sprite
	{
		public var screen:Bitmap;
		public var canva:BitmapData;
		public var pen_pos:Point = new Point();
		public var line_color:uint = 0xff000000;
		
		private var back:BitmapData;
		private var rec:Rectangle;
		private var p:Point = new Point();
		
		private var min_clip_x:int,min_clip_y:int,max_clip_x:int,max_clip_y:int;
		public function BitmapdataRender(width:int,height:int)
		{
			canva = new BitmapData(width,height);
			back = new BitmapData(width,height);
			rec = new Rectangle(0,0,width,height)
			screen = new Bitmap(canva);
			addChild(screen);
			min_clip_x = min_clip_y = 0;
			max_clip_x = canva.width;
			max_clip_y = canva.height;
		}
		
		public function moveTo(x:Number,y:Number):void{
			pen_pos.x = x;
			pen_pos.y = y;
		}
		
		public function clear():void{
			canva.copyPixels(back,rec,p);
		}
		
		public function lineTo_v2(x:Number,y:Number):void{
			var x0:int = pen_pos.x;
			var y0:int = pen_pos.y;
			var x1:int = Math.round(x);
			var y1:int = Math.round(y);
			var dx:int,dy:int,dx2:int,dy2:int,x_inc:int,y_inc:int,error:int,index:int;
			dx = x1 - pen_pos.x;
			dy = y1 - pen_pos.y;
			if(dx>=0){
				x_inc = 1;
			}else{
				x_inc = -1;
				dx = -dx;
			}
			if(dy>=0){
				y_inc = 1;
			}else{
				y_inc = -1;
				dy = -dy;
			}
			dx2 = dx<<1;
			dy2 = dy<<1;
			if(dx > dy){// 近X轴直线  
				error = dy2 - dx;
				for (index = 0; index < dx; index++) 
				{
					canva.setPixel32(x0,y0,line_color);
					if(error > 0){
						
						error -= dx2;  
						y0 += y_inc;  
					}  
					error += dy2;  
					x0 += x_inc; 
				}
				
			}
			else // 近Y轴直线  
			{  
				error = dx2 - dy;  
				for (index = 0; index <= dy; index++)  
				{  
					canva.setPixel32(x0, y0, line_color);  
					if (error >= 0)  
					{  
						error -= dy2;  
						x0 += x_inc;  
					}  
					error += dx2;  
					y0 += y_inc;  
				}  
			} 
			moveTo(x,y);
		}
		
		private function lineTo(x:Number,y:Number):void{
			var k:Number = (y-pen_pos.y)/(x-pen_pos.x);
			if(k<1&&k>-1){
				var sx:int = Math.round(x<=pen_pos.x?x:pen_pos.x);
				var sy:int = Math.round(sx==x?y:pen_pos.y);
				var ex:int = Math.round(x>=pen_pos.x?x:pen_pos.x);
				var ry:int;
				var index:int = 1;
				if(sx == ex){
					canva.setPixel32(sx,sy,line_color);
					return;
				}
				while(sx < ex){
					ry = Math.round(sy+k*index);
					canva.setPixel32(sx,ry,line_color);
					sx++;
					index++;
				}
			}else{
				k = 1/k;
				var sx:int = Math.round(x<=pen_pos.x?x:pen_pos.x);
				var sy:int = Math.round(sx==x?y:pen_pos.y);
				var ey:int = Math.round(y>=pen_pos.y?y:pen_pos.y);
				var rx:int;
				var index:int = 1;
				if(sy == ey){
					canva.setPixel32(sx,sy,line_color);
					return;
				}
				while(sy < ey){
					rx = Math.round(sx+k*index);
					canva.setPixel32(rx,sy,line_color);
					sy++;
					index++;
				}
			}
			
			moveTo(x,y);
		}

		
		public function drawTriangle(x1:Number,y1:Number,
			x2:Number, y2:Number,
			 x3:Number, y3:Number,
			color:uint):void
		{
			// this function draws a triangle on the destination buffer
			// it decomposes all triangles into a pair of flat top, flat bottom
			
			var  temp_x:Number, // used for sorting
			temp_y:Number,
			new_x:Number;
					
			
			// test for h lines and v lines
			if ((Util.float_equal(x1,x2) && Util.float_equal(x2,x3))  ||  (Util.float_equal(y1,y2) && Util.float_equal(y2,y3)))
				return;
			
			// sort p1,p2,p3 in ascending y order
			if (y2 < y1)
			{
				temp_x = x1;x1=x2;x2=temp_x;
				temp_y = y1;y1=y2;y2=temp_y;
			} // end if
			
			// now we know that p1 and p2 are in order
			if (y3 < y1)
			{
				temp_x = x1;x1=x3;x3=temp_x;
				temp_y = y1;y1=y3;y3=temp_y;
			} // end if
			
			// finally test y3 against y2
			if (y3 < y2)
			{
				temp_x = x2;x2=x3;x3=temp_x;
				temp_y = y2;y2=y3;y3=temp_y;
			} // end if
			
			// do trivial rejection tests for clipping
			if ( y3 < min_clip_y || y1 > max_clip_y ||
				(x1 < min_clip_x && x2 < min_clip_x && x3 < min_clip_x) ||
				(x1 > max_clip_x && x2 > max_clip_x && x3 > max_clip_x) )
				return;
			
			// test if top of triangle is flat
			if (Util.float_equal(y1,y2))
			{
				Draw_Top_Tri2_16(x1,y1,x2,y2,x3,y3,color);
			} // end if
			else
				if (Util.float_equal(y2,y3))
				{
					Draw_Bottom_Tri2_16(x1,y1,x2,y2,x3,y3,color);
				} // end if bottom is flat
				else
				{
					// general triangle that's needs to be broken up along long edge
					new_x = x1 + (y2-y1)*(x3-x1)/(y3-y1);
					
					// draw each sub-triangle
					Draw_Bottom_Tri2_16(x1,y1,new_x,y2,x2,y2,color);
					Draw_Top_Tri2_16(x2,y2,new_x,y2,x3,y3,color);
				} // end else
			
		}
		
		public function Draw_Top_Tri2(x1:Number,y1:Number,
			x2:Number, y2:Number,
			x3:Number, y3:Number,
			color:uint):void
		{
			// this function draws a triangle that has a flat top
			
			var dx_right:Number = 0,    // the dx/dy ratio of the right edge of line
			dx_left:Number = 0,     // the dx/dy ratio of the left edge of line
			xs:Number = 0,xe:Number = 0,       // the starting and ending points of the edges
			height:Number = 0,      // the height of the triangle
			temp_x:Number = 0,      // used during sorting as temps
			temp_y:Number = 0,
			right:Number = 0,       // used by clipping
			left:Number = 0;
			
			var  iy1:int,iy3:int,loop_y:int; // integers for y loops
			
			// destination address of next scanline
			var dest_addr:int = 0;
			// test order of x1 and x2
			if (x2 < x1)
			{
				temp_x = x1;x1=x2;x2=temp_x;
			} // end if swap
			
			// compute delta's
			height = y3-y1;
			
			dx_left  = (x3-x1)/height;
			dx_right = (x3-x2)/height;
			
			// set starting points
			xs = x1;
			xe = x2;
				// perform y clipping
				if (y1 < min_clip_y)
				{
					// compute new xs and ys
					xs = xs+dx_left*(-y1+min_clip_y);
					xe = xe+dx_right*(-y1+min_clip_y);
					
					// reset y1
					y1 = min_clip_y;
				} // end if top is off screen
			
			if (y3 > max_clip_y)
				y3 = max_clip_y;
			
			// make sure top left fill convention is observed
			iy1 = Math.ceil(y1);
			iy3 = Math.ceil(y3)-1;
			
			// compute starting address in video memory
			dest_addr = iy1;
			
			// test if x clipping is needed
			if (x1>=min_clip_x && x1<=max_clip_x &&
				x2>=min_clip_x && x2<=max_clip_x &&
				x3>=min_clip_x && x3<=max_clip_x)
			{
				// draw the triangle
				for (loop_y=iy1; loop_y<=iy3; loop_y++,dest_addr+=1)
				{
					// draw the line
					(UCHAR *)dest_addr+(unsigned int)xs, color,(unsigned int)((int)xe-(int)xs+1);
					for (var i:int = 0; i < xe-xs+1; i++) 
					{
						
					}
					
					canva.setPixel32(xs,);
					// adjust starting point and ending point
					xs+=dx_left;
					xe+=dx_right;
				} // end for
				
			} // end if no x clipping needed
			else
			{
				// clip x axis with slower version
				
				// draw the triangle
				for (temp_y=iy1; temp_y<=iy3; temp_y++,dest_addr+=mempitch)
				{
					// do x clip
					left  = xs;
					right = xe;
					
					// adjust starting point and ending point
					xs+=dx_left;
					xe+=dx_right;
					
					// clip line
					if (left < min_clip_x)
					{
						left = min_clip_x;
						
						if (right < min_clip_x)
							continue;
					}
					
					if (right > max_clip_x)
					{
						right = max_clip_x;
						
						if (left > max_clip_x)
							continue;
					}
					// draw the line
					memset((UCHAR  *)dest_addr+(unsigned int)left, color,(unsigned int)((int)right-(int)left+1));
				} // end for
				
			} // end else x clipping needed
			
		}
		
	}
}