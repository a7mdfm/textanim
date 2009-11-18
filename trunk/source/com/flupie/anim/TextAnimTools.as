package com.flupie.anim
{
	/**
	 * textAnim.TextAnim
	 *	
	 * @author		Guilherme Almeida, Mauro de Tarso
	 */

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	public class TextAnimTools
	{
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
		
		public static function setGradientLinear(textAnim:TextAnim, colors:Array, ratios:Array = null, angle:Number = 0):void
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
				block.shape.graphics.beginGradientFill("linear", colors, [1, 1], ratios != null ? ratios : [0, 255], mt);
				block.shape.graphics.drawRect(bounds.x-10, bounds.y-10, bounds.width+20, bounds.height+20);
				block.shape.graphics.endFill();
				block.shape.mask = block.textField;
				block.addChild(block.shape);
				block.addChild(block.textField);
			})
		}

	}
}