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
		public static const FIRST_TO_LAST:String = "firstToLast";
		public static const LAST_TO_FIRST:String = "lastToFirst";
		public static const CENTER_TO_EDGES:String = "centerToEdges";
		public static const EDGES_TO_CENTER:String = "edgesToCenter";
		public static const RANDOM:String = "random";
		
		/**
		 * The way of stream will occurs, like FIRST_TO_LAST, CENTER_TO_EDGES, etc.
		 */
		public var way:String = FIRST_TO_LAST;
		
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

		private var timeout:uint;
		private var queue:Array = null;
		private var lastIndex:int = 0;

		/**
		 * Construtor. Only create the queue array.
		 */
		public function ActionFlow()
		{
			queue = [];
		}
		
		/**
		 * Add a function to stream.
		 *	
		 * @param funct Function added.
		 */
		public function addFunction(funct:Function):void
		{
			queue[queue.length] = {funct:funct, timer:null};
		}
		
		/**
		 * Starts the stream.
		 */
		public function start():void
		{
			switch (way){
				case FIRST_TO_LAST :
					processFirstToLast();
					break;
				case LAST_TO_FIRST :
					processLastToFirst();
					break;
				case CENTER_TO_EDGES :
					processCenterToEdges();
					break;
				case EDGES_TO_CENTER :
					processEdgesToCenter();
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
			for(var i:Number=0; i<queue.length; i++){
				clearTimeout(queue[i].timer);
			}
		}
		
		/**
		* Stops the stream and clear queue.
		*/
		public function clear():void
		{
			stop();
			queue = [];
		}
		
		private function setTimer(i:Number, num:Number):void
		{
			var interv:Number = time/queue.length;
			queue[i].timer = setTimeout(function():void {
				queue[i].funct(i);
				if (onProgress != null) onProgress();
				if (i == lastIndex && onComplete != null) onComplete();
			}, num*interv);
		}
		
		private function processFirstToLast():void
		{
			for(var i:Number=0; i<queue.length; i++){
				setTimer(i, i);
			}
			lastIndex = queue.length - 1;
		}
		
		private function processLastToFirst():void
		{
			var num:Number=queue.length;
			for(var i:Number=0; i<queue.length; i++){
				num--;
				setTimer(i, num);
			}
			lastIndex = 0;
		}
		
		private function processCenterToEdges():void
		{
			var middle:Number=Math.floor(queue.length/2);
			for(var i:Number=0; i<queue.length; i++){
				var num:Number=Math.abs(i-middle);
				setTimer(i, num);
			} 
			lastIndex = 0;
		}
		
		private function processEdgesToCenter():void
		{
			var middle:Number=Math.floor(queue.length/2);
			for(var i:Number=0; i<queue.length; i++){
				var num:Number=middle-Math.abs(middle-i);
				setTimer(i, num);
			}
			lastIndex = middle;
		}
		
		private function processRandom():void
		{
			var num:int = 0;
			var temp:Array = new Array(queue.length);
			
		   	for (var i:int = 0; i < queue.length; i++) {
				temp[i] = i;
			}
			
			for (i = 0; i < queue.length; i++) {
				var r:Number = Math.round(Math.random()*(temp.length-1));
				num = temp.splice(r, 1);
				if (num == queue.length-1) lastIndex = i;
				setTimer(i, num);
			}
		}
		

		
	}
}