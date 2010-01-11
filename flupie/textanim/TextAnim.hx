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

import flash.display.Shape;
import flash.display.Sprite;
import flash.display.BlendMode;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFormat;

/**
 * <code>TextAnim</code> is an extensible class to create text animations.
 *
 */
class TextAnim extends Sprite
{
	public static var BREAK_IN_LETTERS:String = Breaker.BREAK_IN_LETTERS;
	public static var BREAK_IN_WORDS:String = Breaker.BREAK_IN_WORDS;
	public static var BREAK_IN_LINES:String = Breaker.BREAK_IN_LINES;

	public static var ANIM_TO_RIGHT:String = ActionFlow.FIRST_TO_LAST;
	public static var ANIM_TO_LEFT:String = ActionFlow.LAST_TO_FIRST;
	public static var ANIM_TO_CENTER:String = ActionFlow.EDGES_TO_CENTER;
	public static var ANIM_TO_EDGES:String = ActionFlow.CENTER_TO_EDGES;
	public static var ANIM_RANDOM:String = ActionFlow.RANDOM;
	
	public static var ANCHOR_TOP:String = "T";
	public static var ANCHOR_BOTTOM:String = "B";
	public static var ANCHOR_LEFT:String = "L";
	public static var ANCHOR_CENTER:String = "C";
	public static var ANCHOR_RIGHT:String = "R";  
	
	public static var debug:Bool = false;
	
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
	public var effects:Dynamic;
	
	/**
	* It is the interval that effects will be dispatched for each block.
	* 
	* @default 100
	*/
	public var interval:Float;
	
	/**
	* Indicates the totalTime of effects dispatches.
	* <p>If it has a value different 0 that's overwrites the interval.</p>
	*       
	* @default 0
	*/
	public var time:Float;
	
	/**
	* Callback function called when the TextAnim start.
	*/
	public var onStart:Dynamic;
	
	/**
	* Callback function called when each effect dispatch.
	*/
	public var onProgress:Dynamic;
	
	/**
	* Callback function called when the last effect was dispatched .
	*/
	public var onComplete:Dynamic;
	
	/**
	* Callback function called when the blocks are created, or recreated.
	*	
	* <p>It occurs when the <code>breakMode</code> or <code>text</code> changes.</p> 
	*/
	public var onBlocksCreated:Dynamic;
	
	/**
	* Is the way of the effects dispatches will be occurs.
	*		
	* <p>Can be <code>ANIM_TO_RIGHT, ANIM_TO_LEFT, ANIM_TO_CENTER, ANIM_TO_EDGES and ANIM_RANDOM</code></p>
	*	
	* @default TextAnim.ANIM_TO_RIGHT
	* @see breakMode
	*/
	public var animMode:String;
	
	/**
	* It stores the TextAnimBlocks.
	*/
	public var firstBlock:TextAnimBlock;
	
	/**
	* Amount of TextAnimBlocks.
	*/
	public var length:UInt;
	
	public var anchorX(getAnchorX, setAnchorX):String;
	private var _anchorX:String;
	
	public var anchorY(getAnchorY, setAnchorY):String;
	private var _anchorY:String;
	
	public var breakMode(getBreakMode, setBreakMode):String;
	private var _breakMode:String;
	
	public var text(getText, setText):String;
	private var _text:String;
	
	public var blocksVisible(getBlocksVisible, setBlocksVisible):Bool;
	private var _blocksVisible:Bool;
	
	private var flow:ActionFlow;
	private var evStart:Event;
	private var evProgress:Event;
	private var evComplete:Event;
	
	
	/**
	* Construtor. Receives a TextField instance and instruction to replace that automatically.
	*	
	* <p>Using <code>autoReplace = false</code>, you must add the TextAnim instance in the displayList manually.
	* By default, autoReplace is <code>true</code>. It means that TextAnim will do the addChild and position settings job.</p>
	*
	* @param source The TextField instance that TextAnim will be based.
	* @param autoReplace Do a replacement, removing the source and placing this TextAnim instance in the same scope, with same positions. (works only if the source textfield was in display list). 
	* 
	*/
	public function new(source:TextField, ?autoReplace:Bool = true)
	{
		super();

		interval = 100;
		time = 0;
		animMode = ANIM_TO_RIGHT;
		_anchorX = ANCHOR_CENTER;
		_anchorY = ANCHOR_CENTER;
		_breakMode = Breaker.BREAK_IN_LETTERS;
		_blocksVisible = true;
		
		this.source = source;
		length = 0;
		
		evStart = new Event(TextAnimEvent.START);
		evProgress = new Event(TextAnimEvent.PROGRESS);
		evComplete = new Event(TextAnimEvent.COMPLETE);
		
		flow = new ActionFlow();
		flow.onStart = startHandler; 
		flow.onProgress = progressHandler; 
		flow.onComplete = completeHandler; 

		text = source.htmlText;

		if (autoReplace) {
			x = source.x;
			y = source.y;
			
			if (source.parent != null) {
				source.parent.addChild(this);
				source.parent.swapChildren(this, source);
				if (!debug) source.parent.removeChild(source) else source.alpha = .3;
			}
		}
	}
	
