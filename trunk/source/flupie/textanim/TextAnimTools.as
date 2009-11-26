/*
	The MIT License

	Copyright (c) 2009 Guilherme Almeida and Mauro de Tarso

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in
	all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
	THE SOFTWARE.
	
	http://code.google.com/p/textanim/
	http://flupie.net
*/       

package flupie.textanim
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	
	/**
	 * TextAnimTools description
	 */
	public class TextAnimTools
	{
		public static const ANCHOR_TOP:String = "T";
		public static const ANCHOR_MIDDLE:String = "M";
		public static const ANCHOR_BOTTOM:String = "B";
		public static const ANCHOR_LEFT:String = "L";
		public static const ANCHOR_CENTER:String = "C";
		public static const ANCHOR_RIGHT:String = "R";
		
		public static function toBitmap(textAnim:TextAnim, smooth:Boolean = false):void
		{	
			textAnim.applyToAllBlocks(function (block:TextAnimBlock):void {
				var bmpData:BitmapData = new BitmapData(block.textField.width * 4, block.textField.height * 4, true, 0x00000000);
				bmpData.draw(block);
				var rect:Rectangle = bmpData.getColorBoundsRect(0xff000000, 0x00000000, false);
				if (rect.width > 0) {
					bmpData.dispose();
					bmpData = new BitmapData(rect.width, rect.height, true, 0x00000000);
					var mtx:Matrix = new Matrix(1, 0, 0, 1, -rect.x, -rect.y);
					bmpData.draw(block, mtx);
				}
				
				if (block.bmp != null) {
					block.removeChild(block.bmp);
					block.bmp.bitmapData.dispose();
					block.bmp = null;
				}
				
				block.bmp = new Bitmap(bmpData, PixelSnapping.AUTO, smooth);
				block.addChild(block.bmp);
				
				block.bmp.x = rect.x;
				block.bmp.y = rect.y;
				
				if (block.contains(block.textField)) block.removeChild(block.textField);
				if (block.shape != null) if (block.contains(block.shape)) block.removeChild(block.shape);
				
			});
		}
		
		public static function toVector(textAnim:TextAnim):void
		{
			textAnim.applyToAllBlocks(function (block:TextAnimBlock):void {
				if (block.bmp != null) {
					block.removeChild(block.bmp);
					block.bmp.bitmapData.dispose();
					block.bmp = null;
				}
				
				if (block.shape != null) {
					block.addChild(block.shape);
					block.shape.mask = block.textField;
				}
				
				block.addChild(block.textField);
			});
		}
		
		public static function setPattern(textAnim:TextAnim, img:*, stretch:Boolean = false):void
		{
			textAnim.applyToAllBlocks(function (block:TextAnimBlock):void {
				
				var dt:BitmapData = new BitmapData(block.textField.width * 4, block.textField.height * 4, true, 0x00000000);
				var mt:Matrix = new Matrix(1,0,0,1, block.x, block.y);
				dt.draw(block);
				var bounds:Rectangle = dt.getColorBoundsRect(0xff000000, 0x00000000, false);
				dt.dispose();
				
				if (stretch) {
					img.width = bounds.width + 30;
					img.height = bounds.height + 30;
				}
				
				block.addChild(img);
				block.removeChild(block.textField);
				
				var pattern:BitmapData = new BitmapData(img.width, img.height, true, 0xffffff);
				pattern.draw(block);
				
				block.removeChild(img);
				
				if (block.shape != null) block.shape.graphics.clear();
				block.shape = new Shape();
				block.shape.graphics.beginBitmapFill(pattern);
				block.shape.graphics.drawRect(bounds.x-10, bounds.y-10, bounds.width+20, bounds.height+20);
				block.shape.graphics.endFill();
				block.shape.mask = block.textField;
				block.addChild(block.shape);
				block.addChild(block.textField);
			});
		}
		
		public static function setGradientLinear(textAnim:TextAnim, colors:Array, angle:Number = 0, alphas:Array = null, ratios:Array = null):void
		{
			textAnim.applyToAllBlocks(function (block:TextAnimBlock):void {
				var dt:BitmapData = new BitmapData(block.textField.width * 4, block.textField.height * 4, true, 0x00000000);
				dt.draw(block);
				var bounds:Rectangle = dt.getColorBoundsRect(0xff000000, 0x00000000, false);
				dt.dispose();
				
				if (block.shape != null) block.shape.graphics.clear();
				block.shape = new Shape();
				var mt:Matrix = new Matrix();
				mt.createGradientBox(bounds.width+20, bounds.height+20, angle*Math.PI/360);
				block.shape.graphics.beginGradientFill("linear", colors, alphas != null ? alphas : [1, 1], ratios != null ? ratios : [0, 255], mt);
				block.shape.graphics.drawRect(bounds.x-10, bounds.y-10, bounds.width+20, bounds.height+20);
				block.shape.graphics.endFill();
				block.shape.mask = block.textField;
				block.addChild(block.shape);
				block.addChild(block.textField);
			})
		}
		
		public static function blocksAnchor(textAnim:TextAnim, posX:String, posY:String, ignoreVisualBounds:Boolean = false):void
		{
			textAnim.applyToAllBlocks(function (block:TextAnimBlock):void {
				var rect:Rectangle = block.getBounds(block);
				var bmpData:BitmapData;
				if (!ignoreVisualBounds) {
					bmpData = new BitmapData(block.width*2, block.height*2, true, 0x00000000);
					bmpData.draw(block);
				    rect = bmpData.getColorBoundsRect(0xFFFFFF00, 0x00000000, false);
				}

				switch (posX) {
					case ANCHOR_LEFT :
						block.textField.x = -rect.x;
					break;
					case ANCHOR_CENTER :
						block.textField.x = -rect.x - rect.width/2;
					break;
					case ANCHOR_RIGHT :
						block.textField.x = -rect.x - rect.width;
					break;
				}
				
				switch (posY) {
					case ANCHOR_TOP :
						block.textField.y = -rect.y;
					break;
					case ANCHOR_MIDDLE :
						block.textField.y = -rect.y - rect.height/2;
					break;
					case ANCHOR_BOTTOM :
						block.textField.y = -rect.y - rect.height;
					break;
				}
				
				block.x = block.posX = block.posX - block.textField.x;
				block.y = block.posY = block.posY - block.textField.y;
				
				if (bmpData) {
					bmpData.dispose();
					bmpData = null;
				}
			});
		}

	}
}