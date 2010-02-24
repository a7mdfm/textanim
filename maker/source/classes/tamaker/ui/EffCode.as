package tamaker.ui 
{
	import com.bit101.components.*;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.MouseEvent;
	import flash.system.System;
	
	public class EffCode extends Sprite 
	{
		public var _bt_copy:PushButton;
		public var _field:TextField;
		public var label:TextField;
		public var type:CodeType;
	
		public function EffCode()
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
			label.text = "myEffect code:";
			addChild(label);
			
			_bt_copy = new PushButton(this, 0, 0, "Copy code", onCopyClick);
			_bt_copy.y = 5;
			
			_field = new TextField();
			_field.y = _bt_copy.height + 10;
			
			_field.width = 500;
			_field.height = 140;
			_field.border = true;
			//_field.wordWrap = true;
			_field.embedFonts = true;
			_field.defaultTextFormat = new TextFormat(new Monaco().fontName, 12, 0x0);
			addChild(_field);
			
			_field.text = "import caurina.transitions.;\n\n";
			_field.appendText("function myEffect(block:TextAnimBlock):void {\n");
			_field.appendText("    block.scaleX = block.scaleY = 0;\n");
			_field.appendText("    block.rotation = -120;\n");
			_field.appendText("    Tweener.addTween(block, {rotation:0, _scale:1, time:.5, transition:\"easeoutback\"});\n");
			_field.appendText("}");
			
			_bt_copy.x = _field.width - _bt_copy.width;
		}
		
		public function onCopyClick(e:MouseEvent):void
		{
			System.setClipboard(_field.text);
		}
	}

}