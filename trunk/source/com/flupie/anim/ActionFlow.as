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
	 */
 
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;
	
	public class ActionFlow
	{
		public static const FIRST_TO_LAST:String = "firstToLast";
		public static const LAST_TO_FIRST:String = "lastToFirst";
		public static const CENTER_TO_EDGES:String = "centerToEdges";
		public static const EDGES_TO_CENTER:String = "edgesToCenter";
		public static const RANDOM:String = "random";

		public var way:String = FIRST_TO_LAST;
		public var time:Number = 1000;
		public var ease:Number = 0;

		private var timeout:uint;
		private var queue:Array = null;

		public function ActionFlow()
		{
			queue = [];
		}
		
		public function addFunction(funct:Function):void
		{
			queue[queue.length] = {funct:funct, timer:null};
		}
		
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
		}
		
		public function stop():void
		{
			for(var i:Number=0; i<queue.length; i++){
				clearInterval(queue[i].timer);
			}
		}
		
		public function clear():void
		{
			stop();
			queue = [];
		}
		
		private function setTimer(i:Number, num:Number):void
		{
			var interv:Number = time/queue.length;
			queue[i].timer = setTimeout(queue[i].funct, num*interv, [i]);
		}
		
		private function processFirstToLast():void
		{
			for(var i:Number=0; i<queue.length; i++){
				setTimer(i, i);
			}
		}
		
		private function processLastToFirst():void
		{
			var num:Number=queue.length;
			for(var i:Number=0; i<queue.length; i++){
				num--;
				setTimer(i, num);
			}
		}
		
		private function processCenterToEdges():void
		{
			var middle:Number=Math.floor(queue.length/2);
			for(var i:Number=0; i<queue.length; i++){
				var num:Number=Math.abs(i-middle);
				setTimer(i, num);
			}
		}
		
		private function processEdgesToCenter():void
		{
			var middle:Number=Math.floor(queue.length/2);
			for(var i:Number=0; i<queue.length; i++){
				var num:Number=middle-Math.abs(middle-i);
				setTimer(i, num);
			}
		}
		
		private function processRandom():void
		{
			var num:Number=0;
			var temp:Array= new Array();
			var repeat:Boolean= true;
			
			if(queue != null && queue.length>0){
				for(var i:Number=0; i<queue.length; i++){
					repeat=true;
					while(repeat){
						num = Math.round(Math.random()*queue.length);
						repeat=false;
						for(var k:Number=0; k<temp.length; k++){
							if(num==temp[k]){
								repeat=true;
								break;
							}
						}
					}
					temp.push(num);
					setTimer(i, num);
				}
			}
		}
		
	}
}