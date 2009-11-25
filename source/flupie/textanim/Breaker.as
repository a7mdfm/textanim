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

package com.flupie.anim
{
	/**
	 * com.flupie.anim.TextAnim
	 *	
	 * @author		Guilherme Almeida, Mauro de Tarso
	 * @private
	 */ 

	import flash.text.TextField;
	
	internal class Breaker
	{
		public static const BREAK_IN_LETTERS:String = "breakInLetters";
		public static const BREAK_IN_WORDS:String = "breakInWords";
		public static const BREAK_IN_LINES:String = "breakInLines";
		
		internal static function separeBlocks(block:TextAnim, separationMode:String = BREAK_IN_LETTERS):Array {
			var blocks:Array = [];
			switch (separationMode) {
				case "breakInLetters" :
					blocks=breakInLetters(block);
					break;
				case "breakInWords" :
					blocks=breakInWords(block);
					break;
				case "breakInLines" :
					blocks=breakInLines(block);
					break;
				default : blocks=breakInLetters(block);
			}
			return blocks;
		}
		
		internal static function createBlock(anim:TextAnim, str:String, index:Number):TextAnimBlock 
		{
			var block:TextAnimBlock = new TextAnimBlock(anim, index);
			block.text = str;
			return block;
		}
		
		internal static function breakInLetters(anim:TextAnim):Array 
		{
			var temp:Array = [];
			var txt:String = anim.source.text;
			
			for (var i:int = 0; i < txt.length; i++) {
				if(txt.substr(i, 1) != String.fromCharCode(13)) {
					var str:String = txt.substr(i, 1);
					if (stringTest(str)) temp.push(createBlock(anim, str, i));
				}
			}
			return temp;
		}
		
		internal static function breakInWords(anim:TextAnim):Array 
		{
			var temp:Array = [];
			var str:String = "";
			var firstIndex:Number=0;
			var txt:String = anim.source.text;
			
			for (var i:int = 0; i < txt.length; i++) {
				var s:String = txt.substr(i, 1);
				
				if (s != " " && s != null && s != String.fromCharCode(13)) {
					if(str == ""){
						firstIndex=i;
					}
					str += s;
				} else if (s != null) {
					var bl:TextAnimBlock = createBlock(anim, str, firstIndex);
					if (stringTest(str)) temp.push(createBlock(anim, str, firstIndex));
					str = "";
				}
			}

			if (stringTest(str)) temp.push(createBlock(anim, str, firstIndex));
			
			return temp;
		}
		
		internal static function breakInLines(anim:TextAnim):Array
		{
			var temp:Array = [];
			for (var i:int = 0; i < anim.source.numLines; i++) {
					var str:String = anim.source.getLineText(i);
					if (str != "" && str.length > 0 && str != null) {
						if (stringTest(str)) temp.push(createBlock(anim, str, anim.source.getLineOffset(i)));
					}
			}
			return temp;
		}
		
		private static function stringTest(str:String):Boolean
		{
			if (str != "" && str != " " && str.length > 0) return true;
			
			return false;
		}
	}
}