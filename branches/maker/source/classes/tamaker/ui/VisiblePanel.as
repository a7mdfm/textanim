package tamaker.ui 
{
	import com.bit101.components.*;
	import flash.events.MouseEvent;
	
	public class VisiblePanel extends TAPanel 
	{
		public var bt0:RadioButton;
		public var bt1:RadioButton;
		
		public var defaultValue:String = "true";
		
		public static var visibleGroup:Array = [];
		
		public function VisiblePanel()
		{
			super("blocksVisible");
			
			bt0 = new RadioButton(panel, visibleGroup, _lm, _tm, "false", true, onClick);
			bt1 = new RadioButton(panel, visibleGroup, _lm, _tm * 2, "true", false, onClick);
			
			_selected = bt0.label;
			panel.setSize(width, height-_py);
		}
		
		public function onClick(e:MouseEvent):void
		{
			selected = String(e.currentTarget.label);
		}
	}

}