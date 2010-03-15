package tamaker.ui 
{
	import com.bit101.components.*;
	import flash.events.MouseEvent;
	
	public class CodeType extends TAPanel 
	{
		public var bt0:RadioButton;
		public var bt1:RadioButton;
		
		public var defaultValue:String = "Static";
		
		public static var codeGroup:Array = [];
		
		public function CodeType()
		{
			super("");
			
			bt0 = new RadioButton(this, codeGroup, 0, 0, "Instance", true, onClick);
			bt1 = new RadioButton(this, codeGroup, bt0.width + 50, 0, "Static", false, onClick);
			
			_selected = bt0.label;
			removeChild(panel);
		}
		
		public function onClick(e:MouseEvent):void
		{
			selected = e.currentTarget.label;
		}
	
	}

}