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
	* The Tool Render Type will be used in the future to implement Tools that need
	* different types of mouse interactions.
	*
	* @langversion 3.0
    * @playerversion Flash 10 AIR 1.5 
	*/
	public class ToolRenderType {
		
		/**
		*Use for Brush or Pencil functionality.
		*/
		public static const CONTINUOUS:String = "continuous";
		
		/**
		*Use for Tools like a line tool that need a single start point and an end point
		*during a single Mouse Down and Mouse Up operation.
		*/
		public static const CLICK_DRAG:String = "clickDrag";
		
		/**
		*Use for Tools like Fill Bucket, Selection and Text Tools
		*/
		public static const SINGLE_CLICK:String = "singleClick";
		
	}
	
}