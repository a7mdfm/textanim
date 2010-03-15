package tamaker.ui 
{
	import com.bit101.components.*;
	import flash.events.MouseEvent;
	import flupie.textanim.TextAnimMode;
	
	public class ModePanel extends TAPanel 
	{
		public var defaultValue:String;
		public var buttons:Array = [];
		public var value:String;
		
		public static var modeGroup:Array = [];
		
		public function ModePanel()
		{
			super("mode");
			
			buttons = [
				{name:"FIRST_LAST"},
				{name:"LAST_FIRT"},
				{name:"EDGES_CENTER"},
				{name:"CENTER_EDGES"},
				{name:"RANDOM"}
			];
			
			defaultValue =  buttons[0].name;
			
			for (var i:int = 0; i < buttons.length; i++)
			{
				buttons[i].item = new RadioButton(panel, modeGroup, _lm, _tm + _tm * i, buttons[i].name, i==0 ? true : false, onClick);
			}
			
			_selected = buttons[0].item.label;
			value = TextAnimMode.FIRST_LAST;
			
			panel.setSize(width+2, height-_py);
		}
		
		public function onClick(e:MouseEvent):void
		{
			switch (e.currentTarget.label) {
				case buttons[0].name :
					value = TextAnimMode.FIRST_LAST;
					break;
				case buttons[1].name :
					value = TextAnimMode.LAST_FIRST;
					break;
				case buttons[2].name :
					value = TextAnimMode.EDGES_CENTER;
					break;
				case buttons[3].name :
					value = TextAnimMode.CENTER_EDGES;
					break;
				case buttons[4].name :
					value = TextAnimMode.RANDOM;
					break;
			}
			
			selected = e.currentTarget.label;
		}

	}

}