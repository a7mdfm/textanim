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
			
			fmt = new TextFormat();
			fmt.font = new MyriadProCnd().fontName;
			fmt.color = 0xFFFFFF;
			fmt.size = 32;

			label = new TextField();
			label.defaultTextFormat = fmt;
			label.embedFonts = true;
			label.text = "Chupacabra";
			addChild(label);
			
			anim = new TextAnim(label);
			anim.interval = 500;
			anim.effects = eff;
			anim.start();
		}
		
		public function eff(block:TextAnimBlock):void
		{
			block.x = 0;
		}
	}
}