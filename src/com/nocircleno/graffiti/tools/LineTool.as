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
	import com.nocircleno.graffiti.tools.LineType;
	import com.nocircleno.graffiti.utils.Conversions;
	
	/**
	* LineTool Class allows the user to draw a SOLID, DASHED or DOTTED line on the canvas.
	*
	* @langversion 3.0
    * @playerversion Flash 10 AIR 1.5 
	*/
	final public class LineTool extends BitmapTool {
		
		// store local references for performance reasons
		private const sin:Function = Math.sin;
		private const cos:Function = Math.cos;
		private const sqrt:Function = Math.sqrt;
		private const pow:Function = Math.pow;
		private const atan2:Function = Math.atan2;
		
		private const THETA:Number = 45;
		private const LINE_SEGMENT_LENGTH_BASE:uint = 4;
	
		private var _lineWidth:Number;
		private var _color:uint;
		private var _alpha:Number;
		
		private var _dotSpacing:Number;
		private var _r:Number;
		private var _d:Number;
		
		/**
		* The <code>LineTool</code> constructor.
		* 
		* @param lineWidth Line width.
		* @param lineColor Line Color.
		* @param lineType Type of Line.
		* @param toolMode Tool mode the Line will be drawing with.
		* 
		* @example The following code creates a Line instance.
		* <listing version="3.0" >
		* // create a dotted line of size 8 and the color of red
		* var dottedLine:Line = new Line(8, 0xFF0000, 1, LineType.DOTTED);
		* </listing>
		*/
		public function LineTool(lineWidth:Number = 4, lineColor:uint = 0x000000, lineAlpha:Number = 1, lineType:String = null, toolMode:String = null) {
			
			// set render type
			_renderType = ToolRenderType.CLICK_DRAG;
			
			// store size
			this.lineWidth = lineWidth;
			
			// store color
			color = lineColor;
			
			// store alpha
			_alpha = lineAlpha;
			
			// store type
			type = lineType;
			
			// store mode
			mode = toolMode;
			
		}
		
		/**
		* Size of the Line
		*/
		public function set lineWidth(lineW:Number):void {
			
			if(lineW > 0) {
			
				// set brush size
				_lineWidth = lineW;
				
				// update values for dotted line
				_dotSpacing =  2 * _lineWidth;
				_r = _lineWidth * .5;
				_d = _r/cos(Conversions.radians(0.5*THETA));
				
			}
			
		}
		
		public function get lineWidth():Number {
			return _lineWidth;
		}
		
		/**
		* Color of the Line
		*/
		public function set color(lineColor:uint):void {
			_color = lineColor;
		}

		public function get color():uint {
			return _color;
		}
		
		/**
		* Alpha of the Line
		*/
		public function set alpha(lineAlpha:Number):void {
			_alpha = lineAlpha;
		}

		public function get alpha():Number {
			return _alpha;
		}
		
		/**
		* Type of Line
		*/
		public override function set type(lineType:String):void {
			
			// determine type
			if(lineType != null && LineType.validType(lineType)) {
				_type = lineType;
			} else {
				_type = LineType.SOLID;
			}
			
		}
		
		/**
		* The <code>apply</code> method applies the line to the Sprite object passed
		* to the method.
		* 
		* @param drawingTarget Sprite that the line will draw to.
		* @param point1 Starting point to apply line.
		* @param point2 End point to apply line.
		*/
		public override function apply(drawingTarget:DisplayObject, point1:Point, point2:Point = null):void {
			
			// clear drawing commands and data
			resetTool();
			
			// cast target as a Sprite
			var targetCast:Sprite = Sprite(drawingTarget);
			
			// clear it
			targetCast.graphics.clear();
			
			var lineLength:Number = sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2));
			var angle:Number = atan2(point2.y - point1.y, point2.x - point1.x);
			var i:uint;
			
			// make sure second point is defined
			if(point2 != null) {
				
				// move to first point
				commands.push(GraphicsPathCommand.MOVE_TO);
				drawingData.push(point1.x);
				drawingData.push(point1.y);
				
				// draw SOLID line
				if(_type == LineType.SOLID) {
					
					// add line 
					commands.push(GraphicsPathCommand.LINE_TO);
					drawingData.push(point2.x);
					drawingData.push(point2.y);

					targetCast.graphics.lineStyle(_lineWidth, _color, _alpha);
					targetCast.graphics.drawPath(commands, drawingData, GraphicsPathWinding.NON_ZERO); 
				
				// draw DASHED line
				} else if(_type == LineType.DASHED) {
					
					var lineSegmentLength:uint = LINE_SEGMENT_LENGTH_BASE * _lineWidth;
					var lineSegmentLengthSpace:uint = LINE_SEGMENT_LENGTH_BASE * _lineWidth;
					var numberLineSegments:int = Math.floor(lineLength/(lineSegmentLength + lineSegmentLengthSpace));
					var segmentStartPoint:Point = new Point();
					var segmentEndPoint:Point = new Point();
					
					// loop and draw all segments
					for(i=0; i<=numberLineSegments; ++i) {
						
						// calculate segment start point
						segmentStartPoint.x = point1.x + (cos(angle)*(i*(lineSegmentLength + lineSegmentLengthSpace)));
						segmentStartPoint.y = point1.y + (sin(angle)*(i*(lineSegmentLength + lineSegmentLengthSpace)));
						
						// calculate segment end point
						segmentEndPoint.x = point1.x + (cos(angle)*(((i+1)*(lineSegmentLength + lineSegmentLengthSpace)) - lineSegmentLengthSpace));
						segmentEndPoint.y = point1.y + (sin(angle)*(((i+1)*(lineSegmentLength + lineSegmentLengthSpace)) - lineSegmentLengthSpace));
						
						// check last segment and adjust length if needed
						if(i == numberLineSegments) {
							
							var finalLength:Number = sqrt(pow((point2.x - segmentStartPoint.x), 2) + pow((point2.y - segmentStartPoint.y), 2));
							
							// if final length is less then or equal to the line segment then use end point to draw last segment
							if(finalLength <= lineSegmentLength) {
								segmentEndPoint.x = point2.x;
								segmentEndPoint.y = point2.y;
							}
							
						}
						
						// store segment
						commands.push(GraphicsPathCommand.MOVE_TO);
						drawingData.push(segmentStartPoint.x);
						drawingData.push(segmentStartPoint.y);
						
						commands.push(GraphicsPathCommand.LINE_TO);
						drawingData.push(segmentEndPoint.x);
						drawingData.push(segmentEndPoint.y);
						
					}
					
					targetCast.graphics.lineStyle(_lineWidth, _color, _alpha, false, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
					targetCast.graphics.drawPath(commands, drawingData, GraphicsPathWinding.NON_ZERO); 
				
				// draw DOTTED line
				} else if(_type == LineType.DOTTED) {
					
					var k:uint;
					var xControl:Number;
					var yControl:Number;
					var xAnchor:Number;
					var yAnchor:Number;
					var controlAngleRadians:Number;
					var anchorAngleRadians:Number;
					
					var dotPos:Point = new Point();
					
					// loop and draw all points for the line
					for(i=0; i<=lineLength; i+=_dotSpacing) {
						
						// calculate dot position
						dotPos.x = point1.x + (cos(angle) * i);
						dotPos.y = point1.y + (sin(angle) * i);
						
						commands.push(GraphicsPathCommand.MOVE_TO);
						drawingData.push(dotPos.x + _r);
						drawingData.push(dotPos.y);
						
						for(k=(THETA/2); k<361; k=k+THETA) {
							
							controlAngleRadians = Conversions.radians(k);
							anchorAngleRadians = Conversions.radians(k+(THETA/2));
							
							xControl = _d*cos(controlAngleRadians);
							yControl = _d*sin(controlAngleRadians);
							xAnchor = _r*cos(anchorAngleRadians);
							yAnchor = _r*sin(anchorAngleRadians);
							
							commands.push(GraphicsPathCommand.CURVE_TO);
							drawingData.push(dotPos.x + xControl);
							drawingData.push(dotPos.y + yControl);
							drawingData.push(dotPos.x + xAnchor);
							drawingData.push(dotPos.y + yAnchor);
						
						}
						
					}
					
					// draw dots
					targetCast.graphics.lineStyle(0, 0xFF0000, 0);
					targetCast.graphics.beginFill(_color, _alpha);
					targetCast.graphics.drawPath(commands, drawingData, GraphicsPathWinding.NON_ZERO); 
					targetCast.graphics.endFill();
					
				}
				
			}
			
		}
		
	}
		
}