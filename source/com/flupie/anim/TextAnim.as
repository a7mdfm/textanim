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
*/

package com.flupie.anim
{
	/**
	 * textAnim.TextAnim
	 *	
	 * @author		Guilherme Almeida, Mauro de Tarso
	 */	
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;

	public class TextAnim extends Sprite
	{
		public static const BREAK_IN_LETTERS:String = Breaker.BREAK_IN_LETTERS;
		public static const BREAK_IN_WORDS:String = Breaker.BREAK_IN_WORDS;
		public static const BREAK_IN_LINES:String = Breaker.BREAK_IN_LINES;

		public static const ANIM_TO_RIGHT:String = ActionFlow.FIRST_TO_LAST;
		public static const ANIM_TO_LEFT:String = ActionFlow.LAST_TO_FIRST;
		public static const ANIM_TO_CENTER:String = ActionFlow.EDGES_TO_CENTER;
		public static const ANIM_TO_EDGES:String = ActionFlow.CENTER_TO_EDGES;
		public static const ANIM_RANDOM:String = ActionFlow.RANDOM;
		
		public var source:TextField;
		public var effects:*;
		
		public var interval:Number = 100;
		public var time:Number = 0;
		
		public var animMode:String = ActionFlow.FIRST_TO_LAST;
		private var _breakMode:String = Breaker.BREAK_IN_LETTERS;
		
		private var _text:String;
		public var blocks:Array;
		
		private var flow:ActionFlow;
		
		public function TextAnim(source:TextField, autoReplace:Boolean = true)
		{
			super();
			
			this.source = source;
			flow = new ActionFlow();
			
			blocks = [];
			text = source.htmlText;
			
			x = source.x;
			y = source.y;
			
			if (autoReplace) {
				trace("source.parent", source.parent);
				if (source.parent != null) {
					source.parent.addChild(this);
					source.parent.removeChild(source);
				}
			}
		}
		
		public function set text(val:String):void
		{
			source.htmlText = val;
			createBlocks();
		}
		
		public function get text():String
		{
			return source.text;
		}
		
		public function set breakMode(val:String):void
		{
			_breakMode = val;
			createBlocks();
		}
		
		public function get breakMode():String
		{
			return _breakMode;
		}
		
		public function start(delay:Number = 0):void
		{
			if (delay == 0) {
				flowSettings();
				flow.start();
			} else {
				setTimeout(function():void {
					flowSettings();
					flow.start();
				}, delay);
			}
		}
		
		public function stop():void
		{
			flow.stop();
		}
		
		public function dispose():void
		{
			stop();
			
			removeBlocks();
			blocks = null;
			
			flow.clear();
			flow = null;

			if (parent != null) {
				if (parent.contains(this)) parent.removeChild(this);
			}

			source = null;
		}

		public function setBlocksVisibility(visibility:Boolean):void
		{
			applyToAllBlocks(function(block:TextAnimBlock):void {
				block.visible = visibility;
			})
		}

		public function applyEffect(blockIndex:int):void
		{
			var effectList:Array = effects is Array ? effects : [effects];
			var bl:TextAnimBlock = blocks[blockIndex];

			if(bl != null){
				bl.visible = true;
				if (effects != null) {
					for (var k:int = 0; k<effectList.length; k++){
						var eff:Function = effectList[k];
						eff(bl);
					}
				}
			}
		}

		private function createBlocks():void
		{
			if (blocks.length > 0) removeBlocks();
			
			flow.clear();
			blocks = Breaker.separeBlocks(this, _breakMode);
			
			for (var i:int = 0; i < blocks.length; i++) {
				var block:TextAnimBlock = blocks[i];
				addChild(block);
				
				blockSettings(block);
			}
		}
		
		private function removeBlocks():void
		{
			flow.clear();
			
			applyToAllBlocks(function(block:TextAnimBlock):void {
				if (contains(block)) removeChild(block);
				block.dispose();
				block = null
			});
			blocks = [];
		}
		
		public function applyToAllBlocks(act:Function):void
		{
			for (var i:int = 0; i < blocks.length; i++) {
				act(blocks[i]);
			}
		}
		
		private function blockSettings(block:TextAnimBlock):void
		{
			var bounds:Rectangle = source.getCharBoundaries(block.index);
			if (bounds == null) bounds = new Rectangle();
			var fmt:TextFormat = source.getTextFormat(block.index, block.index+1);

			var modX:Number = (fmt.indent as Number) + (fmt.leftMargin as Number);

			block.posX = block.x = bounds.x - 2 - modX;
			block.posY = block.y = bounds.y - 2;
			block.textField.setTextFormat(fmt);
		}
		
		private function flowSettings():void
		{
			var eff:Function;
			var effectList:Array = effects is Array ? effects : [effects];

			flow.clear();
			flow.way = animMode;
			if (time > 0) {
				flow.time = time;
			} else {
				flow.time = interval*blocks.length;
			}

			for (var i:int=0; i<blocks.length; i++) {
				flow.addFunction(function(id:Number):void{
					applyEffect(id);
				});
			}
		}

	}
}