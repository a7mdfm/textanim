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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;

	/**
	 * <code>TextAnim</code> is an extensible class to create text animations.
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
		* Are the effect functions that will be called for all blocks, according to the interval specified.
		* 
		* <p>It can be an Array of functions or just one function.</p>
		* <p>Every effect works as a call and must receive a TextAnimBlock as parameter in order to animate as you want.</p>
		*/
		public var effects:*;
		
		/**
		* It is the interval that effects will be dispatched for each block.
		* 
		* @default 100
		*/
		public var interval:Number = 100;
		
		/**
		* Indicates the totalTime of effects dispatches.
		* <p>If it has a value different 0 that's overwrites the interval.</p>
		*       
		* @default 0
		*/
		public var time:Number = 0;
		
		/**
		* Callback function called when the TextAnim start.
		*/
		public var onStart:Function;
		
		/**
		* Callback function called when each effect dispatch.
		*/
		public var onProgress:Function;
		
		/**
		* Callback function called when the last effect was dispatched .
		*/
		public var onComplete:Function;
		
		/**
		* Callback function called when the blocks are created, or recreated.
		*	
		* <p>It occurs when the <code>breakMode</code> or <code>text</code> changes.</p> 
		*/
		public var onBlocksCreated:Function;
		
		/**
		* Is the way of the effects dispatches will be occurs.
		*		
		* <p>Can be <code>ANIM_TO_RIGHT, ANIM_TO_LEFT, ANIM_TO_CENTER, ANIM_TO_EDGES and ANIM_RANDOM</code></p>
		*	
		* @default TextAnim.ANIM_TO_RIGHT
		* @see breakMode
		*/
		public var animMode:String = ANIM_TO_RIGHT;
		
		/**
		* It stores the TextAnimBlocks.
		*/
		public var blocks:Array;
		
		
		private var _anchorX:String = ANCHOR_CENTER;
		private var _anchorY:String = ANCHOR_CENTER;
		
		
		private var _breakMode:String = Breaker.BREAK_IN_LETTERS;
		private var _text:String;
		private var _blocksVisible:Boolean = true;
		private var flow:ActionFlow;
		private var evStart:Event;
		private var evProgress:Event;
		private var evComplete:Event;
		
		
		/**
		* Contrutor. Receives a TextField instance and instruction to replace that automatically.
		*	
		* <p>Using <code>autoReplace = false</code>, you must add the TextAnim instance in the displayList manually.
		* By default, autoReplace is <code>true</code>. It means that TextAnim will do the addChild and position settings job.</p>
		*
		* @param source The TextField instance that TextAnim will be based.
		* @param autoReplace Do a replacement, removing the source and placing this TextAnim instance in the same scope, with same positions. (works only if the source textfield was in display list). 
		* 
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
				}
			}
		}
		
		public function set text(value:String):void
		{
			source.htmlText = value;
			createBlocks();
		}

		/**
		* To change the text, then all the blocks will be recreated.
		*
		*/
		public function get text():String { return source.text; }

		public function set breakMode(value:String):void
		{
			_breakMode = value;
			createBlocks();
		}

		/**
		* To specify how the TextAnim will break the text.
		*
		* <p>The text can be broken in letter, word or line blocks.</p>	
		*		
		* @param value
		*/
		public function get breakMode():String { return _breakMode; }

		/**
		* Starts the flow of effects dispatches.
		*
		* @param delay Time to wait before the first dispatch, in milliseconds.
		* @see stop
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
		* Stops the flow of effects dispatches.
		* 
		* @see start
		*/
		public function stop():void
		{
			flow.stop();
		}

		/**
		* Clear all blocks, internal references, stops the progress and kill the TextAnim instance.
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
			
			onStart = onProgress = onComplete = onBlocksCreated = null;
		}

		public function set blocksVisible(val:Boolean):void
		{
			_blocksVisible = val;
			applyToAllBlocks(function(block:TextAnimBlock):void {
				block.visible = val;
			})
		}
		
		/**
		* Sets the visibility of all blocks. 
		* In some animations the blocks must be hidden, to show them gradually.
		*/		
		public function get blocksVisible():Boolean
		{
			return _blocksVisible;
		}

		/**
		* To apply the effects to a single block, by the <code>index</code> of the <code>TextAnimBlock</code>.
		*	
		* @param blockIndex The index of the target block.
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
		* Apply a function to all the blocks of this instance. 
		* 
		* <p>This method takes a callback function and will call it according to the amount of blocks. 
		* This must receive a callback object of type as a parameter <code>TextAnimBlock</code></p>
		*
		* @param act The function that will be applied to blocks.		
		*/
		public function applyToAllBlocks(act:Function):void
		{
			for (var i:int = 0; i < blocks.length; i++) {
				act(blocks[i]);
			}
		}
		
		/**
		* Modify the registration x and y of all blocks.
		*	
		* @param anchorX The horizontal registration (textAnim.ANCHOR_LEFT, textAnim.ANCHOR_RIGHT and textAnim.CENTER).
		* @param anchorX The vertical registration (textAnim.ANCHOR_TOP, textAnim.ANCHOR_BOTTOM and textAnim.CENTER). 
		*/
		public function setAnchor(anchorX:String, anchorY:String):void
		{
			if (anchorX == ANCHOR_LEFT || anchorX == ANCHOR_CENTER || anchorX == ANCHOR_RIGHT) _anchorX = anchorX;
			if (anchorY == ANCHOR_TOP || anchorY == ANCHOR_CENTER || anchorY == ANCHOR_BOTTOM) _anchorY = anchorY;
			applyToAllBlocks(function(block:TextAnimBlock):void{
				blockSettings(block);
			});
		}
		
		public function set anchorX(val:String):void
		{
			if (val == ANCHOR_LEFT || val == ANCHOR_CENTER || val == ANCHOR_RIGHT) {
				_anchorX = val;
				applyToAllBlocks(function(block:TextAnimBlock):void{
					blockSettings(block);
				});
			}
		}
		/**
		 * The horizontal registration of each TextAnimBlock.
		 *
		 * <p>It can be <code>TextAnim.ANCHOR_CENTER, TextAnim.ANCHOR_LEFT, TextAnim.ANCHOR_RIGHT</code></p>	
		 * @default TextAnim.ANCHOR_CENTER;
		 * @see setAnchor	
		 */
		public function get anchorX():String
		{
			return _anchorX;
		}
		
		public function set anchorY(val:String):void
		{
			if (val == ANCHOR_TOP || val == ANCHOR_CENTER || val == ANCHOR_BOTTOM) {
				_anchorX = val;
				applyToAllBlocks(function(block:TextAnimBlock):void{
					blockSettings(block);
				});
			}
		}
		/**
		 * The vertical registration of each TextAnimBlock.
		 *
		 * <p>It can be <code>TextAnim.ANCHOR_CENTER, TextAnim.ANCHOR_TOP, TextAnim.ANCHOR_BOTTOM</code></p>	
		 * @default TextAnim.ANCHOR_CENTER;
		 * @see setAnchor	
		 */
		public function get anchorY():String
		{
			return _anchorY;
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
			
			if (onBlocksCreated != null) onBlocksCreated(); 
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

			var i:int = block.textField.text.length;
			while(i--)
				block.textField.setTextFormat(source.getTextFormat(block.index+i, block.index+i+1), i, i+1);
			
			block.visible = _blocksVisible;
			
			anchorConfig(block);
		}
		
		private function anchorConfig(block:TextAnimBlock):void
		{
			var bounds:Rectangle = TextAnimTools.getColorBounds(block);
			
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