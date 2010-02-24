package tamaker.ui 
{
	import com.bit101.components.*;
	import flash.events.MouseEvent;
	import flash.xml.XMLNode;
	
	public class TextPanel extends TAPanel 
	{
		public var bt0:PushButton;
		public var textArea:Text;
		public var defaultValue:String = "TextAnim Maker! Lorem ipsum\ntashin ishi quiring din.";
		//public var defaultValue:String = "TextAnim <font color=\"#FF0000\">Maker!</font> Lorem ipsum\ntashin ishi quiring din.";
		
		public function TextPanel()
		{
			super("text");
			
			textArea = new Text(panel, 8, 8);
			textArea.text = defaultValue;
			textArea.width = 200;
			textArea.height = 50;
			
			bt0 = new PushButton(panel, 110, textArea.height + 14, "Update text", onClick);
			
			_selected = textArea.text;
			panel.setSize(textArea.width + 18, 90);
		}
		
		public function onClick(e:MouseEvent):void
		{
			selected = textArea.text;
		}
	}

}