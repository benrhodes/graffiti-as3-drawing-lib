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
	import com.nocircleno.graffiti.tools.ITool;
	
	/**
	* SelectionTool Class is used to select an object.
	*
	* @langversion 3.0
    * @playerversion Flash 10 AIR 1.5 
	*/
	public class SelectionTool implements ITool
	{
		
		private const LAYER_TYPE:String = LayerType.OBJECT_LAYER;
		
		private var _renderType:String = ToolRenderType.SINGLE_CLICK;
		
		/**
		* The <code>SelectionTool</code> constructor.
		* @example The following code creates a Graffiti Canvas instance. 
		* <listing version="3.0" >
		* var selectionTool:SelectionTool = new SelectionTool();
		* </listing>
		*/
		public function SelectionTool() {}
		
		/**
		* Layer to work on.
		*/	
		public function get layerType():String
		{
			return LAYER_TYPE;
		}
		
		/**
		* Selection Tool Render Mode
		*/
		public function get renderType():String
		{
			return _renderType;
		}
		
	}

}