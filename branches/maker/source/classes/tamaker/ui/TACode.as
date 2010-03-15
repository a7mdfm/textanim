package tamaker.ui 
{
	import com.bit101.components.*;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.system.System;
	
	public class TACode extends Sprite 
	{
		public var _bt_copy:PushButton;
		public var _field:TextField;
		public var label:TextField;
		public var type:CodeType;
	
		public function TACode(onChangeType:Function)
		{
			super();
			
			label = new TextField();
			label.y = 5;
			label.height = 30;
			label.autoSize = "left";
			label.selectable = false;
			label.embedFonts = true;
			label.mouseEnabled = false;
			label.defaultTextFormat = new TextFormat("PF Ronda Seven", 10, Style.LABEL_TEXT);
			label.text = "TextAnim code:";
			addChild(label);
			
			_bt_copy = new PushButton(this, 0, 0, "Copy code", onCopyClick);
			_bt_copy.y = 5;
			
			_field = new TextField();
			_field.y = _bt_copy.height + 10;
			_field.width = 500;
			_field.height = 160;
			_field.border = true;
			_field.wordWrap = true;
			_field.embedFonts = true;
			_field.background = true;
			_field.defaultTextFormat = new TextFormat(new Monaco().fontName, 12, 0x0);
			addChild(_field);
			
			_bt_copy.x = _field.width - _bt_copy.width;
			
			type = new CodeType();
			type.onChange = onChangeType;
			type.x = _bt_copy.x - 110;
			type.y = _bt_copy.y + 5;
			addChild(type);
		}
		
		public function onCopyClick(e:MouseEvent):void
		{
			System.setClipboard(_field.text);
		}
		
		public function set text(value:String):void
		{
			_field.text = value;
		}
		
		public function appendText(txt:String):void
		{
			_field.appendText(txt);
		}
	}

}