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
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	/**
	* The ITool interface will be implemented by all tools.
	*
	* @langversion 3.0
    * @playerversion Flash 10 AIR 1.5 
	*/
	public interface ITool {
		
		/**
		* Type of Layer
		*/
		function get layerType():String;
		
		/**
		* Render Type
		*/
		function get renderType():String;
		
	}
	
}