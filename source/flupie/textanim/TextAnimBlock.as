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
	/**
	 * flupie.textanim.TextAnim
	 *	
	 * @author		Guilherme Almeida, Mauro de Tarso
	 */
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class TextAnimBlock extends Sprite
	{
		public var textAnim:TextAnim;
		public var textField:TextField;
		public var textFormat:TextFormat;
		public var index:int;
		public var firstLetterIndex:int;
		
		public var posX:Number = 0;
		public var posY:Number = 0;
		
		public var bmp:Bitmap;
		public var shape:Shape;
		
		public function TextAnimBlock(textAnim:TextAnim, index:int)
		{
			this.textAnim = textAnim;
			this.index = index;
			
			textField = new TextField();

			textField.selectable = false;
			textField.embedFonts = true;
			textField.x = 0;
			textField.y = 0;
			textField.autoSize = TextFieldAutoSize.LEFT;
			
			addChild(textField);
			
			textField.antiAliasType = textAnim.source.antiAliasType;
			textField.sharpness = textAnim.source.sharpness;
			textField.thickness = textAnim.source.thickness;
			textField.filters = textAnim.source.filters;
			
			textFormat = textAnim.source.getTextFormat();
			textField.setTextFormat(textFormat);
		}
		
		public function set text(val:String):void
		{
			textField.htmlText = val;
			textField.setTextFormat(textFormat);
		}
		
		public function get text():String
		{
			return textField.text;
		}
		
		public function dispose():void
		{
			removeChild(textField);
			textField = null;
			textFormat = null;
			if (bmp != null) {
				if (contains(bmp)) removeChild(bmp);
				bmp.bitmapData.dispose();
				bmp.bitmapData = null;
				bmp = null;
			}
			
			if (shape != null) {
				if (contains(shape)) removeChild(shape);
				shape.graphics.clear();
				shape = null;
			}
		}
	}
}