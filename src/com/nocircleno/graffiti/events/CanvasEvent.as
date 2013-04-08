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

package com.nocircleno.graffiti.events {
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	* The Canvas Event provides a custom Event for Canvas events.
	*
	* @langversion 3.0
    * @playerversion Flash 10 AIR 1.5 
	*/
	public class CanvasEvent extends Event {
		
		/**
		* Dispatched when the canvas zoom value changes.
		*
		* @eventType com.nocircleno.graffiti.events.CanvasEvent.ZOOM
		*/
		public static const ZOOM:String = "zoom";
		
		/**
		* Dispatched when the canvas position is changed.
		*
		* @eventType com.nocircleno.graffiti.events.CanvasEvent.DRAG
		*/
		public static const DRAG:String = "drag";
		
		private var _canvasZoom:Number;
		private var _canvasWidth:uint;
		private var _canvasHeight:uint;
		private var _viewableRect:Rectangle;
		
		/**
		* The <code>CanvasEvent</code> constructor.
		* 
		* @param type Type of Canvas Event.
		* @param zoom Zoom of the Canvas instance that dispatched the event.
		* @param canvasWidth Width of the Canvas instance that dispatched the event.
		* @param canvasHeight Height of the Canvas instance that dispatched the event.
		* @param viewableRect Viewable Rectangle of the Canvas instance that dispatched the event.
		* @param bubbles Does the event bubble.
		* @param cancelable Is the Event cancelable.
		* 
		*/
		public function CanvasEvent(type:String, zoom:Number, canvasWidth:uint, canvasHeight:uint, viewableRect:Rectangle, bubbles:Boolean = false, cancelable:Boolean = false) {
			
			super(type, bubbles, cancelable);
			
			// store canvas properties
			_canvasZoom = zoom;
			_canvasWidth = canvasWidth;
			_canvasHeight = canvasHeight;
			_viewableRect = viewableRect;
			
		}
		
		/**
		* Canvas Zoom value.
		*/
		public function get zoom():Number {
			return _canvasZoom;
		}
		
		/**
		* Canvas Width.
		*/
		public function get canvasWidth():uint {
			return _canvasWidth;
		}
		
		/**
		* Canvas Height
		*/
		public function get canvasHeight():uint {
			return _canvasHeight;
		}
		
		/**
		* Viewable Rectangle of the Canvas.
		*/
		public function get viewableRect():Rectangle {
			return _viewableRect;
		}
		
		
	}
	
	
}