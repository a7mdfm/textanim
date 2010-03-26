package showclip
{
	import flash.display.Sprite;
	import caurina.transitions.Tweener;
	import flash.filters.BlurFilter;

	public class Lights extends Sprite
	{
		public var brith:Sprite;
		public var margin:int = 2;
		public var diff:int = 5;
		public var shape:Sprite;
		public var border:Sprite;
		public var colors:Array;
		
		public var amount:int = 30;
		public var padding:Number = 26.5;
		public var storeBars:Sprite;
		public var bars:Vector.<Bar>;
		
		public function Lights(w:int, h:int)
		{
			super();
			
			colors = [0x96B492, 0xE49E52, 0xAD70BE, 0x448FC3];
			
			shape = new Sprite();
			shape.graphics.beginFill(colors[int(Math.random() * colors.length)]);
			shape.graphics.drawRect(0, 0, w, h);
			shape.graphics.endFill();
			addChild(shape);
			
			bars = new Vector.<Bar>();
			storeBars = new Sprite();
			for (var i:int = 0; i<amount; i++) {
				bars[i] = new Bar();
				bars[i].x = i * padding;
				bars[i].alpha = 0;
				storeBars.addChild(bars[i]);
			}
			storeBars.x = 250;
			storeBars.y = -400;
			storeBars.rotation = 40;
			addChild(storeBars);
			
			brith = new Sprite();
			brith.graphics.lineStyle(10, 0xFFFFFF, .3);
			brith.graphics.beginFill(0xFFFFFF, .3);
			brith.graphics.drawRect(margin, margin, w-margin*2, h-margin*2);
			brith.graphics.endFill();
			brith.filters = [new BlurFilter(10, 10)];
			addChild(brith);
			
			border = new Sprite();
			border.graphics.lineStyle(10, 0x0, 1, false, "normal", "square", "miter", 3);
			border.graphics.drawRect(diff, diff, w-diff*2, h-diff*2);
			border.graphics.endFill();
			addChild(border);
			
			effectOut();
		}
		
		public function update():void
		{
			brith.alpha = Math.random() * .2;
		}
		
		public function effectIn():void
		{
			for (var i:int = amount-1; i>0; i--)
				Tweener.addTween(bars[i], {alpha:i/60, time:.5, transition:"easeoutquart", delay:i/40});
			
			Tweener.addTween(this, {onComplete:effectOut, delay:2 + int(Math.random() * 5)});
		}
		
		public function effectOut():void
		{
			for (var i:int = amount-1; i>0; i--)
				Tweener.addTween(bars[i], {alpha:(amount-i-1)/60, time:.3, transition:"easeoutquart", delay:i/40});
			
			Tweener.addTween(this, {onComplete:effectIn, delay:2 + int(Math.random() * 5)});
		}
		
	}

}

import flash.display.Sprite;

internal class Bar extends Sprite
{
	public function Bar()
	{
		super();
		
		graphics.beginFill(0xFFFFFF, .1);
		graphics.drawRect(0, 0, 25, 800);
		graphics.endFill();
	}

}