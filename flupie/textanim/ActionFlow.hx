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

/**
 * flupie.textanim.TextAnim
 *	
 * @author		Guilherme Almeida, Mauro de Tarso
 */

import flash.events.EventDispatcher;
import haxe.Timer;

/**
 * Create an control a stream of functions dispatches.
 */
class ActionFlow extends EventDispatcher
{
	public static var FIRST_TO_LAST:String = "firstToLast";
	public static var LAST_TO_FIRST:String = "lastToFirst";
	public static var CENTER_TO_EDGES:String = "centerToEdges";
	public static var EDGES_TO_CENTER:String = "edgesToCenter";
	public static var RANDOM:String = "random";
	
	/**
	 * The way of stream will occurs, like FIRST_TO_LAST, CENTER_TO_EDGES, etc.
	 */
	public var way:String;
	
	/**
	 * The total duration (in milliseconds) of the stream, from the first dispatch to the last.
	 */
	public var time:Float;
	
	/**
	 * Callback function called when flow starts.
	 */
	public var onStart:Dynamic;
	
	/**
	 * Callback function called when each action dispatchs.
	 */
	public var onProgress:Dynamic;
	
	/**
	* Callback function called when the last action was dispatched .
	*/
	public var onComplete:Dynamic;

	private var queue:Array<Dynamic>;
	private var lastIndex:Int;

	/**
	 * Construtor. Only create the queue array.
	 */
	public function ActionFlow()
	{
		way = FIRST_TO_LAST;
		time = 1000;
		lastIndex = 0;
		queue = [];
	}
	
	/**
	 * Add a function to stream.
	 *	
	 * @param funct Function added.
	 */
	public function addFunction(funct:Dynamic):Void
	{
		queue[queue.length] = {funct:funct, timer:null};
	}
	
	/**
	 * Starts the stream.
	 */
	public function start():Void
	{
		switch (way) {
			case FIRST_TO_LAST :
				processFirstToLast();
			case LAST_TO_FIRST :
				processLastToFirst();
			case CENTER_TO_EDGES :
				processCenterToEdges();
			case EDGES_TO_CENTER :
				processEdgesToCenter();
			case RANDOM :
				processRandom();
			
			default : processFirstToLast();
		}
		
		if (onStart != null) onStart();
	}
	
	/**
	* Stops the stream.
	*/
	public function stop():Void
	{
		if (queue == null) return;
		for (i in 0... queue.length) {
			if (queue[i].timer != null) queue[i].timer.stop();
		}
	}
	
	/**
	* Stops the stream and clear queue.
	*/
	public function clear():Void
	{
		stop();
		queue = [];
	}
	
	private function setTimer(i:Int, num:Int):Void
	{
		var interv:Float = time/queue.length;
		var af:Dynamic = this;
		queue[i].timer = Timer.delay(function():Void {
			af.queue[i].funct(i);
			if (af.onProgress != null) af.onProgress();
			if (i == af.lastIndex && af.onComplete != null) af.onComplete();
		}, Std.int(num*interv));
	}
	
	private function processFirstToLast():Void
	{
		for(i in 0... queue.length){
			setTimer(i, i);
		}
		lastIndex = queue.length - 1;
	}
	
	private function processLastToFirst():Void
	{
		var num:Int = queue.length;
		for (i in 0... queue.length) {
			num--;
			setTimer(i, num);
		}
		lastIndex = 0;
	}
	
	private function processCenterToEdges():Void
	{
		var middle:Float = Math.floor(queue.length/2);
		for (i in 0... queue.length) {
			var num:Int = Std.int(Math.abs(i-middle));
			setTimer(i, num);
		} 
		lastIndex = 0;
	}
	
	private function processEdgesToCenter():Void
	{
		var middle:Int = Std.int(queue.length/2);
		for (i in 0... queue.length) {
			var num:Int = Std.int(middle - Math.abs(middle - i));
			setTimer(i, num);
		}
		lastIndex = middle;
	}
	
	private function processRandom():Void
	{
		var num:Int = 0;
		var temp:Array<Int> = [];
		
	   	for (i in 0... queue.length) {
			temp[i] = i;
		}
		
		for (i in 0... queue.length) {
			var r:Int = Math.round(Math.random()*(temp.length-1));
			num = temp.splice(r, 1)[0];
			if (num == queue.length-1) lastIndex = i;
			setTimer(i, num);
		}
	}	
}
