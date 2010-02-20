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
	/**
	 * flupie.textanim.TextAnim
	 *	
	 * @author		Guilherme Almeida, Mauro de Tarso
	 */
 
	import flash.events.EventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	/**
	 * Create an control a stream of functions dispatches.
	 */
	public class ActionFlow extends EventDispatcher
	{
		public static const LEFT_RIGHT:String = "firstToLast";
		public static const RIGHT_LEFT:String = "lastToFirst"
		public static const EDGES_CENTER:String = "edgesToCenter";
		public static const CENTER_EDGES:String = "centerToEdges";
		public static const RANDOM:String = "random";
		
		/**
		 * The way of stream will occurs, like LEFT_RIGHT, EDGES_CENTER, etc.
		 */
		public var way:String = LEFT_RIGHT;
		
		/**
		 * The total duration (in milliseconds) of the stream, from the first dispatch to the last.
		 */
		public var time:Number = 1000;
		
		/**
		 * Callback function called when flow starts.
		 */
		public var onStart:Function;
		
		/**
		 * Callback function called when each action dispatchs.
		 */
		public var onProgress:Function;
		
		/**
		* Callback function called when the last action was dispatched .
		*/
		public var onComplete:Function;

		private var lastIndex:int = 0;
		private var firstAction:Object;
		private var lastAction:Object;
		private var length:uint;
		/**
		 * Construtor. Only create the queue array.
		 */
		public function ActionFlow()
		{
			length = 0;
		}
		
		/**
		 * Add a function to stream.
		 *	
		 * @param funct Function added.
		 */
		public function addFunction(callback:Function):void
		{
			var action:Object = {callback:callback, index:length, timer:NaN, next:null};
			if (firstAction == null) firstAction = action;
			if (lastAction != null) lastAction.next = action;
			lastAction = action;
			length++;
		}
		
		/**
		 * Starts the stream.
		 */
		public function start():void
		{
			switch (way){
				case LEFT_RIGHT :
					processFirstToLast();
					break;
				case RIGHT_LEFT :
					processLastToFirst();
					break;
				case EDGES_CENTER :
					processEdgesToCenter();
					break;
				case CENTER_EDGES :
					processCenterToEdges();
					break;
				case RANDOM :
					processRandom();
					break;
				
				default : processFirstToLast();
			}
			
			if (onStart != null) onStart();
		}
		
		/**
		* Stops the stream.
		*/
		public function stop():void
		{
			forEach(function(a:Object):void {
				clearTimeout(a.timer);
			});
		}
		
		/**
		* Stops the stream and clear queue.
		*/
		public function clear():void
		{
			stop();
			firstAction = null;
			lastAction = null;
			length = 0;
		}
		
		private function forEach(cb:Function):void
		{
			var a:Object = firstAction;
			while (a) {
				cb(a);
				a = a.next;
			}
		}
		
		private function setTimer(a:Object, num:Number):void
		{
			var interv:Number = time/length;
			var i:uint = a.index;
			a.timer = setTimeout(function():void {
				a.callback(i);
				if (onProgress != null) onProgress();
				if (i == lastIndex && onComplete != null) onComplete();
			}, num*interv);
		}
		
		private function processFirstToLast():void
		{
			forEach(function(a:Object):void {
				setTimer(a, a.index);
			});
			lastIndex = length - 1;
		}
		
		private function processLastToFirst():void
		{
			var num:uint = length;
			forEach(function(a:Object):void {
				num--;
				setTimer(a, num);
			});
			lastIndex = 0;
		}
		
		private function processCenterToEdges():void
		{
			var middle:uint = Math.floor(length/2);
			forEach(function(a:Object):void {
				var num:uint = Math.abs(a.index - middle);
				setTimer(a, num);
			}); 
			lastIndex = 0;
		}
		
		private function processEdgesToCenter():void
		{
			var middle:uint = Math.floor(length/2);
			forEach(function(a:Object):void {
				var num:uint = middle - Math.abs(middle - a.index);
				setTimer(a, num);
			});
			lastIndex = middle;
		}
		
		private function processRandom():void
		{
			var num:int = 0;
			var temp:Array = [];
			
		   	for (var i:int = 0; i < length; i++) temp[i] = i;
			
			forEach(function(a:Object):void {
				var r:Number = Math.round(Math.random()*(temp.length - 1));
				num = temp.splice(r, 1);
				if (num == length - 1) lastIndex = a.index;
				setTimer(a, num);
			});
		}
		
	}
}