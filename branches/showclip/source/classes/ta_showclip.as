package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextFormat;
	
	import showclip.Lights;
	import flupie.textanim.TextAnim;
	import flash.text.TextField;
	import caurina.transitions.Tweener;
	import showclip.TextEffects;
	
	[SWF(width='640', height='360', backgroundColor='#000000', frameRate='60')]
	
	public class ta_showclip extends Sprite
	{
		public var _lights:Lights;

		public var _tf:TextField;
		public var _fm:TextFormat;
		public var _ta:TextAnim;
		
		public var _sequence:Array;
		public var _index:int = 0;
		
		public function ta_showclip()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_lights = new Lights(stage.stageWidth, stage.stageHeight);
			addChild(_lights);
			
			_fm = new TextFormat(new HelveticaNeue().fontName, 42, 0xFFFFFF);
			_fm.leading = -10;
			_fm.align = "center";
			
			_sequence = [
				{text:"TEXTANIM TEXT ABOUT 1", interval:50, next:3},
				{text:"WRITE ABOUT 2", effects:TextEffects.alphaIn, next:3},
				{text:"TEXT ABOUT 3 TEXT ABOUT\nWITH LASERS"}
			];
			
			playSequence();
			
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		}
		
		public function update(e:Event):void
		{
			_lights.update();
		}
		
		public function playSequence():void
		{
			if (_ta != null) _ta.dispose();
		
			if (_sequence[_index].text) {
				_tf = getText(_sequence[_index].text);
				addChild(_tf);
			}
			
			_ta = TextAnim.create(_tf, _sequence[_index]);
			_ta.start();
			
			if (_index < _sequence.length-1)
				Tweener.addTween(this, {delay:_sequence[_index].next, onComplete:playSequence});
			
			_index ++;
		}
		
		public function getText(txt:String):TextField
		{
			var tf:TextField = new TextField();
			tf.autoSize = "left";
			tf.multiline = true;
			tf.embedFonts = true;
			tf.defaultTextFormat = _fm;
			tf.text = txt;
			tf.x = stage.stageWidth * .5 - tf.width * .5;
			tf.y = stage.stageHeight * .5 - tf.height * .5;
			
			return tf;
		}
	
	}

}