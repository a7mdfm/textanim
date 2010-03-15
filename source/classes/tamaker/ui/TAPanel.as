package tamaker.ui
{	
	import com.bit101.components.*;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class TAPanel extends Sprite
	{
		public var panel:Panel;
		public var label:TextField;
		
		public var onChange:Function;
		public var _selected:String;
		
		public var _lm:int = 10;
		public var _tm:int = 15;
		public var _py:int = 20;
		
		public function TAPanel(name:String)
		{
			super();
			
			panel = new Panel(this, 0, 26);
			
			label = new TextField();
			label.height = 30;
			label.selectable = false;
			label.embedFonts = true;
			label.mouseEnabled = false;
			label.defaultTextFormat = new TextFormat("PF Ronda Seven", 14, Style.LABEL_TEXT);
			label.text = name;
			addChild(label);
		}
		
		public function set selected(value:String):void
		{
			_selected = value;
			if (onChange != null) onChange();
		}
		
		public function get selected():String
		{
			return _selected;
		}

	}
}