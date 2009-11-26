package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import caurina.transitions.Tweener;
	
	import flupie.textanim.TextAnim;
	import flupie.textanim.TextAnimBlock;
	
	[SWF(width='550', height='400', backgroundColor='0x333333', frameRate='60')]
	
	public class textanim_test extends Sprite
	{
		public var label:TextField;
		public var anim:TextAnim;
		
		public function textanim_test()
		{
			/**
			 * That's just a textField, this could be on Flash IDE or SWC, whatever
			 */
			
			label = new TextField();
			label.border = true;
			label.autoSize = TextFieldAutoSize.LEFT;
			label.defaultTextFormat = new TextFormat(new MyriadProCnd().fontName, 32, 0xFFFFFF);
			label.embedFonts = true;
			label.text = "Lorem ipsum dolor sit amet\n consectetur adipiscing elit";
			label.x = 138;
			label.y = 166;
			addChild(label);
			
			
			/**
			 * Here is an instance of TextAnim, which receives the textField as parameter
			 */
			anim = new TextAnim(label);
			anim.breakMode = TextAnim.BREAK_IN_LETTERS;
			anim.animMode = TextAnim.ANIM_TO_LEFT;
			anim.interval = 40;
			anim.effects = [eff0, eff1];
			anim.setBlocksVisibility(false);
			addChild(anim);
			
			anim.start();
			
			
			/**
			 * Delay to call changeAnimMode, modify anim setting and start again. 
			 */
			Tweener.addTween(this, {time:5, onComplete:changeAnimMode});
		}
		
		public function changeAnimMode():void
		{
			anim.breakMode = TextAnim.BREAK_IN_WORDS;
			anim.animMode = TextAnim.ANIM_TO_EDGES;
			anim.interval = 80;
			anim.effects = [eff2, eff3];
			anim.start();
		}
		
		
		/**
		* You can create as many functions of effect you want, just pass on the effects property [Array]. 
		*/
		public function eff0(block:TextAnimBlock):void
		{
			block.alpha = 0;
			block.x = block.posX - 40;
			Tweener.addTween(block, {alpha:1, x:block.posX, time:.5, transition:"easeoutquart"});
		}
		
		public function eff1(block:TextAnimBlock):void
		{
			block.scaleX = block.scaleY = 2;
			Tweener.addTween(block, {scaleX:1, scaleY:1, time:.5, transition:"easeoutquart"});
		}

		public function eff2(block:TextAnimBlock):void
		{
			Tweener.addTween(block, {alpha:0, time:.5, transition:"easeinoutquart"});
		}
		
		public function eff3(block:TextAnimBlock):void
		{
			Tweener.addTween(block, {x:block.index%2==0 ? block.posX - 20 : block.posX +20, time:.5, transition:"easeinoutquart"});
		}
		
	}
}