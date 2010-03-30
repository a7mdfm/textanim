package showclip
{
	import flupie.textanim.TextAnim;
	import flupie.textanim.TextAnimBlock;
	import caurina.transitions.Tweener;

	public class TextEffects
	{
		public static var currentTA:TextAnim;
		
		public static function effect1Intro(block:TextAnimBlock):void
		{
			if (block.index % 2 == 1) {
				block.x = block.posX + 30;
				Tweener.addTween(block, {x:block.posX, time:2.2, transition:"easeoutsine"});
			}
			
			Tweener.addTween(block, {alpha:1, time:.3, transition:"easeoutquart"});
			Tweener.addTween(block, {_Blur_blurY:0, time:1, transition:"easeoutquart", delay:.2});
		}
		
		public static function effect2Intro(block:TextAnimBlock):void
		{
			Tweener.addTween(block, {y:block.posY-Math.random()*5, rotation:Math.random()*30, _Blur_blurY:10, _Blur_blurX:10, time:1, transition:"easeinoutquart"});
			Tweener.addTween(block, {alpha:0, time:.3, transition:"linear", delay:.5});
		}
		
		public static function effect1(block:TextAnimBlock):void
		{
			block.alpha = 0;
			Tweener.addTween(block, {alpha:1, time:1, transition:"easeoutquart"});
		}

		public static function effect2(block:TextAnimBlock):void
		{
			if (block.index>12) {
				Tweener.addTween(block, {x:320, y:20, _bezier:[{x:406, y:80}, {x:380, y:10}, {x:299, y:33}], time:1, transition:"easeinoutquart"});
			} else {
				//Tweener.addTween(block, {x:290, y:20, _bezier:[{x:180, y:80}, {x:197, y:10}, {x:281, y:37}], time:1, transition:"easeinoutquart"});
			}
		}
		
		public static function effect3(block:TextAnimBlock):void
		{
			block.alpha = 0;
			Tweener.addTween(block, {alpha:1, time:1, transition:"easeoutquart"});
		}

		public static function effect4(block:TextAnimBlock):void
		{
			block.alpha = 0;
			Tweener.addTween(block, {alpha:1, time:1, transition:"easeoutquart"});
		}

		public static function effect5(block:TextAnimBlock):void
		{
			block.alpha = 0;
			Tweener.addTween(block, {alpha:1, time:1, transition:"easeoutquart"});
		}

		public static function effect6(block:TextAnimBlock):void
		{
			block.alpha = 0;
			Tweener.addTween(block, {alpha:1, time:1, transition:"easeoutquart"});
		}

		public static function effect7(block:TextAnimBlock):void
		{
			block.alpha = 0;
			Tweener.addTween(block, {alpha:1, time:1, transition:"easeoutquart"});
		}

		public static function effect8(block:TextAnimBlock):void
		{
			block.alpha = 0;
			Tweener.addTween(block, {alpha:1, time:1, transition:"easeoutquart"});
		}

		public static function effect9(block:TextAnimBlock):void
		{
			block.alpha = 0;
			Tweener.addTween(block, {alpha:1, time:1, transition:"easeoutquart"});
		}
	}

}