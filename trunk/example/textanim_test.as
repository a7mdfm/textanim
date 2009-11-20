package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	
	import com.flupie.anim.TextAnim;
	import com.flupie.anim.TextAnimBlock;
	import caurina.transitions.Tweener;
	
	[SWF(width='550', height='400', backgroundColor='0x333333', frameRate='60')]
	
	public class textanim_test extends Sprite
	{
		public var label:TextField;
		public var fmt:TextFormat;
		
		public var anim:TextAnim;
		
		public function textanim_test()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.showDefaultContextMenu = false;
			
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			label = new TextField();
			label.defaultTextFormat = new TextFormat(new MyriadProCnd().fontName, 32, 0xFFFFFF);
			label.embedFonts = true;
			label.text = "Lorem ipsum \n se eu tenho um feijão";
			addChild(label);
			
			anim = new TextAnim(label);
			anim.interval = 100;
			//anim.effects = eff;
			//anim.setBlocksVisibility(false);
			anim.start();
		}
		
		public function eff(block:TextAnimBlock):void
		{
			block.alpha = 0;
			block.x = block.posX - 10;
			Tweener.addTween(block, {alpha:1, x:block.posX, time:.5, transition:"easeoutquart"});
		}
	}
}