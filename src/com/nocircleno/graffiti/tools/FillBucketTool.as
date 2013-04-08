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
	import flash.geom.Point;
	import com.nocircleno.graffiti.tools.ITool;
	import com.nocircleno.graffiti.tools.ToolRenderType;
	
	/**
	* Fill Bucket Tool Class allows the user to flood fill a part of the canvas.
	*
	* @langversion 3.0
    * @playerversion Flash 10 AIR 1.5 
	*/
	final public class FillBucketTool implements ITool {
		
		private const LAYER_TYPE:String = LayerType.DRAWING_LAYER;
		
		private var _renderType:String = ToolRenderType.SINGLE_CLICK;
		private var _fillColor:uint;
		private var _useEntireCanvas:Boolean;
		private var _useAdvancedFill:Boolean;
		private var _smoothStrength:int;
		
		/**
		* The <code>FillBucketTool</code> constructor.
		* 
		* @param fillColor Color to fill with.  This color should have an alpha value.
		* @param useEntireCanvas Use underlaid and overlaid display object when filling.
		* @param useAdvancedFill Apply a smoothing to the fill before applying it to the canvas.
		* @param smoothStrength Smoothing setting for advanced fill.
		*
		* @example The following code creates a Fill Bucket Tool instance.
		* <listing version="3.0" >
		* // create a fill bucket tool
		* var fillTool:FillBucketTool = new FillBucketTool(0xFFFF0000, false); 
		* </listing>
		* 
		*/
		public function FillBucketTool(fillColor:uint, useEntireCanvas:Boolean = false, useAdvancedFill:Boolean = true, smoothStrength:int = 8) {
			
			_fillColor = fillColor;
			_useEntireCanvas = useEntireCanvas;
			_useAdvancedFill = useAdvancedFill;
			_smoothStrength = smoothStrength;
			
		}
		
		/**
		* Fill Color
		*/
		public function set fillColor(color:uint):void {
			_fillColor = color;
		}
		
		public function get fillColor():uint {
			return _fillColor;
		}
		
		/**
		* Use the entire canvas when filling including an overlaid and underlaid display objects.
		*/
		public function set useEntireCanvas(b:Boolean):void {
			_useEntireCanvas = b;
		}
		
		public function get useEntireCanvas():Boolean {
			return _useEntireCanvas;
		}
		
		/**
		* Smooth out the fill before applying to the canvas.
		*/
		public function set useAdvancedFill(b:Boolean):void {
			_useAdvancedFill = b;
		}
		
		public function get useAdvancedFill():Boolean {
			return _useAdvancedFill;
		}
		
		/**
		* Smoothing strength when using advanded fill.
		*/
		public function set smoothStrength(s:int):void {
			_smoothStrength = s;
		}
		
		public function get smoothStrength():int {
			return _smoothStrength;
		}
		
		/**
		* Layer to create on.
		*/		
		public function get layerType():String {
			return LAYER_TYPE;
		}
		
		/**
		* Fill Bucket Render Mode
		*/
		public function get renderType():String {
			return _renderType;
		}
		
	}
	
}