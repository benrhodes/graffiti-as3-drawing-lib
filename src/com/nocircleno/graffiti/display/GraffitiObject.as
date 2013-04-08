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

package com.nocircleno.graffiti.display 
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import com.nocircleno.graffiti.events.GraffitiObjectEvent;
	
	/**
	* GraffitiObject Class is the base class for all object used in the Graffiti Library.
	*
	* @langversion 3.0
    * @playerversion Flash 10 AIR 1.5 
	*/
	public class GraffitiObject extends Sprite
	{
		
		/**
		* Selected Color
		*/
		public static const SELECTED_COLOR:uint = 0xFF0000;
		
		/**
		* Edit Color
		*/
		public static const EDIT_COLOR:uint = 0xFFCC00;
		
		protected var _selected:Boolean = false;
		protected var _editing:Boolean = false;
		
		public function GraffitiObject() {}
		
		/**
		* Selected state.
		*/
		public function set selected(select:Boolean):void {
			_selected = select;
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		
		/**
		* Edited state.
		*/
		public function set editing(edit:Boolean):void {
			
			// only dispatch event if it is different than the current setting
			if(edit != _editing) {
			
				if (edit) {
					dispatchEvent(new GraffitiObjectEvent(this, GraffitiObjectEvent.ENTER_EDIT));
				} else {
					dispatchEvent(new GraffitiObjectEvent(this, GraffitiObjectEvent.EXIT_EDIT));
				}
				
			}
			
			_editing = edit;
			
		}
		
		public function get editing():Boolean {
			return _editing;
		}
		
	}

}