package components
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class BtnGroup extends Sprite
	{		
		public var btnList:Array = [];
		public var spacingY:Number = 46;
		public var currentSelected:Btn;
		public var title:Title;
		
		public function BtnGroup()
		{
			super();
			
			title = new Title();
			addChild(title);
		}
		
		public function addBtn():Btn
		{
			var btn:Btn = new Btn();
			btn.x = btn.width/2;
			btn.y = btnList.length * spacingY + 45;
			addChild(btn);
			btn.addEventListener(MouseEvent.CLICK, clickHandler);
			btnList.push(btn);
			
			return btn;
		}
		
		public function selectBtn(btn:Btn):void
		{
			if (btn.select) return;
			
			if (currentSelected) {
				currentSelected.select = false;
			}
			
			currentSelected = btn;
			btn.select = true;
		}
		
		private function clickHandler(e:*=null):void
		{
			selectBtn(e.currentTarget);
		}
	}
}