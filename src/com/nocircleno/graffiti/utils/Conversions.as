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

package com.nocircleno.graffiti.utils {
	
	public class Conversions {
		/**
		* The <code>radians</code> method converts a degree value to radians.
		* 
		* @param degrees Angle in degrees.
		* 
		*/
		static public function radians(degrees:Number):Number {
			return degrees * Math.PI/180;
		}
		/**
		* The <code>degrees</code> method converts a radian value to degrees.
		* 
		* @param radians Angle in radians.
		* 
		*/
		static public function degrees(radians:Number):Number {
			return radians * 180/Math.PI;
		}
		
	}
	
}