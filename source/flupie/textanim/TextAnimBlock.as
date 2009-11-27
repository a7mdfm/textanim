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
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * TextAnimBlock description
	 */
	public class TextAnimBlock extends Sprite
	{
		public var textAnim:TextAnim;
		public var textField:TextField;
		public var textFormat:TextFormat;
		public var index:int;
		public var firstLetterIndex:int;
		
		public var posX:Number = 0;
		public var posY:Number = 0;
		
		public var texture:Sprite;
		
		public function TextAnimBlock(textAnim:TextAnim, index:int)
		{
			texture = new Sprite();
			addChild(texture);
			
			this.textAnim = textAnim;
			this.index = index;
			
			textField = new TextField();

			textField.selectable = false;
			textField.embedFonts = true;
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
			if (contains(textField)) removeChild(textField);
			textField = null;
			textFormat = null;
			clearTexture();
			if (contains(texture)) removeChild(texture);
			texture = null;
		}

		public function updateRegistration(px:Number, py:Number):void
		{
			textField.x = px;
			textField.y = py;
			texture.x = textField.x;
			texture.y = textField.y;
			x = posX = posX - textField.x;
			y = posY = posY - textField.y;
		}
		
		public function clearTexture():void
		{
			for (var i:int = 0; i < texture.numChildren ; i++) {
				var c:* = texture.getChildAt(i);
				texture.removeChild(c);
				c = null;
				i--;
			}
			texture.mask = null;
			if (textField != null) addChild(textField);
		}
		
	}
}