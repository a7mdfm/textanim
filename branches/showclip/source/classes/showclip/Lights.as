package showclip
{
	import flash.display.Sprite;

	public class Lights extends Sprite
	{
		public var bg:Sprite;
		
		public function Lights()
		{
			super();
			
			bg = new Sprite();
			bg.graphics.beginFill(0x000000);
			bg.graphics.drawRect(0,0,100, 360);
			bg.graphics.endFill();
			addChild(bg);
		}
		
		public function update():void
		{
			bg.alpha = Math.random() * 1;
		}
	
	}

}