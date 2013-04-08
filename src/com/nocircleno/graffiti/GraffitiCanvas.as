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
 
package com.nocircleno.graffiti {
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.LineScaleMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.filters.GradientGlowFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.geom.ColorTransform;
	import flash.ui.Keyboard;
	import com.nocircleno.graffiti.events.GraffitiObjectEvent;
	import com.nocircleno.graffiti.events.CanvasEvent;
	import com.nocircleno.graffiti.tools.ITool;
	import com.nocircleno.graffiti.tools.BitmapTool;
	import com.nocircleno.graffiti.tools.ToolRenderType;
	import com.nocircleno.graffiti.tools.BrushTool;
	import com.nocircleno.graffiti.tools.BrushType;
	import com.nocircleno.graffiti.tools.LineTool;
	import com.nocircleno.graffiti.tools.LineType;
	import com.nocircleno.graffiti.tools.ShapeTool;
	import com.nocircleno.graffiti.tools.ShapeType;
	import com.nocircleno.graffiti.tools.ToolMode;
	import com.nocircleno.graffiti.tools.TextTool;
	import com.nocircleno.graffiti.tools.FillBucketTool;
	import com.nocircleno.graffiti.tools.SelectionTool;
	import com.nocircleno.graffiti.tools.LayerType;
	import com.nocircleno.graffiti.display.GraffitiObject;
	import com.nocircleno.graffiti.display.Text;
	import com.nocircleno.graffiti.managers.GraffitiObjectManager;
	
	/**
	* The GraffitiCanvas Class provides an area on stage to draw in.  It extends
	* the Sprite Class, so you can add it as a child anywhere in the display list.
	* Once you've created an instance of the GraffitiCanvas Class you can assign
	* different tools to the canvas.
	*
	* <p>2.5 Features:
	* <ul>
	*	  <li>Create a drawing area up to 4095x4095 pixels.</li>
	*	  <li>Brush Tool providing 7 different Brush shapes with transparency and blur.</li>
	*     <li>Line Tool providing Solid, Dashed and Dotted lines.</li>
	*     <li>Shape Tool providing Rectangle, Square, Oval and Circle Shapes.</li>
	*     <li>Fill Bucket Tool provides a way to quickly fill a solid area of color with another color.</li>
	*     <li>Text Tool allows you to create, edit and move text on the canvas.</li>
	*	  <li>Add a bitmap or vector image under and/or over the drawing area of the Canvas.</li>
	*     <li>Built in zoom functionality including ability to drag an obscured canvas with the mouse.</li>
	*     <li>Keep and control a history of the drawing allowing undo and redo's</li>
	*     <li>Easily get a copy of your drawing to use with your favorite image encoder.</li>
	* </ul></p>
	* <p>It is up to the developer to implement a UI for these features.
	* </p>
	*
	* @langversion 3.0
    * @playerversion Flash 10 AIR 1.5 
	*/
	public class GraffitiCanvas extends Sprite {
		
		public static const HISTORY_LENGTH_CHANGE:String = "historyLengthChange";
		
		private const MAX_WIDTH:uint = 4095;
		private const MAX_HEIGHT:uint = 4095;
		private const MAX_BITMAP_DIM:uint = 5500;
		
		// display assets		
		private var drawing_layer:Sprite;
		private var object_layer:Sprite;
		private var container:Sprite;
		private var canvas:Bitmap;
		private var overlay_do:DisplayObject;
		private var underlay_do:DisplayObject;

		// private properties
		private var _bmp:BitmapData;
		private var _canvasEnabled:Boolean = true;
		private var _mouseDrag:Boolean = false;
		private var _tool:ITool;
		private var _prevPoint:Point;
		private var _canvasWidth:uint;
		private var _canvasHeight:uint;
		private var _zoom:Number = 1;
		private var _minZoom:uint = 1;
		private var _maxZoom:uint;
		private var _history:Vector.<BitmapData>;
		private var _maxHistoryLength:int;
		private var _historyPosition:uint = 0;
		private var _shiftKeyWasDown:Boolean = false;
		private var _objectManager:GraffitiObjectManager;
		
		/**
		* The <code>GraffitiCanvas</code> constructor.
		* 
		* @param canvasWidth Width of the canvas.
		* @param canvasHeight Height of the canvas.
		* @param numberHistoryLevels Max number of History items to keep, if 0 then no history is kept.
		* @param overlay An optional DisplayObject that can be used as an overlay to the Canvas.  DisplayObject should be partially transparent.
		* @param underlay An optional DisplayObject that can be used as an underlay to the Canvas.
		*
		* @example The following code creates a Graffiti Canvas instance. 
		* <listing version="3.0" >
		* package {
		*
		*		import flash.display.Sprite;
		*		import com.nocircleno.graffiti.GraffitiCanvas;
		*		import com.nocircleno.graffiti.tools.BrushTool;
		*		import com.nocircleno.graffiti.tools.BrushType;
		*		
		*		public class Main extends Sprite {
		*			
		*			public function Main() {
		*				
		*				// create new instance of graffiti canvas, with a width and height of 400 and 10 history levels.
		*				// by default a Brush instance is created inside the GraffitiCanvas Class and assigned as the active tool.
		*				var canvas:GraffitiCanvas = new GraffitiCanvas(400, 400, 10);
		*				addChild(canvas);
		*				
		*				// create a new BrushTool instance, brush size of 8, brush color is Red, fully opaque, no blur and Brush type is Backward line.
		*				var angledBrush:BrushTool = new BrushTool(8, 0xFF0000, 1, 0, BrushType.BACKWARD_LINE);
		*				
		*				// assign the Brush as the active tool used by the Canvas
		*				canvas.activeTool = angledBrush;
		*				
		*			}
		*			
		*		}
		* }
		* </listing>
		* 
		*/
		public function GraffitiCanvas(canvasWidth:uint = 100, canvasHeight:uint = 100, numberHistoryLevels:uint = 0, overlay:DisplayObject = null, underlay:DisplayObject = null) {
			
			// set width and height
			_canvasWidth = canvasWidth;
			_canvasHeight = canvasHeight;
			
			// check values
			checkPropertyLimits();
			
			/////////////////////////////////////////////////
			// Create Default Tool, a Brush
			/////////////////////////////////////////////////
			_tool = new BrushTool(16, 0x000000, 1, 0, BrushType.DIAMOND);
			
			/////////////////////////////////////////////////
			// Create Canvas Assets
			/////////////////////////////////////////////////
			drawing_layer = new Sprite();
			object_layer = new Sprite();
			container = new Sprite();
			
			_bmp = new BitmapData(_canvasWidth, _canvasHeight, true, 0x00FFFFFF);
			canvas = new Bitmap(_bmp, "auto", false);
			
			// add to display list
			addChild(container);
			container.addChild(canvas);
			container.addChild(drawing_layer);
			
			// if a overlay DisplayObject was passed, add it.
			if(overlay != null) {
				overlay_do = overlay;
				container.addChild(overlay_do);
			}
			
			// if a underlay DisplayObject was passed, add it.
			if(underlay != null) {
				underlay_do = underlay;
				container.addChildAt(underlay_do, 0);
			}
			
			// add object layer above everything
			container.addChild(object_layer);
			
			// add event listener
			object_layer.addEventListener(GraffitiObjectEvent.ENTER_EDIT, objectEventHandler, true, 0, true);
			object_layer.addEventListener(GraffitiObjectEvent.EXIT_EDIT, objectEventHandler, true, 0, true);
			
			// init object manager
			_objectManager = GraffitiObjectManager.getInstance();
			_objectManager.addEventListener(GraffitiObjectEvent.SELECT, objectEventHandler);
			_objectManager.addEventListener(GraffitiObjectEvent.DESELECT, objectEventHandler);
			_objectManager.addEventListener(GraffitiObjectEvent.DELETE, objectEventHandler);
			
			// add event listener for mouse down
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			
			// listen for stage add
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
			// set scroll rect
			this.scrollRect = new Rectangle(0, 0, _canvasWidth, _canvasHeight);
			
			/////////////////////////////////////////////////
			// Initialize Drawing History
			/////////////////////////////////////////////////
			initHistory(numberHistoryLevels);
		
		}
		
		/**
		* Control the canvas width.
		*
		* Important:
		* <ul>
		*	  <li>The canvas is resized from the upper left hand corner.</li>
		*	  <li>If you make the canvas width smaller, the drawing will get cropped on the right side.</li>
		*     <li>Changing the width of the canvas is NOT stored in the history.</li>
		* </ul>
		*/
		public function set canvasWidth(w:uint):void {
			// set width
			_canvasWidth = w;
			
			// check value
			checkPropertyLimits();
			
			// rebuild the canvas with the new width
			resizeCanvas();
		}
		
		public function get canvasWidth():uint {
			return _canvasWidth;
		}
		
		/**
		* Control the canvas height.
		*
		* Important:
		* <ul>
		*	  <li>The canvas is resized from the upper left hand corner.</li>
		*	  <li>If you make the canvas height smaller, the drawing will get cropped on the bottom.</li>
		*     <li>Changing the height of the canvas is NOT stored in the history.</li>
		* </ul>
		*/
		public function set canvasHeight(h:uint):void {
			// set height
			_canvasHeight = h;
			
			// check value
			checkPropertyLimits();
			
			// rebuild the canvas with the new height
			resizeCanvas();
		}
		
		public function get canvasHeight():uint {
			return _canvasHeight;
		}
		
		/**
		* Control the zoom state of the canvas from %100 (1) to the max zoom.
		*/
		public function set zoom(z:Number):void {
			
			// check bounds
			if(z >= _minZoom && z <= _maxZoom) {
				
				// find view center point to zoom off us.
				var centerPoint:Point = new Point((Math.abs(container.x) + _canvasWidth/2)/_zoom, (Math.abs(container.y) + _canvasHeight/2)/_zoom);
				
				// store zoom level
				_zoom = z;
				
				// scale container
				container.scaleX = _zoom;
				container.scaleY = _zoom;
				
				// try and keep the same center focus
				container.x = (-(centerPoint.x) * _zoom) + _canvasWidth/2;
				container.y = (-(centerPoint.y) * _zoom) + _canvasHeight/2;
				
				// enfore bounds and make sure no part of the image is out out of bounds
				if(container.x > 0) {
					container.x = 0;
				}
				
				if(container.y > 0) {
					container.y = 0;
				}
				
				if(container.x + container.width < _canvasWidth) {
					container.x = _canvasWidth - container.width;
				}
				
				if(container.y + container.height < _canvasHeight) {
					container.y = _canvasHeight - container.height;
				}
				
				// dispatch zoom event
				dispatchEvent(new CanvasEvent(CanvasEvent.ZOOM, _zoom, _canvasWidth, _canvasHeight, getViewableRect()));
				
			}
			
		}
		
		public function get zoom():Number {
			return _zoom;
		}
		
		/**
		* Minimum Zoom value.
		*/
		public function get minZoom():Number {
			return _minZoom;
		}
		
		/**
		* Maximum Zoom value.
		*/
		public function get maxZoom():Number {
			return _maxZoom;
		}
		
		/**
		* Control what Tool is used when the user interacts with the Canvas.
		*/
		public function set activeTool(tool:ITool):void {
			
			// set tool
			_tool = tool;
			
			// if tool isn't null, then check layer
			if(_tool != null) {
			
				// look to what layer this tool draws to
				if (_tool.layerType == LayerType.OBJECT_LAYER) {
					
					object_layer.mouseChildren = true;
					
					// make sure we turn off editing for any object on the canvas is the selection
					if (_tool is SelectionTool && _objectManager.areObjectsBeingEdited()) {
						_objectManager.exitEditAll();
					}
					
				} else {
					object_layer.mouseChildren = false;
					_objectManager.deselectAll();
				}
			
			// disable object layer
			} else {
				object_layer.mouseChildren = false;
				_objectManager.deselectAll();
			}
			
		}
		
		public function get activeTool():ITool {
			return _tool;
		}
		
		/**
		* Display Object displayed above the drawing.
		*/
		public function set overlay(displayObject:DisplayObject):void {
			
			// if overlay already exists remove it before adding new overlay
			if(overlay_do != null) {
				container.removeChild(overlay_do);
			}
			
			// update overlay
			overlay_do = displayObject;
			
			// add overlay if exists
			if(overlay_do != null) {
				container.addChildAt(overlay_do, container.numChildren - 1);
			}
			
		}
		
		/**
		* Display Object displayed under the drawing.
		*/
		public function set underlay(displayObject:DisplayObject):void {
			
			// if underlay already exists remove it before adding new underlay
			if(underlay_do != null) {
				container.removeChild(underlay_do);
			}
			
			// update underlay
			underlay_do = displayObject;
			
			// add underlay if exists
			if(underlay_do != null) {
				container.addChildAt(underlay_do, 0);
			}
			
		}
		
		/**
		* Control when you can use the mouse to drag around the canvas.
		*/
		public function set mouseDrag(drag:Boolean):void {
			
			if (drag) {
				_objectManager.deselectAll();
			}
			
			_mouseDrag = drag;
			
		}

		public function get mouseDrag():Boolean {
			return _mouseDrag;
		}

		/**
		* Control if Canvas is enabled.
		*/
		public function set canvasEnabled(en:Boolean):void {
			_canvasEnabled = en;
			this.mouseEnabled = en;
			this.mouseChildren = en;
		}
		
		public function get canvasEnabled():Boolean {
			return _canvasEnabled;
		}
		
		/**
		* Get the current number of saved history items.
		*/
		public function get historyLength():uint {
			return _history != null ? _history.length : 0;
		}
		
		/**
		* Get the maximum number of history items.
		*/
		public function get maxHistoryLength():uint {
			return _maxHistoryLength;
		}
		
		/**
		* Get the current history position.
		*/
		public function get historyPosition():uint {
			return _historyPosition;
		}
		
		
		/**
		* The <code>nextHistory</code> method will step forward and display the next item in 
		* the history.
		*
		* @see #prevHistory()
		* @see #historyLength
		* @see #historyPosition
		* @see #maxHistoryLength
		* @see #clearHistory()
		*/
		public function nextHistory():void {
			
			if(_history != null) {
			
				if(_historyPosition != _history.length - 1) {
					_historyPosition++;
					
					restoreFromHistory();
				}
				
			}
			
		}
		
		/**
		* The <code>prevHistory</code> method will step backwards and display the next item in 
		* the history.
		*
		* @see #prevHistory()
		* @see #historyLength
		* @see #historyPosition
		* @see #maxHistoryLength
		* @see #clearHistory()
		*/
		public function prevHistory():void {
			
			if(_history != null) {
			
				if(_historyPosition !=0) {
					_historyPosition--;
					
					restoreFromHistory();
				}
				
			}
			
		}
		
		/**
		* The <code>clearHistory</code> method will clear all history items.
		* the Canvas.
		*
		* @see #prevHistory()
		* @see #historyLength
		* @see #historyPosition
		* @see #maxHistoryLength
		* @see #clearHistory()
		*/
		public function clearHistory():void {
			
			if(_history != null) {
				
				var i:uint;
				
				// kill stored bitmapdata objects
				for(i=0; i<_history.length; ++i) {
					_history[i].dispose();
				}
				
				// create new vector
				_history = new Vector.<BitmapData>();
				
				// reset history position
				_historyPosition = 0;
				
			}
			
			// dispatch event for history length change
			dispatchEvent(new Event(GraffitiCanvas.HISTORY_LENGTH_CHANGE));
			
		}
		
		/**
		* The <code>fill</code> method will flood fill an area of the drawing with the supplied color.
		*
		* @param point Point at which to flood fill with color.
		* @param color Color to fill with.
		* @param useEntireCanvas Set to true to use an overlaid or underlaid display object when filling.
		* @param useAdvancedFill Set to smooth out the fill.
		* @param smoothStrength The strength of the smoothing when using the advanced fill setting.
		*/
		public function fill(point:Point, color:uint, useEntireCanvas:Boolean = false, useAdvancedFill:Boolean = true, smoothStrength:int = 8):void {
			
			// make sure point is within bitmap size
			if (_bmp.rect.containsPoint(point)) {
				
				// if a color is passed with no alpha component, then add it.
				if((color>>24) == 0) {
					
					// add alpha value to color value.
					color = 0xFF << 24 | color;
				
				}
				
				var snapshot1:BitmapData;
				var snapshot2:BitmapData;
				
				// get two snapshot copies
				if (useEntireCanvas) {
					
					// we do not want to include the object layer in the drawing capture
					this.object_layer.visible = false;
					snapshot1 = BitmapData(this.drawing(true));
					this.object_layer.visible = true;
					
				} else {
					snapshot1 = BitmapData(_bmp.clone());
				}
				
				// make another copy
				snapshot2 = BitmapData(snapshot1.clone());
				
				// fill on point
				snapshot1.floodFill(point.x, point.y, color);
				
				// compare snapshots
				var compareResult:Object = snapshot1.compare(snapshot2);
				
				// check to make sure compare result exists (snapshots are not the same).
				if (compareResult != 0) {
					
					var comp:BitmapData = BitmapData(compareResult);
					var compAlpha:BitmapData = comp.clone();
					
					// get alpha value from color
					var alphaValue:uint = color >> 24 & 0x000000FF;
					var alphaNormalized:Number = alphaValue * 0.003921568627450980392156862745098;
				
					// only apply filter if advanced fill is set
					if (useAdvancedFill) {
						
						// apply glow to smoothout and expand the fill a little
						comp.applyFilter(comp, comp.rect, new Point(0, 0), new GradientGlowFilter(0, 90, [color, color], [0, alphaNormalized], [0, 255], 2, 2, smoothStrength, BitmapFilterQuality.HIGH, BitmapFilterType.FULL, true));
						
						// we do not want to apply any alpha settings to this copy that will be used as an alpha mask with copy pixels
						compAlpha.applyFilter(comp, comp.rect, new Point(0, 0), new GradientGlowFilter(0, 90, [color, color], [0, 0], [0, 255], 2, 2, smoothStrength, BitmapFilterQuality.HIGH, BitmapFilterType.FULL));
					
					} else {
						
						// change color of fill difference to desired color
						var cTransform:ColorTransform = new ColorTransform(1, 1, 1, 0, 0, 0, 0, alphaValue);
						cTransform.color = color;
						comp.colorTransform(comp.rect, cTransform);
						
					}
					
					// copy fill back into bitmap
					_bmp.copyPixels(comp, comp.rect, new Point(0, 0), compAlpha, new Point(0, 0), true);

					// kill compare bitmapdata objects
					comp.dispose();
					compAlpha.dispose();
				
				}
				
				// kill snapshot bitmapdata objects
				snapshot1.dispose();
				snapshot2.dispose();
				
				// record to history if one is being recorded
				if(_maxHistoryLength != 0) {
					writeToHistory();
				}
				
			}
			
		}
		
		/**
		* The <code>getColorAtPoint</code> method will return the color at a specific point on the drawing.
		* If the point is out of bounds then 0 is returned.
		*
		* @param point Point to get color from.
		* @param useEntireCanvas A Boolean value that specifies whether to include any overlay or underlay display objects when reading the color at the point specified.
		*
		* @return Returns the color value at the point passed, returns 0 if point is outside of canvas dimensions.
		*/
		public function getColorAtPoint(point:Point, useEntireCanvas:Boolean = false):uint {
			
			var rColor:uint;
			
			// make sure point is within bitmap size
			if(_bmp.rect.containsPoint(point)) {
				
				if(useEntireCanvas) {
					
					// get snapshot
					var snapshot:BitmapData = BitmapData(this.drawing());
					
					// get color
					rColor = snapshot.getPixel32(point.x, point.y);
					
					// kill bitmapdata
					snapshot.dispose();
					
				} else {
				
					// get color
					rColor = _bmp.getPixel32(point.x, point.y);
				
				}
				
			} else {
				rColor = 0;
			}
			
			return rColor;
			
		}
		
		/**
		* The <code>getViewableRect</code> method will return a Rectangle defining the viewable area of the Canvas.
		* 
		* @return A Rectangle object that represents the viewable are of the Canvas.
		* If the canvas is zoomed all they way out then the dimensions of the Rectangle
		* are same as the Canvas width and height.
		*/
		public function getViewableRect():Rectangle {
			
			var absX:Number = container.x > 0.0 ? container.x : -container.x;
			var absY:Number = container.y > 0.0 ? container.y : -container.y;
			
			return new Rectangle(absX/_zoom, absY/_zoom, _canvasWidth/_zoom, _canvasHeight/_zoom);
		}
		
		/**
		* The <code>setCanvasPos</code> method will change the position of the canvas.
		* 
		* @param pos Point to move canvas to.
		*/
		public function setCanvasPos(pos:Point):void {
			
			// try and keep the same center focus
			container.x = pos.x;
			container.y = pos.y;
			
			// enfore bounds and make sure no part of the image is out out of bounds
			if(container.x > 0) {
				container.x = 0;
			}
			
			if(container.y > 0) {
				container.y = 0;
			}
			
			if(container.x + container.width < _canvasWidth) {
				container.x = _canvasWidth - container.width;
			}
			
			if(container.y + container.height < _canvasHeight) {
				container.y = _canvasHeight - container.height;
			}
		
		}
		
		/**
		* The <code>clearCanvas</code> method will clear the Canvas.
		*/
		public function clearCanvas():void {
			
			// clear canvas
			_bmp.fillRect(new Rectangle(0, 0, _canvasWidth, _canvasHeight), 0x00FFFFFF);
			
			// delete all objects
			_objectManager.selectAll();
			_objectManager.deleteSelected();
			
			// record to history if one is being recorded
			if(_maxHistoryLength != 0) {
				writeToHistory();
			}
			
		}
		
		/**
		* The <code>drawing</code> method will return the bitmapdata object that captures
		* the drawn canvas including any overlay or underlay assets.
		*
		* @param transparentBg Specify if you want the image to have a transparent background.
		* 
		* @return A BitmapData object containing the entire canvas.
		*/
		public function drawing(transparentBg:Boolean = false):BitmapData {
			
			// make sure we deselect all objects before capturing the canvas.
			_objectManager.deselectAll();
			
			var canvasBmp:BitmapData;
			
			if(!transparentBg) {
				canvasBmp = new BitmapData(_canvasWidth, _canvasHeight, false, 0xFFFFFFFF);
			} else {
				canvasBmp = new BitmapData(_canvasWidth, _canvasHeight, true, 0x00FFFFFF);
			}
			
			canvasBmp.draw(container);
			
			return canvasBmp;
			
		}
		
		/**
		* The <code>drawToCanvas</code> method will draw a display object or bitmapdata object to the canvas.
		* This allows you to add an image that will be editable by the drawing engine.
		* 
		* @param asset Image to write to canvas. Object must IBitmapDrawable. This includes MovieClips, Sprites, Bitmaps, BitmapData.
		*/
		public function drawToCanvas(asset:Object):void {
			
			if(asset is IBitmapDrawable) {
				
				_bmp.draw(IBitmapDrawable(asset));
				
				// record to history if one is being recorded
				if(_maxHistoryLength != 0) {
					writeToHistory();
				}
				
			}
			
		}
		
		/**************************************************************************
			Method	: addToStageHandler()
			
			Purpose	: This method will assign a listener for keyboard shortcuts
					  to the stage.
					  
			Params	: e - Event Object
		***************************************************************************/
		private function addToStageHandler(e:Event):void {
			
			this.removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyboardShortcutHandler);
			
		}
		
		/**************************************************************************
			Method	: keyboardShortcutHandler()
			
			Purpose	: This method will handles keyboard shortcuts.
					  
			Params	: e - KeyboardEvent Object
		***************************************************************************/
		private function keyboardShortcutHandler(e:KeyboardEvent):void {
			
			if(_canvasEnabled) {
			
				if (e.keyCode == Keyboard.DELETE) {
					_objectManager.deleteSelected();
				}
				
			}
			
		}
		
		/**************************************************************************
			Method	: objectEventHandler()
			
			Purpose	: This method will handle graffiti object events.
					  
			Params	: e - GraffitiObjectEvent Object
		***************************************************************************/
		private function objectEventHandler(e:GraffitiObjectEvent):void {
		
			var dispatch:Boolean = true;
			
			if (e.type == GraffitiObjectEvent.DESELECT) {
				
				if (e.graffitiObject is Text) {
					
					// if the text field has no text, then kill it
					if (Text(e.graffitiObject).text == "") {
						
						if (object_layer.contains(e.graffitiObject)) {
							object_layer.removeChild(e.graffitiObject);
						}
						
						dispatch = false;
					}
					
				}
		
			} else if (e.type == GraffitiObjectEvent.DELETE) {
				object_layer.removeChild(e.graffitiObject);
			}
			
			// stop event from rocking
			e.stopPropagation();
			
			// dispatch event if ok
			if (dispatch) {
				dispatchEvent(e.clone());
			}
			
		}
		
		/**************************************************************************
			Method	: checkPropertyLimits()
			
			Purpose	: This method will make sure canvas width, canvas height and
					  zoom level are within the bounds.
		***************************************************************************/
		private function checkPropertyLimits():void {
			
			// check bounds of canvas width and height
			_canvasWidth = _canvasWidth <= MAX_WIDTH ? _canvasWidth : MAX_WIDTH;
			_canvasHeight = _canvasHeight <= MAX_HEIGHT ? _canvasHeight : MAX_HEIGHT;
			
			// calculate max zoom to avoid bitmap display problems
			_maxZoom = Math.floor(MAX_BITMAP_DIM/Math.max(_canvasWidth, _canvasHeight));
			
			// check zoom to make sure if not greater then max zoom
			if(_zoom > _maxZoom) {
				this.zoom = _maxZoom;
			}
			
		}
		
		/**************************************************************************
			Method	: resizeCanvas()
			
			Purpose	: This method will resize the canvas assets.
		***************************************************************************/
		private function resizeCanvas():void {
			
			/////////////////////////////////////////////////
			// Create Bitmap
			/////////////////////////////////////////////////
			if(_bmp != null) {
				
				// make a copy of the canvas
				var bmpCopy:BitmapData = _bmp.clone();
				
				// kill current bitmap
				_bmp.dispose();
				
				// create new bitmapdata object with new width and height
				_bmp = new BitmapData(_canvasWidth, _canvasHeight, true, 0x00FFFFFF);
				
				// copy pixels back
				_bmp.copyPixels(bmpCopy, bmpCopy.rect, new Point(0, 0));
				
				// kill copy
				bmpCopy.dispose();
				
				// update canvas bitmapdata object
				canvas.bitmapData = _bmp;
				
			}
			
			// update scroll rect
			this.scrollRect = new Rectangle(0, 0, _canvasWidth, _canvasHeight);
			
		}
		
		/**************************************************************************
			Method	: initHistory()
			
			Purpose	: This method will initialize our drawing history.
			
			Params	: levels -- number of levels of history to keep.
		***************************************************************************/
		private function initHistory(levels:int):void {
			
			_maxHistoryLength = levels;
			
			if(_maxHistoryLength != 0) {
				
				// create history vector
				_history = new Vector.<BitmapData>();
				
				// record blank canvas to history
				writeToHistory();
				
			}
			
		}
		
		/**************************************************************************
			Method	: restoreFromHistory()
			
			Purpose	: This method will restore the drawing to a store history
					  drawing.
		***************************************************************************/
		private function restoreFromHistory():void {
			
			// get history bitmap rectangle
			var historyRect:Rectangle = _history[_historyPosition].rect;
			
			// check to see if the dims of history bitmap and the current canas size don't match
			if(historyRect.width != _canvasWidth || historyRect.height != _canvasHeight) {
				
				// create a tempory bitmapdata object the size of the canvas width and height
				var temp:BitmapData = new BitmapData(_canvasWidth, _canvasHeight, true, 0x00FFFFFF);
				
				// merge new tempory and history bitmapdata objects
				temp.copyPixels(_history[_historyPosition], _history[_historyPosition].rect, new Point(0, 0));
				
				// copy pixels to canvas bitmapdata
				_bmp.copyPixels(temp, temp.rect, new Point(0, 0));
				
				// kill temp bitmapdata
				temp.dispose();
				
			} else {
				
				// restore history
				_bmp.copyPixels(_history[_historyPosition], _history[_historyPosition].rect, new Point(0, 0));
			
			}
			
		}
		
		/**************************************************************************
			Method	: writeToHistory()
			
			Purpose	: This method will record the current drawing to history.
		***************************************************************************/
		private function writeToHistory():void {
			
			var historyLength:int = _history.length;
			
			// if the history position is not at the end then
			// we need to dispose of the top of the history queue.
			if(_historyPosition != historyLength - 1) {
				
				var i:int;
				
				for(i=(historyLength-1); i>_historyPosition; --i) {
					_history[i].dispose();
					_history.splice(i, 1);
				}
				
			}
			
			// if we have reached the max history length
			if(_history.length == _maxHistoryLength) {
				
				_history[0].dispose();
				_history.splice(0, 1);
				
			}
			
			// write current drawing to history
			_history.push(_bmp.clone());
			
			// set history index to end
			_historyPosition = _history.length - 1;
			
			// dispatch event for history length change
			dispatchEvent(new Event(GraffitiCanvas.HISTORY_LENGTH_CHANGE));
			
		}
		
		/**************************************************************************
			Method	: mouseHandler()
			
			Purpose	: This method will handle the mouse events used for drawing.
			
			Params	: e -- MouseEvent object.
		***************************************************************************/
		private function mouseHandler(e:MouseEvent):void {
			
			if(_canvasEnabled && (_tool != null || _mouseDrag)) {
	
				if(e.type == MouseEvent.MOUSE_DOWN) {
					
					// if mousedrag is true then user can click and drag canvas, only used if zoomed in on canvas.
					if(_mouseDrag) {
						
						container.startDrag(false, new Rectangle(-(container.width - _canvasWidth), -(container.height - _canvasHeight), (container.width - _canvasWidth), (container.height - _canvasHeight)));
						stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
						stage.addEventListener(MouseEvent.MOUSE_MOVE, dragEventUpdater);
						
					} else {
					
						if (_tool.renderType == ToolRenderType.SINGLE_CLICK) {
							
							if (_tool is FillBucketTool) {
								fill(new Point(container.mouseX, container.mouseY), FillBucketTool(_tool).fillColor, FillBucketTool(_tool).useEntireCanvas, FillBucketTool(_tool).useAdvancedFill, FillBucketTool(_tool).smoothStrength);						
							} else {
								
								// Get any objects under the mouse position.
								// We will use this to decide if we clicked on an object or just canvas
								var objs:Array = this.object_layer.getObjectsUnderPoint(new Point(container.mouseX, container.mouseY));
								var selectedObjects:Vector.<GraffitiObject>;
								var text:Text;
								
								// if no objects where click on...
								if (objs.length == 0) {
									
									if (_tool is TextTool) {
										
										if (_objectManager.areObjectsSelected()) {
											_objectManager.deselectAll();
										} else {
											
											text = new Text(TextTool(_tool).textSettings);
											text.x = container.mouseX;
											text.y = container.mouseY - (text.height/2);
											object_layer.addChild(text);
											
											_objectManager.deselectAll();
											_objectManager.addObject(text);
											
											// set the object as selection
											selectedObjects = new Vector.<GraffitiObject>();
											selectedObjects.push(text);
											
											_objectManager.setSelection(selectedObjects);
											
										}
										
									} else if (_tool is SelectionTool) {
										
										if (_objectManager.areObjectsSelected()) {
											_objectManager.deselectAll();
										} 
										
									}
								
								// determine what was clicked on
								} else {
									
									if (_tool is TextTool) {
									
										// get Text Reference
										if (e.target is TextField) {
											text = Text(e.target.parent);
										} else {
											text = Text(e.target);
										}
									
										if (!text.editing) {
											
											selectedObjects = new Vector.<GraffitiObject>();
											selectedObjects.push(text);
											
											_objectManager.setSelection(selectedObjects);
											
											text.editing = true;
											
										}
										
									} else if (_tool is SelectionTool) {
										
										var go:GraffitiObject;
										
										// get graffiti object Reference
										if (e.target.parent == this.object_layer) {
											go = GraffitiObject(e.target);
										} else if(e.target.parent.parent == this.object_layer) {
											go = GraffitiObject(e.target.parent);
										}
										
										selectedObjects = new Vector.<GraffitiObject>();
										selectedObjects.push(go);
											
										_objectManager.setSelection(selectedObjects);
										
										if (!go.editing) {
											go.startDrag();
										}
										
									}
									
									stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
									
								}
								
							} 
							
						} else {
						
							if (_tool.renderType == ToolRenderType.CLICK_DRAG) {
								_prevPoint = new Point(container.mouseX, container.mouseY);
							}
							
							stage.addEventListener(MouseEvent.MOUSE_MOVE, draw);
							draw();
							
							stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
							
						}
						
					}
					
				} else if(e.type == MouseEvent.MOUSE_UP) {
					
					stopDrag();
					
					// prevPoint will be defined if in drawing mode
					if(_prevPoint != null) {
						
						// if filters are present, this is a blur on a brush
						// need to divide the blur value by zoom for better effect.
						if (drawing_layer.filters.length > 0) {
							var modBrushBlur:Number = BrushTool(_tool).blur / _zoom;
							drawing_layer.filters = [new BlurFilter(modBrushBlur, modBrushBlur, 2)];
						}
						
						// draw to bitmap
						_bmp.draw(drawing_layer, new Matrix(), null, BitmapTool(_tool).mode);
						
						// clear vectors from drawing space
						drawing_layer.graphics.clear();
						
						// reset tool data
						BitmapTool(_tool).resetTool();
						
						// clear filters if they exist
						if(drawing_layer.filters.length > 0) {
							drawing_layer.filters = [];
						}
						
						// record to history if one is being recorded
						if(_maxHistoryLength != 0) {
							writeToHistory();
						}
						
						// clear prev point
						_prevPoint = null;
						
						// remove drawing event
						stage.removeEventListener(MouseEvent.MOUSE_MOVE, draw);
						
					} else {
						// remove drag event dispatcher
						stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragEventUpdater);
					}
						
					// remove mouse up event
					stage.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
					
				}
				
			}
		
		}
		
		/**************************************************************************
			Method	: dragEventUpdater()
			
			Purpose	: This method will dispatch the DRAG event for the canvas.
			
			Params	: e -- MouseEvent object.
		***************************************************************************/
		private function dragEventUpdater(e:MouseEvent):void {
			
			// dispatch zoom event
			dispatchEvent(new CanvasEvent(CanvasEvent.DRAG, _zoom, _canvasWidth, _canvasHeight, getViewableRect()));
			
		}
	
		/**************************************************************************
			Method	: draw()
			
			Purpose	: This method will draw a new line.
			
			Params	: e -- MouseEvent object that can be null.
		***************************************************************************/
		private function draw(e:MouseEvent = null):void {
			
			var toolRef:BitmapTool = BitmapTool(_tool);
			var nextPoint:Point = new Point(container.mouseX, container.mouseY);
			
			if(toolRef.renderType == ToolRenderType.CLICK_DRAG) {
				// clear vectors from drawing space
				drawing_layer.graphics.clear();
			}
			
			if(_prevPoint == null) {
				
				// apply tool
				toolRef.apply(drawing_layer, nextPoint);
				
			} else {
				
				///////////////////////////////////////////////////////
				// Check to see if SHIFT is down to enforce limits
				// on the Line or Shape tools.
				///////////////////////////////////////////////////////
				if(toolRef is LineTool && e != null) {
					
					// if shift then limit line to 90 degree angles
					if(e.shiftKey) {
						
						// calculate abs x and y difference values
						var xDiff:Number = nextPoint.x - _prevPoint.x;
						var yDiff:Number = nextPoint.y - _prevPoint.y;
						var absXDiff:Number = xDiff > 0.0 ? xDiff : -xDiff;
						var absYDiff:Number = yDiff > 0.0 ? yDiff : -yDiff;
						
						// lock to 45, 135, 225, or 295 angle
						if(xDiff > yDiff * .5 && xDiff * .5 < yDiff) {
							
							// take the lowest diff as the value to use
							var finalOffSet:Number = xDiff < yDiff ? xDiff : yDiff;
							
							// determine the new x & y values to give us a 45 degree angle value
							var xDiffRaw:Number = nextPoint.x - _prevPoint.x;
							var yDiffRaw:Number = nextPoint.y - _prevPoint.y;
							var xOffSet:Number = xDiffRaw < 0 ? -finalOffSet : finalOffSet;
							var yOffSet:Number = yDiffRaw < 0 ? -finalOffSet : finalOffSet;
							
							// update next point to be on a 45 degree angle
							nextPoint.x = _prevPoint.x + xOffSet;
							nextPoint.y = _prevPoint.y + yOffSet;
						
						// lock line to 0 or 180 angle
						} else if(absXDiff < absYDiff) {
							nextPoint.x = _prevPoint.x;
						// lock line to 90 or 270 angle
						} else {
							nextPoint.y = _prevPoint.y;
						}
						
					}
					
				} else if (toolRef is ShapeTool && e != null) {
					
					// if shift then make RECTANGLE -> SQUARE or OVAL -> CIRCLE
					if(e.shiftKey) {
					
						if(toolRef.type == ShapeType.OVAL) {
							toolRef.type = ShapeType.CIRCLE;
						} else if(toolRef.type == ShapeType.RECTANGLE) {
							toolRef.type = ShapeType.SQUARE;
						}
						
						// set flag
						_shiftKeyWasDown = true;
						
					} else {
						
						if(_shiftKeyWasDown) {
							
							// reset flag
							_shiftKeyWasDown = false;
						
							// check to see if we need to switch shapes back
							if(toolRef.type == ShapeType.CIRCLE) {
								toolRef.type = ShapeType.OVAL;
							} else if(toolRef.type == ShapeType.SQUARE) {
								toolRef.type = ShapeType.RECTANGLE;
							}
							
						}
						
					}
					
				}
				
				// apply tool
				toolRef.apply(drawing_layer, _prevPoint, nextPoint);
				
			}
			
			// if render type is continuous then write image to 
			if(_tool.renderType == ToolRenderType.CONTINUOUS) {
				
				// store prev point for next time
				_prevPoint = new Point(nextPoint.x, nextPoint.y);
				
				// erase modes need to be draw here and not on mouse up.
				if(toolRef.mode == ToolMode.ERASE) {
					
					// draw to bitmap
					_bmp.draw(drawing_layer, new Matrix(), null, toolRef.mode);
					
					// clear vectors from drawing space
					drawing_layer.graphics.clear();
					
					// reset tool data
					toolRef.resetTool();
					
				}
				
			}
			
			// force screen update if event object is defined
			if(e != null) {
				e.updateAfterEvent();
			}
				
		}
		
	}
		
}