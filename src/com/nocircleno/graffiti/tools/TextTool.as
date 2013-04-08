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
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;

	/**
	* TextTool Class is used to create and edit text objects for the graffiti library.
	*
	* @langversion 3.0
    * @playerversion Flash 10 AIR 1.5 
	*/
	public class TextTool implements ITool
	{
		
		private const LAYER_TYPE:String = LayerType.OBJECT_LAYER;
		
		private var _renderType:String = ToolRenderType.SINGLE_CLICK;
		private var _textSettings:TextSettings;
		
		/**
		* The <code>TextTool</code> constructor.
		*
		* @param textSettings TextSettings instance used when the TextTool is used.
		* 
		* @example The following code creates an instance of the TextTool.
		* <listing version="3.0" >
		* var fmt:TextFormat = new TextFormat();
		* fmt.font = "Arial";
		* fmt.size = 22;
		* fmt.color = 0x000000;
		* 
		* var textSettings:TextSettings = new TextSettings(fmt);
		* 
		* var textTool:TextTool = new TextTool(textSettings);
		* </listing>
		* 
		*/
		public function TextTool(textSettings:TextSettings) 
		{
			
			// store properties
			_textSettings = textSettings;
			
		}
		
		/**
		* Layer to create on.
		*/		
		public function get layerType():String {
			return LAYER_TYPE;
		}
		
		/**
		* Text Tool Render Mode
		*/
		public function get renderType():String {
			return _renderType;
		}
		
		/**
		* Text Settings used by the Text Tool
		*/
		public function get textSettings():TextSettings { return _textSettings; }
		
		public function set textSettings(value:TextSettings):void 
		{
			_textSettings = value;
		}
		
	}
	
}