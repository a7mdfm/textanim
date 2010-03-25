package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import showclip.Lights;
	
	[SWF(width='640', height='360', backgroundColor='#FFFFFF', frameRate='60')]
	
	public class ta_showclip extends Sprite
	{
		public var lights:Lights;
		
		public function ta_showclip()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			lights = new Lights();
			addChild(lights);
			
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		}
		
		public function update(e:Event):void
		{
			lights.update();
		}
	
	}

}