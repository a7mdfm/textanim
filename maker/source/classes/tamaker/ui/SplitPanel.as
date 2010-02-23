package tamaker.ui 
{
	import com.bit101.components.*;
	import flash.events.MouseEvent;
	
	public class SplitPanel extends TAPanel 
	{
		public var bt0:RadioButton;
		public var bt1:RadioButton;
		public var bt2:RadioButton;
		
		public var defaultValue:String = "CHARS";
		
		public static var splitGroup:Array = [];
		
		public function SplitPanel()
		{
			super("split");
			
			bt0 = new RadioButton(panel, splitGroup, _lm, _tm, "CHARS", true, onClick);
			bt1 = new RadioButton(panel, splitGroup, _lm, _tm * 2, "WORDS", false, onClick);
			bt2 = new RadioButton(panel, splitGroup, _lm, _tm * 3, "LINES", false, onClick);
			
			_selected = bt0.label;
			panel.setSize(width-_py, height-_py);
		}
		
		public function onClick(e:MouseEvent):void
		{
			selected = e.currentTarget.label;
		}
	
	}

}