	private function setText(value:String):String
	{
		source.htmlText = value;
		createBlocks();
		_text = value;
		return _text;
	}

	/**
	* To change the text, then all the blocks will be recreated.
	*
	*/
	private function getText():String { return _text; }

	private function setBreakMode(value:String):String
	{
		_breakMode = value;
		createBlocks();
		
		return _breakMode;
	}

	/**
	* To specify how the TextAnim will break the text.
	*
	* <p>The text can be broken in letter, word or line blocks.</p>	
	*		
	* @param value
	*/
	private function getBreakMode():String { return _breakMode; }

	/**
	* Starts the flow of effects dispatches.
	*
	* @see stop
	*/
	public function start():Void
	{
		flowSettings();
		flow.start();
	}

	/**
	* Stops the flow of effects dispatches.
	* 
	* @see start
	*/
	public function stop():Void
	{
		flow.stop();
	}

	/**
	* Clear all blocks, internal references, stops the progress and kill the TextAnim instance.
	*/
	public function dispose():Void
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

	private function setBlocksVisible(val:Bool):Bool
	{
		_blocksVisible = val;
		forEachBlock(function(block:TextAnimBlock):Void {
			block.visible = val;
		});
		return _blocksVisible;
	}
	
	/**
	* Sets the visibility of all blocks. 
	* In some animations the blocks must be hidden, to show them gradually.
	*/		
	private function getBlocksVisible():Bool
	{
		return _blocksVisible;
	}

	/**
	* To apply the effects to a single block, by the <code>index</code> of the <code>TextAnimBlock</code>.
	*	
	* @param blockIndex The index of the target block.
	*/
	public function applyEffect(block:TextAnimBlock):Void
	{
		var effectList:Array<Dynamic> = Std.is(effects, Array) ? effects : [effects];
		var bl:TextAnimBlock = block;

		if(block != null){
			block.visible = true;
			if (effects != null) {
				var i:Int = effectList.length - 1;
				while (i >= 0) {
					var eff:Dynamic = effectList[i];
					eff(block);
					i--;
				}
			}
		}
	}

	/**
	* Apply a function to each block of this TextAnim.  
	* 
	* <p>This method takes a callback function and will call it according to the amount of blocks. 
	* This must receive a callback object of type as a parameter <code>TextAnimBlock</code></p>
	*
	* @param act The function that will be applied to blocks.		
	*/
	public function forEachBlock(callBack:Dynamic):Void
	{
		var block:TextAnimBlock = firstBlock;
		while (block != null) {
			callBack(block);
			block = block.nextBlock;
		}
	}
	
	/**
	* Modify the registration x and y of all blocks.
	*	
	* @param anchorX The horizontal registration (textAnim.ANCHOR_LEFT, textAnim.ANCHOR_RIGHT and textAnim.CENTER).
	* @param anchorX The vertical registration (textAnim.ANCHOR_TOP, textAnim.ANCHOR_BOTTOM and textAnim.CENTER). 
	*/
	public function setAnchor(anchorX:String, anchorY:String):Void
	{
		if (anchorX == ANCHOR_LEFT || anchorX == ANCHOR_CENTER || anchorX == ANCHOR_RIGHT) _anchorX = anchorX;
		if (anchorY == ANCHOR_TOP || anchorY == ANCHOR_CENTER || anchorY == ANCHOR_BOTTOM) _anchorY = anchorY;
		forEachBlock(blockSettings);
	}
	
	private function setAnchorX(val:String):String
	{
		if (val == ANCHOR_LEFT || val == ANCHOR_CENTER || val == ANCHOR_RIGHT) {
			_anchorX = val;
			forEachBlock(blockSettings);
		}
		
		return _anchorX;
	}
	
	/**
	 * The horizontal registration of each TextAnimBlock.
	 *
	 * <p>It can be <code>TextAnim.ANCHOR_CENTER, TextAnim.ANCHOR_LEFT, TextAnim.ANCHOR_RIGHT</code></p>	
	 * @default TextAnim.ANCHOR_CENTER;
	 * @see setAnchor	
	 */
	private function getAnchorX():String { return _anchorX; }
	
