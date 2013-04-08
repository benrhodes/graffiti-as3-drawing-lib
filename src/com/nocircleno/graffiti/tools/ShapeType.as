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
	
	/**
	* Class provides constant values used to define the types of shapes available.
	*
	* @langversion 3.0
    * @playerversion Flash 10 AIR 1.5 
	*/
	public class ShapeType {
		
		/**
		* Rectangle Shape
		*/
		public static const RECTANGLE:String = "rectangle";
		/**
		* Square Shape
		*/
		public static const SQUARE:String = "square";
		/**
		* Oval Shape
		*/
		public static const OVAL:String = "oval";
		/**
		* Circle Shape
		*/
		public static const CIRCLE:String = "circle";
		/**
		* The <code>validType</code> method is used to validate a shape type.
		* 
		* @param type String to check to see if it is a valid Shape Type.
		* 
		*/
		static public function validType(type:String):Boolean {
		
			var valid:Boolean = false;
			
			if(type == ShapeType.RECTANGLE || type == ShapeType.SQUARE || type == ShapeType.OVAL || type == ShapeType.CIRCLE) {
				valid = true;
			}
			
			return valid;
			
		}
		
	}
	
}