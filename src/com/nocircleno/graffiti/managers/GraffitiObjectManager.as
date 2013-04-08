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

package com.nocircleno.graffiti.managers 
{
	
	import com.nocircleno.graffiti.display.GraffitiObject;
	import com.nocircleno.graffiti.display.Text;
	import com.nocircleno.graffiti.tools.TextSettings;
	import com.nocircleno.graffiti.events.GraffitiObjectEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	
	/**
	* GraffitiObjectManager Class manages graffiti objects on the GraffitiCanvas.  This is a singleton class, use the GraffitiObjectManager.getInstance() method to get an instance of this class.
	*
	* @langversion 3.0
    * @playerversion Flash 10 AIR 1.5 
	*/
	public class GraffitiObjectManager extends EventDispatcher
	{
		
		private static var _instance:GraffitiObjectManager;
		
		private var _objects:Vector.<GraffitiObject>;
		private var _selectedObjects:Vector.<GraffitiObject>;
		private var _pendingSettings:Object;
		
		/**
		* The <code>getInstance</code> method returns an instance of GraffitiObjectManager.
		* 
		* @return GraffitiObjectManager instance.
		*/
		public static function getInstance():GraffitiObjectManager {
			return _instance ? _instance : _instance = new GraffitiObjectManager(new SingletonEnforcer());
		}
		
		/**
		* The <code>GraffitiObjectManager</code> constructor.
		* @example The following code gets an instance of the GraffitiObjectManager.
		* <listing version="3.0" >
		* var goManager:GraffitiObjectManager = GraffitiObjectManager.getInstance();
		* </listing>
		*/
		public function GraffitiObjectManager(param:SingletonEnforcer) {
			init();
		}
		
		/**
		* The <code>areObjectsSelected</code> method checks to see if any object is currently selected.
		* 
		* @return true if one or more objects are selected, false if not.
		*/
		public function areObjectsSelected():Boolean {
			
			var isSelected:Boolean = false;
			var numObjects:uint = _objects.length;
			
			for (var i:int = 0; i < numObjects; ++i) {
				
				if (_objects[i].selected) {
					isSelected = true;
					break;
				}
				
			}
		
			return isSelected;
			
		}
		
		/**
		* The <code>areObjectsBeingEdited</code> method checks to see if any object is being edited.
		* 
		* @return true if one or more objects are edited, false if not.
		*/
		public function areObjectsBeingEdited():Boolean {
			
			var isEdit:Boolean = false;
			var numObjects:uint = _objects.length;
			
			for (var i:int = 0; i < numObjects; ++i) {
			
				if (_objects[i].editing) {
					
					isEdit = true;
					break;
					
				}
				
			}
		
			return isEdit;
			
		}
		
		/**
		* The <code>changeSettingsForSelectedObjects</code> method updates the settings for all selected objects.
		* 
		* @param settings Object that contains the settings for a GraffitObject.
		*/
		public function changeSettingsForSelectedObjects(settings:Object):void {
			
			// store pending settings object
			_pendingSettings = settings;
			
			// update all settings
			_selectedObjects.forEach(changeSettings, null);	
			
			// remove pending settings
			_pendingSettings = null;
			
		}
		
		/**
		* The <code>addObject</code> method adds a GraffitObject to the assets list held by this Class.
		* 
		* @param object GraffitObject
		*/
		public function addObject(object:GraffitiObject):void {
			
			// add listener so we know it it is removed from the stage
			object.addEventListener(Event.REMOVED_FROM_STAGE, cleanUp);
			
			// add to object list
			_objects.push(object);
			
		}
		
		/**
		* The <code>setSelection</code> method selects one or more grafffiti objects.
		* 
		* @param objectList Vector of GraffitObjects to select.
		*/
		public function setSelection(objectList:Vector.<GraffitiObject>):void {
			
			// make unique copy of the vector
			_selectedObjects = objectList.concat(new Vector.<GraffitiObject>());
			
			// select each object in the vector
			if(_selectedObjects.length > 0) {
				_selectedObjects.forEach(selectObject, null);
			}
			
			// sync selection list with the main list
			if(_objects.length > 0) {
				_objects.forEach(syncListWithSelection, null);
			}
			
		}
		
		/**
		* The <code>deselectAll</code> method deselects all selected objects.
		*/
		public function deselectAll():void {
			
			// deselect all object in vector
			if(_selectedObjects.length > 0) {
				_selectedObjects.forEach(deselectObject);
			}
			
			// clear selected object vector
			_selectedObjects = new Vector.<GraffitiObject>();
			
		}
		
		/**
		* The <code>selectAll</code> method selects all registered objects.
		*/
		public function selectAll():void {
			if(_objects.length > 0) {
				setSelection(_objects);
			}
		}
		
		/**
		* The <code>exitEditAll</code> method will turn off any object that is being edited.
		*/
		public function exitEditAll():void {
			
			var numObjects:uint = _objects.length - 1;
			
			for (var i:int = numObjects; i >= 0; i--) {
			
				if (_objects[i].editing) {
					_objects[i].editing = false;
				}
				
			}
			
		}
		
		/**
		* The <code>deleteSelected</code> method deletes all selected objects.
		* This method removes the objects from the display list.
		*/
		public function deleteSelected():void {
			
			var numSelectedObjects:int = _selectedObjects.length-1;
			
			// loop and delete all objects in the selected list
			for (var i:int = numSelectedObjects; i >= 0; --i) {
			
				if (!_selectedObjects[i].editing) {
					dispatchEvent(new GraffitiObjectEvent(_selectedObjects[i], GraffitiObjectEvent.DELETE));
				}
				
			}
		
		}
		
		/**************************************************************************
			Method	: init()
			
			Purpose	: This method will initalize the data to hold the objects.
		***************************************************************************/
		private function init():void {
			
			if (_objects != null) {
				return;
			}
			
			_objects = new Vector.<GraffitiObject>();
			_selectedObjects = new Vector.<GraffitiObject>();
			
		}
		
		/**************************************************************************
			Method	: changeSettings()
			
			Purpose	: This method changes the settings for an object.
			
			Params	: item - GraffitiObject
					  index - index of graffiti object in vector.
					  vector - The vector that stores the graffiti objects.
		***************************************************************************/
		private function changeSettings(item:GraffitiObject, index:int, vector:Vector.<GraffitiObject>):void {
			
			// update text settings if item is text and pending settings is textsettings
			if (item is Text && _pendingSettings is TextSettings) {
				Text(item).textSetting = TextSettings(_pendingSettings);
			}
			
		}
		
		/**************************************************************************
			Method	: removeObject()
			
			Purpose	: This method will remove a graffiti object from the manager.
					  This method does not remove the object from the display
					  list.
			
			Params	: object - GraffitiObject
		***************************************************************************/
		public function removeObject(object:GraffitiObject):void {
		
			// check and remove object from object list
			var itemIndex:int = _objects.indexOf(object);
			
			if (itemIndex != -1) {
				_objects.splice(itemIndex, 1);
			}
			
			// check and remove object from selected list
			itemIndex = _selectedObjects.indexOf(object);
			
			if (itemIndex != -1) {
				_selectedObjects.splice(itemIndex, 1);
			}
			
		}
		
		/**************************************************************************
			Method	: syncListWithSelection()
			
			Purpose	: This method will make sure if an item is in the main object
					  list and not in the selected list, it will deselect
					  that object.
			
			Params	: item - GraffitiObject
					  index - index of graffiti object in vector.
					  vector - The vector that stores the graffiti objects.
		***************************************************************************/
		private function syncListWithSelection(item:GraffitiObject, index:int, vector:Vector.<GraffitiObject>):void {
			
			// if item is not in selected object list
			if (_selectedObjects.indexOf(item) == -1) {
				
				// if object is selected, then deselect it
				if (item.selected) {
					item.selected = false;
					item.editing = false;
					dispatchEvent(new GraffitiObjectEvent(item, GraffitiObjectEvent.DESELECT));
				}
				
			}
			
		}
		
		/**************************************************************************
			Method	: cleanUp()
			
			Purpose	: This method will handle the remove child from stage event
					  for a graffiti object.
			
			Params	: e - Event Object
		***************************************************************************/
		private function cleanUp(e:Event):void {
			e.currentTarget.removeEventListener(Event.REMOVED_FROM_STAGE, cleanUp);
			removeObject(GraffitiObject(e.currentTarget));
		}
		
		/**************************************************************************
			Method	: selectObject()
			
			Purpose	: This method will select a graffiti object if not already
					  selected.
			
			Params	: item - GraffitiObject
					  index - index of graffiti object in vector.
					  vector - The vector that stores the graffiti objects.
		***************************************************************************/
		private function selectObject(item:GraffitiObject, index:int, vector:Vector.<GraffitiObject>):void {
			
			if (!item.selected) {
				item.selected = true;
				dispatchEvent(new GraffitiObjectEvent(item, GraffitiObjectEvent.SELECT));
			}
			
		}
		
		/**************************************************************************
			Method	: deselectObject()
			
			Purpose	: This method will deselect a graffiti object if already
					  selected.
			
			Params	: item - GraffitiObject
					  index - index of graffiti object in vector.
					  vector - The vector that stores the graffiti objects.
		***************************************************************************/
		private function deselectObject(item:GraffitiObject, index:int, vector:Vector.<GraffitiObject>):void {
			
			if (item.selected) {
				
				item.selected = false;
				
				// turn off editing
				if(item.editing) {
					item.editing = false;
				}
				
				dispatchEvent(new GraffitiObjectEvent(item, GraffitiObjectEvent.DESELECT));
				
			}
				
		}
		
	}

}

class SingletonEnforcer {}