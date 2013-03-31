/**
* GTween by Grant Skinner. Aug 1, 2005
* Visit www.gskinner.com/blog for documentation, updates and more free code.
*
*
* Copyright (c) 2005 Grant Skinner
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
**/

package
{
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.display.MovieClip;
	import flash.display.Stage;

	public class AdvancedCollision 
	{
		static public function checkForCollision(mc1, mc2:MovieClip, stage:Stage):Boolean 
		{
			// get bounds:
			var bounds1:Object = mc1.getBounds(stage);
			mc1.xMax = bounds1.x + bounds1.width;
			mc1.xMin = bounds1.x;
			mc1.yMax = bounds1.y + bounds1.height;
			mc1.yMin = bounds1.y;
			
			var bounds2:Object = mc2.getBounds(stage);
			mc2.xMax = bounds2.x + bounds2.width;
			mc2.xMin = bounds2.x;
			mc2.yMax = bounds2.y + bounds2.height;
			mc2.yMin = bounds2.y;
			
			// rule out anything that we know can't collide:
			if (((mc1.xMax < mc2.xMin) || (mc2.xMax < mc1.xMin)) || ((mc1.yMax < mc2.yMin) || (mc2.yMax < mc1.yMin))) 
				return false;
			
			// determine test area boundaries:
			var bounds:Object = new Object();
			bounds.xMin = Math.max(mc1.xMin,mc2.xMin);
			bounds.xMax = Math.min(mc1.xMax,mc2.xMax);
			bounds.yMin = Math.max(mc1.yMin,mc2.yMin);
			bounds.yMax = Math.min(mc1.yMax,mc2.yMax);
			
			// set up the image to use:
			var img:BitmapData = new BitmapData(bounds.xMax - bounds.xMin, bounds.yMax - bounds.yMin, false);
			
			// draw in the first image:
			var mat:Matrix = mc1.transform.concatenatedMatrix;
			mat.tx -= bounds.xMin;
			mat.ty -= bounds.yMin;
			img.draw(mc1,mat, new ColorTransform(1,1,1,1,255,-255,-255,255));
			
			// overlay the second image:
			mat = mc2.transform.concatenatedMatrix;
			mat.tx -= bounds.xMin;
			mat.ty -= bounds.yMin;
			img.draw(mc2,mat, new ColorTransform(1,1,1,1,255,255,255,255),"difference");
			
			// find the intersection:
			var intersection:Rectangle = img.getColorBoundsRect(0xFFFFFFFF,0xFF00FFFF);
			
			// if there is no intersection, return null:
			if (intersection.width == 0) 
				return false;

			return true;
		}
	}
}