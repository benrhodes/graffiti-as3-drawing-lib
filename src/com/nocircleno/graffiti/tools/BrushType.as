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
	* Class provides constant values used to define the types of brushes available.
	*
	* @langversion 3.0
    * @playerversion Flash 10 AIR 1.5 
	*/
	public class BrushType {
		
		/**
		* Square Brush
		*/
		public static const SQUARE:String = "square";
		/**
		* Round Brush
		*/
		public static const ROUND:String = "round";
		/**
		* Horizontal Line Brush '-'
		*/
		public static const HORIZONTAL_LINE:String = "horizontal_line";
		/**
		* Vertical Line Brush '|'
		*/
		public static const VERTICAL_LINE:String = "vertical_line";
		/**
		* Foward Line Brush '/'
		*/
		public static const FORWARD_LINE:String = "forward_line";
		/**
		* Backward Line Brush '\'
		*/
		public static const BACKWARD_LINE:String = "backward_line";
		/**
		* Diamond Brush
		*/
		public static const DIAMOND:String = "diamond";
		
		/**
		* The <code>validType</code> method is used to validate a brush type.
		* 
		* @param type String to check to see if it is a valid Brush Type.
		* 
		*/
		static public function validType(type:String):Boolean {
		
			var valid:Boolean = false;
			
			if(type == BrushType.SQUARE || type == BrushType.ROUND || type == BrushType.HORIZONTAL_LINE || type == BrushType.VERTICAL_LINE || type == BrushType.FORWARD_LINE || type == BrushType.BACKWARD_LINE || type == BrushType.DIAMOND) {
				valid = true;
			}
			
			return valid;
			
		}
		
	}
	
}