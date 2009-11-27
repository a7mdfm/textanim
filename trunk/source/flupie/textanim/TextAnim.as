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
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	import flash.events.Event;

	/**
	 * <code>TextAnim</code> is a extensible Class to create text animations.
	 *
	 */
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
		
		public static const ANCHOR_TOP:String = "T";
		public static const ANCHOR_BOTTOM:String = "B";
		public static const ANCHOR_LEFT:String = "L";
		public static const ANCHOR_CENTER:String = "C";
		public static const ANCHOR_RIGHT:String = "R";  
		
		/**
		* The original TextField instance.
		* <p>That's can be whatever TextField instance, but you need to make sure to embed font. The textanim will preserve all 
		* settings TextFormat of the TextField has.</p>
		*/
		public var source:TextField;
		
		/**
		* Are the methods that will be called for all blocks according to the interval specified.
		* <p>It is an Array containing all the functions of effects that will be applied, or simply just a function.</p>
		* <p>Every effect works as a call and must receive a TextAnimBlock as parameter in order to animate as you want.</p>
		*/
		public var effects:*;
		
		/**
		* It is the interval in which the blocks will be dispatched
		* 
		* @default 100
		*/
		public var interval:Number = 100;
		
		/**
		* Time is to limit the time for dispatching blocks.
		* <p>If it has a value different 0 that's overwrites the interval.</p>
		*       
		* @default 0
		*/
		public var time:Number = 0;
		
		/**
		* Callback function called when the TextAnim start
		*/
		public var onStart:Function;
		
		/**
		* Callback function called during the blocks are dispatch
		*/
		public var onProgress:Function;
		
		/**
		* Callback function called it's done, all the blocks was dispatch 
		*/
		public var onComplete:Function;
		
		/**
		* animMode Is the way that the blocks of text will be cut.
		*	
		* <p>Can be <code>ANIM_TO_RIGHT, ANIM_TO_LEFT, ANIM_TO_CENTER, ANIM_TO_EDGES and ANIM_RANDOM</code></p>
		*	
		* @default ActionFlow.FIRST_TO_LAST
		* @see breakMode
		*/
		public var animMode:String = ActionFlow.FIRST_TO_LAST;
		
		/**
		* blocks is a public Array contains all blocks
		*/
		public var blocks:Array;
		
		public var anchorX:String = ANCHOR_CENTER;
		public var anchorY:String = ANCHOR_CENTER;
		
		private var _breakMode:String = Breaker.BREAK_IN_LETTERS;
		private var _text:String;
		private var _blocksVisibility:Boolean = true;
		private var flow:ActionFlow;
		private var evStart:Event;
		private var evProgress:Event;
		private var evComplete:Event;
		
		/**
		* The constructor recive your TextField instance. The textanim will preserve all settings TextFormat of the TextField has.
		*	
		* <p>You can specify that the autoReplace to FALSE, so the TextAnim will not do the swapChildren between TextAnim and TextField</p>
		*
		* @param source The TextField instance
		* @param autoReplace To make <code>swapChildren</code> of original TextField to TextAnim instance 
		* 
		* @see stop
		*/
		public function TextAnim(source:TextField, autoReplace:Boolean = true)
		{
			super();

			this.source = source;
			
			evStart = new Event(TextAnimEvent.START);
			evProgress = new Event(TextAnimEvent.PROGRESS);
			evComplete = new Event(TextAnimEvent.COMPLETE);
			
			flow = new ActionFlow();
			flow.onStart = startHandler; 
			flow.onProgress = progressHandler; 
			flow.onComplete = completeHandler; 

			blocks = [];
			text = source.htmlText;

			x = source.x;
			y = source.y;

			if (autoReplace) {
				if (source.parent != null) {
					source.parent.addChild(this);
					source.parent.swapChildren(this, source);
					source.parent.removeChild(source);
					source.alpha = .1;
				}
			}
		}

		public function set text(value:String):void
		{
			source.htmlText = value;
			createBlocks();
		}

		/**
		* To change text, that's will restart all.
		*	
		* @param value 
		*/
		public function get text():String { return source.text; }

		public function set breakMode(value:String):void
		{
			_breakMode = value;
			createBlocks();
		}

		/**
		* breakMode is a setter to specify how the TextAnim will breack the text block.
		*	
		* @param value 
		* @see animMode
		*/
		public function get breakMode():String { return _breakMode; }

		/**
		* start is the go ahead function.
		*
		* @param delay Time to wait before start.
		*/
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

		/**
		* stop to dispatch blocks
		* 
		* @see dispose
		*/
		public function stop():void
		{
			flow.stop();
		}

		/**
		* dispose method clear all internal reference and stop progress.
		* And also will try to do a removeChild the instance of TextAnim
		*/
		public function dispose():void
		{
			if (flow == null) return;

			stop();

			removeBlocks();
			blocks = null;

			flow.clear();
			flow = null;
			
			evStart = null;
			evProgress = null;
			evComplete = null;

			if (parent != null) {
				if (parent.contains(this)) parent.removeChild(this);
			}

			source = null;
		}

		/**
		* setBlocksVisibility This method is very useful when you need to control the visibility of the blocks. 
		* Some animations require the blocks disappear to enter or already on the screen and do something after.
		*/
		public function setBlocksVisibility(visibility:Boolean):void
		{
			_blocksVisibility = visibility;
			applyToAllBlocks(function(block:TextAnimBlock):void {
				block.visible = visibility;
			})
		}

		/**
		* applyEffect You can apply the effects starting from any one block, for that all <code>TextAnimBlock</code> has the property <code>index</code>.
		*/
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

		/**
		* applyToAllBlocks To get all the blocks of the list of blocks. 
		* <p>This method takes a callback function and will call it according to the amount of blocks. 
		* This must receive a callback object of type as a parameter <code>TextAnimBlock</code></p>
		*/
		public function applyToAllBlocks(act:Function):void
		{
			for (var i:int = 0; i < blocks.length; i++) {
				act(blocks[i]);
			}
		}
		
		public function setAnchor(anchorX:String, anchorY:String):void
		{
			this.anchorX = anchorX;
			this.anchorY = anchorY;
			applyToAllBlocks(function(block:TextAnimBlock):void{
				blockSettings(block);
			})
		}

		/**
		 *	@private
		 */
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

		private function blockSettings(block:TextAnimBlock):void
		{
			var bounds:Rectangle = source.getCharBoundaries(block.index);
			if (bounds == null) bounds = new Rectangle();
			var fmt:TextFormat = source.getTextFormat(block.index, block.index+1);

			var modX:Number = (fmt.indent as Number) + (fmt.leftMargin as Number);

			block.textField.x = block.textField.y = block.texture.x = block.texture.y = 0;
			block.posX = block.x = bounds.x - 2 - modX;
			block.posY = block.y = bounds.y - 2;
			block.textField.setTextFormat(fmt);
			
			block.visible = _blocksVisibility;
			
			bounds = TextAnimTools.getColorBounds(block);
			
			var px:Number;
			var py:Number;
			
			switch (anchorX) {
				case ANCHOR_LEFT :
					px = -bounds.x;
				break;
				case ANCHOR_CENTER :
					px = -bounds.x - bounds.width/2;
				break;
				case ANCHOR_RIGHT :
					px = -bounds.x - bounds.width;
				break;
			}
			
			switch (anchorY) {
				case ANCHOR_TOP :
					py = -bounds.y;
				break;
				case ANCHOR_CENTER :
					py = -bounds.y - bounds.height/2;
				break;
				case ANCHOR_BOTTOM :
					py = -bounds.y - bounds.height;
				break;
			}

			block.updateRegistration(px, py);
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
		
		private function completeHandler():void
		{
			if (onComplete != null) onComplete();
			dispatchEvent(evComplete); 
		}    
		
		private function progressHandler():void
		{        
			if (onProgress != null) onProgress();
			dispatchEvent(evProgress); 
		}
		
		private function startHandler():void
		{         
			if (onStart != null) onStart(); 
			dispatchEvent(evStart); 
		}

	}
}