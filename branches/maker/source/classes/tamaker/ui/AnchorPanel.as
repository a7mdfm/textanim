package tamaker.ui 
{
	import com.bit101.components.*;
	import flash.events.MouseEvent;
	
	public class AnchorPanel extends TAPanel 
	{
		public static var anchorGroup:Array;
		
		public var buttons:Vector.<RadioButton>;
		public var defaultValue:String = "CENTER";
		
		public function AnchorPanel(name:String, items:Array)
		{
			super(name);
			
			buttons = new Vector.<RadioButton>();
			anchorGroup = [];
			
			for (var i:int = 0; i < items.length; i++)
			{
				buttons[i] = new RadioButton(panel, anchorGroup, _lm, _tm + _tm * i, items[i], i==items.length-1 ? true : false, onClick);
			}
			
			_selected = buttons[items.length-1].label;
			panel.setSize(width-_py, height-_py);
		}
		
		public function onClick(e:MouseEvent):void
		{
			selected = e.currentTarget.label;
		}
	
	}

}