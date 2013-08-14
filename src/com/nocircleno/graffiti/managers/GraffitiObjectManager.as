/*
*  	Graffiti 3.0
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
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.text.Font;
	import com.nocircleno.graffiti.display.BrushObject;
	import com.nocircleno.graffiti.display.GraffitiObject;
	import com.nocircleno.graffiti.display.ShapeObject;
	import com.nocircleno.graffiti.display.TextObject;
	import com.nocircleno.graffiti.display.LineObject;
	import com.nocircleno.graffiti.tools.BrushDefinition;
	import com.nocircleno.graffiti.tools.ShapeDefinition;
	import com.nocircleno.graffiti.tools.LineDefinition;
	import com.nocircleno.graffiti.tools.TextSettings;
	import com.nocircleno.graffiti.events.GraffitiObjectEvent;
	import com.nocircleno.graffiti.tools.EditableParams;
	
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
		private var _objectContainer:Sprite;
		private var _showSelectionRectangle:Boolean = true;
		
		/**
		* The <code>GraffitiObjectManager</code> constructor.
		*/
		public function GraffitiObjectManager() {
			init();
		}
		
		/**
		* Show selection rectangle when selected
		*/
		public function get showSelectionRectangle():Boolean {
			return _showSelectionRectangle;
		}
		
		public function set showSelectionRectangle(showRect:Boolean):void {
			
			// set flag
			_showSelectionRectangle = showRect;
			
			// update all registered objects
			var numSelectedObjects:int = _objects.length;
					
			for(var i:int=0; i<numSelectedObjects; ++i) {
				_objects[i].showSelectionRectangle = _showSelectionRectangle;
			}
			
		}
		
		/**
		* The <code>areObjectsSelected</code> method checks to see if any object is currently selected.
		*
		* @return true if one or more objects are selected, false if not.
		*/
		public function areObjectsSelected():Boolean {
			
			var isSelected:Boolean = false;
			
			if(_selectedObjects != null) {
				isSelected = _selectedObjects.length > 0;
			}
		
			return isSelected;
			
		}
		
		/**
		* The <code>areMultipleObjectsSelected</code> method checks to see if more than one object is currently selected.
		*
		* @return true if more than one objects are selected, false if not.
		*/
		public function areMultipleObjectsSelected():Boolean {
			
			var isSelected:Boolean = false;
			
			if(_selectedObjects != null) {
				isSelected = _selectedObjects.length > 1;
			}
		
			return isSelected;
			
		}
		
		/**
		* The <code>areMultipleObjectTypesSelected</code> method checks to see if mutliple object types are selected.
		*
		* @return true if more than one type of object is selected, false if not.
		*/
		public function areMultipleObjectTypesSelected():Boolean {
			
			var multipleObjectTypesSelected:Boolean = false;
			var numSelectedObjects:int = _selectedObjects.length;
			var lastClassType:String;
			
			for(var i:int=0; i<numSelectedObjects; ++i) {
				
				if(i == 0) {
					lastClassType = getQualifiedClassName(_selectedObjects[i]);
				} else {
					
					if(lastClassType != getQualifiedClassName(_selectedObjects[i])) {
					   multipleObjectTypesSelected = true;
					   break;
					}
					
				}
				
			}
			
			return multipleObjectTypesSelected;
			
		}
		
		/**
		* The <code>areMultipleValuesInSelection</code> method checks the passed param to see if there is more than one value within the selected objects.  This can be used to update UI with a mixed items display.  The EditableParam Class contains all the constants that can be passed to this method.
		*
		* @return true if more than one value is contained in selection for passed param.
		*/
		public function areMultipleValuesInSelection(param:String):Boolean {
			
			var multipleValuesInSelection:Boolean = false;
			var numSelectedObjects:int = _selectedObjects.length;
			
			var color:int = -2;
			var lastColor:int = -2;
			var alpha:Number = -1;
			var lastAlpha:Number = -1;
			var size:Number = -1;
			var lastSize:Number = -1;
			var font:Font;
			var lastFont:Font;
			
			for(var i:int=0; i<numSelectedObjects; ++i) {
				
				if(param == EditableParams.FILL_TEXT_COLOR) {
					
					if(_selectedObjects[i] is TextObject) {
						color = int(TextObject(_selectedObjects[i]).textSetting.textFormat.color);
					} else if(_selectedObjects[i] is BrushObject) {
						color = BrushObject(_selectedObjects[i]).brushDefinition.color;
					} else if(_selectedObjects[i] is ShapeObject) {
						color = ShapeObject(_selectedObjects[i]).shapeDefinition.fillColor;
					}
					
					if(lastColor > -2 && color != lastColor) {
						multipleValuesInSelection = true;
						break;
					} else {
						lastColor = color;
					}
				
				} else if(param == EditableParams.FONT) {
					
					if(_selectedObjects[i] is TextObject) {
						
						font = TextObject(_selectedObjects[i]).textSetting.font;
						
						if(lastFont != null) {
							
							if(lastFont != font) {
								multipleValuesInSelection = true;
								break;
							} else {
								lastFont = font;
							}
							
						} else {
							lastFont = font;
						}
						
					}
					
				} else if(param == EditableParams.TEXT_SIZE) {
					
					if(_selectedObjects[i] is TextObject) {
						
						size = int(TextObject(_selectedObjects[i]).textSetting.textFormat.size);
						
						if(lastSize > -1 && size != lastSize) {
							multipleValuesInSelection = true;
							break;
						} else {
							lastSize = size;
						}
						
					}
					
				} else if(param == EditableParams.STROKE_COLOR) {
					
					if(_selectedObjects[i] is ShapeObject) {
						color = ShapeObject(_selectedObjects[i]).shapeDefinition.strokeColor
					} else if(_selectedObjects[i] is LineObject) {
						color = LineObject(_selectedObjects[i]).lineDefinition.strokeColor;
					}
					
					if(lastColor > -2 && color != lastColor) {
						multipleValuesInSelection = true;
						break;
					} else {
						lastColor = color;
					}
					
				} else if(param == EditableParams.FILL_ALPHA) {
					
					if(_selectedObjects[i] is BrushObject) {
						alpha = BrushObject(_selectedObjects[i]).brushDefinition.alpha;
					} else if(_selectedObjects[i] is ShapeObject) {
						alpha = ShapeObject(_selectedObjects[i]).shapeDefinition.fillAlpha;
					}
					
					if(lastAlpha > -1 && alpha != lastAlpha) {
						multipleValuesInSelection = true;
						break;
					} else {
						lastAlpha = alpha;
					}
					
				} else if(param == EditableParams.STROKE_ALPHA) {
					
					if(_selectedObjects[i] is LineObject) {
						alpha = LineObject(_selectedObjects[i]).lineDefinition.strokeAlpha;
					} else if(_selectedObjects[i] is ShapeObject) {
						alpha = ShapeObject(_selectedObjects[i]).shapeDefinition.strokeAlpha;
					}
					
					if(lastAlpha > -1 && alpha != lastAlpha) {
						multipleValuesInSelection = true;
						break;
					} else {
						lastAlpha = alpha;
					}
					
				} else if(param == EditableParams.STROKE_SIZE) {
					
					if(_selectedObjects[i] is LineObject) {
						size = LineObject(_selectedObjects[i]).lineDefinition.strokeSize;
					} else if(_selectedObjects[i] is ShapeObject) {
						size = ShapeObject(_selectedObjects[i]).shapeDefinition.strokeSize;
					}
					
					if(lastSize > -1 && size != lastSize) {
						multipleValuesInSelection = true;
						break;
					} else {
						lastSize = size;
					}
					
				}
				
			}
			
			return multipleValuesInSelection;
			
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
		* List of Graffiti Objects, they are sorted by depth
		*/
		public function get objectList():Vector.<GraffitiObject> {
			
			var sortedList:Vector.<GraffitiObject> = new Vector.<GraffitiObject>(_objects.length, true);
			
			for (var i:int = 0; i < _objects.length; ++i) {
				sortedList[_objectContainer.getChildIndex(_objects[i])] = _objects[i];
			}
			
			return sortedList;
		
		}
		
		/**
		* Number of Selected Objects
		*/
		public function get numberSelectedObjects():int {
			
			var so:int = 0;
			
			if(_selectedObjects != null) {
				so = _selectedObjects.length;
			}
			
			return so;
			
		}
		
		/**
		* The <code>changeSettingsForSelectedObjects</code> method updates the settings for all selected objects.  You can
		*
		* @param settings Object that contains the settings for a GraffitObject.
		*
		* @example The following code creates a Graffiti Canvas instance.
		* <listing version="3.0" >
		*
		* 	// PARAMS
		* 	// --------------
		*   // Font
		*	// TextSize
		*	// FillTextColor
		*	// FillAlpha
		*	// StrokeColor
		*	// StrokeAlpha
		*	// StrokeSize
		*
		*	_objectManager.changeSettingsForSelectedObjects({FillTextColor:0xFF0000});
		*
		* </listing>
		*/
		public function changeSettingsForSelectedObjects(settings:Object):void {
			
			var numberSelectedObjects:int = _selectedObjects.length;
			var ts:TextSettings;
			var bd:BrushDefinition;
			var sd:ShapeDefinition;
			var ld:LineDefinition;
			
			for(var setting:String in settings) {
				
				for(var i:int=0; i<numberSelectedObjects; ++i) {
					
					if(setting == EditableParams.FONT || setting == EditableParams.TEXT_SIZE) {
								
						if (_selectedObjects[i] is TextObject) {
						
							if(setting == EditableParams.FONT) {
								
								ts = TextObject(_selectedObjects[i]).textSetting;
								ts.font = Font(settings[setting]);
								
								TextObject(_selectedObjects[i]).textSetting = ts;
								
							} else if(setting == EditableParams.TEXT_SIZE) {
								
								ts = TextObject(_selectedObjects[i]).textSetting;
								ts.textFormat.size = int(settings[setting]);
								
								TextObject(_selectedObjects[i]).textSetting = ts;
								
							}
							
						}
						
					} else if(setting == EditableParams.FILL_TEXT_COLOR) {
						
						if(_selectedObjects[i] is BrushObject) {
						
							bd = BrushObject(_selectedObjects[i]).brushDefinition;
							bd.color = int(settings[setting]);
						
							BrushObject(_selectedObjects[i]).brushDefinition = bd;
							
						} else if(_selectedObjects[i] is ShapeObject) {
							
							sd = ShapeObject(_selectedObjects[i]).shapeDefinition;
							sd.fillColor = int(settings[setting]);
							
							ShapeObject(_selectedObjects[i]).shapeDefinition = sd;
							
						} else if (_selectedObjects[i] is TextObject) {
							
							ts = TextObject(_selectedObjects[i]).textSetting;
							ts.textFormat.color = int(settings[setting]);
								
							TextObject(_selectedObjects[i]).textSetting = ts;
							
						}
						
					} else if(setting == EditableParams.FILL_ALPHA) {
						
						if(_selectedObjects[i] is BrushObject) {
						
							bd = BrushObject(_selectedObjects[i]).brushDefinition;
							bd.alpha = int(settings[setting]);
						
							BrushObject(_selectedObjects[i]).brushDefinition = bd;
							
						} else if(_selectedObjects[i] is ShapeObject) {
							
							sd = ShapeObject(_selectedObjects[i]).shapeDefinition;
							sd.fillAlpha = int(settings[setting]);
							
							ShapeObject(_selectedObjects[i]).shapeDefinition = sd;
							
						}
						
					} else if (setting == EditableParams.STROKE_COLOR) {
						
						if(_selectedObjects[i] is ShapeObject) {
							
							sd = ShapeObject(_selectedObjects[i]).shapeDefinition;
							sd.strokeColor = int(settings[setting]);
							
							ShapeObject(_selectedObjects[i]).shapeDefinition = sd;
							
						}  else if(_selectedObjects[i] is LineObject) {
							
							ld = LineObject(_selectedObjects[i]).lineDefinition;
							ld.strokeColor = int(settings[setting]);
							
							LineObject(_selectedObjects[i]).lineDefinition = ld;
							
						}
					
					} else if (setting == EditableParams.STROKE_ALPHA) {
						
						if(_selectedObjects[i] is ShapeObject) {
							
							sd = ShapeObject(_selectedObjects[i]).shapeDefinition;
							sd.strokeAlpha = int(settings[setting]);
							
							ShapeObject(_selectedObjects[i]).shapeDefinition = sd;
							
						}  else if(_selectedObjects[i] is LineObject) {
							
							ld = LineObject(_selectedObjects[i]).lineDefinition;
							ld.strokeAlpha = int(settings[setting]);
							
							LineObject(_selectedObjects[i]).lineDefinition = ld;
							
						}
						
					}  else if (setting == EditableParams.STROKE_SIZE) {
						
						if(_selectedObjects[i] is ShapeObject) {
							
							sd = ShapeObject(_selectedObjects[i]).shapeDefinition;
							sd.strokeSize = int(settings[setting]);
							
							ShapeObject(_selectedObjects[i]).shapeDefinition = sd;
							
						}  else if(_selectedObjects[i] is LineObject) {
							
							ld = LineObject(_selectedObjects[i]).lineDefinition;
							ld.strokeSize = int(settings[setting]);
							
							LineObject(_selectedObjects[i]).lineDefinition = ld;
							
						}
						
					}
					
				}
				
				
			}
			
		}
		
		/**
		* The <code>addObject</code> method adds a GraffitObject to the assets list held by this Class.
		*
		* @param object GraffitObject
		*/
		public function addObject(object:GraffitiObject):void {
			
			if (_objectContainer == null) {
				_objectContainer = Sprite(object.parent);
			}
			
			// add listener so we know it it is removed from the stage
			object.addEventListener(Event.REMOVED_FROM_STAGE, cleanUp);
			
			// set show selection rectangle
			object.showSelectionRectangle = _showSelectionRectangle;
			
			// add to object list
			_objects.push(object);
			
		}
		
		/**
		* The <code>removeObject</code> method will remove a graffiti object from the object manager.
		*
		* @param object Graffiti Object to remove.
		*/
		public function removeObject(object:GraffitiObject):void {
			
			// remove item from entire list
			removeItemFromList(object, _objects);
			
			// remove item from selected list (if in it)
			removeItemFromList(object, _selectedObjects);
			
		}
		
		/**
		* The <code>moveSelectedObjects</code> method will move all selected objects by the x and y offset values passed.
		*
		* @param xOffset The amount to move each object on the x axis.
		* @param yOffset The amount to move each object on the y axis.
		*/
		public function moveSelectedObjects(xOffset:Number, yOffset:Number):void {
			
			var num:int = _selectedObjects.length;
			
			for(var i:int = 0; i<num; ++i) {

				_selectedObjects[i].x += xOffset;
				_selectedObjects[i].y += yOffset;
					
			}
			
			// dispatch move event if there are selected objects
			if(num > 0) {
				dispatchEvent(new GraffitiObjectEvent(_selectedObjects, GraffitiObjectEvent.MOVE));
			}
			
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
			
			if(_selectedObjects.length > 0) {
				dispatchEvent(new GraffitiObjectEvent(_selectedObjects, GraffitiObjectEvent.SELECT));
			}
			
		}
		
		/**
		* The <code>setSelectionByRectangle</code> method will select all objects that are within the passed rectangle.
		*
		* @param rect Rectangle used to make the selection.
		* @param includePartiallySelected Indicates if objects partly within the rectangle should be included in selection. Default is false.
		*/
		public function setSelectionByRectangle(rect:Rectangle, includePartiallySelected:Boolean = false):void {
			
			var objectBounds:Rectangle;
			var insideRect:Boolean;
			
			var numObjects:uint = _objects.length - 1;
			var newObjectsSelected:Boolean = false;
			
			var deselectedObjects:Vector.<GraffitiObject> = new Vector.<GraffitiObject>();
		
			for (var i:int = numObjects; i >= 0; i--) {
				
				objectBounds = _objects[i].getBounds(_objectContainer);
				insideRect = includePartiallySelected ? rect.intersects(objectBounds) : rect.containsRect(objectBounds);
				
				if(!insideRect && _objects[i].selected) {
					removeItemFromList(_objects[i], _selectedObjects);
					_objects[i].selected = false;
					deselectedObjects.push(_objects[i]);
				
				} else if(!_objects[i].selected && insideRect) {
					newObjectsSelected = true;
					_objects[i].selected = true;
					_selectedObjects.push(_objects[i]);
					
				}
					
			}
			
			// dispatch deselect events if objects where deselected
			if(deselectedObjects.length > 0) {
				dispatchEvent(new GraffitiObjectEvent(deselectedObjects, GraffitiObjectEvent.DESELECT));
			}
			
			// dispatch select events if objects where deselected
			if(_selectedObjects.length > 0 && newObjectsSelected) {
				dispatchEvent(new GraffitiObjectEvent(_selectedObjects, GraffitiObjectEvent.SELECT));
			}
				
		}
		
		/**
		* The <code>addToSelection</code> method will add a new graffiti object to selected objects.
		*
		* @param go Graffiti Object to select.
		*/
		public function addToSelection(go:GraffitiObject):void {
			
			if(_selectedObjects == null) {
				_selectedObjects = new Vector.<GraffitiObject>();
			}
			
			if(!go.selected) {
				go.selected = true;
				_selectedObjects.push(go);
				dispatchEvent(new GraffitiObjectEvent(_selectedObjects, GraffitiObjectEvent.SELECT));
			}
			
		}
		
		/**
		* The <code>removeFromSelection</code> method will remove a graffiti object from the selected objects.
		*
		* @param go Graffiti Object to remove from selection.
		*/
		public function removeFromSelection(go:GraffitiObject):void {
			
			if(_selectedObjects != null) {
				
				if(go.selected) {
					
					var numSelectedObjects:int = _selectedObjects.length;
					
					for(var i:int=0; i<numSelectedObjects; ++i) {
						
						if(_selectedObjects[i] == go) {
							
							_selectedObjects.splice(i, 1);
							break;
							
						}
						
					}
					
					go.selected = false;
					
					var deselect:Vector.<GraffitiObject> = new Vector.<GraffitiObject>();
					deselect.push(go);
					dispatchEvent(new GraffitiObjectEvent(deselect, GraffitiObjectEvent.DESELECT));
					
				}
				
			}
			
		}
		
		/**
		* The <code>deselectAll</code> method deselects all selected objects.
		*/
		public function deselectAll():void {
			
			// deselect all object in vector
			if(_selectedObjects.length > 0) {
				
				_selectedObjects.forEach(deselectObject);
				
				dispatchEvent(new GraffitiObjectEvent(_selectedObjects.concat(new Vector.<GraffitiObject>()), GraffitiObjectEvent.DESELECT));
				
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
			
			var gol:Vector.<GraffitiObject> = new Vector.<GraffitiObject>();
			
			// loop and delete all objects in the selected list
			for (var i:int = numSelectedObjects; i >= 0; --i) {
			
				if (!_selectedObjects[i].editing) {
					gol.push(_selectedObjects[i]);
				}
				
			}
			
			if(gol.length > 0) {
				dispatchEvent(new GraffitiObjectEvent(gol, GraffitiObjectEvent.DELETE));
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
			Method	: removeItemFromList()
			
			Purpose	: This method will remove a graffiti object from the list
					  of registered objects.
					
			Params	: item - GraffitiObject
					  list - The list of graffiti objects.
		***************************************************************************/
		private function removeItemFromList(item:GraffitiObject, list:Vector.<GraffitiObject>):void {
			
			var itemIndex:int = list.indexOf(item);
			
			if (itemIndex != -1) {
				list.splice(itemIndex, 1);
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
				
			}
				
		}
		
	}

}
