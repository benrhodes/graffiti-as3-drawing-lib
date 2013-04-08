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

package com.nocircleno.graffiti.events 
{
	
	import flash.events.Event;
	import com.nocircleno.graffiti.display.GraffitiObject;
	
	/**
	* GraffitiObjectEvent Class is used to notify of object changes.
	*
	* @langversion 3.0
    * @playerversion Flash 10 AIR 1.5 
	*/
	public class GraffitiObjectEvent extends Event 
	{
		
		/**
		* Dispatched when an object is selected.
		*
		* @eventType com.nocircleno.graffiti.events.GraffitiObjectEvent.SELECT
		*/
		public static const SELECT:String = "select";
		
		/**
		* Dispatched when an object is deselected.
		*
		* @eventType com.nocircleno.graffiti.events.GraffitiObjectEvent.DESELECT
		*/
		public static const DESELECT:String = "deselect";
		
		/**
		* Dispatched when an object enters edit mode.
		*
		* @eventType com.nocircleno.graffiti.events.GraffitiObjectEvent.ENTER_EDIT
		*/
		public static const ENTER_EDIT:String = "enterEdit";
		
		/**
		* Dispatched when an object exits edit mode.
		*
		* @eventType com.nocircleno.graffiti.events.GraffitiObjectEvent.EXIT_EDIT
		*/
		public static const EXIT_EDIT:String = "exitEdit";
		
		/**
		* Dispatched when an object is deleted from the stage.
		*
		* @eventType com.nocircleno.graffiti.events.GraffitiObjectEvent.DELETE
		*/
		public static const DELETE:String = "delete";
		
		private var _graffitiObject:GraffitiObject;
		
		/**
		* The <code>GraffitiObjectEvent</code> constructor.
		*
		* @param gObject Graffiti Object affected by event.
		* @param type Event type.
		* @param bubbles Does the event bubble.
		* @param cancelable Is the Event cancelable.
		*/
		public function GraffitiObjectEvent(gObject:GraffitiObject, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			
			super(type, bubbles, cancelable);
			
			_graffitiObject = gObject;
			
		} 
		
		/**
		 * Graffiti Object affected by event.
		 */
		public function get graffitiObject():GraffitiObject { return _graffitiObject; }
		
		/**
		* The <code>clone</code> method will return a new instance of the ObjectEvent.
		*
		* @return Returns new ObjectEvent with all the same settings.
		*/
		public override function clone():Event 
		{ 
			return new GraffitiObjectEvent(_graffitiObject, type, bubbles, cancelable);
		} 
		
		/**
		* The <code>toString</code> method will output the event details. 
		*
		* @return Returns the event information.
		*/
		public override function toString():String 
		{ 
			return formatToString("GraffitiObjectEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}