package tamaker.ui 
{
	import com.bit101.components.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class IntervalPanel extends TAPanel 
	{
		public var slider:HUISlider;
		public var defaultValue:String = "100";
		
		public function IntervalPanel()
		{
			super("interval (ms)");
			
			slider = new HUISlider(panel, _lm, _tm, "", onChangeSlide);
			slider.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 0, true);
			slider.width = 150;
			slider.value = 100;
			slider.maximum = 1000;
			
			panel.setSize(width - 70, height - 15);
		}
		
		public function onChangeSlide(e:Event):void
		{
			
		}
		
		public function onMouseUp(e:MouseEvent):void
		{
			selected = String(slider.value);
		}
	}

}