	private function setAnchorY(val:String):String
	{
		if (val == ANCHOR_TOP || val == ANCHOR_CENTER || val == ANCHOR_BOTTOM) {
			_anchorY = val;
			forEachBlock(blockSettings);
		}
		
		return _anchorY;
	}
	/**
	 * The vertical registration of each TextAnimBlock.
	 *
	 * <p>It can be <code>TextAnim.ANCHOR_CENTER, TextAnim.ANCHOR_TOP, TextAnim.ANCHOR_BOTTOM</code></p>	
	 * @default TextAnim.ANCHOR_CENTER;
	 * @see setAnchor	
	 */
	public function getAnchorY():String { return _anchorY; }
	
	/**
	 *	@private
	 */
	private function createBlocks():Void
	{
		if (firstBlock != null) removeBlocks();

		flow.clear();
		firstBlock = Breaker.separeBlocks(this, _breakMode);
		forEachBlock(blockSettings);
		if (onBlocksCreated != null) onBlocksCreated(); 
	}

	private function removeBlocks():Void
	{
		flow.clear();
		forEachBlock(killBlock);
		length = 0;
		firstBlock = null;
	}

	private function blockSettings(block:TextAnimBlock):Void
	{
		var bounds:Rectangle = source.getCharBoundaries(block.index);
		if (bounds == null) bounds = new Rectangle();
		var fmt:TextFormat = source.getTextFormat(block.index, block.index+1);

		var modX:Float = fmt.indent + fmt.leftMargin;

		block.textField.x = block.textField.y = block.texture.x = block.texture.y = 0;
		block.posX = block.x = bounds.x - 2 - modX;
		block.posY = block.y = bounds.y - 2;

		var i:Int = block.textField.text.length - 1;
		
		while (i >= 0) {
			var fmt = source.getTextFormat(block.index+i, block.index+i+1);
			if (fmt != null) block.textField.setTextFormat(fmt, i, i+1);
			i--;
		}
		
		block.visible = _blocksVisible;
		addChild(block);
		
		anchorConfig(block);
		
		length++;
	}
	
	private function killBlock(block:TextAnimBlock):Void
	{
		if (contains(block)) removeChild(block);
		block.dispose();
		block = null;
	}
	
	private function anchorConfig(block:TextAnimBlock):Void
	{
		var bounds:Rectangle = TextAnimTools.getColorBounds(block);
		
		var px:Float = 0;
		var py:Float = 0;
		
		switch (_anchorX) {
			case ANCHOR_LEFT :
				px = -bounds.x;
			case ANCHOR_CENTER :
				px = -bounds.x - bounds.width/2;
			case ANCHOR_RIGHT :
				px = -bounds.x - bounds.width;
		}
		
		switch (_anchorY) {
			case ANCHOR_TOP :
				py = -bounds.y;
			case ANCHOR_CENTER :
				py = -bounds.y - bounds.height/2;
			case ANCHOR_BOTTOM :
				py = -bounds.y - bounds.height;
		}
		
		block.updateRegistration(px, py);
		
		if (debug && block.getChildByName("regRef") == null) {
			var regRef:Shape = new Shape();
			regRef.name = "regRef";
			regRef.graphics.beginFill(0xFF0000);
			regRef.graphics.drawRect(0, 0, 2, 2);
			regRef.graphics.endFill();
			regRef.x = -1;
			regRef.y = -1;
			regRef.blendMode = BlendMode.INVERT;
			block.addChild(regRef);
		}
	}

	private function flowSettings():Void
	{
		var eff:Dynamic;
		var effectList:Array<Dynamic> = Std.is(effects, Array) ? effects : [effects];

		flow.clear();
		flow.way = animMode;
		if (time > 0) {
			flow.time = time;
		} else {
			flow.time = interval*length;
		}
		
		var ta:TextAnim = this;
		forEachBlock(function(block:TextAnimBlock):Void {
			ta.flow.addFunction(function(index:Int):Void {
				ta.applyEffect(block);
			});
		});
	}
	
	private function completeHandler():Void
	{
		_blocksVisible = true;
		if (onComplete != null) onComplete();
		dispatchEvent(evComplete); 
	}    
	
	private function progressHandler():Void
	{        
		if (onProgress != null) onProgress();
		dispatchEvent(evProgress); 
	}
	
	private function startHandler():Void
	{         
		if (onStart != null) onStart(); 
		dispatchEvent(evStart); 
	}

}
