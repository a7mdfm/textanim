package tamaker.ui 
{
	import flupie.textanim.*;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flupie.textanim.TextAnimTools;
	import com.gskinner.motion.easing.Back;
	import com.gskinner.motion.GTween;
	import textanim_maker;

	public class AnimHolder extends Sprite 
	{
		public var _ta:TextAnim;
		public var _tf:TextField;
		public var _fm:TextFormat;
		
		public var _w:int = 550;
		public var _h:int = 120;
		
		public var _grid:Boolean = false;
		
		public function AnimHolder()
		{
			super();
			
			graphics.lineStyle(1, 0x0, _grid ? .1 :0);
			graphics.beginFill(0x0, _grid ? .02 : 0);
			graphics.drawRect(0, 0, _w, _h);
			graphics.endFill();
			
			_fm = new TextFormat(new AbadiBold().fontName, 38, 0x0);
			_fm.align = "center";
		}
		
		public function createTextAnim(params:Object):void
		{
			if (_ta != null) _ta.dispose();
			
			_tf = new TextField();
			_tf.x = _tf.y = 10;
			_tf.width = _w - _tf.x;
			_tf.height = _h - _tf.y;
			_tf.multiline = true;
			_tf.embedFonts = true;
			_tf.defaultTextFormat = _fm;
			addChild(_tf);
			
			
			//CREATE TEXTANIM INSTANCE
			_ta = new TextAnim(_tf);
			_ta.blocksVisible = params.blocksVisible == "true" ? true : false;
			_ta.anchorX = TextAnimAnchor[params.anchorX];
			_ta.anchorY = TextAnimAnchor[params.anchorY];
			_ta.split = TextAnimSplit[params.split];
			_ta.interval = params.interval;
			_ta.effects = defaultEffect;
			_ta.mode = params.mode;
			_ta.delay = params.delay || 0;
			_ta.htmlText = params.text;
			if (params.showAnchors) TextAnimTools.showAnchors(_ta);
			
			_ta.start();
			
			//TextAnim.create(_tf, {effects:defaultEffect}).start(1000);
		}
		
		public function defaultEffect(block:TextAnimBlock):void
		{
			block.alpha = 0;
			block.scaleX = block.scaleY = 0;
			block.rotation = -120;
			new GTween(block, .5, {alpha:1, rotation:0, scaleX:1, scaleY:1}, {ease:Back.easeOut});
		}
		
		/*override public function get width():Number
		{
			return _w;
		}
		
		override public function get height():Number
		{
			return _h;
		}*/
		
	}

}