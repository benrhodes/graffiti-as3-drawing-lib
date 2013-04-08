/*
*  	Graffiti 2.5.6
*  	______________________________________________________________________
*  	www.nocircleno.com/graffiti/
*/

/*
* 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* 	OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* 	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* 	HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* 	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* 	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* 	OTHER DEALINGS IN THE SOFTWARE.
*/

package com.nocircleno.graffiti.tools {
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.LineScaleMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	import flash.filters.BlurFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import com.nocircleno.graffiti.tools.ITool;
	import com.nocircleno.graffiti.tools.ToolRenderType;
	import com.nocircleno.graffiti.tools.BrushType;
	import com.nocircleno.graffiti.utils.Conversions;
	
	/**
	* BrushTool Class allows the user to paint anti-alias shapes to the Canvas.
	*
	* @langversion 3.0
    * @playerversion Flash 10 AIR 1.5 
	*/
	final public class BrushTool extends BitmapTool {
		
		// store local references for performance reasons
		private const sin:Function = Math.sin;
		private const cos:Function = Math.cos;
		private const atan2:Function = Math.atan2;
		private const abs:Function = Math.abs;
		
		private var _size:Number;
		private var _halfSize:Number;
		private var _fourthSize:Number;
		private var _eighthSize:Number;
		private var _sixteenthSize:Number;
		private var _color:uint;
		private var _alpha:Number;
		private var _blur:Number;
		
		/**
		* The <code>BrushTool</code> constructor.
		* 
		* @param brushSize Size of the brush.
		* @param brushColor Color of the brush.
		* @param brushAlpha Alpha value of the brush.
		* @param brushBlur Blur value of the brush.
		* @param brushType Type of Brush
		* @param toolMode Tool mode the Brush will be drawing with.
		*
		* @example The following code creates a Brush instance.
		* <listing version="3.0" >
		* // create a diamond brush
		* var diamondBrush:BrushTool = new BrushTool(8, 0xFF0000, 1, 0, BrushType.DIAMOND);
		* </listing>
		* 
		*/
		public function BrushTool(brushSize:Number = 4, brushColor:uint = 0x000000, brushAlpha:Number = 1, brushBlur:Number = 0, brushType:String = null, toolMode:String = null) {
			
			// set render type
			_renderType = ToolRenderType.CONTINUOUS;
			
			// store size
			size = brushSize;
			
			// store color
			color = brushColor;
			
			// store alpha
			alpha = brushAlpha;
			
			// brush blur
			blur = brushBlur;
			
			// store type
			type = brushType;
			
			// store mode
			mode = toolMode;
			
		}
		
		/**
		* Size of the Brush
		*/
		public function set size(brushSize:Number):void {
			
			if(brushSize > 0) {
			
				// set brush size
				_size = brushSize;
				
				// calcuate divisions
				_halfSize = _size * .5;
				_fourthSize = _size * .25;
				_eighthSize = _size * .125;
				_sixteenthSize = _size * 0.0625;
				
			}
			
		}
		
		public function get size():Number {
			return _size;
		}
		
		/**
		* Color of the Brush
		*/
		public function set color(brushColor:uint):void {
			_color = brushColor;
		}

		public function get color():uint {
			return _color;
		}
		
		/**
		* Alpha of the Brush
		*/
		public function set alpha(brushAlpha:Number):void {
			
			if(brushAlpha < 0) {
				brushAlpha = 0;
			} else if(brushAlpha > 1) {
				brushAlpha = 1;
			}
			
			_alpha = brushAlpha;
		}

		public function get alpha():Number {
			return _alpha;
		}
		
		/**
		* Blur of the Brush
		*/
		public function set blur(brushBlur:Number):void {
			
			if(brushBlur < 0) {
				brushBlur = 0;
			}
			
			_blur = brushBlur;
			
		}

		public function get blur():Number {
			return _blur;
		}
		
		/**
		* Type of brush
		*/
		public override function set type(brushType:String):void {
			
			// determine type
			if(brushType != null && BrushType.validType(brushType)) {
				_type = brushType;
			} else {
				_type = BrushType.SQUARE;
			}
			
		}
		
		/**
		* The <code>generateBrush</code> method creates a visual representation of the Brush
		* that could be used for a button or a cursor.
		* 
		* @param brushSize Size of the brush, if you don't want to use the defined size.
		* @param brushColor Color of the brush, if you don't want to use the defined color.
		* 
		* @return A Sprite object containing the brush.
		*
		*/
		public function generateBrush(brushSize:Number = 0, brushColor:int = -1):Sprite {
			
			var brush_sp:Sprite = new Sprite();
			
			var xOffset:Number;
			var yOffset:Number;
			
			var genBrushSize:Number;
			var genBrushHalfSize:Number;
			var genBrushFourthSize:Number;
			var genBrushEighthSize:Number;
			var genBrushSixteenthSize:Number;
			var genColor:uint;
			
			// check brush size
			if(brushSize == 0) {
				genBrushSize = _size;
				genBrushHalfSize = _halfSize;
				genBrushFourthSize = _fourthSize;
				genBrushEighthSize = _eighthSize;
				genBrushSixteenthSize = _sixteenthSize;
			} else {
				genBrushSize = brushSize;
				genBrushHalfSize = brushSize/2;
				genBrushFourthSize = brushSize/4;
				genBrushEighthSize = brushSize/8;
				genBrushSixteenthSize = brushSize/16;
			}
			
			// check brush color
			if(brushColor < 0) {
				genColor = _color;
			} else {
				genColor = brushColor;
			}
			
			// apply blur filter if blur is grater than zero
			if(_blur > 0) {
				brush_sp.filters = [new BlurFilter(_blur, _blur, BitmapFilterQuality.MEDIUM)];
			}
			
			//////////////////////////////////////////////////////////
			// Round Shape Brush
			//////////////////////////////////////////////////////////
			if(_type == BrushType.ROUND) {
				
				brush_sp.graphics.beginFill(genColor, 1);
				brush_sp.graphics.drawCircle(0, 0, genBrushHalfSize);
				brush_sp.graphics.endFill();
				
			//////////////////////////////////////////////////////////
			// Rectangle Shape Brushes
			//////////////////////////////////////////////////////////
			} else if(_type == BrushType.HORIZONTAL_LINE || _type == BrushType.VERTICAL_LINE || _type == BrushType.SQUARE) {
				
				if(_type == BrushType.HORIZONTAL_LINE) {
					
					xOffset = genBrushHalfSize;
					yOffset = genBrushSixteenthSize;
					
				} else if(_type == BrushType.VERTICAL_LINE) {
					
					xOffset = genBrushSixteenthSize;
					yOffset = genBrushHalfSize;
					
				} else if(_type == BrushType.SQUARE) {
					
					xOffset = genBrushHalfSize;
					yOffset = genBrushHalfSize;
				
				}
				
				brush_sp.graphics.beginFill(genColor, 1);
				brush_sp.graphics.drawRect(- xOffset, - yOffset, xOffset << 1, yOffset << 1);
				brush_sp.graphics.endFill();
			
			//////////////////////////////////////////////////////////
			// Foward Line Shape Brush
			//////////////////////////////////////////////////////////
			} else if(_type == BrushType.FORWARD_LINE) {
				
				brush_sp.graphics.beginFill(genColor, 1);
				brush_sp.graphics.moveTo(genBrushHalfSize - genBrushEighthSize,  - genBrushHalfSize);
				brush_sp.graphics.lineTo(genBrushHalfSize, - genBrushHalfSize);
				brush_sp.graphics.lineTo(-genBrushHalfSize + genBrushEighthSize, genBrushHalfSize);
				brush_sp.graphics.lineTo(-genBrushHalfSize, genBrushHalfSize);
				brush_sp.graphics.lineTo(genBrushHalfSize - genBrushEighthSize,  - genBrushHalfSize);
				brush_sp.graphics.endFill();
				
			//////////////////////////////////////////////////////////
			// Backward Line Shape Brush
			//////////////////////////////////////////////////////////
			} else if(_type == BrushType.BACKWARD_LINE) {
				
				brush_sp.graphics.beginFill(genColor, 1);
				brush_sp.graphics.moveTo(-genBrushHalfSize + genBrushEighthSize, - genBrushHalfSize);
				brush_sp.graphics.lineTo(-genBrushHalfSize, - genBrushHalfSize);
				brush_sp.graphics.lineTo(genBrushHalfSize - genBrushEighthSize, genBrushHalfSize);
				brush_sp.graphics.lineTo(genBrushHalfSize, genBrushHalfSize);
				brush_sp.graphics.lineTo(-genBrushHalfSize + genBrushEighthSize, -genBrushHalfSize);
				brush_sp.graphics.endFill();
			
			//////////////////////////////////////////////////////////
			// Diamond Shape Brush
			//////////////////////////////////////////////////////////
			} else if(_type == BrushType.DIAMOND) {
				
				brush_sp.graphics.beginFill(genColor, 1);
				brush_sp.graphics.moveTo(0, -genBrushHalfSize);
				brush_sp.graphics.lineTo(genBrushHalfSize, 0);
				brush_sp.graphics.lineTo(0, genBrushHalfSize);
				brush_sp.graphics.lineTo(- genBrushHalfSize, 0);
				brush_sp.graphics.lineTo(0, - genBrushHalfSize);
				brush_sp.graphics.endFill();
				
			}
			
			return brush_sp;
			
		}
		
		/**
		* The <code>apply</code> method applies the brush to the DisplayObject passed
		* to the method.  We use two point due to the delay in Mouse Events to create
		* continuous  brush strokes.
		* 
		* @param drawingTarget Sprite that the brush will draw to.
		* @param point1 Starting point to apply brush.
		* @param point2 End point to apply brush.
		*/
		public override function apply(drawingTarget:DisplayObject, point1:Point, point2:Point = null):void {
			
			// cast target as a Sprite
			var targetCast:Sprite = Sprite(drawingTarget);
			
			var xOffset:Number;
			var yOffset:Number;
			var vPoint1:Point;
			var vPoint2:Point;
			var angleBetweenPoints:Number;
			
			// apply blur filter if blur is greater than zero
			if(_blur > 0 && targetCast.filters.length < 1) {
				targetCast.filters = [new BlurFilter(_blur, _blur, BitmapFilterQuality.MEDIUM)];
			}
			
			// if we only have one point then draw a single shape of the 
			if(point2 == null) {
				
				//////////////////////////////////////////////////////////
				// Round Shape Brush
				//////////////////////////////////////////////////////////
				if(_type == BrushType.ROUND) {
					
					commands.push(GraphicsPathCommand.MOVE_TO);
					drawingData.push(point1.x);
					drawingData.push(point1.y);
					
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(point1.x + 1);
					drawingData.push(point1.y + 1);
					
				//////////////////////////////////////////////////////////
				// Rectangle Shape Brushes
				//////////////////////////////////////////////////////////
				} else if(_type == BrushType.HORIZONTAL_LINE || _type == BrushType.VERTICAL_LINE || _type == BrushType.SQUARE) {
					
					if(_type == BrushType.HORIZONTAL_LINE) {
						
						xOffset = _halfSize;
						yOffset = _sixteenthSize;
						
					} else if(_type == BrushType.VERTICAL_LINE) {
						
						xOffset = _sixteenthSize;
						yOffset = _halfSize;
						
					} else if(_type == BrushType.SQUARE) {
						
						xOffset = _halfSize;
						yOffset = _halfSize;
					
					}
					
					commands.push(GraphicsPathCommand.MOVE_TO);
					drawingData.push(point1.x - xOffset);
					drawingData.push(point1.y - yOffset);
					
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(point1.x - xOffset + (xOffset << 1));
					drawingData.push(point1.y - yOffset);
					
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(point1.x - xOffset + (xOffset << 1));
					drawingData.push(point1.y - yOffset + (yOffset << 1));
					
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(point1.x - xOffset);
					drawingData.push(point1.y - yOffset + (yOffset << 1));
					
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(point1.x - xOffset);
					drawingData.push(point1.y - yOffset);
				
				//////////////////////////////////////////////////////////
				// Foward Line Shape Brush
				//////////////////////////////////////////////////////////
				} else if(_type == BrushType.FORWARD_LINE) {
					
					commands.push(GraphicsPathCommand.MOVE_TO);
					drawingData.push(point1.x + _halfSize - _eighthSize);
					drawingData.push(point1.y - _halfSize);
					
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(point1.x + _halfSize);
					drawingData.push(point1.y - _halfSize);
					
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(point1.x - _halfSize + _eighthSize);
					drawingData.push(point1.y + _halfSize);
					
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(point1.x - _halfSize);
					drawingData.push(point1.y + _halfSize);
					
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(point1.x + _halfSize - _eighthSize);
					drawingData.push(point1.y - _halfSize);
					
				//////////////////////////////////////////////////////////
				// Backward Line Shape Brush
				//////////////////////////////////////////////////////////
				} else if(_type == BrushType.BACKWARD_LINE) {
					
					commands.push(GraphicsPathCommand.MOVE_TO);
					drawingData.push(point1.x - _halfSize + _eighthSize);
					drawingData.push(point1.y - _halfSize);
					
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(point1.x - _halfSize);
					drawingData.push(point1.y - _halfSize);
					
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(point1.x + _halfSize - _eighthSize);
					drawingData.push(point1.y + _halfSize);
					
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(point1.x + _halfSize);
					drawingData.push(point1.y + _halfSize);
					
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(point1.x - _halfSize + _eighthSize);
					drawingData.push(point1.y - _halfSize);
					
				//////////////////////////////////////////////////////////
				// Diamond Shape Brush
				//////////////////////////////////////////////////////////
				} else if(_type == BrushType.DIAMOND) {
					
					commands.push(GraphicsPathCommand.MOVE_TO);
					drawingData.push(point1.x);
					drawingData.push(point1.y - _halfSize);
					
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(point1.x + _halfSize);
					drawingData.push(point1.y);
					
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(point1.x);
					drawingData.push(point1.y + _halfSize);
					
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(point1.x - _halfSize);
					drawingData.push(point1.y);
					
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(point1.x);
					drawingData.push(point1.y - _halfSize);
					
				}
				
			} else {
				
				// check for order of points
				if(point1.x <= point2.x) {
					vPoint1 = point1;
					vPoint2 = point2;
				} else {
					vPoint1 = point2;
					vPoint2 = point1;
				}
				
				//////////////////////////////////////////////////////////
				// Round Shape Brushes
				//////////////////////////////////////////////////////////
				if(_type == BrushType.ROUND) {
					
					commands.push(GraphicsPathCommand.MOVE_TO);
					drawingData.push(point1.x);
					drawingData.push(point1.y);
					
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(point2.x);
					drawingData.push(point2.y);
					
				//////////////////////////////////////////////////////////
				// Rectangle Shape Brushes
				//////////////////////////////////////////////////////////
				} else if(_type == BrushType.HORIZONTAL_LINE || _type == BrushType.VERTICAL_LINE || _type == BrushType.SQUARE) {
					
					if(_type == BrushType.HORIZONTAL_LINE) {
						
						xOffset = _halfSize;
						yOffset = _sixteenthSize;
						
					} else if(_type == BrushType.VERTICAL_LINE) {
						
						xOffset = _sixteenthSize;
						yOffset = _halfSize;
						
					} else if(_type == BrushType.SQUARE) {
						
						xOffset = _halfSize;
						yOffset = _halfSize;
					
					}
					
					if(vPoint1.y < vPoint2.y) {
						
						commands.push(GraphicsPathCommand.MOVE_TO);
						drawingData.push(vPoint1.x + xOffset);
						drawingData.push(vPoint1.y - yOffset);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x + xOffset);
						drawingData.push(vPoint2.y - yOffset);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x + xOffset);
						drawingData.push(vPoint2.y + yOffset);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x - xOffset);
						drawingData.push(vPoint2.y + yOffset);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x - xOffset);
						drawingData.push(vPoint1.y + yOffset);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x - xOffset);
						drawingData.push(vPoint1.y - yOffset);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x + xOffset);
						drawingData.push(vPoint1.y - yOffset);
						
					} else {
						
						commands.push(GraphicsPathCommand.MOVE_TO);
						drawingData.push(vPoint1.x - xOffset);
						drawingData.push(vPoint1.y - yOffset);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x - xOffset);
						drawingData.push(vPoint2.y - yOffset);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x + xOffset);
						drawingData.push(vPoint2.y - yOffset);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x + xOffset);
						drawingData.push(vPoint2.y + yOffset);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x + xOffset);
						drawingData.push(vPoint1.y + yOffset);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x - xOffset);
						drawingData.push(vPoint1.y + yOffset);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x - xOffset);
						drawingData.push(vPoint1.y - yOffset);
						
					}
					
				//////////////////////////////////////////////////////////
				// Foward Line Shape Brush
				//////////////////////////////////////////////////////////
				} else if(_type == BrushType.FORWARD_LINE) {
					
					angleBetweenPoints = Conversions.degrees(atan2(vPoint2.x - vPoint1.x, vPoint2.y - vPoint1.y));
					
					commands.push(GraphicsPathCommand.MOVE_TO);
					drawingData.push(vPoint1.x - _halfSize);
					drawingData.push(vPoint1.y + _halfSize);
					
					if(angleBetweenPoints >= 135) {
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x - _halfSize);
						drawingData.push(vPoint2.y + _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x + _halfSize - _eighthSize);
						drawingData.push(vPoint2.y - _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x + _halfSize);
						drawingData.push(vPoint2.y - _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x + _halfSize);
						drawingData.push(vPoint1.y - _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x - _halfSize + _eighthSize);
						drawingData.push(vPoint1.y + _halfSize);
						
					} else if(angleBetweenPoints >= 90) {
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x + _halfSize - _eighthSize);
						drawingData.push(vPoint1.y - _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x + _halfSize - _eighthSize);
						drawingData.push(vPoint2.y - _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x + _halfSize);
						drawingData.push(vPoint2.y - _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x - _halfSize + _eighthSize);
						drawingData.push(vPoint2.y + _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x - _halfSize + _eighthSize);
						drawingData.push(vPoint1.y + _halfSize);
					
					} else {
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x + _halfSize - _eighthSize);
						drawingData.push(vPoint1.y - _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x + _halfSize);
						drawingData.push(vPoint1.y - _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x + _halfSize);
						drawingData.push(vPoint2.y - _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x - _halfSize + _eighthSize);
						drawingData.push(vPoint2.y + _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x - _halfSize);
						drawingData.push(vPoint2.y + _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x - _halfSize + _eighthSize);
						drawingData.push(vPoint1.y + _halfSize);
						
					}
					
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(vPoint1.x - _halfSize);
					drawingData.push(vPoint1.y + _halfSize);
					
				//////////////////////////////////////////////////////////
				// Backward Line Shape Brush
				//////////////////////////////////////////////////////////
				} else if(_type == BrushType.BACKWARD_LINE) {
					
					angleBetweenPoints = Conversions.degrees(atan2(vPoint2.x - vPoint1.x, vPoint2.y - vPoint1.y));
					
					commands.push(GraphicsPathCommand.MOVE_TO);
					drawingData.push(vPoint1.x - _halfSize);
					drawingData.push(vPoint1.y - _halfSize);
					
					if(angleBetweenPoints <= 45) {
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x - _halfSize + _eighthSize);
						drawingData.push(vPoint1.y - _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x + _halfSize);
						drawingData.push(vPoint1.y + _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x + _halfSize);
						drawingData.push(vPoint2.y + _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x + _halfSize - _eighthSize);
						drawingData.push(vPoint2.y + _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x - _halfSize);
						drawingData.push(vPoint2.y - _halfSize);
						
					} else if(angleBetweenPoints <= 90) {
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x - _halfSize + _eighthSize);
						drawingData.push(vPoint1.y - _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x - _halfSize + _eighthSize);
						drawingData.push(vPoint2.y - _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x + _halfSize);
						drawingData.push(vPoint2.y + _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x + _halfSize - _eighthSize);
						drawingData.push(vPoint2.y + _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x + _halfSize - _eighthSize);
						drawingData.push(vPoint1.y + _halfSize);
					
					} else {
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x - _halfSize);
						drawingData.push(vPoint2.y - _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x - _halfSize + _eighthSize);
						drawingData.push(vPoint2.y - _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x + _halfSize);
						drawingData.push(vPoint2.y + _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x + _halfSize);
						drawingData.push(vPoint1.y + _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x + _halfSize - _eighthSize);
						drawingData.push(vPoint1.y + _halfSize);
						
					}
					
				//////////////////////////////////////////////////////////
				// Diamond Shape Brush
				//////////////////////////////////////////////////////////
				} else if(_type == BrushType.DIAMOND) {
					
					if(abs(point2.x - point1.x) > abs(point2.y - point1.y)) {	
					
						commands.push(GraphicsPathCommand.MOVE_TO);
						drawingData.push(vPoint1.x);
						drawingData.push(vPoint1.y - _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x);
						drawingData.push(vPoint2.y - _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x + _halfSize);
						drawingData.push(vPoint2.y);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x);
						drawingData.push(vPoint2.y + _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x);
						drawingData.push(vPoint1.y + _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x - _halfSize);
						drawingData.push(vPoint1.y);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x);
						drawingData.push(vPoint1.y - _halfSize);
						
					} else {
						
						// check for order of points based of y
						if(point1.y < point2.y) {
							vPoint1 = point1;
							vPoint2 = point2;
						} else {
							vPoint1 = point2;
							vPoint2 = point1;
						}
						
						// store brush segment
						commands.push(GraphicsPathCommand.MOVE_TO);
						drawingData.push(vPoint1.x + _halfSize);
						drawingData.push(vPoint1.y);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x + _halfSize);
						drawingData.push(vPoint2.y);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x);
						drawingData.push(vPoint2.y + _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint2.x - _halfSize);
						drawingData.push(vPoint2.y);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x - _halfSize);
						drawingData.push(vPoint1.y);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x);
						drawingData.push(vPoint1.y - _halfSize);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(vPoint1.x + _halfSize);
						drawingData.push(vPoint1.y);
						
					}
					
				}
				
			}
			
			// draw brush session
			targetCast.graphics.clear();
			
			if(_type == BrushType.ROUND) {
				targetCast.graphics.lineStyle(_size, _color, _alpha, false, LineScaleMode.NORMAL, CapsStyle.ROUND);
			} else {
				targetCast.graphics.beginFill(_color, _alpha);
			}
			
			targetCast.graphics.drawPath(commands, drawingData, GraphicsPathWinding.NON_ZERO); 
			
		}
		
	}
		
}