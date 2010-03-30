package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextFormat;
	import flash.text.TextField;
	
	import showclip.Lights;
	import showclip.TextEffects;
	
	import flupie.textanim.*;
	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	import caurina.transitions.properties.CurveModifiers;
	import caurina.transitions.properties.DisplayShortcuts;
	import caurina.transitions.properties.FilterShortcuts;
	import flash.media.SoundChannel;
	
	[SWF(width='640', height='360', backgroundColor='#000000', frameRate='60')]
	
	public class ta_showclip extends Sprite
	{
		public var _lights:Lights;

		public var _tf:TextField;
		public var _fm:TextFormat;
		public var _ta:TextAnim;
		
		public var _sequence:Array;
		public var _index:int = 0;
		public var _track:TATrack;
		public var _channel:SoundChannel;
		
		public function ta_showclip()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_track = new TATrack();
			_channel = new SoundChannel();

			_channel = _track.play();
			
			ColorShortcuts.init();
			CurveModifiers.init();
			DisplayShortcuts.init();
			FilterShortcuts.init();
			
			_lights = new Lights(stage.stageWidth, stage.stageHeight);
			addChild(_lights);
			
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);
			
			Tweener.addTween(this, {delay:1.5, onComplete:intro1Step});
		}
		
		public function intro1Step():void
		{
			_fm = new TextFormat(new HelveticaNeue().fontName, 14, 0x333333);
			var pre:TextField = getText("flupie presents");
			addChild(pre);
			
			_ta = TextAnim.create(pre, {split:"words", blocksVisible:true, interval:1000, effects:TextEffects.effect1Intro});
			_ta.forEachBlocks(function(block:TextAnimBlock):void {
				Tweener.addTween(block, {_Blur_blurY:20, alpha:0});
			});
			
			var posX:Number = _ta.x-100;
			_ta.x += 200;
			Tweener.addTween(_ta, {x:posX, time:7, transition:"easeoutsine"});
			
			TATrack
			
			_ta.start();
			Tweener.addTween(this, {delay:3, onComplete:intro2Step});
			Tweener.addTween(this, {delay:8, onComplete:configSequence});
		}
		
		public function intro2Step():void
		{
			_ta.split = "chars";
			_ta.blocksVisible = true;
			_ta.interval = 150;
			_ta.effects = TextEffects.effect2Intro;
			_ta.start();
		}
		
		public function configSequence():void
		{
			_fm = new TextFormat(new HelveticaNeue().fontName, 42, 0xFFFFFF);
			_fm.leading = -10;
			_fm.align = "center";
			
			_sequence = [
				{text:"TEXTANIM AS3 LIBRARY", size:52, interval:50, next:5},
				{text:"TEXTANIM IS AN OPEN SOURCE CODE", size:34, interval:50, next:3, mode:"edgesToCenter", effects:null, next:7},
				{text:"FOR DYNAMIC TEXT ANIMATION IN FLASH", interval:50, next:5},
				{text:"IT'S EVENTS BASED AND TWEEN\nENGINE INDEPENDENT", size:38, interval:50, next:6},
				{text:"HAS NO READY-MADE ANIMATION", size:38, interval:50, next:4},
				{text:"TO BE FREE TO MAKE\nWHATEVER ANIMATION", size:48, interval:50, next:4},
				{text:"DOESN'T MATTER WHICH\nTWEEN ENGINE THAT YOU LIKE", size:42, interval:50, next:6.5},
				{text:"TEXTANIM AS3", size:58, interval:100}
			];
			
			playSequence();
		}
		
		public function update(e:Event):void
		{
			_lights.update();
		}
		
		public function playSequence():void
		{
			if (_ta != null) _ta.dispose();
			
			if (_sequence[_index].size) _fm.size = _sequence[_index].size;
		
			if (_sequence[_index].text) {
				_tf = getText(_sequence[_index].text);
				addChild(_tf);
			}
			
			_ta = TextAnim.create(_tf, _sequence[_index]);
			_ta.start();
			
			if (_index < _sequence.length-1) {
				Tweener.addTween(this, {delay:_sequence[_index].next, onComplete:playSequence});
				_lights.nextColor();
				_index ++;
			} else {
				_lights.endColor();
			}
		}
		
		public function getText(txt:String):TextField
		{
			var tf:TextField = new TextField();
			tf.autoSize = "left";
			tf.multiline = true;
			tf.embedFonts = true;
			tf.defaultTextFormat = _fm;
			tf.text = txt;
			tf.x = int(stage.stageWidth * .5 - tf.width * .5);
			tf.y = int(stage.stageHeight * .5 - tf.height * .5);
			
			return tf;
		}
	
	}

}