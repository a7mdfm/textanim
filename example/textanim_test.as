package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import caurina.transitions.Tweener;
	
	import com.flupie.anim.TextAnim;
	import com.flupie.anim.TextAnimBlock;
	
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
			label.defaultTextFormat = new TextFormat(new MyriadProCnd().fontName, 32, 0xFFFFFF);
			label.embedFonts = true;
			label.text = "Lorem ipsum \nse eu tenho um feijão";
			
			
			/**
			 * Here is an instance of TextAnim, which receives the textField as parameter
			 */
			anim = new TextAnim(label);
			anim.x = anim.y = 150;
			anim.breakMode = TextAnim.BREAK_IN_LETTERS;
			anim.animMode = TextAnim.ANIM_TO_LEFT;
			anim.interval = 80;
			anim.effects = [alphaEff, scaleEff];
			anim.setBlocksVisibility(false);
			addChild(anim);
			
			anim.start();
		}
		
		
		/**
		* You can create as many functions of effect you want, just pass on the effects property [Array]. 
		*/
		public function alphaEff(block:TextAnimBlock):void
		{
			block.alpha = 0;
			block.x = block.posX - 40;
			Tweener.addTween(block, {alpha:1, x:block.posX, time:.5, transition:"easeoutquart"});
		}
		
		public function scaleEff(block:TextAnimBlock):void
		{
			block.scaleX = block.scaleY = 2;
			Tweener.addTween(block, {scaleX:1, scaleY:1, time:.5, transition:"easeoutquart"});
		}
		
	}
}