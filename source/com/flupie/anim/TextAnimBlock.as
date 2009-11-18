package com.flupie.anim
{
	/**
	 * textAnim.TextAnim
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