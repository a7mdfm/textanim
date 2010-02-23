package
{
	import com.bit101.components.*;
	import com.gabriellaet.FPS;
	import flupie.textanim.*;
	import tamaker.ui.*;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.system.System;
	
	[SWF(width='955', height='550', backgroundColor='#FAFAFA', frameRate='60')]
	
	public class textanim_maker extends Sprite
	{
		public var _mode_panel:ModePanel;
		public var _split_panel:SplitPanel;
		public var _anchor_x_panel:AnchorPanel;
		public var _anchor_y_panel:AnchorPanel;
		public var _text_panel:TextPanel;
		public var _interval_panel:IntervalPanel;
		public var _visible_panel:VisiblePanel;
		public var _bt_start:PushButton;
		public var _bt_copy:PushButton;
		public var _bt_show_anchor:CheckBox;
		public var _anim_holder:AnimHolder;
		public var _code_type:CodeType;
		
		public var _ta_code:TextField;
		public var _ta_params:Object;
		public var _fps:FPS;
		
		public function textanim_maker()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			createInterface();
			onChangeValue();
			
			stage.addEventListener(Event.RESIZE, onResize, false, 0, true);
			onResize();
		}
		
		public function createInterface():void
		{
			_fps = new FPS()
			addChild(_fps);
			
			_mode_panel = new ModePanel();
			_mode_panel.onChange = onChangeValue;
			_mode_panel.x = 10;
			addChild(_mode_panel);
			
			_split_panel = new SplitPanel();
			_split_panel.onChange = onChangeValue;
			_split_panel.x = 130;
			addChild(_split_panel);
			
			_anchor_x_panel = new AnchorPanel("anchorX", ["LEFT", "RIGHT", "CENTER"]);
			_anchor_x_panel.onChange = onChangeValue;
			_anchor_x_panel.x = 230;
			addChild(_anchor_x_panel);

			_anchor_y_panel = new AnchorPanel("anchorY", ["TOP", "BOTTOM", "CENTER"]);
			_anchor_y_panel.onChange = onChangeValue;
			_anchor_y_panel.x = 330;
			addChild(_anchor_y_panel);
			
			_bt_show_anchor = new CheckBox(this, 0, 0, "Show anchors", onChangeValue);
			_bt_show_anchor.x = _anchor_x_panel.x + 5;
			_bt_show_anchor.y = 105;
			
			_text_panel = new TextPanel();
			_text_panel.onChange = onChangeValue;
			_text_panel.x = 430;
			addChild(_text_panel);
			
			_interval_panel = new IntervalPanel();
			_interval_panel.onChange = onChangeValue;
			_interval_panel.x = _mode_panel.x;
			_interval_panel.y = 140;
			addChild(_interval_panel);
			
			_visible_panel = new VisiblePanel();
			_visible_panel.onChange = onChangeValue;
			_visible_panel.x = _mode_panel.x;
			_visible_panel.y = 210;
			addChild(_visible_panel);
			
			_bt_start = new PushButton(this, 0, 0, "START", startClick);
			
			_bt_copy = new PushButton(this, 0, 0, "Copy code");
			_bt_copy.addEventListener(MouseEvent.CLICK, onCopyClick, false, 0, true);
			
			_code_type = new CodeType();
			_code_type.onChange = changeCodeType;
			addChild(_code_type);
			
			_anim_holder = new AnimHolder();
			addChild(_anim_holder);
			
			_ta_code = new TextField();
			_ta_code.width = 500;
			_ta_code.height = 140;
			_ta_code.border = true;
			_ta_code.embedFonts = true;
			_ta_code.defaultTextFormat = new TextFormat(new Monaco().fontName, 12, 0x0);
			addChild(_ta_code);
		}
		
		public function onCopyClick(e:MouseEvent):void
		{
			System.setClipboard(_ta_code.text);
		}
		
		public function onChangeValue(e:Event = null):void
		{
			_ta_params = {
				showAnchors:_bt_show_anchor.selected,
				text:_text_panel.selected,
				blocksVisible:_visible_panel.selected,
				mode:_mode_panel.value,
				split:_split_panel.selected,
				anchorX:_anchor_x_panel.selected,
				anchorY:_anchor_y_panel.selected,
				interval:int(_interval_panel.slider.value * 5)
			}
			
			changeCodeType();
			
			_anim_holder.createTextAnim(_ta_params);
			onResize();
		}
		
		public function changeCodeType(e:Event = null):void
		{
			if (_code_type.selected == "Static") {
				setCodeStatic();
				return;
			}
			
			setCodeInstace();
		}
		
		public function setCodeStatic():void
		{
			_ta_code.text = "import flupie.textanim.*;\n\n";
			_ta_code.appendText("TextAnim.create(tf, {");
			
			if (_mode_panel.selected != _mode_panel.defaultValue)
				_ta_code.appendText("mode:TextAnimMode."+_mode_panel.selected+", ");
				
			if (_split_panel.selected != _split_panel.defaultValue)
				_ta_code.appendText("split:TextAnimSplit."+_ta_params.split+", ");
				
			if (_anchor_x_panel.selected != _anchor_x_panel.defaultValue)
				_ta_code.appendText("anchorX:TextAnimAnchor."+_ta_params.anchorX+", ");
				
			if (_anchor_y_panel.selected != _anchor_y_panel.defaultValue)
				_ta_code.appendText("anchorY:TextAnimAnchor."+_ta_params.anchorY+", ");
				
			if (_ta_params.blocksVisible != _visible_panel.defaultValue)
				_ta_code.appendText("blocksVisible:"+_ta_params.blocksVisible+", ");
				
			if (_ta_params.interval != _interval_panel.defaultValue)
				_ta_code.appendText("interval:"+_ta_params.interval+", ");
				
			_ta_code.appendText("effect:myEffect}).start();\n");
		}
		
		public function setCodeInstace():void
		{
			_ta_code.text = "import flupie.textanim.*;\n\n";
			_ta_code.appendText("var txtanim:TextAnim = new TextAnim(myTextField);\n");
			
			if (_mode_panel.selected != _mode_panel.defaultValue)
				_ta_code.appendText("txtanim.mode = TextAnimMode."+_mode_panel.selected+";\n");
				
			if (_split_panel.selected != _split_panel.defaultValue)
				_ta_code.appendText("txtanim.split = TextAnimSplit."+_ta_params.split+";\n");
				
			if (_anchor_x_panel.selected != _anchor_x_panel.defaultValue)
				_ta_code.appendText("txtanim.anchorX = TextAnimAnchor."+_ta_params.anchorX+";\n");
				
			if (_anchor_y_panel.selected != _anchor_y_panel.defaultValue)
				_ta_code.appendText("txtanim.anchorY = TextAnimAnchor."+_ta_params.anchorY+";\n");
				
			if (_ta_params.interval != _interval_panel.defaultValue)
				_ta_code.appendText("txtanim.interval = "+_ta_params.interval+";\n");

			if (_ta_params.blocksVisible != _visible_panel.defaultValue)
				_ta_code.appendText("txtanim.blocksVisible = "+_ta_params.blocksVisible+";\n");

			_ta_code.appendText("txtanim.effects = myEffect;\n");
			_ta_code.appendText("txtanim.start();\n");
			
			if (_bt_show_anchor.selected) {
				_ta_code.appendText("\nTextAnimTools.showAnchors(txtanim);");
			}
		}
		
		public function startClick(e:MouseEvent):void
		{
			_anim_holder.createTextAnim(_ta_params);
		}
		
		public function onResize(e:Event = null):void
		{
			_fps.x = stage.stageWidth - _fps.width - 1;
			
			_ta_code.y = stage.stageHeight - _ta_code.height - 2;
			_ta_code.width = stage.stageWidth - 2; 
			
			_bt_copy.x = _ta_code.width - _bt_copy.width;
			_bt_copy.y = _ta_code.y - _bt_copy.height - 2;
			
			_code_type.x = _bt_copy.x - 110;
			_code_type.y = _bt_copy.y + 5;
			
			_anim_holder.x = (stage.stageWidth * .5) - _anim_holder.width * .5;
			_anim_holder.y = (stage.stageHeight * .5) - _anim_holder.height * .5;
						
			_bt_start.x = (_anim_holder.x + _anim_holder.width * .5) - _bt_start.width * .5;
			_bt_start.y = _anim_holder.y + _anim_holder.height + 10;
		}
	
	}

}