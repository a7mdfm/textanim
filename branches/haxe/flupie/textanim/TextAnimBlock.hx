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

package flupie.textanim;

import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

/**
 * Represents a piece of TextAnim that contains a text slice. 
 */
class TextAnimBlock extends Sprite
{
	/**
	* The instance of TextAnim that the block belongs.
	*/		
	public var textAnim:TextAnim;
	
	/**
	* The textField containing the slice of original text.
	*/
	public var textField:TextField;
	
	/**
	* The TextFormat of the original text.
	*/
	public var textFormat:TextFormat;
	
	/**
	* Index works like a ID block in the TextAnim instance. Each block has a index, starting from 0 ascending to right. 
	* It serves as a reference for actions, delays and whatever it needs.
	*/		
	public var index:Int;
	
	/**
	* The original X position of the block, very useful for creating animations, this value is generated after all blocks are 
	* created and positioned. With this you always know where the original X position of text.
	*/		
	public var posX:Float;
	
	/**
	* The original Y position of the block, very useful for creating animations, this value is generated after all blocks are 
	* created and positioned. With this you always know where the original Y position of text.
	*/		
	public var posY:Float;
	
	/**
	* The container used for patterns, bitmaps, etc.
	*/
	public var texture:Sprite;
	
	/**
	 * TextAnimBlock is the most important object to manipulate your animations. No matter what you specify 
	 * breakMode every effect will receive a TextAnimBlock so you can animate it.
	 */
	
	public var nextBlock:TextAnimBlock;
	
	public var text(getText, setText):String;
	
	public function new(textAnim:TextAnim, index:Int)
	{
		super();
		
		posX = 0;
		posY = 0;
		
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
	
	private function setText(val:String):String
	{
		textField.htmlText = val;
		textField.setTextFormat(textFormat);
		return textField.text;
	}
	
	/**
	* You can change the text of a block at any time.
	*/
	public function getText():String { return textField.text; }
	
	/**
	* Clear the references.
	*/
	public function dispose():Void
	{
		if (contains(textField)) removeChild(textField);
		textField = null;
		textFormat = null;
		clearTexture();
		if (contains(texture)) removeChild(texture);
		texture = null;
	}

	/**
	* Sets the registration point of block;
	*	
	* @param px The horizontal registration.
	* @param py The vertical registration.	
	*/
	public function updateRegistration(px:Float, py:Float):Void
	{
		textField.x = px;
		textField.y = py;
		texture.x = textField.x;
		texture.y = textField.y;
		x = posX = posX - textField.x;
		y = posY = posY - textField.y;
	}
	
	/**
	* Clear the texture sprite that can contains any display objects, used in patterns, gradientColors, etc. 
	*/
	public function clearTexture():Void
	{
		var num:Int = texture.numChildren;
		for (i in num... 0) {
			var c:Dynamic = texture.getChildAt(i);
			texture.removeChild(c);
			c = null;
		}
		
		texture.mask = null;
		if (textField != null) addChild(textField);
	}
	
}
