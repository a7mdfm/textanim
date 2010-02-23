package tamaker.ui 
{
	import flupie.textanim.*;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flupie.textanim.TextAnimTools;

	public class AnimHolder extends Sprite 
	{
		public var _ta:TextAnim;
		public var _tf:TextField;
		public var _fm:TextFormat;
		
		public var _w:int = 550;
		public var _h:int = 120;
		
		public var setedText:String;
		public var defaultText:String;
		
		public function AnimHolder()
		{
			super();
			
			graphics.lineStyle(1, 0x0, .1);
			graphics.beginFill(0x0, .02);
			graphics.drawRect(0, 0, _w, _h);
			graphics.endFill();
			
			_fm = new TextFormat(new AbadiBold().fontName, 38, 0x0);
			_fm.align = "center";
			
			defaultText = "TextAnim Maker! Lorem ipsum\ntashin ishi quiring din.";
			setedText = defaultText;
		}
		
		public function createTextAnim(params:Object):void
		{
			if (_ta != null) _ta.dispose();
			
			_tf = new TextField();
			_tf.x = _tf.y = 10;
			_tf.width = _w - _tf.x;
			_tf.height = _h - _tf.y;
			_tf.embedFonts = true;
			_tf.defaultTextFormat = _fm;
			_tf.text = setedText;
			addChild(_tf);
			
			_ta = new TextAnim(_tf);
			
			if (params.debug) TextAnimTools.debug(_ta);
			
			_ta.interval = params.interval;
			_ta.anchorX = TextAnimAnchor[params.anchorX];
			_ta.anchorY = TextAnimAnchor[params.anchorY];
			_ta.mode = params.mode;
			_ta.split = TextAnimSplit[params.split];
			_ta.blocksVisible = false;
			_ta.start();
			
		}
	
	}

}