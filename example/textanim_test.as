package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	
	import com.flupie.anim.TextAnim;
	
	[SWF(width='550', height='400', backgroundColor='0x333333', frameRate='60')]
	
	public class textanim_test extends Sprite
	{
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
			
			//do something
		}
	}
}