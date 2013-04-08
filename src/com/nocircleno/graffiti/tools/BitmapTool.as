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

package com.nocircleno.graffiti.tools 
{
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import com.nocircleno.graffiti.tools.ITool;
	
	/**
	* BitmapTool Class is the base class used by Tools that draw to the bitmap layer.
	*
	* @langversion 3.0
    * @playerversion Flash 10 AIR 1.5 
	*/
	public class BitmapTool implements ITool
	{
		
		protected const LAYER_TYPE:String = LayerType.DRAWING_LAYER;
		
		protected var _renderType:String;
		protected var _mode:String;
		protected var _type:String;
		
		protected var commands:Vector.<int> = new Vector.<int>();
		protected var drawingData:Vector.<Number> = new Vector.<Number>();
		
		public function BitmapTool() {}
		
		/**
		* Render Type
		*/
		public function get renderType():String {
			return _renderType;
		}
		
		/**
		* Type of Tool Option
		*/
		public function set type(t:String):void {
			_type = t;
		}
		
		public function get type():String {
			return _type;
		}
		
		/**
		* Layer Tool Writes to
		*/		
		public function get layerType():String {
			return LAYER_TYPE;
		}
		
		/**
		* Drawing Mode
		*/
		public function set mode(toolMode:String):void {
			
			// store mode
			if(toolMode != null && ToolMode.validMode(toolMode)) {
				_mode = toolMode;
			} else {
				_mode = ToolMode.NORMAL;
			}
			
		}
		
		public function get mode():String {
			return _mode;
		}
		
		/**
		* The <code>resetTool</code> method will reset the drawing data held by the tool.
		*/
		public function resetTool():void {
		
			commands = new Vector.<int>();
			drawingData = new Vector.<Number>();
			
		}
		
		/**
		* The <code>apply</code> method applies the BitmapTool to the DisplayObject passed
		* to the method.
		* 
		* @param drawingTarget Sprite that the bitmap tool will draw to.
		* @param point1 Starting point to apply tool.
		* @param point2 End point to apply tool.
		*/
		public function apply(drawingTarget:DisplayObject, point1:Point, point2:Point = null):void {}
		
	}
	
}