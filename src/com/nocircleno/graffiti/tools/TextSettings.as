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
	import flash.text.FontType;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	/**
	* TextSettings Class is used to configure the look of text for the graffiti library.
	*
	* @langversion 3.0
    * @playerversion Flash 10 AIR 1.5 
	*/
	public class TextSettings extends Object
	{
		
		private var _font:Font;
		private var _textFormat:TextFormat;
		private var _embeddedFont:Boolean = false;
		private var _backgroundColor:int;
		private var _borderColor:int;
		
		/**
		* The <code>TextSettings</code> constructor.
		*
		* @param font Font object used for text.
		* @param textFormat TextFormat Object used to display Text.
		* @param backgroundColor Background Color used for the text, set to -1 for no background.
		* @param borderColor Border Color used for the text, set to -1 for no border.
		* 
		* @example The following code creates an instance of the TextSettings.
		* <listing version="3.0" >
		* var allFonts:Array = Font.enumerateFonts(true);
		* allFonts.sortOn("fontName", Array.CASEINSENSITIVE);
		* 
		* var fmt:TextFormat = new TextFormat();
		* fmt.size = 22;
		* fmt.color = 0x000000;
		* 
		* var textSettings:TextSettings = new TextSettings(Font(allFonts[0]), fmt, -1, 0xFF0000);
		* </listing>
		* 
		*/
		public function TextSettings(font:Font, textFormat:TextFormat, backgroundColor:int = -1, borderColor:int = -1) 
		{
			
			// store properties
			this.font = font;
			this.textFormat = textFormat;
			_backgroundColor = backgroundColor;
			_borderColor = borderColor;
			
		}
		
		/**
		* Is the font used an embedded font.
		*/	
		public function get embeddedFont():Boolean { return _embeddedFont; }
		
		/**
		* Font Object
		*/	
		public function set font(f:Font):void {
			
			_font = f;
			
			// check to see if font is embedded or not
			if (_font.fontType == FontType.DEVICE) {
				_embeddedFont = false;
			} else {
				_embeddedFont = true;
			}
			
			// update text format object if exist
			if (_textFormat != null) {
				_textFormat.font = _font.fontName;	
			}
			
		}
		
		public function get font():Font {
			return _font;
		}
		
		/**
		* Text Format for Text
		*/	
		public function set textFormat(fmt:TextFormat):void {
			
			_textFormat = fmt;
			_textFormat.font = _font.fontName;
			
		}
		
		public function get textFormat():TextFormat {
			return _textFormat;
		}
		
		/**
		* Background Color of Text.  Set to -1 for no background.
		*/	
		public function set backgroundColor(color:int):void {
			_backgroundColor = color;
		}
		
		public function get backgroundColor():int {
			return _backgroundColor;
		}
		
		/**
		* Border Color of Text.  Set to -1 for no border.
		*/	
		public function set borderColor(color:int):void {
			_borderColor = color;
		}
		
		public function get borderColor():int {
			return _borderColor;
		}
		
		/**
		* The <code>clone</code> method will return a new instance of the TextSettings.
		*
		* @return Returns new TextSettings with all the same settings.
		*/
		public function clone():TextSettings {
			
			return new TextSettings(_font, _textFormat, _backgroundColor, _borderColor);
			
		}
		
	}
	
}