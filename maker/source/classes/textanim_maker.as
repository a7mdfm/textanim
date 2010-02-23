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
	
	[SWF(width='955', height='550', backgroundColor='#FAFAFA', frameRate='60')]
	
	public class textanim_maker extends Sprite	 
	{
		public var _split_panel:SplitPanel;
		public var _mode_panel:ModePanel;
		public var _interval_slider:IntervalPanel;
		public var _code_area:TextField;
		public var _bt_start:PushButton;
		public var _bt_copy:PushButton;
		public var _anim_holder:AnimHolder;
		public var _anchor_x_panel:AnchorPanel;
		public var _anchor_y_panel:AnchorPanel;
		public var _ta_params:Object;
		public var _fps:FPS;
		
		public function textanim_maker()
		{
			super();
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			createInterface();
			
			stage.addEventListener(Event.RESIZE, onResize, false, 0, true);
			onResize();
		}
		
		public function createInterface():void
		{
			_fps = new FPS()
			addChild(_fps);
			
			_mode_panel = new ModePanel();
			_mode_panel.onChange = onChangeValue;
			addChild(_mode_panel);
			
			_split_panel = new SplitPanel();
			_split_panel.onChange = onChangeValue;
			addChild(_split_panel);
			
			_anchor_x_panel = new AnchorPanel("anchorX", ["LEFT", "RIGHT", "CENTER"]);
			_anchor_x_panel.onChange = onChangeValue;
			addChild(_anchor_x_panel);

			_anchor_y_panel = new AnchorPanel("anchorY", ["TOP", "BOTTOM", "CENTER"]);
			_anchor_y_panel.onChange = onChangeValue;
			addChild(_anchor_y_panel);
			
			_interval_slider = new IntervalPanel(onChangeValue);
			addChild(_interval_slider);
			
			_bt_start = new PushButton(this, 0, 0, "START", startClick);
			addChild(_bt_start);
			
			_bt_copy = new PushButton(this, 0, 0, "Copy code");
			addChild(_bt_copy)
			
			_anim_holder = new AnimHolder();
			addChild(_anim_holder);
			
			_code_area = new TextField();
			_code_area.width = 500;
			_code_area.height = 140;
			_code_area.border = true;
			_code_area.embedFonts = true;
			_code_area.mouseEnabled = false;
			_code_area.defaultTextFormat = new TextFormat(new Monaco().fontName, 12, 0x0);
			addChild(_code_area);
			
			onChangeValue();
		}
		
		public function onChangeValue(e:Event = null):void
		{
			var interval:int = int(_interval_slider.slider.value * 5);
			
			_ta_params = {
				mode:_mode_panel.value,
				split:_split_panel.selected,
				anchorX:_anchor_x_panel.selected,
				anchorY:_anchor_y_panel.selected,
				interval:interval
			}
			
			_code_area.text = "var txtanim:TextAnim = new TextAnim(myTextField);\n";
			
			if (_mode_panel.selected != _mode_panel.defaultValue)
				_code_area.appendText("txtanim.mode = TextAnimMode."+_mode_panel.selected+";\n");
				
			if (_split_panel.selected != _split_panel.defaultValue)
				_code_area.appendText("txtanim.split = TextAnimSplit."+_ta_params.split+";\n");
				
			if (_anchor_x_panel.selected != _anchor_x_panel.defaultValue)
				_code_area.appendText("txtanim.anchorX = TextAnimAnchor."+_ta_params.anchorX+";\n");
				
			if (_anchor_y_panel.selected != _anchor_y_panel.defaultValue)
				_code_area.appendText("txtanim.anchorY = TextAnimAnchor."+_ta_params.anchorY+";\n");
				
			if (_ta_params.interval != _interval_slider.defaultValue)
				_code_area.appendText("txtanim.interval = "+_ta_params.interval+";\n");
			
			_code_area.appendText("txtanim.blocksVisible = "+false+";\n");
			
			_code_area.appendText("txtanim.start();\n");
			
			_anim_holder.createTextAnim(_ta_params);
		}
		
		public function startClick(e:MouseEvent):void
		{
			_anim_holder.createTextAnim(_ta_params);
		}
		
		public function onResize(e:Event = null):void
		{
			_fps.x = stage.stageWidth - _fps.width - 1;

			_mode_panel.x = 10;
			_mode_panel.y = 10;
			
			_split_panel.x = 140;
			_split_panel.y = _mode_panel.y;

			_anchor_x_panel.x = 240;
			_anchor_x_panel.y = _mode_panel.y;
			
			_anchor_y_panel.x = 340;
			_anchor_y_panel.y = _mode_panel.y;
			
			_code_area.y = stage.stageHeight - _code_area.height-1;
			
			_bt_copy.x = _code_area.width - _bt_copy.width - 2;
			_bt_copy.y = _code_area.y + _code_area.height - _bt_copy.height - 2;
			
			_interval_slider.x = _mode_panel.x;
			_interval_slider.y = 140;

			_anim_holder.x = (stage.stageWidth * .5) - _anim_holder.width * .5;
			_anim_holder.y = (stage.stageHeight * .5) - _anim_holder.height * .5;
						
			_bt_start.x = (_anim_holder.x + _anim_holder.width * .5) - _bt_start.width *.5;
			_bt_start.y = _anim_holder.y + _anim_holder.height + 10;
		}
	
	}

}