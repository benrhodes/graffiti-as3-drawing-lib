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
	import flash.display.LineScaleMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import com.nocircleno.graffiti.tools.ITool;
	import com.nocircleno.graffiti.tools.ToolRenderType;
	import com.nocircleno.graffiti.tools.ShapeType;
	import com.nocircleno.graffiti.utils.Conversions;
	
	/**
	* ShapeTool Class allows the user to draw RECTANGLE, SQUARE, OVAL or CIRCLE to the canvas.
	* You can control the stroke and fill of the shape.
	*
	* @langversion 3.0
    * @playerversion Flash 10 AIR 1.5 
	*/
	final public class ShapeTool extends BitmapTool {
		
		// store local references for performance reasons
		private const cos:Function = Math.cos;
		private const sin:Function = Math.sin;
		private const sqrt:Function = Math.sqrt;
		private const pow:Function = Math.pow;
		private const abs:Function = Math.abs;
		private const max:Function = Math.max;
	
		private var _strokeWidth:Number;
		private var _strokeColor:int;
		private var _fillColor:int;
		private var _strokeAlpha:Number;
		private var _fillAlpha:Number;
		
		/**
		* The <code>ShapeTool</code> constructor.
		* 
		* @param strokeWidth Stroke width.
		* @param strokeColor Stroke Color, pass -1 for NO stroke on Shape.
		* @param fillColor Fill Color, pass -1 for NO fill in Shape.
		* @param strokeAlpha Stroke Alpha, default is 1.
		* @param fillAlpha Fill Alpha, default is 1.
		* @param shapeType Type of Shape.
		* @param toolMode Tool mode the Shape will be drawing with.
		* 
		* @example The following code creates a Shape instance.
		* <listing version="3.0" >
		* // create a rectangle shape with red stroke width of 2 and no fill
		* var rectangleShape:Shape = new Shape(2, 0xFF0000, -1, 1, 1, ShapeType.RECTANGLE);
		* </listing>
		*/
		public function ShapeTool(strokeWidth:Number = 1, strokeColor:int = 0x000000, fillColor:int = 0xFFFFFF, strokeAlpha:Number = 1, fillAlpha:Number = 1, shapeType:String = null, toolMode:String = null) {
			
			// set render type
			_renderType = ToolRenderType.CLICK_DRAG;
			
			// store size
			this.strokeWidth = strokeWidth;
			
			// store stroke color
			this.strokeColor = strokeColor;
			
			// store fill color
			this.fillColor = fillColor;
			
			// store stroke alpha
			this.strokeAlpha = strokeAlpha;
			
			// store fill alpha
			this.fillAlpha = fillAlpha;
			
			// store type
			type = shapeType;
			
			// store mode
			mode = toolMode;
			
		}
		
		/**
		* Stroke width
		*/
		public function set strokeWidth(strokeW:Number):void {
			
			if(strokeW > 0 || strokeW == -1) {
			
				// set stroke size
				_strokeWidth = strokeW;
				
			}
			
		}
		
		public function get strokeWidth():Number {
			return _strokeWidth;
		}
		
		/**
		* Color of the Stroke, set to -1 for no stroke.
		*/
		public function set strokeColor(color:int):void {
			_strokeColor = color;
		}

		public function get strokeColor():int {
			return _strokeColor;
		}
		
		/**
		* Color of the Fill, set to -1 for no fill.
		*/
		public function set fillColor(color:int):void {
			_fillColor = color;
		}

		public function get fillColor():int {
			return _fillColor;
		}
		
		/**
		* Alpha of the Stroke
		*/
		public function set strokeAlpha(alpha:Number):void {
			_strokeAlpha = alpha;
		}

		public function get strokeAlpha():Number {
			return _strokeAlpha;
		}
		
		/**
		* Alpha of the Fill
		*/
		public function set fillAlpha(alpha:Number):void {
			_fillAlpha = alpha;
		}

		public function get fillAlpha():Number {
			return _fillAlpha;
		}
		
		/**
		* Type of Shape
		*/
		public override function set type(shapeType:String):void {
			
			// determine type
			if(shapeType != null && ShapeType.validType(shapeType)) {
				_type = shapeType;
			} else {
				_type = ShapeType.RECTANGLE;
			}
			
		}
		
		/**
		* The <code>apply</code> method applies the line to the Sprite object passed
		* to the method.
		* 
		* @param drawingTarget Sprite that the Shape will draw to.
		* @param point1 Starting point to apply Shape.
		* @param point2 End point to apply Shape.
		*/
		public override function apply(drawingTarget:DisplayObject, point1:Point, point2:Point = null):void {
			
			var k:uint;
			var xControl:Number;
			var yControl:Number;
			var xAnchor:Number;
			var yAnchor:Number;
			var theta:Number = 45;
			var r:Number;
			var r2:Number;
			var d:Number;
			var d2:Number;
			var controlAngleRadians:Number;
			var anchorAngleRadians:Number;
			var centerPoint:Point;
			
			// clear drawing commands and data
			resetTool();
			
			// cast target as a Sprite
			var targetCast:Sprite = Sprite(drawingTarget);
			
			// calculate dim differences
			var xDiff:Number = point2.x - point1.x;
			var yDiff:Number = point2.y - point1.y;
			
			// if stroke color exists, define line style
			if(_strokeColor != -1) {
				
				// use square corners with miter joints for rectangle and square shapes
				if(_type == ShapeType.RECTANGLE || _type == ShapeType.SQUARE) {
					targetCast.graphics.lineStyle(_strokeWidth, _strokeColor, _strokeAlpha,  false, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
				} else {
					targetCast.graphics.lineStyle(_strokeWidth, _strokeColor, _strokeAlpha);
				}
				
			}
			
			// if fill color exists, start fill
			if(_fillColor != -1) {
				targetCast.graphics.beginFill(_fillColor, _fillAlpha);
			}
			
			// draw shape
			if(_type == ShapeType.RECTANGLE) {
				
				commands.push(GraphicsPathCommand.MOVE_TO);
				drawingData.push(point1.x);
				drawingData.push(point1.y);
				
				commands.push(GraphicsPathCommand.LINE_TO);
				drawingData.push(point1.x + xDiff);
				drawingData.push(point1.y);
				
				commands.push(GraphicsPathCommand.LINE_TO);
				drawingData.push(point1.x + xDiff);
				drawingData.push(point1.y + yDiff);
				
				commands.push(GraphicsPathCommand.LINE_TO);
				drawingData.push(point1.x);
				drawingData.push(point1.y + yDiff);
				
				commands.push(GraphicsPathCommand.LINE_TO);
				drawingData.push(point1.x);
				drawingData.push(point1.y);
			
			} if(_type == ShapeType.SQUARE) {
				
				// calculate length
				var segmentLength:Number = abs(max(xDiff, yDiff));
				var squareWidth:Number = point2.x < point1.x ? -segmentLength : segmentLength;
				var squareHeight:Number = point2.y < point1.y ? -segmentLength : segmentLength;
				
				commands.push(GraphicsPathCommand.MOVE_TO);
				drawingData.push(point1.x);
				drawingData.push(point1.y);
				
				commands.push(GraphicsPathCommand.LINE_TO);
				drawingData.push(point1.x + squareWidth);
				drawingData.push(point1.y);
				
				commands.push(GraphicsPathCommand.LINE_TO);
				drawingData.push(point1.x + squareWidth);
				drawingData.push(point1.y + squareHeight);
				
				commands.push(GraphicsPathCommand.LINE_TO);
				drawingData.push(point1.x);
				drawingData.push(point1.y + squareHeight);
				
				commands.push(GraphicsPathCommand.LINE_TO);
				drawingData.push(point1.x);
				drawingData.push(point1.y);
			
			} else if(_type == ShapeType.OVAL) {
				
				r = xDiff/2;
				r2 = yDiff/2;
				
				d = r/cos(Conversions.radians(0.5*theta));
				d2 = r2/cos(Conversions.radians(0.5*theta));
				
				centerPoint = new Point(point1.x + ((xDiff)/2), point1.y + ((yDiff)/2));
				
				commands.push(GraphicsPathCommand.MOVE_TO);
				drawingData.push(centerPoint.x + r);
				drawingData.push(centerPoint.y);
							
				// draw the new preview circle
				for(k=(theta/2); k<361; k=k+theta) {
					
					controlAngleRadians = Conversions.radians(k);
					anchorAngleRadians = Conversions.radians(k+(theta/2));
					
					xControl = d*cos(controlAngleRadians);
					yControl = d2*sin(controlAngleRadians);
					xAnchor = r*cos(anchorAngleRadians);
					yAnchor = r2*sin(anchorAngleRadians);
					
					commands.push(GraphicsPathCommand.CURVE_TO);
					drawingData.push(centerPoint.x + xControl);
					drawingData.push(centerPoint.y + yControl);
					drawingData.push(centerPoint.x + xAnchor);
					drawingData.push(centerPoint.y + yAnchor);
				
				}
			
			} else if(_type == ShapeType.CIRCLE) {
				
				var lineLength:Number = sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2));
				
				r = lineLength/2;
				d = r/cos(Conversions.radians(0.5*theta));
				
				centerPoint = new Point(point1.x + ((xDiff)/2), point1.y + ((yDiff)/2));
				
				commands.push(GraphicsPathCommand.MOVE_TO);
				drawingData.push(centerPoint.x + r);
				drawingData.push(centerPoint.y);
				
				for(k=(theta/2); k<361; k=k+theta) {
					
					controlAngleRadians = Conversions.radians(k);
					anchorAngleRadians = Conversions.radians(k+(theta/2));
					
					xControl = d*cos(controlAngleRadians);
					yControl = d*sin(controlAngleRadians);
					xAnchor = r*cos(anchorAngleRadians);
					yAnchor = r*sin(anchorAngleRadians);
					
					commands.push(GraphicsPathCommand.CURVE_TO);
					drawingData.push(centerPoint.x + xControl);
					drawingData.push(centerPoint.y + yControl);
					drawingData.push(centerPoint.x + xAnchor);
					drawingData.push(centerPoint.y + yAnchor);
				
				}
				
			}
			
			// draw shape
			targetCast.graphics.drawPath(commands, drawingData, GraphicsPathWinding.NON_ZERO); 
			
			// if fill color exists then end fill
			if(_fillColor != -1) {
				targetCast.graphics.endFill();
			}
			
		}
		
	}
		
}