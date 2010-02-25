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
	http://flupie.net/blog/
*/       

package flupie.textanim
{	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 *	TextAnim is an extensible class to create text animations.
	 *	<p>TextAnim works creating blocks of text, then applying functions that you create to each one of them.
	 *	We call these functions as "effects". These functions must receives a TextAnimBlock as a parameter.</p>
	 *	<p>Here is the most basic example:</p>
	 *	<p><code>
	 *	import flupie.textanim.*;
	 *	
	 *	var myTextAnim:TextAnim = new TextAnim(myTextField);
	 *	myTextAnim.effects = myEffect;
	 *	myTextAnim.start();
	 *	
	 *	function myEffect(block:TextAnimBlock):void {
	 *		block.scaleY = 2;
	 *	}
	 *	</code></p>
	 *
	 */
	public class TextAnim extends Sprite
	{
		/**
		* 	The original TextField instance thats TextAnim will use as reference. 
		* 	<p>Can be any textField, since it has an embed font.</p>
		*/
		public var source:TextField;
		
		/**
		* 	Are the effect functions that will be called for all blocks, according to the interval specified.
		* 	<p>It can be an Array of functions or just one. These functions must receives a TextAnimBlock as a parameter.</p>
		*	<p>Ex.:<code>
		*	myTextAnim.effects = effectFunction1;
		*	</code><p>or</p><code>
		*	myTextAnim.effects = [effectFunction1, effectFunction2];
		*	</code></p>
		*/
		public var effects:*;
		
		/**
		* 	Sets the interval (in milliseconds) between each effect dispatch.
		*	<p>If the interval is 300, it means that the TextAnim will dispatch an effect each 300 milliseconds, 
		*	until all the blocks are animated.</p>
		* 
		* 	@default 100
		*/
		public var interval:Number = 100;
		
		/**
		* 	Sets the delay (in milliseconds) before start.
		* 
		* 	@default 0
		*/
		public var delay:Number = 0;
		
		/**
		* 	Indicates a fixed total time (in milliseconds) of effects dispatches.
		* 	<p>A value of 5000 means the last dispatch will occurs 5 seconds after the first dispatch.
		*	Interval is ignored if time has a value higher than 0.</p>
		*       
		* 	@default 0
		*/
		public var time:Number = 0;
		
		/**
		* 	Callback function called when the TextAnim starts.
		*	<p>Runs only after delay setted.</p>
		*	<p><code>
		*	import flupie.textanim.*;
		*
		*	var myTextAnim:TextAnim = new TextAnim(myTextField);
		*	myTextAnim.effects = myEffect;
		*	myTextAnim.delay = 1000;
		*	myTextAnim.onStart = function():void {
		*		trace("textAnim starts after 1 second");
		*	}
		*	myTextAnim.start();
		*	</code></p>
		*	
		*	@default null
		*/
		public var onStart:Function;
		
		/**
		* 	Callback function called when each effect dispatch.
		*	<p><code>
		*	import flupie.textanim.*;
		*
		*	var myTextAnim:TextAnim = new TextAnim(myTextField);
		*	myTextAnim.effects = myEffect;
		*	myTextAnim.onProgress = function():void {
		*		trace("effect was dispatched.");
		*	}
		*	myTextAnim.start();
		*	</code></p>
		*	
		*	@default null
		*/
		public var onProgress:Function;
		
		/**
		* 	Callback function called when the last effect was dispatched.
		*	<p><code>
		*	import flupie.textanim.*;
		*
		*	var myTextAnim:TextAnim = new TextAnim(myTextField);
		*	myTextAnim.effects = myEffect;
		*	myTextAnim.onComplete = function():void {
		*		trace("text animation completed!");
		*	}
		*	myTextAnim.start();
		*	</code></p>
		*	
		*	@default null
		*/
		public var onComplete:Function;
		
		/**
		* 	Callback function called when the blocks are created, or recreated.
		* 	<p>It occurs when the <code>split</code> or <code>text</code> changes.</p> 
		*	
		*	@default null
		*/
		public var onBlocksCreated:Function;
		
		/**
		* 	Is the way of the effects dispatches will be occurs.
		*	<p>TextAnim dispatch effects in five diferent ways:
		*	TextAnimMode.FIRST_LAST - Begins with the first char and ends with last (left to right).
		*	TextAnimMode.LAST_FIRST - Begins with the last char and ends with first.
		*	TextAnimMode.EDGES_CENTER - Begins with the first and last, then evolues to center.
		*	TextAnimMode.CENTER_EDGES - Begins in the central chars and evolues to edges.
		*	TextAnimMode.RANDOM - Animate randomly.
		*	</p>
		*	
		* 	@default TextAnimMode.FIRST_LAST
		*/
		public var mode:String = TextAnimMode.FIRST_LAST;
		
		/**
		* 	The first block reference.
		*	<p>TextAnim has a singly linked list of blocks, and this is the head of the list.</p>
		*	
		*	@default null
		*/
		public var firstBlock:TextAnimBlock;
		
		/**
		* Amount of TextAnimBlocks.
		*/
		public var length:int;
		
		private var _text:String;
		private var _split:String = Splitter.CHARS;
		private var _anchorX:String = TextAnimAnchor.CENTER;
		private var _anchorY:String = TextAnimAnchor.CENTER;
		private var _blocksVisible:Boolean = true;
		private var flow:DispatchFlow;
		private var evStart:Event;
		private var evProgress:Event;
		private var evComplete:Event;
		
		
		/**
		* 	Constructor. Receives a TextField instance and instruction to replace that automatically.
		*	<p>The source textField must have the font embbeded. TextAnim will use the source as reference
		*	to create and organize TextAnimBlocks to looks identical to the source text. If the source already 
		*	is in displayList, TextAnim can self add in displayList in the same position/depth 
		*	with autoReplace setted as true</p>
		*	<p>
		*	By default, TextAnim creates the first set of blocks with the source text, but you can change this text
		*	everytime you want, using <code>text</code> or <code>htmlText</code> properties.
		*	</p>
		*	
		*	<p>
		*	Auto-replacement if the source textField is in displayList:
		*	<code>
		*	var anim:TextAnim = new TextAnim(myTextField);
		*	</code>
		*	</p><p>
		*	Without auto-replacement, then you need do add settings manually:
		*	<code>
		*	var anim:TextAnim = new TextAnim(myTextField, false);
		*	myTextField.x = 50;
		*	myTextField.y = 100;
		*	addChild(myTextField);
		*	</code>
		*	</p> 
		*
		* 	@param source The TextField instance that TextAnim will be based.
		* 	@param autoReplace Do a replacement removing the source and placing this TextAnim instance in the same scope, with same positions. (works only if the source textfield was in display list). 
		* 
		*/
		public function TextAnim(source:TextField, autoReplace:Boolean = true)
		{
			super();
			
			this.source = source;
			length = 0;
			
			evStart = new Event(TextAnimEvent.START);
			evProgress = new Event(TextAnimEvent.PROGRESS);
			evComplete = new Event(TextAnimEvent.COMPLETE);
			
			flow = new DispatchFlow();
			flow.onStart = startHandler; 
			flow.onProgress = progressHandler; 
			flow.onComplete = completeHandler; 

			text = source.text;

			if (autoReplace) {
				x = source.x;
				y = source.y;
				
				if (source.parent != null) {
					source.parent.addChild(this);
					source.parent.swapChildren(this, source);
					source.parent.removeChild(source);
				}
			}
		}
		
		
		/**
		* 	Creates an instance of TextAnim in a fast way.
		* 	<p>If you needs a fast text animation, hit:
		* 	<code>
		*	var anim:TextAnim = TextAnim.create(myTextField, {effects:myEffect, interval:50, split:TextAnimSplit.WORD});
		* 	</code>
		* 	</p>
		*
		* 	@param source The TextField instance that TextAnim will be based.
		* 	@param config Additional instance settings, like time, blocksVisible, etc.	
		*/
		public static function create(source:TextField, config:Object=null):TextAnim
		{
			var tanim:TextAnim = new TextAnim(source);
			tanim.blocksVisible = false;

			for (var prop:* in config) 
				if (tanim.hasOwnProperty(prop)) tanim[prop] = config[prop];
			
			return tanim;
		}
		
		
		public function set text(value:String):void
		{
			source.text = value;
			source.height = source.textHeight;
			createBlocks();
		}
		/**
		* 	Changes the text. All the blocks will be recreated.
		*	<p>The first value will be the same of the source's text. 
		*	If you need use html as text, use <code>htmlText</code>.</p>
		*	
		*	@see htmlText
		*/
		public function get text():String { return source.text; }
		
		
		
		public function set htmlText(value:String):void
		{
			source.htmlText = value.replace(/\r/g, "<br>");
			source.height = source.textHeight;
			createBlocks();
		}
		/**
		*	Sets a html as text. Like <code>text</code>, all the blocks will be recreated.
		*	
		*	@see text
		*/
		public function get htmlText():String { return source.htmlText; }
		


		public function set split(value:String):void
		{
			_split = value;
			createBlocks();
		}
		/**
		* 	To specify how the TextAnim will break the text: in chars, words or lines.
		*	<p>Everytime split changes, the blocks will be recreated automatically, 
		*	keeping the text and appearance.</p>
		*	<p><code>
		*	myTextAnim.split = TextAnimSplit.WORD; //this instance will be splitted in words.
		*	</code>
		*	</p>
		*		
		*	@see TextAnimSplit
		*/
		public function get split():String { return _split; }


		/**
		* 	Starts the flow of effects dispatches, with delay specified.
		*	<p><code>
		*	myTextAnim.start(2000); //This instance will start after 2 seconds.
		*	</code></p>
		* 	
		*	@param delay The time (in milliseconds) thats TextAnim will wait to execute the first dispatch.
		* 	
		*	@see stop
		*	@see delay
		*/
		public function start(delay:Number = 0):void
		{
			flowSettings();
			flow.start(delay > 0 ? delay : this.delay);
		}


		/**
		* 	Stops the flow of effects dispatches.
		*	<p>The effects, onProgress and textAnimEvent.PROGRESS dispatches stops.
		*	The onComplete will not be dispatched, except that animation starts again.</p>
		* 
		* 	@see start
		*/
		public function stop():void
		{
			flow.stop();
		}


		/**
		* 	Clear all blocks, internal references, stops the progress and kill the TextAnim instance.
		*	<p>Do it when the instance of TextAnim is not needed anymore. Delete blocks, remove references and clear memory.</p>
		*	<p><code>
		*	myTextAnim.dispose();
		*	myTextAnim = null;
		*	</code></p>
		*/
		public function dispose():void
		{
			if (flow == null) return;

			stop();

			removeBlocks();
			firstBlock = null;

			flow.clear();
			flow = null;
			
			evStart = null;
			evProgress = null;
			evComplete = null;

			if (parent != null) {
				if (parent.contains(this)) parent.removeChild(this);
			}

			source = null;
			length = 0;
			
			onStart = onProgress = onComplete = onBlocksCreated = null;
		}


		public function set blocksVisible(val:Boolean):void
		{
			_blocksVisible = val;
			forEachBlock(function(block:TextAnimBlock):void {
				block.visible = val;
			})
		}
		/**
		* 	Sets the visibility of all blocks. 
		* 	<p>Change the <code>visible</code> property of each block.
		*	In some animations the blocks must be hidden, to show them gradually.</p>
		*/		
		public function get blocksVisible():Boolean
		{
			return _blocksVisible;
		}


		/**
		*	To apply the effects to a single block.
		*	<p>Use when you need play the <code>effects</code> just to one block:
		*	<code>myTextAnim.applyEffect(myTextAnimBlock);</code>
		*	</p>
		*	
		* 	@param block The target block who plays the instance effects.
		*/
		public function applyEffect(block:TextAnimBlock):void
		{
			var effectList:Array = effects is Array ? effects : [effects];

			if(block != null){
				block.visible = true;
				if (effects != null) {
					var i:uint = effectList.length;
					while (i--){
						var eff:Function = effectList[i];
						eff(block);
					}
				}
			}
		}


		/**
		* 	Apply a function to each block of this TextAnim.
		*	<p>Offers access to all blocks of textAnim instance.</p>
		*	<code>
		*	myTextAnim.forEachBlock = function(block:TextAnimBlock):void {
		*		block.alpha = .5;
		*		trace(block.text);	
		*	};
		*	</code>
		*
		* 	@param callback The function that will be applied to each block.		
		*/
		public function forEachBlock(callback:Function):void
		{
			var block:TextAnimBlock = firstBlock;
			while (block) {
				var b:TextAnimBlock = block;
				block = block.nextBlock;
				callback(b);
			}
		}
		
		
		/**
		* 	Modify the registration x and y of all blocks.
		*	
		* 	@param anchorX The horizontal registration (TextAnimAnchor.LEFT, TextAnimAnchor.RIGHT and TextAnimAnchor.CENTER).
		* 	@param anchorX The vertical registration (TextAnimAnchor.TOP, TextAnimAnchor.BOTTOM and TextAnimAnchor.CENTER). 
		*/
		public function setAnchor(anchorX:String, anchorY:String):void
		{
			if (anchorX == TextAnimAnchor.LEFT || anchorX == TextAnimAnchor.CENTER || anchorX == TextAnimAnchor.RIGHT) _anchorX = anchorX;
			if (anchorY == TextAnimAnchor.TOP || anchorY == TextAnimAnchor.CENTER || anchorY == TextAnimAnchor.BOTTOM) _anchorY = anchorY;
			forEachBlock(blockSettings);
		}
		
		
		public function set anchorX(val:String):void
		{
			if (val == TextAnimAnchor.LEFT || val == TextAnimAnchor.CENTER || val == TextAnimAnchor.RIGHT) {
				_anchorX = val;
				forEachBlock(blockSettings);
			}
		}
		/**
		* 	The horizontal registration of each TextAnimBlock.
		*
		* 	<p>It can be <code>TextAnimAnchor.CENTER, TextAnimAnchor.LEFT, TextAnimAnchor.RIGHT</code></p>	
		* 	@default TextAnimAnchor.CENTER;
		*	@see setAnchor	
		*/
		public function get anchorX():String { return _anchorX; }
		
		
		public function set anchorY(val:String):void
		{
			if (val == TextAnimAnchor.TOP || val == TextAnimAnchor.CENTER || val == TextAnimAnchor.BOTTOM) {
				_anchorY = val;
				forEachBlock(blockSettings);
			}
		}
		/**
		* 	The vertical registration of each TextAnimBlock.
		*
		* 	<p>It can be <code>TextAnimAnchor.CENTER, TextAnimAnchor.TOP, TextAnimAnchor.BOTTOM</code></p>	
		* 	@default TextAnimAnchor.CENTER;
		* 	@see setAnchor	
		*/
		public function get anchorY():String { return _anchorY; }
		
		
		/**
		 *	@private
		 */
		private function createBlocks():void
		{
			if (firstBlock != null) removeBlocks();
			
			flow.clear();
			firstBlock = Splitter.separeBlocks(this, _split);
			forEachBlock(blockSettings);
			if (onBlocksCreated != null) onBlocksCreated(); 
		}

		private function removeBlocks():void
		{
			flow.clear();
			forEachBlock(killBlock);
			length = 0;
			firstBlock = null;
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
			addChild(block);
			
			anchorConfig(block);
			
			length++;
		}
		
		private function killBlock(block:TextAnimBlock):void
		{
			if (contains(block)) removeChild(block);
			block.dispose();
			block = null
		}
		
		private function anchorConfig(block:TextAnimBlock):void
		{
			var bounds:Rectangle = TextAnimTools.getColorBounds(block);
			
			var px:Number;
			var py:Number;
			
			switch (_anchorX) {
				case TextAnimAnchor.LEFT :
					px = -bounds.x;
					break;
				case TextAnimAnchor.CENTER :
					px = -bounds.x - bounds.width/2;
					break;
				case TextAnimAnchor.RIGHT :
					px = -bounds.x - bounds.width;
					break;
			}
			
			switch (_anchorY) {
				case TextAnimAnchor.TOP :
					py = -bounds.y;
					break;
				case TextAnimAnchor.CENTER :
					py = -bounds.y - bounds.height/2;
					break;
				case TextAnimAnchor.BOTTOM :
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
			flow.way = mode;
			if (time > 0) {
				flow.time = time;
			} else {
				flow.time = interval*length;
			}

			forEachBlock(function(block:TextAnimBlock):void {
				flow.addFunction(function(index:int):void{
					applyEffect(block);
				});
			});
		}
		
		private function completeHandler():void
		{
			_blocksVisible = true;
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