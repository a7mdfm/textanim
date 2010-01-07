package flupie.textanim
{
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import flupie.textanim.TextAnim;
	import flupie.textanim.TextAnimBlock;
	import flupie.textanim.TextAnimEvent;
	
	/**
	 *	Helpful class to create sequential animations for TextAnim
	 *
	 *	@langversion ActionScript 3.0
	 *
	 *	@author Lucas Motta
	 *	@since  02.12.2009
	 */
	public class TextAnimSequence
	{
		
		//--------------------------------------
		// PUBLIC VARIABLES
		//--------------------------------------
		
		/**
		 *	The original TextField instance.
		 *	<p>That's can be whatever TextField instance, but you need to make sure to embed font. The textanim will preserve all settings TextFormat of the TextField has.</p>
		*/
		public var source:TextField;
		
		/**
		 *	The original TextAnim instance.
		 */
		public var anim:TextAnim;
		
		/**
		 *	Array that contains all the TextAnims parameters
		 */
		public var sequence:Array = [];
		
		/**
		 *	Set if the sequence will have loop or not
		 *	
		 *	@default false;
		 */
		public var loop:Boolean = false;
		
		//--------------------------------------
		// PRIVATE VARIABLES
		//--------------------------------------
		
		private var _count:int;
		private var _timer:uint;
		private var _currentAnim:Object;
		
		//--------------------------------------
		//  CONSTRUCTOR
		//--------------------------------------
	
		/**
		 *	@constructor
		 */
		public function TextAnimSequence(p_source:TextField)
		{
			source = p_source;
		}
		
		//--------------------------------------
		//  PRIVATE METHODS
		//--------------------------------------
		
		private function setupAnim():void
		{
			var textParent:Object = source.parent;
			
			anim = new TextAnim(source);
			anim.addEventListener(TextAnimEvent.COMPLETE, onTextAnimComplete);
			textParent.addChild(anim);
		}
		
		private function playNextAnim():void
		{
			var updateAnchor:Boolean = false;
			
			_currentAnim = sequence[_count];
			
			for (var p:String in _currentAnim)
			{
				if(p == "delay") continue;
				if(p == "source") continue;
				if(p == "anchorY") updateAnchor = true;
				if(p == "anchorX") updateAnchor = true;
				
				anim[p] = _currentAnim[p];
			}
			if(updateAnchor) anim.setAnchor(anim.anchorX, anim.anchorY);
			anim.start();
			
			_count++
		}
		
		//--------------------------------------
		//  PUBLIC METHODS
		//--------------------------------------
		
		/**
		 *	Method to add the textAnim parameters to the sequence
		 *	
		 *	@param				params:Object		The parameters must be exactly to the TextAnim parameters. <b>Eg: animMode, breakMode, interval, effects, anchorX, anchorY, 
		 *	@return				void
		 */
		public function add(params:Object):void
		{
			// add the parameter delay, if it's not setted
			params["delay"] ||= 0;
			
			sequence.push(params);
		}
		
		/**
		 *	Start the sequence
		 */
		public function start():void
		{
			if(_count == 0) setupAnim();
			
			_timer = setTimeout(playNextAnim, sequence[_count].delay * 1000);
		}
		
		//--------------------------------------
		//  GETTER/SETTERS
		//--------------------------------------
		
		//--------------------------------------
		//  EVENT HANDLERS
		//--------------------------------------
		
		private function onTextAnimComplete(e:Event):void
		{
			// check if it's the last item on the sequence
			if(_count == sequence.length)
			{
				// check if the loop is setted for and reset the count
				if(!loop)
				{
					trace("complete all", "dispatch a SEQUENCE_COMPLETE event?");
					return;
				}
				_count = 0;
			}
			
			_timer = setTimeout(playNextAnim, sequence[_count].delay * 1000);
		}
	}
	
}

