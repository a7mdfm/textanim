package components
{
	import caurina.transitions.Tweener;
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class Btn extends BtnView
	{
		public var onClick:Function;
		public var label:TextField;
		
		private var _select:Boolean = false;
		
		public function Btn()
		{
			super();
			base.stop();
			
			label = labelContainer.label;
			
			labelContainer.mouseEnabled = labelContainer.mouseChildren = false;
			addEventListener(MouseEvent.ROLL_OVER, overHandler);
			addEventListener(MouseEvent.ROLL_OUT, outHandler);
			addEventListener(MouseEvent.CLICK, clickHandler);
			buttonMode = true;
		}
		
		public function overHandler(e:*):void
		{
			if (_select) return;
			base.gotoAndStop("over");	
		}
		
		public function outHandler(e:*):void
		{
			if (_select) return;
			base.gotoAndStop("normal");
		}
		
		public function clickHandler(e:*):void
		{
			if (onClick != null) onClick();
		}
		
		public function set select(val:Boolean):void
		{
			_select = val;
			if (_select) {
				base.gotoAndStop("selected");
				Tweener.addTween(labelContainer, {_color:0xFFFFFF});
			} else {
				base.gotoAndStop("normal");
				Tweener.addTween(labelContainer, {_color:null});
			}	
		}
		
		public function get select():Boolean
		{
			return _select;
		}
		
		public function setLabel(str:String):void
		{
			label.text = str;
			label.autoSize = TextFieldAutoSize.CENTER;
			label.y = -label.textHeight/2 - 3;
		}
		
		public override function set width(value:Number):void
		{
			base.width = value;	
		}
		
		public override function get width():Number
		{
			return base.width;
		}
		
		public override function set height(value:Number):void
		{
			base.height = value;	
		}
		
		public override function get height():Number
		{
			return base.height;
		}
		
		
	}
}